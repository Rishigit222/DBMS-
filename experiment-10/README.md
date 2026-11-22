# Experiment 10: Query Optimization

## Aim

Generate a dataset with at least 10,000 rows. Write five slow queries, analyze them using `EXPLAIN`, optimize them using indexing and query rewriting, and compare execution performance before and after optimization.

## Concepts Covered

- **Query Execution Bottlenecks**: Full table scans (`type: ALL`), unindexed range filters, non-sargable functions in `WHERE` clauses, and external sorting operations (`Using filesort`).
- **Index Optimization Strategies**:
  - Single-column B-tree indexes for selective equality filters.
  - Multi-column composite indexes for compound equality conditions (`Department`, `City`).
  - Index-based sorting: Creating composite index `(Department, Salary)` to eliminate costly `filesort` algorithms.
- **Query Rewriting (Sargable Predicates)**:
  - Non-sargable predicates like `WHERE YEAR(Joining_Date) = 2022` force the database engine to evaluate the function for every single table row, precluding index utilization.
  - Rewriting into an indexed range condition (`WHERE Joining_Date >= '2022-01-01' AND Joining_Date < '2023-01-01'`) enables efficient B-tree range scans (`type: range`).
- **Optimizer Metrics (`EXPLAIN`)**: Tracking changes across access `type`, `possible_keys`, `key`, `key_len`, `rows` scanned, and `Extra` information.

## Database Objects / Implementation

- Database: `OptimizationDB`
- Table `Employees`:
  - `Emp_ID INT PRIMARY KEY`
  - `Emp_Name VARCHAR(50)`
  - `Department VARCHAR(30)`
  - `City VARCHAR(30)`
  - `Salary DECIMAL(10, 2)`
  - `Joining_Date DATE`
- Stored Procedure `GenerateEmployees()`: Populates 10,000 employee records with distributed departments, cities, salaries, and dates using modular expressions.
- Indexes:
  - `idx_department`: Index on `(Department)`
  - `idx_city`: Index on `(City)`
  - `idx_salary`: Index on `(Salary)`
  - `idx_dept_city`: Composite index on `(Department, City)`
  - `idx_dept_salary`: Composite index on `(Department, Salary)`
  - `idx_joining_date`: Index on `(Joining_Date)`

## SQL Operations Performed

1. **Table Creation & 10,000 Record Generation**:
   - Defined `Employees` table with primary key.
   - Implemented `GenerateEmployees()` procedure using `DELIMITER $$` and a 10,000-iteration `WHILE` loop.
2. **Analysis of Five Slow Queries (Before Optimization)**:
   - Query 1: `Department = 'IT'` (`type: ALL`, ~10,000 rows)
   - Query 2: `City = 'Delhi'` (`type: ALL`, ~10,000 rows)
   - Query 3: `Salary > 50000` (`type: ALL`, ~10,000 rows)
   - Query 4: `Department = 'Sales' AND City = 'Mumbai'` (`type: ALL`, ~10,000 rows)
   - Query 5: `Department = 'HR' ORDER BY Salary DESC` (`type: ALL`, `Extra: Using filesort`)
3. **Index Creation**: Created selective single-column and composite indexes.
4. **Analysis of Five Optimized Queries (After Optimization)**:
   - Queries 1 & 2 convert to index references (`type: ref`, `rows: ~2000-2500`).
   - Query 3 converts to index range scan (`type: range`, `key: idx_salary`).
   - Query 4 uses composite index `idx_dept_city` (`type: ref`, `key_len: 246`).
   - Query 5 satisfies both filter and sorting order using `idx_dept_salary`, eliminating `Using filesort`.
5. **Query Rewriting Demonstration**:
   - Analyzed unoptimized function-wrapped date filter: `WHERE YEAR(Joining_Date) = 2022`.
   - Rewrote into sargable range: `WHERE Joining_Date >= '2022-01-01' AND Joining_Date < '2023-01-01'`.
   - Created `idx_joining_date` and verified range scan optimization (`type: range`, `key: idx_joining_date`).
6. **Dataset Verification**: Verified total row count (`10,000` records).

## Execution Instructions

Run from the repository root:

```bash
mysql -u <username> -p < experiment-10/experiment_10.sql
```

The script creates the independent `OptimizationDB` database, populates 10,000 records, evaluates query execution plans before and after indexing, and demonstrates query rewriting.

## Expected Results

- Dataset size: Exactly 10,000 records generated in `Employees`.
- Pre-optimization execution plans demonstrate full table scans across all 10,000 rows.
- Post-optimization plans utilize targeted index lookups (`type: ref`) and range scans (`type: range`).
- Query 5 eliminates sorting overhead (`Using filesort` removed).
- Rewritten date range query leverages `idx_joining_date` rather than scanning all 10,000 rows.

## Files Included

- [SQL source](./experiment_10.sql)
- [Original submission](./dbms_exp_10.pdf)
