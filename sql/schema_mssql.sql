IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'rcms')
    CREATE DATABASE rcms;
GO

USE rcms;
GO

IF OBJECT_ID('invoices',     'U') IS NOT NULL DROP TABLE invoices;
IF OBJECT_ID('reservations', 'U') IS NOT NULL DROP TABLE reservations;
IF OBJECT_ID('customers',    'U') IS NOT NULL DROP TABLE customers;
IF OBJECT_ID('vehicles',     'U') IS NOT NULL DROP TABLE vehicles;
IF OBJECT_ID('locations',    'U') IS NOT NULL DROP TABLE locations;
GO

CREATE TABLE locations (
    location_id INT IDENTITY(1,1) PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    address     VARCHAR(255) NOT NULL,
    city        VARCHAR(100) NOT NULL,
    phone       VARCHAR(20)
);

CREATE TABLE vehicles (
    vehicle_id  INT IDENTITY(1,1) PRIMARY KEY,
    location_id INT NOT NULL REFERENCES locations(location_id),
    make        VARCHAR(50)  NOT NULL,
    model       VARCHAR(50)  NOT NULL,
    year        INT          NOT NULL,
    vin         VARCHAR(17)  NOT NULL UNIQUE,
    category    VARCHAR(30)  NOT NULL,
    daily_rate  DECIMAL(8,2) NOT NULL,
    status      VARCHAR(20)  NOT NULL DEFAULT 'available'
                CHECK (status IN ('available','rented','maintenance'))
);

CREATE TABLE customers (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    full_name   VARCHAR(100) NOT NULL,
    email       VARCHAR(150) NOT NULL UNIQUE,
    phone       VARCHAR(20),
    license_no  VARCHAR(50)  NOT NULL UNIQUE
);

CREATE TABLE reservations (
    reservation_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id    INT         NOT NULL REFERENCES customers(customer_id),
    vehicle_id     INT         NOT NULL REFERENCES vehicles(vehicle_id),
    start_date     DATE        NOT NULL,
    end_date       DATE        NOT NULL,
    status         VARCHAR(20) NOT NULL DEFAULT 'active'
                   CHECK (status IN ('active','completed','cancelled')),
    created_at     DATETIME    NOT NULL DEFAULT GETDATE(),
    CHECK (end_date > start_date)
);

CREATE TABLE invoices (
    invoice_id     INT IDENTITY(1,1) PRIMARY KEY,
    reservation_id INT           NOT NULL REFERENCES reservations(reservation_id),
    subtotal       DECIMAL(10,2) NOT NULL,
    tax            DECIMAL(10,2) NOT NULL,
    total          DECIMAL(10,2) NOT NULL,
    paid           BIT           NOT NULL DEFAULT 0,
    issued_at      DATETIME      NOT NULL DEFAULT GETDATE()
);
GO