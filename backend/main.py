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

# ── Locations ──────────────────────────────────────────────────────────────────

@app.get("/locations")
def get_locations():
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM locations ORDER BY location_id")
            return cur.fetchall()

# ── Vehicles ───────────────────────────────────────────────────────────────────

@app.get("/vehicles")
def get_vehicles(status: str = None):
    with get_conn() as conn:
        with conn.cursor() as cur:
            if status:
                cur.execute("""
                    SELECT v.*, l.name AS location_name
                    FROM vehicles v
                    JOIN locations l USING (location_id)
                    WHERE v.status = %s
                    ORDER BY v.vehicle_id
                """, (status,))
            else:
                cur.execute("""
                    SELECT v.*, l.name AS location_name
                    FROM vehicles v
                    JOIN locations l USING (location_id)
                    ORDER BY v.vehicle_id
                """)
            return cur.fetchall()

@app.patch("/vehicles/{vehicle_id}/status")
def update_vehicle_status(vehicle_id: int, status: str):
    valid = ("available", "rented", "maintenance")
    if status not in valid:
        raise HTTPException(400, f"status must be one of {valid}")
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "UPDATE vehicles SET status = %s WHERE vehicle_id = %s RETURNING *",
                (status, vehicle_id)
            )
            row = cur.fetchone()
            if not row:
                raise HTTPException(404, "Vehicle not found")
            conn.commit()
            return row

# ── Customers ──────────────────────────────────────────────────────────────────

@app.get("/customers")
def get_customers():
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM customers ORDER BY customer_id")
            return cur.fetchall()

@app.post("/customers", status_code=201)
def create_customer(body: CustomerIn):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                INSERT INTO customers (full_name, email, phone, license_no)
                VALUES (%s, %s, %s, %s) RETURNING *
            """, (body.full_name, body.email, body.phone, body.license_no))
            row = cur.fetchone()
            conn.commit()
            return row

# ── Reservations ───────────────────────────────────────────────────────────────

@app.get("/reservations")
def get_reservations():
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT
                    r.*,
                    c.full_name  AS customer_name,
                    v.make || ' ' || v.model AS vehicle_name,
                    v.daily_rate
                FROM reservations r
                JOIN customers c USING (customer_id)
                JOIN vehicles  v USING (vehicle_id)
                ORDER BY r.created_at DESC
            """)
            return cur.fetchall()

@app.post("/reservations", status_code=201)
def create_reservation(body: ReservationIn):
    with get_conn() as conn:
        with conn.cursor() as cur:

            # check vehicle is available
            cur.execute("SELECT * FROM vehicles WHERE vehicle_id = %s", (body.vehicle_id,))
            vehicle = cur.fetchone()
            if not vehicle:
                raise HTTPException(404, "Vehicle not found")
            if vehicle["status"] != "available":
                raise HTTPException(400, "Vehicle is not available")

            # check no overlapping reservation
            cur.execute("""
                SELECT 1 FROM reservations
                WHERE vehicle_id = %s
                  AND status = 'active'
                  AND start_date < %s
                  AND end_date   > %s
            """, (body.vehicle_id, body.end_date, body.start_date))
            if cur.fetchone():
                raise HTTPException(400, "Vehicle already booked for those dates")

            # create reservation
            cur.execute("""
                INSERT INTO reservations (customer_id, vehicle_id, start_date, end_date)
                VALUES (%s, %s, %s, %s) RETURNING *
            """, (body.customer_id, body.vehicle_id, body.start_date, body.end_date))
            reservation = cur.fetchone()

            # auto-generate invoice
            days = (body.end_date - body.start_date).days
            subtotal = days * float(vehicle["daily_rate"])
            tax      = round(subtotal * 0.18, 2)
            total    = round(subtotal + tax, 2)

            cur.execute("""
                INSERT INTO invoices (reservation_id, subtotal, tax, total)
                VALUES (%s, %s, %s, %s)
            """, (reservation["reservation_id"], subtotal, tax, total))

            # mark vehicle as rented
            cur.execute(
                "UPDATE vehicles SET status = 'rented' WHERE vehicle_id = %s",
                (body.vehicle_id,)
            )

            conn.commit()
            return reservation

@app.patch("/reservations/{reservation_id}/cancel")
def cancel_reservation(reservation_id: int):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM reservations WHERE reservation_id = %s", (reservation_id,))
            res = cur.fetchone()
            if not res:
                raise HTTPException(404, "Reservation not found")
            if res["status"] != "active":
                raise HTTPException(400, "Only active reservations can be cancelled")

            cur.execute(
                "UPDATE reservations SET status = 'cancelled' WHERE reservation_id = %s",
                (reservation_id,)
            )
            cur.execute(
                "UPDATE vehicles SET status = 'available' WHERE vehicle_id = %s",
                (res["vehicle_id"],)
            )
            conn.commit()
            return {"message": "Reservation cancelled"}

# ── Invoices ───────────────────────────────────────────────────────────────────

@app.get("/invoices")
def get_invoices():
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT
                    i.*,
                    c.full_name AS customer_name,
                    v.make || ' ' || v.model AS vehicle_name
                FROM invoices i
                JOIN reservations r USING (reservation_id)
                JOIN customers    c USING (customer_id)
                JOIN vehicles     v USING (vehicle_id)
                ORDER BY i.issued_at DESC
            """)
            return cur.fetchall()

@app.patch("/invoices/{invoice_id}/pay")
def mark_invoice_paid(invoice_id: int):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "UPDATE invoices SET paid = TRUE WHERE invoice_id = %s RETURNING *",
                (invoice_id,)
            )
            row = cur.fetchone()
            if not row:
                raise HTTPException(404, "Invoice not found")
            conn.commit()
            return row