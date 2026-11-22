-- ============================================================================
-- Experiment 9: Database Indexing and Performance Benchmarking
-- Aim: Create a Railway Booking table with at least 5,000 records.
--      Benchmark query performance before and after creating single-column
--      and composite indexes. Use EXPLAIN to compare execution plans.
-- ============================================================================

CREATE DATABASE IF NOT EXISTS RailwayDB;
USE RailwayDB;

-- Clean up existing objects to support repeatable execution
DROP PROCEDURE IF EXISTS InsertBookings;
DROP TABLE IF EXISTS Railway_Booking;

-- ----------------------------------------------------------------------------
-- Step 1: Create Railway Booking Table
-- ----------------------------------------------------------------------------
CREATE TABLE Railway_Booking (
    Booking_ID INT PRIMARY KEY,
    Passenger_Name VARCHAR(50),
    Train_No INT,
    Source VARCHAR(50),
    Destination VARCHAR(50),
    Journey_Date DATE,
    Seat_No INT,
    Fare DECIMAL(10, 2)
);

-- ----------------------------------------------------------------------------
-- Step 2: Insert 5,000 Records via Stored Procedure
-- ----------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE InsertBookings()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 5000 DO
        INSERT INTO Railway_Booking VALUES (
            i,
            CONCAT('Passenger_', i),
            12000 + (i % 20),
            'Delhi',
            'Lucknow',
            DATE_ADD('2026-01-01', INTERVAL (i % 365) DAY),
            i % 100,
            500 + (i % 1500)
        );
        SET i = i + 1;
    END WHILE;
END$$
DELIMITER ;

CALL InsertBookings();

-- Verify dataset size and inspect initial sample rows
SELECT COUNT(*) AS Total_Bookings FROM Railway_Booking;
SELECT * FROM Railway_Booking LIMIT 10;

-- ----------------------------------------------------------------------------
-- Step 3: Query Execution Plan Before Indexing (Full Table Scan)
-- ----------------------------------------------------------------------------
-- Expects type: ALL, possible_keys: NULL, key: NULL, scanning ~5000 rows
EXPLAIN SELECT * FROM Railway_Booking
WHERE Train_No = 12005;

-- ----------------------------------------------------------------------------
-- Step 4: Single-Column Index Creation and Analysis
-- ----------------------------------------------------------------------------
CREATE INDEX idx_train ON Railway_Booking(Train_No);

-- Inspect optimized execution plan using single-column index
-- Expects type: ref, possible_keys: idx_train, key: idx_train, key_len: 5, rows: ~250
EXPLAIN SELECT * FROM Railway_Booking
WHERE Train_No = 12005;

-- ----------------------------------------------------------------------------
-- Step 5: Composite Index Creation and Analysis
-- ----------------------------------------------------------------------------
CREATE INDEX idx_train_date ON Railway_Booking(Train_No, Journey_Date);

-- Inspect optimized execution plan using composite index
-- Expects type: ref, key: idx_train_date, key_len: 9, rows: ~1
EXPLAIN SELECT * FROM Railway_Booking
WHERE Train_No = 12005
  AND Journey_Date = '2026-03-15';

-- ----------------------------------------------------------------------------
-- Step 6: Query Performance Comparison & Execution Verification
-- ----------------------------------------------------------------------------
-- Single-filter query execution (Index: idx_train)
SELECT * FROM Railway_Booking
WHERE Train_No = 12005;

-- Multi-filter query execution (Composite Index: idx_train_date)
SELECT * FROM Railway_Booking
WHERE Train_No = 12005
  AND Journey_Date = '2026-03-15';

-- Final verification of table records
SELECT * FROM Railway_Booking LIMIT 10;
