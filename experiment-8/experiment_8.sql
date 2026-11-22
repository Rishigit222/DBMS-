-- ============================================================================
-- Experiment 8: Transactions and Concurrency Control
-- Aim: Implement banking-style transactions using BEGIN, COMMIT, ROLLBACK,
--      and SAVEPOINT. Simulate partial failures. Demonstrate transaction
--      isolation levels and concurrency anomalies using two sessions.
-- ============================================================================

CREATE DATABASE IF NOT EXISTS BankingDB;
USE BankingDB;

-- Clean up existing table to support repeatable runs
DROP TABLE IF EXISTS Accounts;

-- ----------------------------------------------------------------------------
-- Step 1: Create Banking Table & Insert Initial Records
-- ----------------------------------------------------------------------------
CREATE TABLE Accounts (
    Account_ID INT PRIMARY KEY,
    Holder_Name VARCHAR(50),
    Balance DECIMAL(10, 2)
);

INSERT INTO Accounts VALUES
(101, 'Amit', 10000.00),
(102, 'Rahul', 8000.00);

SELECT * FROM Accounts;

-- ----------------------------------------------------------------------------
-- Step 2: BEGIN and COMMIT (Atomic Fund Transfer)
-- Transfer 2000 from Amit (101) to Rahul (102).
-- ----------------------------------------------------------------------------
START TRANSACTION;

UPDATE Accounts
SET Balance = Balance - 2000.00
WHERE Account_ID = 101;

UPDATE Accounts
SET Balance = Balance + 2000.00
WHERE Account_ID = 102;

COMMIT;

SELECT * FROM Accounts;

-- ----------------------------------------------------------------------------
-- Step 3: ROLLBACK (Full Transaction Abort)
-- Attempt an unauthorized or invalid debit of 5000 from Amit and roll back.
-- ----------------------------------------------------------------------------
START TRANSACTION;

UPDATE Accounts
SET Balance = Balance - 5000.00
WHERE Account_ID = 101;

-- Abort transaction: balance reverts to post-commit state (8000.00)
ROLLBACK;

SELECT * FROM Accounts;

-- ----------------------------------------------------------------------------
-- Step 4: SAVEPOINT and Partial Rollback
-- Apply a valid debit of 1000, establish a savepoint, simulate an excessive
-- debit of 20000, and roll back only to the savepoint before committing.
-- ----------------------------------------------------------------------------
START TRANSACTION;

UPDATE Accounts
SET Balance = Balance - 1000.00
WHERE Account_ID = 101;

SAVEPOINT sp1;

UPDATE Accounts
SET Balance = Balance - 20000.00
WHERE Account_ID = 102;

-- Roll back only the invalid debit on Account 102
ROLLBACK TO SAVEPOINT sp1;

COMMIT;

SELECT * FROM Accounts;

-- ----------------------------------------------------------------------------
-- Step 5: Partial Failure Simulation
-- Debit 500 from Amit (101) and attempt to credit non-existent account 999.
-- Transaction is rolled back to preserve consistency.
-- ----------------------------------------------------------------------------
START TRANSACTION;

UPDATE Accounts
SET Balance = Balance - 500.00
WHERE Account_ID = 101;

-- Simulated failure: target account does not exist
UPDATE Accounts
SET Balance = Balance + 500.00
WHERE Account_ID = 999;

ROLLBACK;

SELECT * FROM Accounts;

-- ----------------------------------------------------------------------------
-- Step 6: Transaction Isolation Levels Demonstration
-- Configure transaction isolation levels: READ COMMITTED, REPEATABLE READ,
-- and SERIALIZABLE.
-- ----------------------------------------------------------------------------
-- 1. READ COMMITTED
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT * FROM Accounts;
COMMIT;

-- 2. REPEATABLE READ (MySQL InnoDB Default)
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT * FROM Accounts;
COMMIT;

-- 3. SERIALIZABLE (Strictest isolation level)
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
SELECT * FROM Accounts;
COMMIT;

-- ----------------------------------------------------------------------------
-- Step 7: Concurrency Anomaly Demonstration (Two Sessions)
-- Demonstrates read consistency / non-repeatable read prevention.
--
-- INSTRUCTIONS FOR DUAL-SESSION EXECUTION:
-- Open two separate MySQL client connections (Terminal 1 and Terminal 2).
-- Execute the statements in the exact numbered order below:
--
-- Terminal 1 (Session 1):
--   START TRANSACTION;
--   SELECT Balance FROM Accounts WHERE Account_ID = 101; -- Reads 7000.00
--
-- Terminal 2 (Session 2):
--   START TRANSACTION;
--   UPDATE Accounts SET Balance = Balance - 500 WHERE Account_ID = 101;
--   COMMIT;                                             -- Committed 6500.00
--
-- Terminal 1 (Session 1):
--   SELECT Balance FROM Accounts WHERE Account_ID = 101;
--   -- In REPEATABLE READ: Reads consistent snapshot (7000.00)
--   -- In READ COMMITTED:  Reads updated value (6500.00)
--   COMMIT;
-- ----------------------------------------------------------------------------

-- Sequential simulation script for automated batch execution:
-- Session 1 reads initial balance
START TRANSACTION;
SELECT Balance AS Session1_Initial_Read FROM Accounts WHERE Account_ID = 101;
COMMIT;

-- Session 2 executes update and commits
START TRANSACTION;
UPDATE Accounts SET Balance = Balance - 500.00 WHERE Account_ID = 101;
COMMIT;

-- Session 1 verifies final balance
START TRANSACTION;
SELECT Balance AS Session1_Subsequent_Read FROM Accounts WHERE Account_ID = 101;
COMMIT;

-- ----------------------------------------------------------------------------
-- Step 8: Final Account Table Verification
-- ----------------------------------------------------------------------------
SELECT * FROM Accounts;
