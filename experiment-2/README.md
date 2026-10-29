# Experiment 2: Advanced Queries and Execution Plans

## Aim

Use inner, left, self, and multi-table joins; correlated subqueries; `EXISTS`; simulated set difference; and `EXPLAIN`.

## Concepts Demonstrated

- Joining employees to departments and projects
- Avoiding duplicate self-join pairs with an ordered key comparison
- Comparing each employee with their department average
- Testing row existence with `EXISTS` and `NOT EXISTS`
- Inspecting optimizer access plans

Run after Experiment 1:

```bash
mysql -u <username> -p < experiment-2/experiment_2.sql
```

- [SQL source](./experiment_2.sql)
- [Original submission](./dbms_exp_2.pdf)
