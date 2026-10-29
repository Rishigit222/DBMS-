# Experiment 5: Relational Schema and Integrity Constraints

## Aim

Convert the e-commerce design into relational tables and demonstrate primary keys, foreign keys, uniqueness, checks, cascading deletes, and null-setting referential actions.

## Schema

The implementation includes `Seller`, `Customer`, `Category`, `Product`, `Orders`, and `OrderItem`. The script creates `EcommerceDB`, inserts a small valid dataset, lists generated tables, and verifies a joined order result.

```bash
mysql -u <username> -p < experiment-5/experiment_5.sql
```

- [SQL source](./experiment_5.sql)
- [Original submission](./dbms_exp_5.pdf)
