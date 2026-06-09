-- ============================================
-- Rental Car Management System
-- SQL Server (T-SQL) Schema
-- ============================================

-- Create database (run this separately if needed)
-- CREATE DATABASE rcms;
-- GO
-- USE rcms;
-- GO

-- Drop tables if they exist (for re-running)
IF OBJECT_ID('invoices', 'U') IS NOT NULL DROP TABLE invoices;
IF OBJECT_ID('reservations', 'U') IS NOT NULL DROP TABLE reservations;
IF OBJECT_ID('maintenance', 'U') IS NOT NULL DROP TABLE maintenance;
IF OBJECT_ID('vehicles', 'U') IS NOT NULL DROP TABLE vehicles;
IF OBJECT_ID('customers', 'U') IS NOT NULL DROP TABLE customers;
IF OBJECT_ID('locations', 'U') IS NOT NULL DROP TABLE locations;
GO

-- Locations (branches)
CREATE TABLE locations (
    location_id   INT IDENTITY(1,1) PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    address       VARCHAR(200) NOT NULL,
    city          VARCHAR(50)  NOT NULL,
    phone         VARCHAR(20)
);

-- Vehicles
CREATE TABLE vehicles (
    vehicle_id    INT IDENTITY(1,1) PRIMARY KEY,
    location_id   INT NOT NULL,
    make          VARCHAR(50)  NOT NULL,
    model         VARCHAR(50)  NOT NULL,
    year          INT          NOT NULL,
    vin           VARCHAR(20)  UNIQUE NOT NULL,
    daily_rate    DECIMAL(8,2) NOT NULL,
    status        VARCHAR(20)  NOT NULL DEFAULT 'available'
                  CHECK (status IN ('available', 'rented', 'maintenance')),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- Customers
CREATE TABLE customers (
    customer_id   INT IDENTITY(1,1) PRIMARY KEY,
    first_name    VARCHAR(50)  NOT NULL,
    last_name     VARCHAR(50)  NOT NULL,
    email         VARCHAR(100) UNIQUE NOT NULL,
    phone         VARCHAR(20),
    license_no    VARCHAR(30)  UNIQUE NOT NULL
);

-- Reservations
CREATE TABLE reservations (
    reservation_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id    INT          NOT NULL,
    vehicle_id     INT          NOT NULL,
    start_date     DATE         NOT NULL,
    end_date       DATE         NOT NULL,
    status         VARCHAR(20)  NOT NULL DEFAULT 'active'
                   CHECK (status IN ('active', 'completed', 'cancelled')),
    created_at     DATETIME     DEFAULT GETDATE(),
    CHECK (end_date > start_date),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (vehicle_id)  REFERENCES vehicles(vehicle_id)
);

-- Invoices
CREATE TABLE invoices (
    invoice_id     INT IDENTITY(1,1) PRIMARY KEY,
    reservation_id INT          NOT NULL UNIQUE,
    subtotal       DECIMAL(10,2) NOT NULL,
    tax            DECIMAL(10,2) NOT NULL,
    total          DECIMAL(10,2) NOT NULL,
    paid           BIT          NOT NULL DEFAULT 0,
    created_at     DATETIME     DEFAULT GETDATE(),
    FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id)
);

-- Maintenance log
CREATE TABLE maintenance (
    maintenance_id INT IDENTITY(1,1) PRIMARY KEY,
    vehicle_id     INT          NOT NULL,
    type           VARCHAR(100) NOT NULL,
    performed_on   DATE         NOT NULL,
    next_due       DATE,
    notes          VARCHAR(500),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
);
GO

-- ============================================
-- Sample Data
-- ============================================

INSERT INTO locations (name, address, city, phone) VALUES
('Downtown Branch',  '123 Main St',    'Karachi',   '021-1234567'),
('Airport Branch',   '456 Airport Rd', 'Lahore',    '042-7654321'),
('Uptown Branch',    '789 Mall Blvd',  'Islamabad', '051-9876543');

INSERT INTO vehicles (location_id, make, model, year, vin, daily_rate, status) VALUES
(1, 'Toyota',  'Corolla',  2021, 'VIN-001', 5000.00,  'available'),
(1, 'Honda',   'Civic',    2022, 'VIN-002', 5500.00,  'available'),
(1, 'Suzuki',  'Swift',    2020, 'VIN-003', 3500.00,  'rented'),
(2, 'Toyota',  'Fortuner', 2023, 'VIN-004', 12000.00, 'available'),
(2, 'Honda',   'HR-V',     2022, 'VIN-005', 8000.00,  'available'),
(3, 'Suzuki',  'Cultus',   2021, 'VIN-006', 3000.00,  'maintenance');

INSERT INTO customers (first_name, last_name, email, phone, license_no) VALUES
('Ali',     'Khan',    'ali.khan@email.com',    '0300-1111111', 'LIC-001'),
('Sara',    'Ahmed',   'sara.ahmed@email.com',  '0301-2222222', 'LIC-002'),
('Usman',   'Malik',   'usman.malik@email.com', '0302-3333333', 'LIC-003');

INSERT INTO reservations (customer_id, vehicle_id, start_date, end_date, status) VALUES
(1, 3, '2024-01-10', '2024-01-15', 'completed'),
(2, 1, '2024-02-05', '2024-02-08', 'completed'),
(3, 5, '2024-03-01', '2024-03-07', 'active');

INSERT INTO invoices (reservation_id, subtotal, tax, total, paid) VALUES
(1, 17500.00, 2625.00, 20125.00, 1),
(2, 15000.00, 2250.00, 17250.00, 1),
(3, 48000.00, 7200.00, 55200.00, 0);
GO