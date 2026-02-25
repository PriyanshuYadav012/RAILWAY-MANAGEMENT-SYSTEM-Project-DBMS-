-- Railway Management System SQL Database Schema and Sample Data

DROP DATABASE IF EXISTS railway_management_system;
CREATE DATABASE RailwayManagementDB;
USE RailwayManagementDB;

-- 1. MASTER TABLES
CREATE TABLE passenger (
  passenger_id INT PRIMARY KEY AUTO_INCREMENT,
  full_name VARCHAR(100) NOT NULL,
  age INT CHECK (age > 0),
  gender ENUM('M','F','O') NOT NULL,
  phone VARCHAR(15) UNIQUE,
  email VARCHAR(120) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE station (
  station_id INT PRIMARY KEY AUTO_INCREMENT,
  station_code VARCHAR(10) NOT NULL UNIQUE,
  station_name VARCHAR(100) NOT NULL,
  city VARCHAR(80) NOT NULL,
  state VARCHAR(80) NOT NULL
);

CREATE TABLE train (
  train_id INT PRIMARY KEY,
  train_name VARCHAR(120) NOT NULL,
  train_type ENUM('Express','Superfast','Passenger','Mail','Rajdhani','Shatabdi') NOT NULL,
  total_seats INT NOT NULL CHECK (total_seats > 0)
);

-- 2. ROUTE + SCHEDULE
CREATE TABLE route (
  route_id INT PRIMARY KEY AUTO_INCREMENT,
  train_id INT NOT NULL,
  source_station_id INT NOT NULL,
  destination_station_id INT NOT NULL,
  distance_km DECIMAL(8,2) NOT NULL CHECK (distance_km > 0),
  CONSTRAINT fk_route_train FOREIGN KEY (train_id) REFERENCES train(train_id) ON DELETE CASCADE,
  CONSTRAINT fk_route_source FOREIGN KEY (source_station_id) REFERENCES station(station_id),
  CONSTRAINT fk_route_destination FOREIGN KEY (destination_station_id) REFERENCES station(station_id),
  CONSTRAINT chk_source_destination CHECK (source_station_id <> destination_station_id),
  UNIQUE (train_id, source_station_id, destination_station_id)
);

CREATE TABLE schedule (
  schedule_id INT PRIMARY KEY AUTO_INCREMENT,
  train_id INT NOT NULL,
  departure_time TIME NOT NULL,
  arrival_time TIME NOT NULL,
  running_day ENUM('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday','Daily') NOT NULL,
  CONSTRAINT fk_schedule_train FOREIGN KEY (train_id) REFERENCES train(train_id) ON DELETE CASCADE
);

-- 3. TICKETING + PAYMENT
CREATE TABLE ticket (
  ticket_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  passenger_id INT NOT NULL,
  train_id INT NOT NULL,
  source_station_id INT NOT NULL,
  destination_station_id INT NOT NULL,
  journey_date DATE NOT NULL,
  seat_number VARCHAR(10),
  booking_status ENUM('Confirmed','Waiting','Cancelled') NOT NULL DEFAULT 'Waiting',
  fare DECIMAL(10,2) NOT NULL CHECK (fare >= 0),
  booked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_ticket_passenger FOREIGN KEY (passenger_id) REFERENCES passenger(passenger_id),
  CONSTRAINT fk_ticket_train FOREIGN KEY (train_id) REFERENCES train(train_id),
  CONSTRAINT fk_ticket_source FOREIGN KEY (source_station_id) REFERENCES station(station_id),
  CONSTRAINT fk_ticket_destination FOREIGN KEY (destination_station_id) REFERENCES station(station_id),
  CONSTRAINT chk_ticket_src_dest CHECK (source_station_id <> destination_station_id)
);

CREATE TABLE payment (
  payment_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  ticket_id BIGINT NOT NULL,
  amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
  payment_mode ENUM('UPI','Card','NetBanking','Cash') NOT NULL,
  payment_status ENUM('Success','Failed','Refunded','Pending') NOT NULL,
  transaction_ref VARCHAR(50) UNIQUE,
  transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_payment_ticket FOREIGN KEY (ticket_id) REFERENCES ticket(ticket_id) ON DELETE CASCADE
);

-- 4. INDEXES
CREATE INDEX idx_ticket_train_date ON ticket (train_id, journey_date);
CREATE INDEX idx_ticket_passenger ON ticket (passenger_id);
CREATE INDEX idx_payment_status ON payment (payment_status);

-- 5. SAMPLE DATA
INSERT INTO station (station_code, station_name, city, state) VALUES
('NDLS','New Delhi','Delhi','Delhi'),
('CNB','Kanpur Central','Kanpur','Uttar Pradesh'),
('PRYJ','Prayagraj Junction','Prayagraj','Uttar Pradesh'),
('DDU','Pt. Deen Dayal Upadhyay Jn','Mughalsarai','Uttar Pradesh'),
('HWH','Howrah Junction','Howrah','West Bengal'),
('BCT','Mumbai Central','Mumbai','Maharashtra');

INSERT INTO train (train_id, train_name, train_type, total_seats) VALUES
(12301,'Rajdhani Express','Rajdhani',1200),
(12230,'Lucknow Mail','Mail',900),
(12952,'Mumbai Rajdhani','Rajdhani',1100),
(12002,'Shatabdi Express','Shatabdi',700);

INSERT INTO passenger (full_name, age, gender, phone, email) VALUES
('Priyanshu Yadav',21,'M','9876500001','priyanshu@example.com'),
('Ananya Singh',22,'F','9876500002','ananya@example.com'),
('Rohit Verma',25,'M','9876500003','rohit@example.com'),
('Ishita Sharma',20,'F','9876500004','ishita@example.com');

-- Fetch station ids dynamically for readable inserts
INSERT INTO route (train_id, source_station_id, destination_station_id, distance_km)
SELECT 12301, s1.station_id, s2.station_id, 1447.00
FROM station s1, station s2
WHERE s1.station_code='NDLS' AND s2.station_code='HWH';

INSERT INTO route (train_id, source_station_id, destination_station_id, distance_km)
SELECT 12230, s1.station_id, s2.station_id, 440.00
FROM station s1, station s2
WHERE s1.station_code='NDLS' AND s2.station_code='CNB';

INSERT INTO route (train_id, source_station_id, destination_station_id, distance_km)
SELECT 12952, s1.station_id, s2.station_id, 1385.00
FROM station s1, station s2
WHERE s1.station_code='BCT' AND s2.station_code='NDLS';

INSERT INTO schedule (train_id, departure_time, arrival_time, running_day) VALUES
(12301,'16:55:00','10:00:00','Daily'),
(12230,'22:10:00','05:30:00','Daily'),
(12952,'17:00:00','08:35:00','Daily'),
(12002,'06:00:00','12:00:00','Monday');

-- Tickets
INSERT INTO ticket (passenger_id, train_id, source_station_id, destination_station_id, journey_date, seat_number, booking_status, fare)
SELECT p.passenger_id, 12301, s1.station_id, s2.station_id, '2026-03-10', 'B2-24', 'Confirmed', 2450.00
FROM passenger p, station s1, station s2
WHERE p.email='priyanshu@example.com' AND s1.station_code='NDLS' AND s2.station_code='HWH';

INSERT INTO ticket (passenger_id, train_id, source_station_id, destination_station_id, journey_date, seat_number, booking_status, fare)
SELECT p.passenger_id, 12230, s1.station_id, s2.station_id, '2026-03-11', NULL, 'Waiting', 780.00
FROM passenger p, station s1, station s2
WHERE p.email='ananya@example.com' AND s1.station_code='NDLS' AND s2.station_code='CNB';

INSERT INTO payment (ticket_id, amount, payment_mode, payment_status, transaction_ref)
SELECT t.ticket_id, t.fare, 'UPI', 'Success', 'TXN100001'
FROM ticket t
JOIN passenger p ON p.passenger_id = t.passenger_id
WHERE p.email='priyanshu@example.com'
ORDER BY t.ticket_id DESC
LIMIT 1;

INSERT INTO payment (ticket_id, amount, payment_mode, payment_status, transaction_ref)
SELECT t.ticket_id, t.fare, 'Card', 'Pending', 'TXN100002'
FROM ticket t
JOIN passenger p ON p.passenger_id = t.passenger_id
WHERE p.email='ananya@example.com'
ORDER BY t.ticket_id DESC
LIMIT 1;

-- 6. CORE OPERATIONS

-- A) BOOK A NEW TICKET
INSERT INTO ticket (passenger_id, train_id, source_station_id, destination_station_id, journey_date, seat_number, booking_status, fare)
VALUES (1, 12952, 6, 1, '2026-03-15', 'A1-12', 'Confirmed', 2200.00);

-- B) CANCEL TICKET
UPDATE ticket
SET booking_status = 'Cancelled', seat_number = NULL
WHERE ticket_id = 2;

-- C) MARK REFUND IN PAYMENT
UPDATE payment
SET payment_status = 'Refunded'
WHERE ticket_id = 2;

-- 7. USEFUL REPORTING QUERIES

-- 1. Passenger booking history
SELECT 
  p.full_name,
  t.ticket_id,
  tr.train_name,
  ss.station_name AS source_station,
  ds.station_name AS destination_station,
  t.journey_date,
  t.seat_number,
  t.booking_status,
  t.fare
FROM ticket t
JOIN passenger p ON p.passenger_id = t.passenger_id
JOIN train tr ON tr.train_id = t.train_id
JOIN station ss ON ss.station_id = t.source_station_id
JOIN station ds ON ds.station_id = t.destination_station_id
ORDER BY t.booked_at DESC;

-- 2. Daily revenue (successful payments only)
SELECT
  DATE(transaction_date) AS payment_day,
  SUM(amount) AS total_revenue
FROM payment
WHERE payment_status = 'Success'
GROUP BY DATE(transaction_date)
ORDER BY payment_day;

-- 3. Train occupancy for a date (confirmed seats only)
SELECT
  tr.train_id,
  tr.train_name,
  tr.total_seats,
  COUNT(CASE WHEN t.booking_status = 'Confirmed' THEN 1 END) AS confirmed_bookings,
  ROUND((COUNT(CASE WHEN t.booking_status = 'Confirmed' THEN 1 END) * 100.0 / tr.total_seats),2) AS occupancy_percent
FROM train tr
LEFT JOIN ticket t ON t.train_id = tr.train_id AND t.journey_date = '2026-03-10'
GROUP BY tr.train_id, tr.train_name, tr.total_seats
ORDER BY occupancy_percent DESC;

-- 4. Waiting list report
SELECT
  t.ticket_id,
  p.full_name,
  tr.train_name,
  t.journey_date,
  t.booking_status
FROM ticket t
JOIN passenger p ON p.passenger_id = t.passenger_id
JOIN train tr ON tr.train_id = t.train_id
WHERE t.booking_status = 'Waiting'
ORDER BY t.booked_at;

-- 5. Tickets between two stations
SELECT
  t.ticket_id,
  p.full_name,
  tr.train_name,
  t.journey_date,
  t.booking_status
FROM ticket t
JOIN passenger p ON p.passenger_id = t.passenger_id
JOIN train tr ON tr.train_id = t.train_id
JOIN station s1 ON s1.station_id = t.source_station_id
JOIN station s2 ON s2.station_id = t.destination_station_id
WHERE s1.station_code = 'NDLS' AND s2.station_code = 'HWH';

-- 8. OPTIONAL VIEW
CREATE OR REPLACE VIEW v_ticket_details AS
SELECT 
  t.ticket_id,
  p.full_name,
  tr.train_name,
  ss.station_code AS source_code,
  ds.station_code AS destination_code,
  t.journey_date,
  t.seat_number,
  t.booking_status,
  t.fare,
  t.booked_at
FROM ticket t
JOIN passenger p ON p.passenger_id = t.passenger_id
JOIN train tr ON tr.train_id = t.train_id
JOIN station ss ON ss.station_id = t.source_station_id
JOIN station ds ON ds.station_id = t.destination_station_id;