# Experiment 9: Database Indexing

## Aim

Create a Railway Booking table populated with at least 5,000 records. Benchmark query performance before and after creating single-column and composite indexes. Use `EXPLAIN` to compare execution plans.

## Concepts Covered

- **B-Tree Indexing**: Accelerating search and retrieval operations by maintaining balanced index trees.
- **Execution Plan Analysis (`EXPLAIN`)**:
  - `type`: Access type transitioning from `ALL` (full table scan) to `ref` (non-unique index lookup).
  - `possible_keys`: Indexes candidate for lookup.
  - `key`: The specific index selected by the MySQL query optimizer.
  - `key_len`: Length of the chosen index key in bytes (e.g., 5 bytes for `INT NULL`, 9 bytes for `INT + DATE`).
  - `rows`: Estimated number of rows scanned by the storage engine.
- **Single-Column Index**: Indexing a high-cardinality search attribute (`Train_No`).
- **Composite Index**: Multi-column indexing on `(Train_No, Journey_Date)` leveraging the leftmost prefix rule.
- **Automated Synthetic Data Generation**: Writing MySQL stored procedures with looping constructs to seed realistic benchmarking datasets.

## Database Objects / Implementation

- Database: `RailwayDB`
- Table `Railway_Booking`:
  - `Booking_ID INT PRIMARY KEY`
  - `Passenger_Name VARCHAR(50)`
  - `Train_No INT`
  - `Source VARCHAR(50)`
  - `Destination VARCHAR(50)`
  - `Journey_Date DATE`
  - `Seat_No INT`
  - `Fare DECIMAL(10, 2)`
- Stored Procedure `InsertBookings()`: Inserts 5,000 generated booking rows with cyclic variation across train numbers, dates, and fares.
- Indexes:
  - `idx_train`: Single-column index on `Railway_Booking(Train_No)`.
  - `idx_train_date`: Composite index on `Railway_Booking(Train_No, Journey_Date)`.

## SQL Operations Performed

1. **Table Definition & Data Seeding**:
   - Defined `Railway_Booking` schema with primary key constraint.
   - Implemented `InsertBookings()` using MySQL `DELIMITER $$` and a `WHILE` loop to insert 5,000 rows.
2. **Baseline Query Analysis (Before Indexing)**:
   - Executed `EXPLAIN SELECT * FROM Railway_Booking WHERE Train_No = 12005;`.
   - Verified that the optimizer performs a full table scan (`type: ALL`, `key: NULL`, `rows: ~5000`).
3. **Single-Column Indexing**:
   - Created index `idx_train` on column `Train_No`.
   - Re-executed `EXPLAIN` and observed the transition to index lookup (`type: ref`, `key: idx_train`, `rows: ~250`).
4. **Composite Indexing**:
   - Created composite index `idx_train_date` on `(Train_No, Journey_Date)`.
   - Executed `EXPLAIN SELECT * ... WHERE Train_No = 12005 AND Journey_Date = '2026-03-15';`.
   - Observed pinpoint row scanning (`type: ref`, `key: idx_train_date`, `rows: 1`).
5. **Execution Verification**: Executed both indexed queries to verify fast and accurate result retrieval.

## Execution Instructions

Run from the repository root:

```bash
mysql -u <username> -p < experiment-9/experiment_9.sql
```

The script creates the independent `RailwayDB` database, compiles and executes the procedure to generate 5,000 rows, and runs all benchmarking queries.

## Expected Results

- Dataset size: Exactly 5,000 rows generated in `Railway_Booking`.
- Unindexed query scans the entire table (~5,000 rows examined).
- Single-column index `idx_train` reduces examined rows to approximately 250 rows (~95% reduction).
- Composite index `idx_train_date` pinpoints the target tuple directly (`rows: 1`).

## Files Included

- [SQL source](./experiment_9.sql)
- [Original submission](./dbms_exp_9.pdf)
