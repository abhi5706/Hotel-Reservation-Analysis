-- HOTEL RESERVATION OPERATIONS ANALYTICS
-- MySQL Business Analytics Project
-- Database: hotel_reservation_analysis

CREATE DATABASE IF NOT EXISTS hotel_reservation_analysis;
USE hotel_reservation_analysis;

-- =========================================================
-- SPRINT 2: DATABASE SETUP
-- =========================================================

DROP TABLE IF EXISTS stays;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS guests;
DROP TABLE IF EXISTS hotels;

CREATE TABLE guests (
    guest_id VARCHAR(10) PRIMARY KEY,
    guest_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    guest_type ENUM('Individual','Corporate') NOT NULL,
    preferred_room_type ENUM('Standard','Deluxe','Executive','Suite') NOT NULL,
    loyalty_tier ENUM('Silver','Gold','Platinum') NULL,
    account_since DATE NOT NULL
);

CREATE TABLE hotels (
    hotel_id VARCHAR(10) PRIMARY KEY,
    hotel_name VARCHAR(150) NOT NULL,
    city VARCHAR(50) NOT NULL,
    star_rating TINYINT NOT NULL,
    total_rooms INT NOT NULL,
    opened_date DATE NOT NULL
);

CREATE TABLE staff (
    staff_id VARCHAR(10) PRIMARY KEY,
    staff_name VARCHAR(100) NOT NULL,
    hire_date DATE NOT NULL,
    rating DECIMAL(3,2) NOT NULL,
    department VARCHAR(50) NOT NULL,
    is_active ENUM('Yes','No') NOT NULL DEFAULT 'Yes'
);

CREATE TABLE rooms (
    room_id VARCHAR(10) PRIMARY KEY,
    hotel_id VARCHAR(10) NOT NULL,
    room_type ENUM('Standard','Deluxe','Executive','Suite') NOT NULL,
    floor_number INT NOT NULL,
    max_occupancy INT NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL,
    is_active ENUM('Yes','No') NOT NULL DEFAULT 'Yes',
    CONSTRAINT fk_rooms_hotel
        FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id)
);

CREATE TABLE bookings (
    booking_id VARCHAR(10) PRIMARY KEY,
    guest_id VARCHAR(10) NOT NULL,
    hotel_id VARCHAR(10) NOT NULL,
    booking_date DATE NOT NULL,
    room_type_requested ENUM('Standard','Deluxe','Executive','Suite') NOT NULL,
    booking_channel VARCHAR(30) NOT NULL,
    nights_booked INT NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    CONSTRAINT fk_bookings_guest
        FOREIGN KEY (guest_id) REFERENCES guests(guest_id),
    CONSTRAINT fk_bookings_hotel
        FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id)
);

CREATE TABLE stays (
    stay_id VARCHAR(10) PRIMARY KEY,
    booking_id VARCHAR(10) NOT NULL,
    room_id VARCHAR(10) NOT NULL,
    staff_id VARCHAR(10) NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    status ENUM('Checked-out','No-show','Cancelled','In-progress') NOT NULL,
    nights_stayed INT NOT NULL,
    service_requests INT NOT NULL DEFAULT 0,
    stay_duration_hrs INT NOT NULL,
    CONSTRAINT fk_stays_booking
        FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    CONSTRAINT fk_stays_room
        FOREIGN KEY (room_id) REFERENCES rooms(room_id),
    CONSTRAINT fk_stays_staff
        FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

-- =========================================================
-- DATA IMPORT
-- Update the file paths to your local CSV locations.
-- MySQL Workbench Table Data Import Wizard may also be used.
-- Dates in bookings/guests CSV are DD-MM-YYYY; load using
-- STR_TO_DATE if using LOAD DATA.
-- =========================================================

-- Example:
-- LOAD DATA LOCAL INFILE 'C:/path/Dataset/guests.csv'
-- INTO TABLE guests
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- IGNORE 1 ROWS
-- (guest_id,guest_name,city,guest_type,preferred_room_type,@loyalty_tier,@account_since)
-- SET loyalty_tier = NULLIF(@loyalty_tier,''),
--     account_since = STR_TO_DATE(@account_since,'%d-%m-%Y');

-- For the other CSVs, use the MySQL Workbench Import Wizard
-- or adapt the following date formats:
-- hotels.opened_date: %Y-%m-%d
-- staff.hire_date: %Y-%m-%d
-- rooms: no date columns
-- bookings.booking_date: %d-%m-%Y
-- stays.check_in_date/check_out_date: %Y-%m-%d

LOAD DATA LOCAL INFILE "D:/mysql_project/hotels.csv"
INTO TABLE hotels
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS
(hotel_id,hotel_name,city,star_rating,total_rooms,opened_date);
delete  from  guests;
LOAD DATA LOCAL INFILE "D:/mysql_project/guests.csv"
INTO TABLE guests
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS
(
    guest_id,
    guest_name,
    city,
    guest_type,
    preferred_room_type,
    @loyalty_tier,
    @account_since
)
SET loyalty_tier = NULLIF(@loyalty_tier,''),
    account_since = STR_TO_DATE(@account_since,'%d-%m-%Y');
UPDATE guests
SET loyalty_tier = NULL
WHERE loyalty_tier = '';


LOAD DATA LOCAL INFILE "D:/mysql_project/staff.csv"
INTO TABLE staff
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS
(
    staff_id,
    staff_name,
    @hire_date,
    rating,
    department,
    is_active
)
SET hire_date = STR_TO_DATE(@hire_date,'%Y-%m-%d');

LOAD DATA LOCAL INFILE "D:/mysql_project/rooms.csv"
INTO TABLE rooms
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS
(
    room_id,
    hotel_id,
    room_type,
    floor_number,
    max_occupancy,
    price_per_night,
    is_active
);


LOAD DATA LOCAL INFILE "D:/mysql_project/bookings.csv"
INTO TABLE bookings
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS
(
    booking_id,
    guest_id,
    hotel_id,
    @booking_date,
    room_type_requested,
    booking_channel,
    nights_booked,
    total_amount
)
SET booking_date = STR_TO_DATE(@booking_date,'%d-%m-%Y');


LOAD DATA LOCAL INFILE "D:/mysql_project/stays.csv"
INTO TABLE stays
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS
(
    stay_id,
    booking_id,
    room_id,
    staff_id,
    @check_in_date,
    @check_out_date,
    status,
    nights_stayed,
    service_requests,
    stay_duration_hrs
)
SET check_in_date = STR_TO_DATE(@check_in_date,'%Y-%m-%d'),
    check_out_date = STR_TO_DATE(@check_out_date,'%Y-%m-%d');
SET GLOBAL local_infile = 1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';
LOAD DATA LOCAL INFILE 'D:/mysql_project/stays.csv'
INTO TABLE stays;
select * from bookings;
    
select * from stays;
-- =========================================================
-- DATA VERIFICATION
-- =========================================================

SHOW TABLES;

SELECT COUNT(*) AS total_guests FROM guests;
SELECT COUNT(*) AS total_hotels FROM hotels;
SELECT COUNT(*) AS total_rooms FROM rooms;
SELECT COUNT(*) AS total_bookings FROM bookings;
SELECT COUNT(*) AS total_stays FROM stays;
SELECT COUNT(*) AS total_staff FROM staff;

DESCRIBE guests;
DESCRIBE hotels;
DESCRIBE rooms;
DESCRIBE bookings;
DESCRIBE stays;
DESCRIBE staff;

-- =========================================================
-- SPRINT 1.4: LOGICAL ANALYTICAL SOLUTIONS
-- =========================================================
-- 1. Multiple bookings:
-- guests + bookings; connect guest_id; count bookings per guest.
--
-- 2. Stay outcomes:
-- stays contains status and check-in/check-out information; booking_id
-- can connect the stay to the original booking.
--
-- 3. Individual vs Corporate:
-- guests.guest_type + bookings.guest_id/booking activity.
--
-- 4. Booking channels vs nights/spend:
-- bookings.booking_channel, bookings.nights_booked, bookings.total_amount.
-- Connect bookings to stays through booking_id when actual stay performance
-- is required.
--
-- 5. Staff handled stays:
-- stays.staff_id -> staff.staff_id; use staff name/rating and stay outcome.
--
-- 6. Room type vs stay duration:
-- stays.room_id -> rooms.room_id; compare rooms.room_type and stays.nights_stayed.
--
-- 7. Hotel performance:
-- hotels.hotel_id -> bookings.hotel_id; use hotel details and booking metrics.
--
-- 8. Room capacity vs service requests:
-- rooms.max_occupancy + stays.service_requests through stays.room_id = rooms.room_id.
--
-- 9. Stay outcomes by channel:
-- bookings.booking_channel + stays.status through booking_id.
--
-- 10. Guest bookings and stays:
-- guests -> bookings via guest_id -> stays via booking_id.

-- =========================================================
-- SPRINT 3: BASIC ANALYSIS
-- =========================================================

-- 1. Total guests
SELECT COUNT(*) AS total_guests FROM guests;

-- 2. Total bookings
SELECT COUNT(*) AS total_bookings FROM bookings;

-- 3. Total stays
SELECT COUNT(*) AS total_stays FROM stays;

-- 4. Different room types
SELECT DISTINCT room_type
FROM rooms
ORDER BY room_type;

-- 5. Active staff
SELECT COUNT(*) AS active_staff
FROM staff
WHERE is_active = 'Yes';

-- 6. Different booking channels
SELECT DISTINCT booking_channel
FROM bookings
ORDER BY booking_channel;

-- 7. Total booking amount
SELECT ROUND(SUM(total_amount),2) AS total_booking_amount
FROM bookings;

-- 8. Average nights booked
SELECT ROUND(AVG(nights_booked),2) AS avg_nights_booked
FROM bookings;

-- =========================================================
-- SPRINT 4.1: UNDERSTAND BOOKING DEMAND
-- =========================================================

-- Q1. Which hotels have the highest booking volume?
SELECT h.hotel_name, COUNT(*) AS total_bookings
FROM bookings b
JOIN hotels h ON b.hotel_id = h.hotel_id
GROUP BY h.hotel_id, h.hotel_name
ORDER BY total_bookings DESC;

-- Q2. Which booking channels generate the most bookings and revenue?
SELECT booking_channel,
       COUNT(*) AS total_bookings,
       ROUND(SUM(total_amount),2) AS total_booking_amount,
       ROUND(AVG(total_amount),2) AS avg_booking_amount
FROM bookings
GROUP BY booking_channel
ORDER BY total_bookings DESC;

-- Q3. How does booking volume vary by requested room type?
SELECT room_type_requested,
       COUNT(*) AS total_bookings,
       ROUND(SUM(total_amount),2) AS total_amount,
       ROUND(AVG(nights_booked),2) AS avg_nights
FROM bookings
GROUP BY room_type_requested
ORDER BY total_bookings DESC;

-- Q4. How does booking demand change by month?
SELECT YEAR(booking_date) AS booking_year,
       MONTH(booking_date) AS booking_month,
       COUNT(*) AS total_bookings,
       ROUND(SUM(total_amount),2) AS total_amount
FROM bookings
GROUP BY YEAR(booking_date), MONTH(booking_date)
ORDER BY booking_year, booking_month;

-- Q5. Which hotels generate the most booking revenue?
SELECT h.hotel_name,
       COUNT(*) AS bookings,
       ROUND(SUM(b.total_amount),2) AS revenue
FROM bookings b
JOIN hotels h ON b.hotel_id = h.hotel_id
GROUP BY h.hotel_id, h.hotel_name
ORDER BY revenue DESC;

-- =========================================================
-- SPRINT 4.2: GUEST BOOKING BEHAVIOUR
-- =========================================================

-- Q1. Which guests have made multiple bookings?
SELECT g.guest_id, g.guest_name, COUNT(b.booking_id) AS total_bookings
FROM guests g
JOIN bookings b ON g.guest_id = b.guest_id
GROUP BY g.guest_id, g.guest_name
HAVING COUNT(b.booking_id) > 1
ORDER BY total_bookings DESC;

-- Q2. Which guests have the highest total booking amount?
SELECT g.guest_id, g.guest_name,
       COUNT(b.booking_id) AS bookings,
       ROUND(SUM(b.total_amount),2) AS total_amount
FROM guests 
JOIN bookings b ON g.guest_id = b.guest_id
GROUP BY g.guest_id, g.guest_name
ORDER BY total_amount DESC
LIMIT 10;

-- Q3. Individual vs Corporate booking behaviour
SELECT g.guest_type,
       COUNT(b.booking_id) AS total_bookings,
       ROUND(SUM(b.total_amount),2) AS total_amount,
       ROUND(AVG(b.total_amount),2) AS avg_booking_amount,
       ROUND(AVG(b.nights_booked),2) AS avg_nights
FROM guests g
JOIN bookings b ON g.guest_id = b.guest_id
GROUP BY g.guest_type;

-- Q4. Guest activity across hotels
SELECT g.guest_type, h.hotel_name,
       COUNT(b.booking_id) AS total_bookings,
       ROUND(SUM(b.total_amount),2) AS total_amount
FROM guests g
JOIN bookings b ON g.guest_id = b.guest_id
JOIN hotels h ON b.hotel_id = h.hotel_id
GROUP BY g.guest_type, h.hotel_id, h.hotel_name
ORDER BY g.guest_type, total_bookings DESC;

-- Q5. Booking patterns by month
SELECT YEAR(b.booking_date) AS booking_year,
       MONTH(b.booking_date) AS booking_month,
       COUNT(*) AS total_bookings
FROM bookings b
GROUP BY YEAR(b.booking_date), MONTH(b.booking_date)
ORDER BY booking_year, booking_month;

-- =========================================================
-- SPRINT 4.3: EVALUATE STAY PERFORMANCE
-- =========================================================

-- Q1. Stay outcomes by hotel
SELECT h.hotel_name, s.status,
       COUNT(*) AS total_stays
FROM stays s
JOIN bookings b ON s.booking_id = b.booking_id
JOIN hotels h ON b.hotel_id = h.hotel_id
GROUP BY h.hotel_id, h.hotel_name, s.status
ORDER BY h.hotel_name, total_stays DESC;

-- Q2. Overall stay outcome distribution
SELECT status, COUNT(*) AS total_stays
FROM stays
GROUP BY status
ORDER BY total_stays DESC;

-- Q3. Average stay duration by outcome
SELECT status,
       ROUND(AVG(nights_stayed),2) AS avg_nights_stayed,
       ROUND(AVG(stay_duration_hrs),2) AS avg_duration_hours
FROM stays
GROUP BY status;

-- Q4. Hotels with the highest problem rate
SELECT h.hotel_name,
       COUNT(*) AS total_stays,
       SUM(CASE WHEN s.status IN ('Cancelled','No-show') THEN 1 ELSE 0 END) AS problem_stays,
       ROUND(
          100.0 * SUM(CASE WHEN s.status IN ('Cancelled','No-show') THEN 1 ELSE 0 END)
          / COUNT(*), 2
       ) AS problem_rate_pct
FROM stays s
JOIN bookings b ON s.booking_id = b.booking_id
JOIN hotels h ON b.hotel_id = h.hotel_id
GROUP BY h.hotel_id, h.hotel_name
ORDER BY problem_rate_pct DESC;

-- Q5. Stay performance by month
SELECT YEAR(check_in_date) AS stay_year,
       MONTH(check_in_date) AS stay_month,
       status,
       COUNT(*) AS total_stays
FROM stays
GROUP BY YEAR(check_in_date), MONTH(check_in_date), status
ORDER BY stay_year, stay_month, status;

-- =========================================================
-- SPRINT 4.4: STAFF AND ROOM PERFORMANCE
-- =========================================================

-- Q1. Staff members handling the most stays
SELECT st.staff_id, st.staff_name, st.department,
       COUNT(s.stay_id) AS stays_handled,
       ROUND(st.rating,2) AS staff_rating
FROM staff st
JOIN stays s ON st.staff_id = s.staff_id
GROUP BY st.staff_id, st.staff_name, st.department, st.rating
ORDER BY stays_handled DESC;

-- Q2. Staff performance by stay outcome
SELECT st.staff_name, st.department, s.status,
       COUNT(*) AS total_stays
FROM staff st
JOIN stays s ON st.staff_id = s.staff_id
GROUP BY st.staff_id, st.staff_name, st.department, s.status
ORDER BY st.staff_name, total_stays DESC;

-- Q3. Room usage by room type
SELECT r.room_type,
       COUNT(s.stay_id) AS total_stays,
       ROUND(AVG(s.nights_stayed),2) AS avg_nights,
       ROUND(AVG(s.service_requests),2) AS avg_service_requests
FROM rooms r
JOIN stays s ON r.room_id = s.room_id
GROUP BY r.room_type
ORDER BY total_stays DESC;

-- Q4. Stay performance by room
SELECT r.room_id, r.room_type,
       COUNT(s.stay_id) AS stays,
       ROUND(AVG(s.nights_stayed),2) AS avg_nights,
       ROUND(AVG(s.service_requests),2) AS avg_requests
FROM rooms r
JOIN stays s ON r.room_id = s.room_id
GROUP BY r.room_id, r.room_type
ORDER BY stays DESC;

-- Q5. Does larger room capacity relate to service requests?
SELECT r.max_occupancy,
       COUNT(s.stay_id) AS stays,
       ROUND(AVG(s.service_requests),2) AS avg_service_requests
FROM rooms r
JOIN stays s ON r.room_id = s.room_id
GROUP BY r.max_occupancy
ORDER BY r.max_occupancy;

-- =========================================================
-- SPRINT 4.5: IDENTIFY BOOKING AND STAY PROBLEMS
-- =========================================================

-- Q1. Bookings resulting in cancellations/no-shows
SELECT b.booking_id, b.guest_id, b.hotel_id,
       b.booking_channel, s.status
FROM bookings b
JOIN stays s ON b.booking_id = s.booking_id
WHERE s.status IN ('Cancelled','No-show')
ORDER BY b.booking_id;

-- Q2. Common stay statuses
SELECT status, COUNT(*) AS total_stays,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM stays),2) AS pct_of_stays
FROM stays
GROUP BY status
ORDER BY total_stays DESC;

-- Q3. High service-request stays
SELECT s.stay_id, s.booking_id, s.room_id, s.service_requests,
       s.status, s.nights_stayed
FROM stays s
WHERE s.service_requests >= 3
ORDER BY s.service_requests DESC, s.nights_stayed DESC;

-- Q4. Compare stay outcome by service-request level
SELECT
    CASE
        WHEN service_requests = 0 THEN '0 Requests'
        WHEN service_requests BETWEEN 1 AND 2 THEN '1-2 Requests'
        ELSE '3+ Requests'
    END AS request_group,
    COUNT(*) AS total_stays,
    ROUND(AVG(nights_stayed),2) AS avg_nights
FROM stays
GROUP BY request_group
ORDER BY total_stays DESC;

-- Q5. Hotels with the most booking/stay problems
SELECT h.hotel_name,
       SUM(CASE WHEN s.status IN ('Cancelled','No-show') THEN 1 ELSE 0 END) AS problem_stays,
       COUNT(*) AS total_stays,
       ROUND(100.0 * SUM(CASE WHEN s.status IN ('Cancelled','No-show') THEN 1 ELSE 0 END)/COUNT(*),2) AS problem_rate_pct
FROM stays s
JOIN bookings b ON s.booking_id = b.booking_id
JOIN hotels h ON b.hotel_id = h.hotel_id
GROUP BY h.hotel_id, h.hotel_name
ORDER BY problem_rate_pct DESC;

