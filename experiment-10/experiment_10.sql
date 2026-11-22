-- ============================================================================
-- Experiment 10: Query Optimization and Index Benchmarking
-- Aim: Generate a dataset with at least 10,000 rows. Write five slow queries,
--      analyze execution plans using EXPLAIN, optimize using indexing and
--      query rewriting, and compare execution performance.
-- ============================================================================

CREATE DATABASE IF NOT EXISTS OptimizationDB;
USE OptimizationDB;

-- Clean up existing objects to support repeatable execution
DROP PROCEDURE IF EXISTS GenerateEmployees;
DROP TABLE IF EXISTS Employees;

-- ----------------------------------------------------------------------------
-- Step 1: Create Employees Table
-- ----------------------------------------------------------------------------
CREATE TABLE Employees (
    Emp_ID INT PRIMARY KEY,
    Emp_Name VARCHAR(50),
    Department VARCHAR(30),
    City VARCHAR(30),
    Salary DECIMAL(10, 2),
    Joining_Date DATE
);

-- ----------------------------------------------------------------------------
-- Step 2: Generate 10,000 Records via Stored Procedure
-- ----------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE GenerateEmployees()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 10000 DO
        INSERT INTO Employees VALUES (
            i,
            CONCAT('Employee_', i),
            ELT((i % 5) + 1, 'IT', 'HR', 'Sales', 'Finance', 'Marketing'),
            ELT((i % 4) + 1, 'Delhi', 'Mumbai', 'Lucknow', 'Pune'),
            20000 + (i % 50000),
            DATE_ADD('2020-01-01', INTERVAL (i % 2000) DAY)
        );
        SET i = i + 1;
    END WHILE;
END$$
DELIMITER ;

CALL GenerateEmployees();

-- Inspect sample records
SELECT * FROM Employees LIMIT 10;

-- ----------------------------------------------------------------------------
-- Step 3: Five Slow Queries - EXPLAIN Analysis Before Optimization
-- All queries below result in full table scans (type: ALL, key: NULL, ~10000 rows).
-- ----------------------------------------------------------------------------

-- Query 1: Search by Department
EXPLAIN SELECT * FROM Employees
WHERE Department = 'IT';

-- Query 2: Search by City
EXPLAIN SELECT * FROM Employees
WHERE City = 'Delhi';

-- Query 3: Salary Filtering (Range condition)
EXPLAIN SELECT * FROM Employees
WHERE Salary > 50000;

-- Query 4: Multiple Conditions (Department AND City)
EXPLAIN SELECT * FROM Employees
WHERE Department = 'Sales'
  AND City = 'Mumbai';

-- Query 5: Sorting and Filtering (Filesort overhead)
EXPLAIN SELECT * FROM Employees
WHERE Department = 'HR'
ORDER BY Salary DESC;

-- ----------------------------------------------------------------------------
-- Step 4: Optimization Using Indexing
-- Single-column and composite B-tree indexes designed for search and sort patterns.
-- ----------------------------------------------------------------------------
CREATE INDEX idx_department ON Employees(Department);
CREATE INDEX idx_city ON Employees(City);
CREATE INDEX idx_salary ON Employees(Salary);
CREATE INDEX idx_dept_city ON Employees(Department, City);
CREATE INDEX idx_dept_salary ON Employees(Department, Salary);

-- ----------------------------------------------------------------------------
-- Step 5: Five Optimized Queries - EXPLAIN Analysis After Optimization
-- Index lookups replace full table scans; sorting is satisfied by index order.
-- ----------------------------------------------------------------------------

-- Query 1: Department lookup (type: ref, key: idx_department)
EXPLAIN SELECT * FROM Employees
WHERE Department = 'IT';

-- Query 2: City lookup (type: ref, key: idx_city)
EXPLAIN SELECT * FROM Employees
WHERE City = 'Delhi';

-- Query 3: Salary range lookup (type: range, key: idx_salary)
EXPLAIN SELECT * FROM Employees
WHERE Salary > 50000;

-- Query 4: Department and City composite lookup (type: ref, key: idx_dept_city)
EXPLAIN SELECT * FROM Employees
WHERE Department = 'Sales'
  AND City = 'Mumbai';

-- Query 5: Department filtering with sorted salary (type: ref, key: idx_dept_salary, no filesort)
EXPLAIN SELECT * FROM Employees
WHERE Department = 'HR'
ORDER BY Salary DESC;

-- ----------------------------------------------------------------------------
-- Step 6: Query Rewriting Example (Sargable Predicate Optimization)
-- ----------------------------------------------------------------------------

-- Non-sargable query: Applying YEAR() prevents index usage, causing full table scan
-- Before Optimization:
SELECT * FROM Employees
WHERE YEAR(Joining_Date) = 2022;

-- Sargable query: Rewritten to a bounded range condition
-- After Optimization:
SELECT * FROM Employees
WHERE Joining_Date >= '2022-01-01'
  AND Joining_Date < '2023-01-01';

-- Create Index for Date Search to support the rewritten query
CREATE INDEX idx_joining_date ON Employees(Joining_Date);

-- EXPLAIN rewritten query with index (type: range, key: idx_joining_date)
EXPLAIN SELECT * FROM Employees
WHERE Joining_Date >= '2022-01-01'
  AND Joining_Date < '2023-01-01';

-- ----------------------------------------------------------------------------
-- Step 7: Final Dataset Verification
-- ----------------------------------------------------------------------------
SELECT COUNT(*) AS Total_Records FROM Employees;
