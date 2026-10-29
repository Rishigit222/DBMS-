# Experiment 3: Views and Recursive CTEs

## Aim

Extend the employee schema with a reporting hierarchy, create views, test view behavior, and traverse the hierarchy with a recursive CTE.

## Views

- `Department_Salary_Summary` aggregates salary statistics by department.
- `Employee_Hierarchy` joins employees to departments and managers.
- `Employee_Basic` demonstrates a simple updatable projection.

The recursive query uses an anchor set of root employees and repeatedly joins their direct reports.

```bash
mysql -u <username> -p < experiment-3/experiment_3.sql
```

- [SQL source](./experiment_3.sql)
- [Original submission](./dbms_exp_3.pdf)
