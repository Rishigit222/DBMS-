# DBMS Laboratory Practical Repository

A complete, organized collection of DBMS laboratory submissions, executable SQL source code, documentation, and database design artifacts.

## Repository Architecture

```text
DBMS-/
├── README.md
├── .gitignore
├── company_db_setup.sql
├── experiment-1/
├── experiment-2/
├── experiment-3/
├── experiment-4/
├── experiment-5/
├── experiment-6/
├── experiment-7/
│   ├── README.md
│   ├── experiment_7.sql
│   └── dbms_exp_7.pdf
├── experiment-8/
│   ├── README.md
│   ├── experiment_8.sql
│   └── dbms_exp_8.pdf
├── experiment-9/
│   ├── README.md
│   ├── experiment_9.sql
│   └── dbms_exp_9.pdf
└── experiment-10/
    ├── README.md
    ├── experiment_10.sql
    └── dbms_exp_10.pdf
```

## Experiments

| Experiment | Focus | Resources |
|---|---|---|
| 1 | Schema creation, population, and basic SQL | [README](./experiment-1/), [SQL](./experiment-1/experiment_1.sql), [PDF](./experiment-1/dbms_exp_1.pdf) |
| 2 | Joins, subqueries, set logic, and `EXPLAIN` | [README](./experiment-2/), [SQL](./experiment-2/experiment_2.sql), [PDF](./experiment-2/dbms_exp_2.pdf) |
| 3 | Views, view updatability, and recursive CTEs | [README](./experiment-3/), [SQL](./experiment-3/experiment_3.sql), [PDF](./experiment-3/dbms_exp_3.pdf) |
| 4 | Conceptual ER modeling | [README](./experiment-4/), [Mermaid diagram](./experiment-4/er_diagram.mermaid), [PDF](./experiment-4/dbms_exp_4.pdf) |
| 5 | Relational mapping and integrity constraints | [README](./experiment-5/), [SQL](./experiment-5/experiment_5.sql), [PDF](./experiment-5/dbms_exp_5.pdf) |
| 6 | Stored procedures, validation, and audit triggers | [README](./experiment-6/), [SQL](./experiment-6/experiment_6.sql), [PDF](./experiment-6/dbms_exp_6.pdf) |
| 7 | Database normalization (UNF to 3NF), lossless join, and dependency preservation | [README](./experiment-7/), [SQL](./experiment-7/experiment_7.sql), [PDF](./experiment-7/dbms_exp_7.pdf) |
| 8 | Transactions, TCL (`COMMIT`, `ROLLBACK`, `SAVEPOINT`), isolation levels, and concurrency | [README](./experiment-8/), [SQL](./experiment-8/experiment_8.sql), [PDF](./experiment-8/dbms_exp_8.pdf) |
| 9 | Database indexing (single & composite), synthetic data generation, and `EXPLAIN` benchmarking | [README](./experiment-9/), [SQL](./experiment-9/experiment_9.sql), [PDF](./experiment-9/dbms_exp_9.pdf) |
| 10 | Query optimization, `EXPLAIN` analysis, indexing strategies, and query rewriting | [README](./experiment-10/), [SQL](./experiment-10/experiment_10.sql), [PDF](./experiment-10/dbms_exp_10.pdf) |

## Requirements

- MySQL Server 8.0 or later
- MySQL CLI or MySQL Workbench
- Mermaid-compatible Markdown viewer for the ER diagram

## Quick Start

From the repository root:

```bash
mysql -u <username> -p < experiment-1/experiment_1.sql
mysql -u <username> -p < experiment-2/experiment_2.sql
mysql -u <username> -p < experiment-3/experiment_3.sql
mysql -u <username> -p < experiment-5/experiment_5.sql
mysql -u <username> -p < experiment-6/experiment_6.sql
mysql -u <username> -p < experiment-7/experiment_7.sql
mysql -u <username> -p < experiment-8/experiment_8.sql
mysql -u <username> -p < experiment-9/experiment_9.sql
mysql -u <username> -p < experiment-10/experiment_10.sql
```

Experiment 2, 3, and 6 use the `CompanyDB` created by Experiment 1. Experiment 4 is a design artifact, and Experiment 5 creates the independent `EcommerceDB` schema. Experiments 7, 8, 9, and 10 create independent schemas (`NormalizationDB`, `BankingDB`, `RailwayDB`, and `OptimizationDB` respectively). Experiment 8 additionally includes an interactive dual-session demonstration for concurrency and transaction isolation testing.

## Submission PDFs

The original practical PDFs are preserved in their experiment folders. The SQL files and Mermaid diagram provide readable, runnable source versions of the database work represented by the submissions.
