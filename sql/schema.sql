-- ============================================
-- Rental Car Management System - Schema
-- ============================================

-- Locations (branches)
CREATE TABLE locations (
    location_id SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    address     VARCHAR(255) NOT NULL,
    city        VARCHAR(100) NOT NULL,
    phone       VARCHAR(20)
);

-- Vehicles
CREATE TABLE vehicles (
    vehicle_id   SERIAL PRIMARY KEY,
    location_id  INT NOT NULL REFERENCES locations(location_id),
    make         VARCHAR(50)  NOT NULL,   -- e.g. Toyota
    model        VARCHAR(50)  NOT NULL,   -- e.g. Corolla
    year         INT          NOT NULL,
    vin          VARCHAR(17)  UNIQUE NOT NULL,
    category     VARCHAR(30)  NOT NULL,   -- economy, suv, luxury
    daily_rate   NUMERIC(8,2) NOT NULL,
    status       VARCHAR(20)  NOT NULL DEFAULT 'available'
                 CHECK (status IN ('available', 'rented', 'maintenance'))
);

-- Customers
CREATE TABLE customers (
    customer_id   SERIAL PRIMARY KEY,
    full_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(150) UNIQUE NOT NULL,
    phone         VARCHAR(20),
    license_no    VARCHAR(50)  UNIQUE NOT NULL
);

-- Reservations
CREATE TABLE reservations (
    reservation_id SERIAL PRIMARY KEY,
    customer_id    INT          NOT NULL REFERENCES customers(customer_id),
    vehicle_id     INT          NOT NULL REFERENCES vehicles(vehicle_id),
    start_date     DATE         NOT NULL,
    end_date       DATE         NOT NULL,
    status         VARCHAR(20)  NOT NULL DEFAULT 'active'
                   CHECK (status IN ('active', 'completed', 'cancelled')),
    created_at     TIMESTAMP    NOT NULL DEFAULT NOW(),
    CHECK (end_date > start_date)
);

-- Invoices
CREATE TABLE invoices (
    invoice_id     SERIAL PRIMARY KEY,
    reservation_id INT          NOT NULL REFERENCES reservations(reservation_id),
    subtotal       NUMERIC(10,2) NOT NULL,
    tax            NUMERIC(10,2) NOT NULL,
    total          NUMERIC(10,2) NOT NULL,
    paid           BOOLEAN      NOT NULL DEFAULT FALSE,
    issued_at      TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- ============================================
-- Sample Data
-- ============================================

INSERT INTO locations (name, address, city, phone) VALUES
('Downtown Branch',  '123 Main St',    'Lahore', '042-1111111'),
('Airport Branch',   '45 Airport Rd',  'Lahore', '042-2222222'),
('Gulberg Branch',   '78 MM Alam Rd',  'Lahore', '042-3333333');

INSERT INTO vehicles (location_id, make, model, year, vin, category, daily_rate) VALUES
(1, 'Toyota',  'Corolla',  2022, 'VIN0000000000001', 'economy', 5000.00),
(1, 'Honda',   'City',     2023, 'VIN0000000000002', 'economy', 5500.00),
(2, 'Toyota',  'Fortuner', 2022, 'VIN0000000000003', 'suv',     12000.00),
(2, 'Kia',     'Sportage', 2023, 'VIN0000000000004', 'suv',     10000.00),
(3, 'Honda',   'Civic',    2023, 'VIN0000000000005', 'economy', 6000.00),
(3, 'Toyota',  'Camry',    2022, 'VIN0000000000006', 'luxury',  15000.00);

INSERT INTO customers (full_name, email, phone, license_no) VALUES
('Ali Hassan',    'ali@email.com',   '0300-1111111', 'LHR-001'),
('Sara Khan',     'sara@email.com',  '0300-2222222', 'LHR-002'),
('Umar Farooq',   'umar@email.com',  '0300-3333333', 'LHR-003');

INSERT INTO reservations (customer_id, vehicle_id, start_date, end_date) VALUES
(1, 1, '2025-06-01', '2025-06-05'),
(2, 3, '2025-06-03', '2025-06-07');

INSERT INTO invoices (reservation_id, subtotal, tax, total) VALUES
(1, 20000.00, 3600.00, 23600.00),
(2, 48000.00, 8640.00, 56640.00);