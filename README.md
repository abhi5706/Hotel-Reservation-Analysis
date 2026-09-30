# Hotel Reservation Operations Analytics

## MySQL Business Analytics Project

This project analyzes hotel reservation operations for **StayPoint Hospitality** using MySQL. The analysis focuses on booking demand, guest booking behaviour, stay outcomes, staff and room utilization, and booking/stay problems.

The project follows a sprint-based analytics workflow:

1. Business Understanding and Data Understanding
2. Database Setup
3. Basic Analysis / Data Exploration
4. Objective-Based Analysis

---

## Project Overview

The objective of this project is to move from a business requirement to a data-driven answer by:

- Understanding the hotel reservation business problem
- Understanding the database/ER model
- Designing and creating a relational MySQL database
- Importing and verifying the project data
- Writing SQL queries for basic analysis
- Performing objective-based business analysis
- Interpreting results and identifying business insights
- Communicating meaningful conclusions and recommendations

The project documentation identifies the main business areas as booking demand, guest behaviour, stay performance, staff and room performance, and booking/stay problems.

---

## Dataset Overview

The project contains six relational tables:

| Table | Rows | Columns | Purpose |
|---|---:|---:|---|
| `guests` | 350 | 7 | Guest information and preferences |
| `hotels` | 25 | 6 | Hotel/property information |
| `rooms` | 600 | 7 | Room details and capacity |
| `bookings` | 2,800 | 8 | Reservation and booking information |
| `stays` | 3,200 | 10 | Stay, outcome, room and service information |
| `staff` | 70 | 6 | Staff information and ratings |

---

## Database Structure

The main relationships used in the project are:

- `rooms.hotel_id` → `hotels.hotel_id`
- `bookings.guest_id` → `guests.guest_id`
- `bookings.hotel_id` → `hotels.hotel_id`
- `stays.booking_id` → `bookings.booking_id`
- `stays.room_id` → `rooms.room_id`
- `stays.staff_id` → `staff.staff_id`

The SQL script creates the database, creates the tables with primary/foreign keys and constraints, imports the CSV data, verifies the tables, and performs the analytical queries.

---

## Sprint 1 – Business Understanding and Data Understanding

The project begins by understanding the hotel business and the ER diagram.

The analytical situations include:

- Identifying guests with multiple bookings
- Investigating cancelled and no-show stays
- Comparing Individual and Corporate guests
- Comparing booking channels based on nights and spending
- Identifying staff who handled stays and their ratings
- Comparing room types and stay durations
- Comparing hotel booking performance
- Investigating room capacity and service requests
- Comparing stay outcomes across booking channels
- Connecting guests with their bookings and stays

---

## Sprint 2 – Database Setup

The database is created using MySQL.

### Main tasks

- Create the `hotel_reservation_analysis` database
- Create the six project tables
- Define primary keys
- Define foreign keys
- Apply constraints such as `NOT NULL` and `DEFAULT`
- Import the CSV data
- Verify the imported data

The SQL script contains the table definitions and data-import queries.

> **Important:** The SQL file currently contains local Windows CSV paths such as `D:/mysql_project/hotels.csv`. These paths are specific to the original local environment. Before running the import section on another computer, update the paths to match the location of your CSV files.

---

## Sprint 3 – Basic Analysis / Data Exploration

The project performs basic SQL analysis to become familiar with the database.

The questions include:

- What is the total number of guests?
- What is the total number of bookings?
- What is the total number of stays?
- What are the different room types available?
- How many staff members are currently active?
- What are the different booking channels?
- What is the total booking amount?
- What is the average number of nights booked?

---

## Sprint 4 – Objective-Based Analysis

### 4.1 Understand Booking Demand

The analysis examines:

- Booking volume across hotels
- Booking volume across booking channels
- Requested room types
- Booking volume over time
- Booking amount across different groups

### 4.2 Understand Guest Booking Behaviour

The analysis examines:

- Guests with multiple bookings
- Guests with higher total booking amounts
- Guest activity across hotels
- Individual vs Corporate guest behaviour
- Booking patterns over time

### 4.3 Evaluate Stay Performance

The analysis examines:

- Stay outcomes across hotels
- Stay duration
- Stay status distribution
- Hotel-level stay/problem rates
- Stay performance over time

Stay statuses include:

- `Checked-out`
- `No-show`
- `Cancelled`
- `In-progress`

### 4.4 Understand Staff and Room Performance

The analysis examines:

- Number of stays handled by staff
- Staff performance by stay outcome
- Room usage by room type
- Performance across individual rooms
- Room capacity and service-request patterns

### 4.5 Identify Booking and Stay Problems

The analysis examines:

- Cancellations and no-shows
- Common stay statuses
- High service-request stays
- Stay performance by service-request level
- Hotels with higher booking/stay problem rates

---

## SQL File

The main SQL script contains:

- Database creation
- Table creation
- Primary and foreign keys
- Data import statements
- Data verification queries
- Sprint 1.4 logical analytical solutions
- Sprint 3 basic analysis queries
- Sprint 4 objective-based analytical queries

### SQL file

`hotel_reservation_analysis.sql`

---

## How to Run the Project

### Prerequisites

Install:

- MySQL Server
- MySQL Workbench
- The project CSV datasets

### Step 1 – Clone or download the repository

Clone the GitHub repository to your computer.

```bash
git clone <YOUR-GITHUB-REPOSITORY-URL>
cd hotel-reservation-analytics
```

### Step 2 – Open the SQL file

Open:

```text
hotel_reservation_analysis.sql
```

in MySQL Workbench.

### Step 3 – Update CSV paths

Find the `LOAD DATA LOCAL INFILE` statements in the SQL script.

For example:

```sql
LOAD DATA LOCAL INFILE "D:/mysql_project/hotels.csv"
```

Change the path to the location of your CSV files.

### Step 4 – Create the database

Run:

```sql
CREATE DATABASE IF NOT EXISTS hotel_reservation_analysis;
USE hotel_reservation_analysis;
```

### Step 5 – Create the tables

Run the table creation section of the SQL script.

### Step 6 – Import the data

Run the data import statements after updating the CSV file paths.

Alternatively, MySQL Workbench's Table Data Import Wizard can be used.

### Step 7 – Verify the data

Run:

```sql
SHOW TABLES;
```

Then verify the row counts:

```sql
SELECT COUNT(*) AS total_guests FROM guests;
SELECT COUNT(*) AS total_hotels FROM hotels;
SELECT COUNT(*) AS total_rooms FROM rooms;
SELECT COUNT(*) AS total_bookings FROM bookings;
SELECT COUNT(*) AS total_stays FROM stays;
SELECT COUNT(*) AS total_staff FROM staff;
```

You can also inspect table structures using:

```sql
DESCRIBE guests;
DESCRIBE hotels;
DESCRIBE rooms;
DESCRIBE bookings;
DESCRIBE stays;
DESCRIBE staff;
```

---

## Repository Structure

A clean GitHub repository can be organized like this:

```text
hotel-reservation-analytics/
│
├── README.md
├── sql/
│   └── hotel_reservation_analysis.sql
│
├── documentation/
│   └── Hotel_Reservation_Analytics_documentation.docx
│
├── data/
│   ├── guests.csv
│   ├── hotels.csv
│   ├── rooms.csv
│   ├── bookings.csv
│   ├── stays.csv
│   └── staff.csv
│
└── screenshots/
    └── (optional project screenshots)
```

If the CSV datasets are not part of your GitHub submission, remove the `data/` section from the repository structure.

---

## Tools & Technologies

- **MySQL**
- **MySQL Workbench**
- **SQL**
- **Relational Database Design**
- **Git & GitHub**

---

## Key Skills Demonstrated

This project demonstrates:

- Relational database design
- Primary and foreign key relationships
- Data import and verification
- SQL querying
- Joins
- Aggregations
- `GROUP BY`
- `HAVING`
- `CASE`
- Date-based analysis
- Business question formulation
- Operational analytics
- Business insight generation

---

## Project Deliverables

The project documentation specifies the following deliverables:

- ER diagram interpretation and Sprint 1.4 logical solutions
- MySQL database created from the ER diagram
- Imported and verified project data
- SQL queries for Sprint 3
- Analytical questions for Sprint 4 objectives
- Supporting SQL queries
- Findings and business insights
- Final conclusions and recommendations where appropriate

---

## Author

**Pinninti Abhinav**

### Project

**Hotel Reservation Operations Analytics – MySQL Business Analytics Project**
