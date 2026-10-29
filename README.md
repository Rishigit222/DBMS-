# DBMS Laboratory Practical Repository

A complete, organized collection of DBMS laboratory submissions, executable SQL source code, documentation, and database design artifacts.

## Repository Architecture

```text
DBMS-/
├── README.md
├── .gitignore
├── company_db_setup.sql
├── experiment-1/
│   ├── README.md
│   ├── experiment_1.sql
│   └── dbms_exp_1.pdf
├── experiment-2/
│   ├── README.md
│   ├── experiment_2.sql
│   └── dbms_exp_2.pdf
├── experiment-3/
│   ├── README.md
│   ├── experiment_3.sql
│   └── dbms_exp_3.pdf
├── experiment-4/
│   ├── README.md
│   ├── er_diagram.mermaid
│   └── dbms_exp_4.pdf
├── experiment-5/
│   ├── README.md
│   ├── experiment_5.sql
│   └── dbms_exp_5.pdf
└── experiment-6/
    ├── README.md
    ├── experiment_6.sql
    └── dbms_exp_6.pdf
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
```

Experiment 2, 3, and 6 use the `CompanyDB` created by Experiment 1. Experiment 4 is a design artifact, and Experiment 5 creates the independent `EcommerceDB` schema.

## Submission PDFs

The original practical PDFs are preserved in their experiment folders. The SQL files and Mermaid diagram provide readable, runnable source versions of the database work represented by the submissions.
