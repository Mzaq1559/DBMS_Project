from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from datetime import date
from database import get_conn

app = FastAPI(title="Rental Car Management System")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# ── Pydantic Models ────────────────────────────────────────────────────────────

class CustomerIn(BaseModel):
    full_name: str
    email: str
    phone: str
    license_no: str

class ReservationIn(BaseModel):
    customer_id: int
    vehicle_id: int
    start_date: date
    end_date: date

# ── Helper: row → dict ─────────────────────────────────────────────────────────

def row_to_dict(cursor, row):
    """Convert a pyodbc Row to a plain dict using cursor.description."""
    if row is None:
        return None
    columns = [col[0] for col in cursor.description]
    return dict(zip(columns, row))

def rows_to_list(cursor, rows):
    columns = [col[0] for col in cursor.description]
    return [dict(zip(columns, row)) for row in rows]

# ── Locations ──────────────────────────────────────────────────────────────────

@app.get("/locations")
def get_locations():
    conn = get_conn()
    try:
        cur = conn.cursor()
        cur.execute("SELECT * FROM locations ORDER BY location_id")
        return rows_to_list(cur, cur.fetchall())
    finally:
        conn.close()

# ── Vehicles ───────────────────────────────────────────────────────────────────

@app.get("/vehicles")
def get_vehicles(status: str = None):
    conn = get_conn()
    try:
        cur = conn.cursor()
        if status:
            cur.execute("""
                SELECT v.*, l.name AS location_name
                FROM vehicles v
                JOIN locations l ON l.location_id = v.location_id
                WHERE v.status = ?
                ORDER BY v.vehicle_id
            """, (status,))
        else:
            cur.execute("""
                SELECT v.*, l.name AS location_name
                FROM vehicles v
                JOIN locations l ON l.location_id = v.location_id
                ORDER BY v.vehicle_id
            """)
        return rows_to_list(cur, cur.fetchall())
    finally:
        conn.close()

@app.patch("/vehicles/{vehicle_id}/status")
def update_vehicle_status(vehicle_id: int, status: str):
    valid = ("available", "rented", "maintenance")
    if status not in valid:
        raise HTTPException(400, f"status must be one of {valid}")
    conn = get_conn()
    try:
        cur = conn.cursor()
        cur.execute(
            "UPDATE vehicles SET status = ? WHERE vehicle_id = ?",
            (status, vehicle_id)
        )
        if cur.rowcount == 0:
            raise HTTPException(404, "Vehicle not found")
        conn.commit()
        cur.execute("SELECT * FROM vehicles WHERE vehicle_id = ?", (vehicle_id,))
        return row_to_dict(cur, cur.fetchone())
    finally:
        conn.close()

# ── Customers ──────────────────────────────────────────────────────────────────

@app.get("/customers")
def get_customers():
    conn = get_conn()
    try:
        cur = conn.cursor()
        cur.execute("SELECT * FROM customers ORDER BY customer_id")
        return rows_to_list(cur, cur.fetchall())
    finally:
        conn.close()

@app.post("/customers", status_code=201)
def create_customer(body: CustomerIn):
    conn = get_conn()
    try:
        cur = conn.cursor()

        # Insert and capture new ID before committing
        cur.execute("""
            INSERT INTO customers (full_name, email, phone, license_no)
            OUTPUT INSERTED.customer_id
            VALUES (?, ?, ?, ?)
        """, (body.full_name, body.email, body.phone, body.license_no))

        row = cur.fetchone()
        if not row:
            raise HTTPException(500, "Failed to create customer")
        new_id = row[0]

        conn.commit()

        cur.execute("SELECT * FROM customers WHERE customer_id = ?", (new_id,))
        return row_to_dict(cur, cur.fetchone())
    finally:
        conn.close()

# ── Reservations ───────────────────────────────────────────────────────────────

@app.get("/reservations")
def get_reservations():
    conn = get_conn()
    try:
        cur = conn.cursor()
        cur.execute("""
            SELECT
                r.*,
                c.full_name AS customer_name,
                v.make + ' ' + v.model AS vehicle_name,
                v.daily_rate
            FROM reservations r
            JOIN customers c ON c.customer_id = r.customer_id
            JOIN vehicles  v ON v.vehicle_id  = r.vehicle_id
            ORDER BY r.created_at DESC
        """)
        return rows_to_list(cur, cur.fetchall())
    finally:
        conn.close()

@app.post("/reservations", status_code=201)
def create_reservation(body: ReservationIn):
    conn = get_conn()
    try:
        cur = conn.cursor()

        # Check vehicle exists and is available
        cur.execute("SELECT * FROM vehicles WHERE vehicle_id = ?", (body.vehicle_id,))
        vehicle = row_to_dict(cur, cur.fetchone())
        if not vehicle:
            raise HTTPException(404, "Vehicle not found")
        if vehicle["status"] != "available":
            raise HTTPException(400, "Vehicle is not available")

        # Check no overlapping reservation
        cur.execute("""
            SELECT 1 FROM reservations
            WHERE vehicle_id = ?
              AND status = 'active'
              AND start_date < ?
              AND end_date   > ?
        """, (body.vehicle_id, body.end_date, body.start_date))
        if cur.fetchone():
            raise HTTPException(400, "Vehicle already booked for those dates")

        # Validate date range
        if body.end_date <= body.start_date:
            raise HTTPException(400, "end_date must be after start_date")

        # Insert and capture new reservation ID before committing
        cur.execute("""
            INSERT INTO reservations (customer_id, vehicle_id, start_date, end_date)
            OUTPUT INSERTED.reservation_id
            VALUES (?, ?, ?, ?)
        """, (body.customer_id, body.vehicle_id, body.start_date, body.end_date))

        row = cur.fetchone()
        if not row:
            raise HTTPException(500, "Failed to create reservation")
        new_id = row[0]

        # Auto-generate invoice
        days     = (body.end_date - body.start_date).days
        subtotal = round(days * float(vehicle["daily_rate"]), 2)
        tax      = round(subtotal * 0.18, 2)
        total    = round(subtotal + tax, 2)

        cur.execute("""
            INSERT INTO invoices (reservation_id, subtotal, tax, total)
            VALUES (?, ?, ?, ?)
        """, (new_id, subtotal, tax, total))

        # Mark vehicle as rented
        cur.execute(
            "UPDATE vehicles SET status = 'rented' WHERE vehicle_id = ?",
            (body.vehicle_id,)
        )

        conn.commit()

        # Fetch and return the full reservation row
        cur.execute("SELECT * FROM reservations WHERE reservation_id = ?", (new_id,))
        return row_to_dict(cur, cur.fetchone())

    finally:
        conn.close()

@app.patch("/reservations/{reservation_id}/cancel")
def cancel_reservation(reservation_id: int):
    conn = get_conn()
    try:
        cur = conn.cursor()
        cur.execute("SELECT * FROM reservations WHERE reservation_id = ?", (reservation_id,))
        res = row_to_dict(cur, cur.fetchone())
        if not res:
            raise HTTPException(404, "Reservation not found")
        if res["status"] != "active":
            raise HTTPException(400, "Only active reservations can be cancelled")

        cur.execute(
            "UPDATE reservations SET status = 'cancelled' WHERE reservation_id = ?",
            (reservation_id,)
        )
        cur.execute(
            "UPDATE vehicles SET status = 'available' WHERE vehicle_id = ?",
            (res["vehicle_id"],)
        )
        conn.commit()
        return {"message": "Reservation cancelled"}
    finally:
        conn.close()

# ── Invoices ───────────────────────────────────────────────────────────────────

@app.get("/invoices")
def get_invoices():
    conn = get_conn()
    try:
        cur = conn.cursor()
        cur.execute("""
            SELECT
                i.*,
                c.full_name AS customer_name,
                v.make + ' ' + v.model AS vehicle_name
            FROM invoices i
            JOIN reservations r ON r.reservation_id = i.reservation_id
            JOIN customers    c ON c.customer_id    = r.customer_id
            JOIN vehicles     v ON v.vehicle_id     = r.vehicle_id
            ORDER BY i.issued_at DESC
        """)
        return rows_to_list(cur, cur.fetchall())
    finally:
        conn.close()

@app.patch("/invoices/{invoice_id}/pay")
def mark_invoice_paid(invoice_id: int):
    conn = get_conn()
    try:
        cur = conn.cursor()
        cur.execute(
            "UPDATE invoices SET paid = 1 WHERE invoice_id = ?",
            (invoice_id,)
        )
        if cur.rowcount == 0:
            raise HTTPException(404, "Invoice not found")
        conn.commit()
        cur.execute("SELECT * FROM invoices WHERE invoice_id = ?", (invoice_id,))
        return row_to_dict(cur, cur.fetchone())
    finally:
        conn.close()