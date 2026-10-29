# Experiment 6: Stored Procedures and Triggers

## Aim

Implement a validated employee transfer procedure, reject negative salaries before update, and record successful salary changes in an audit table.

## Database Objects

- `transfer_employee(emp_id, new_dept_id)` validates both foreign records and raises custom `45000` errors.
- `before_employee_salary_update` enforces the non-negative salary rule.
- `after_employee_salary_update` writes old and new values to `Salary_Audit`.

Run after Experiment 1:

```bash
mysql -u <username> -p < experiment-6/experiment_6.sql
```

- [SQL source](./experiment_6.sql)
- [Original submission](./dbms_exp_6.pdf)
