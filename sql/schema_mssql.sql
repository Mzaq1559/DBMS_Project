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
INSERT INTO locations (name, address, city, phone) VALUES
('Downtown Branch','123 Main St','Lahore','042-1111111'),
('Airport Branch','45 Airport Rd','Lahore','042-2222222'),
('Gulberg Branch','78 MM Alam Rd','Lahore','042-3333333');
INSERT INTO vehicles (location_id,make,model,year,vin,category,daily_rate) VALUES
(1,'Toyota','Corolla',2022,'VIN0000000000001','economy',5000.00),
(1,'Honda','City',2023,'VIN0000000000002','economy',5500.00),
(2,'Toyota','Fortuner',2022,'VIN0000000000003','suv',12000.00),
(2,'Kia','Sportage',2023,'VIN0000000000004','suv',10000.00),
(3,'Honda','Civic',2023,'VIN0000000000005','economy',6000.00),
(3,'Toyota','Camry',2022,'VIN0000000000006','luxury',15000.00);
INSERT INTO customers (full_name,email,phone,license_no) VALUES
('Ali Hassan','ali@email.com','0300-1111111','LHR-001'),
('Sara Khan','sara@email.com','0300-2222222','LHR-002'),
('Umar Farooq','umar@email.com','0300-3333333','LHR-003');
INSERT INTO reservations (customer_id,vehicle_id,start_date,end_date,status) VALUES
(1,1,'2025-06-01','2025-06-05','completed'),
(2,3,'2025-06-03','2025-06-07','completed');
INSERT INTO invoices (reservation_id,subtotal,tax,total,paid) VALUES
(1,20000.00,3600.00,23600.00,1),
(2,48000.00,8640.00,56640.00,1);
GO
