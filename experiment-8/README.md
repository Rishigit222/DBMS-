# Experiment 8: Transactions and Concurrency Control

## Aim

Implement banking-style transactions using `START TRANSACTION`, `COMMIT`, `ROLLBACK`, and `SAVEPOINT`. Simulate partial failures. Demonstrate transaction isolation levels and concurrency anomalies using two sessions.

## Concepts Covered

- **ACID Properties**: Atomicity, Consistency, Isolation, and Durability in the MySQL InnoDB storage engine.
- **Transaction Control Language (TCL)**:
  - `START TRANSACTION` / `BEGIN`: Initiates an explicit transaction block.
  - `COMMIT`: Persists all modifications made in the current transaction.
  - `ROLLBACK`: Aborts the transaction and reverts uncommitted changes.
  - `SAVEPOINT`: Creates an intermediate milestone within a transaction.
  - `ROLLBACK TO SAVEPOINT`: Selectively discards modifications made after the savepoint without aborting the entire transaction.
- **Transaction Isolation Levels**:
  - `READ COMMITTED`: Avoids dirty reads; reads latest committed data.
  - `REPEATABLE READ`: MySQL InnoDB default; provides snapshot isolation via MVCC (Multi-Version Concurrency Control) preventing non-repeatable reads.
  - `SERIALIZABLE`: Highest isolation level; locks read rows in shared mode to prevent phantom reads.
- **Multi-Session Concurrency**: Demonstrating how concurrent transactions interact and how isolation levels prevent read and update anomalies.

## Database Objects / Implementation

- Database: `BankingDB`
- `Accounts`: Primary ledger table storing bank accounts:
  - `Account_ID INT PRIMARY KEY`
  - `Holder_Name VARCHAR(50)`
  - `Balance DECIMAL(10, 2)`

## SQL Operations Performed

1. **Table Setup & Seeding**: Created `Accounts` and inserted initial balances for Amit (₹10,000.00) and Rahul (₹8,000.00).
2. **Atomic Fund Transfer (BEGIN & COMMIT)**: Transferred ₹2,000.00 from Account 101 to Account 102 inside an explicit transaction block, committing the updated balances (₹8,000.00 and ₹10,000.00).
3. **Transaction Abort (ROLLBACK)**: Simulated an unauthorized debit of ₹5,000.00 from Account 101 followed by a `ROLLBACK`, restoring the balance to ₹8,000.00.
4. **Intermediate Savepoints (SAVEPOINT & ROLLBACK TO SAVEPOINT)**:
   - Debited ₹1,000.00 from Account 101 and marked `SAVEPOINT sp1`.
   - Simulated an invalid debit of ₹20,000.00 from Account 102.
   - Executed `ROLLBACK TO SAVEPOINT sp1` and committed, preserving the ₹1,000.00 debit while discarding the erroneous debit on Account 102.
5. **Partial Failure Simulation**: Debited ₹500.00 from Account 101 and attempted to credit non-existent Account 999; executed `ROLLBACK` to preserve ledger integrity.
6. **Isolation Level Demonstration**: Configured `READ COMMITTED`, `REPEATABLE READ`, and `SERIALIZABLE` session scopes.
7. **Two-Session Concurrency Test**: Simulated a non-repeatable read scenario across two database clients to observe InnoDB consistent read snapshots.

## Execution Instructions

### Automated Script Execution

Run from the repository root:

```bash
mysql -u <username> -p < experiment-8/experiment_8.sql
```

### Interactive Two-Session Concurrency Test

To reproduce the multi-session concurrency behavior interactively:

1. Open **Terminal 1** (`mysql -u <username> -p BankingDB`):
   ```sql
   START TRANSACTION;
   SELECT Balance FROM Accounts WHERE Account_ID = 101;
   ```
2. Open **Terminal 2** (`mysql -u <username> -p BankingDB`):
   ```sql
   START TRANSACTION;
   UPDATE Accounts SET Balance = Balance - 500 WHERE Account_ID = 101;
   COMMIT;
   ```
3. Return to **Terminal 1**:
   ```sql
   -- Under REPEATABLE READ, reads consistent snapshot (7000.00)
   -- Under READ COMMITTED, reads committed value (6500.00)
   SELECT Balance FROM Accounts WHERE Account_ID = 101;
   COMMIT;
   ```

## Expected Results

- Ledger updates only persist upon explicit `COMMIT`.
- Transactions subjected to `ROLLBACK` leave database state completely unaffected.
- `ROLLBACK TO SAVEPOINT` allows partial recovery within complex transactions.
- Concurrent reads under `REPEATABLE READ` maintain consistent multi-version snapshots.

## Files Included

- [SQL source](./experiment_8.sql)
- [Original submission](./dbms_exp_8.pdf)
