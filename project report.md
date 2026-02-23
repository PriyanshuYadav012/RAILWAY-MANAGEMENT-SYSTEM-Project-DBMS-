# Project Report: Railway Management System

## 1. Title
**Railway Management System (RMS)**

## 2. Abstract
The Railway Management System is a database-driven project developed to automate and streamline core railway operations such as passenger registration, train scheduling, station management, ticket booking, seat allocation, and payment tracking. Traditional manual methods for reservation and record management are time-consuming and error-prone. This project demonstrates how a relational database can improve data consistency, reduce redundancy, and support fast retrieval of operational information.

The system is designed using DBMS concepts including entity-relationship modeling, normalization, primary and foreign key constraints, and structured query language (SQL) operations. It aims to provide a practical implementation of transactional data handling in a real-world domain.

## 3. Objectives
1. Design a normalized relational database for railway operations.
2. Maintain accurate records of trains, routes, stations, and schedules.
3. Manage passenger details and reservation history.
4. Support ticket booking, cancellation, and status tracking.
5. Demonstrate SQL operations: `CREATE`, `INSERT`, `UPDATE`, `DELETE`, and `SELECT` with joins and aggregations.
6. Ensure data integrity through constraints and relational mappings.

## 4. Problem Statement
Railway operations involve large volumes of interconnected data, including passenger details, train routes, timetable information, and ticket transactions. Manual or poorly structured systems lead to duplicate records, booking conflicts, delayed query response, and weak reporting capabilities. A robust DBMS solution is required to organize this data systematically and support reliable reservation workflows.

## 5. Scope of the Project
The project covers the following modules:
- Passenger Management
- Train and Station Management
- Route and Schedule Management
- Reservation and Ticketing
- Payment and Booking Status
- Basic administrative reporting

Out of scope:
- Real-time GPS tracking
- Dynamic fare prediction using ML
- Integration with external payment gateways

## 6. Methodology
The project was developed in the following phases:
1. Requirement analysis and module definition
2. ER model design and entity identification
3. Relational schema creation with constraints
4. SQL implementation and sample data population
5. Query testing and output verification
6. Documentation and report preparation

## 7. System Requirements
### Hardware Requirements
- Processor: Intel i3 or above
- RAM: 4 GB minimum
- Storage: 500 MB free space

### Software Requirements
- Operating System: Windows/Linux/macOS
- DBMS: MySQL / PostgreSQL (any relational DBMS)
- SQL Client: MySQL Workbench / pgAdmin / CLI
- Optional Frontend: HTML/CSS/JS or any basic UI tool

## 8. Database Design

### 8.1 Main Entities
- `Passenger`
- `Train`
- `Station`
- `Route`
- `Schedule`
- `Ticket`
- `Payment`

### 8.2 Sample Relational Schema

#### Passenger
- `passenger_id` (PK)
- `full_name`
- `age`
- `gender`
- `phone`
- `email`

#### Train
- `train_id` (PK)
- `train_name`
- `train_type`
- `total_seats`

#### Station
- `station_id` (PK)
- `station_name`
- `city`
- `state`

#### Route
- `route_id` (PK)
- `train_id` (FK -> Train)
- `source_station_id` (FK -> Station)
- `destination_station_id` (FK -> Station)
- `distance_km`

#### Schedule
- `schedule_id` (PK)
- `train_id` (FK -> Train)
- `departure_time`
- `arrival_time`
- `running_day`

#### Ticket
- `ticket_id` (PK)
- `passenger_id` (FK -> Passenger)
- `train_id` (FK -> Train)
- `source_station_id` (FK -> Station)
- `destination_station_id` (FK -> Station)
- `journey_date`
- `seat_number`
- `booking_status`

#### Payment
- `payment_id` (PK)
- `ticket_id` (FK -> Ticket)
- `amount`
- `payment_mode`
- `payment_status`
- `transaction_date`

### 8.3 Normalization
- **1NF:** Atomic values only; no repeating groups.
- **2NF:** Non-key attributes fully depend on the primary key.
- **3NF:** Transitive dependencies minimized by separating payment, passenger, train, and schedule details.

## 9. Key SQL Operations (Illustrative)

### Insert Passenger
```sql
INSERT INTO Passenger (passenger_id, full_name, age, gender, phone, email)
VALUES (101, 'Aman Kumar', 24, 'M', '9876543210', 'aman@example.com');
```

### Book Ticket
```sql
INSERT INTO Ticket (
  ticket_id, passenger_id, train_id, source_station_id, destination_station_id,
  journey_date, seat_number, booking_status
)
VALUES (5001, 101, 2203, 11, 27, '2026-03-10', 'S3-28', 'Confirmed');
```

### View Passenger Booking History
```sql
SELECT p.full_name, t.ticket_id, tr.train_name, t.journey_date, t.booking_status
FROM Ticket t
JOIN Passenger p ON t.passenger_id = p.passenger_id
JOIN Train tr ON t.train_id = tr.train_id
WHERE p.passenger_id = 101;
```

### Cancel Ticket
```sql
UPDATE Ticket
SET booking_status = 'Cancelled'
WHERE ticket_id = 5001;
```

## 10. Expected Outputs
- Successful registration and storage of passenger records
- Ticket booking linked to train and station details
- Accurate booking status updates (confirmed/cancelled/waiting)
- Query-based retrieval of passenger and train information
- Summary reports for administrators

## 11. Testing and Validation
The system was tested using sample datasets for all major entities. Validation checks included:
- Foreign key integrity checks (invalid references rejected)
- Duplicate primary key rejection
- Correct status updates after cancellation
- Correct output of multi-table join queries
- Data consistency after multiple insert/update operations

## 12. Advantages
- Centralized and structured data management
- Faster retrieval of booking and train details
- Reduced manual errors
- Better reporting and monitoring support
- Easy extension for future modules


## 14. Future Enhancements
1. Add role-based login for admin, staff, and passengers.
2. Integrate live train status APIs.
3. Implement dynamic fare calculation and quota handling.
4. Add waitlist prioritization and automatic seat allocation.
5. Build a web/mobile interface for end users.
6. Add analytics dashboard for occupancy and revenue.

## 15. Conclusion
The Railway Management System demonstrates practical DBMS implementation for a complex, real-life domain. By applying relational design principles and SQL operations, the project ensures organized data storage, efficient transaction handling, and reliable query processing. The current system establishes a strong foundation that can be scaled into a full-featured railway reservation platform.

## 16. References
1. Silberschatz, Korth, Sudarshan - *Database System Concepts*.
2. Elmasri & Navathe - *Fundamentals of Database Systems*.
3. Official MySQL / PostgreSQL documentation.
