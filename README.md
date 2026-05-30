# Rental Car Management System (RCMS)

A simple web app to manage a car rental business — built as a DBMS Lab project.

**Team:**
- Muhammad Zulqarnain Abdullah (24-CS-19)
- Muhammad Ali (24-CS-129)
- Muhammad Bilal (24-CS-64)

---

## What Does This App Do?

This app lets you manage a car rental business with 3 branches and 50 vehicles. You can:

- View all cars in the fleet and their status (available, rented, under maintenance)
- Make a reservation for a customer
- Cancel a reservation
- View and manage invoices

---

## Tech Stack

| Part | Technology | What it does |
|------|-----------|--------------|
| Database | PostgreSQL | Stores all data (cars, customers, bookings) |
| Backend | FastAPI (Python) | The server that handles requests and talks to the database |
| Frontend | HTML + CSS + JavaScript | The webpage the user sees and interacts with |

---

## Project Structure

```
DBMS_Project/
├── backend/
│   ├── main.py          # All API endpoints (the logic)
│   ├── database.py      # Database connection
│   └── requirements.txt # Python packages needed
├── frontend/
│   └── index.html       # The entire UI in one file
├── sql/
│   └── schema.sql       # Database tables + sample data
├── .gitignore
└── README.md
```

---

## How to Run This Project (Step by Step)

### Step 1 — Install PostgreSQL

PostgreSQL is the database software. Install it:

```bash
sudo apt-get update
sudo apt install postgresql postgresql-contrib --fix-missing
```

Start it:

```bash
sudo systemctl start postgresql
```

### Step 2 — Create the Database

Switch to the postgres user:

```bash
sudo -i -u postgres
```

Open the postgres shell:

```bash
psql
```

Run these commands inside the shell:

```sql
CREATE DATABASE rcms;
\password postgres
```

It will ask you to set a password — use `1234` (or anything you want, just remember it).

Then exit:

```sql
\q
```

```bash
exit
```

### Step 3 — Fix Authentication (one time only)

By default PostgreSQL doesn't allow password login locally. Fix it:

```bash
sudo nano /etc/postgresql/16/main/pg_hba.conf
```

Find this line:

```
local   all   postgres   peer
```

Change `peer` to `md5`:

```
local   all   postgres   md5
```

Save with `Ctrl+O` → Enter → `Ctrl+X`, then restart PostgreSQL:

```bash
sudo systemctl restart postgresql
```

### Step 4 — Load the Schema

This creates all the tables and inserts sample data:

```bash
psql -U postgres -d rcms -W -f sql/schema.sql
```

Enter your password when asked.

### Step 5 — Set Up the Backend

Go into the backend folder:

```bash
cd backend
```

Create a virtual environment (an isolated space for Python packages):

```bash
python3 -m venv venv
```

Activate it:

```bash
source venv/bin/activate
```

You'll see `(venv)` in your terminal. Now install the required packages:

```bash
pip install -r requirements.txt
```

Create the `.env` file (this tells the backend your database password):

```bash
nano .env
```

Paste this inside:

```
DB_HOST=localhost
DB_NAME=rcms
DB_USER=postgres
DB_PASSWORD=1234
```

Save with `Ctrl+O` → Enter → `Ctrl+X`.

### Step 6 — Run the Backend

Make sure you're in the `backend` folder with `(venv)` active, then:

```bash
uvicorn main:app --reload
```

You should see:

```
INFO: Uvicorn running on http://127.0.0.1:8000
```

The backend is now running. You can explore all API endpoints at:
`http://localhost:8000/docs`

### Step 7 — Run the Frontend

Open a **new terminal** and run:

```bash
cd ~/Desktop/Coding/Projects/DBMS_Project/frontend
python3 -m http.server 3000
```

Then open your browser and go to:

```
http://localhost:3000
```

The app should be running.

---

## Database Design

The system has 5 tables:

- **locations** — the 3 branches
- **vehicles** — all cars, each belongs to a location
- **customers** — people who rent cars
- **reservations** — links a customer to a vehicle for a date range
- **invoices** — auto-generated when a reservation is made (subtotal + 18% tax)

---

## Common Issues

**`Connection refused` error** — PostgreSQL is not running. Fix:
```bash
sudo systemctl start postgresql
```

**`Peer authentication failed`** — You skipped Step 3. Follow it to change `peer` to `md5`.

**`Could not import module "main"`** — You're not in the `backend` folder. Run `cd backend` first.

**`(venv)` not showing** — Virtual environment is not active. Run `source venv/bin/activate` from inside the `backend` folder.