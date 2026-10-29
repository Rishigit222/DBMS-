# Experiment 1: Database Creation and Basic Queries

## Aim

Create and populate a company database, then demonstrate filtering, projection, aggregation, grouping, conditional expressions, and ordering.

## Schema

`Department`, `Employee`, `Project`, and `Employee_Project` model departments, employees, projects, and the many-to-many employee/project relationship.

## Execution

Run from the repository root:

```bash
mysql -u <username> -p < experiment-1/experiment_1.sql
```

The script loads [`company_db_setup.sql`](../company_db_setup.sql) and runs representative basic queries.

- [SQL source](./experiment_1.sql)
- [Original submission](./dbms_exp_1.pdf)
