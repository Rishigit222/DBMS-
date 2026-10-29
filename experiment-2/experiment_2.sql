USE CompanyDB;

SELECT e.Emp_ID, e.Emp_Name, d.Dept_Name
FROM Employee e INNER JOIN Department d ON e.Dept_ID = d.Dept_ID;

SELECT d.Dept_Name, e.Emp_Name
FROM Department d LEFT JOIN Employee e ON d.Dept_ID = e.Dept_ID;

SELECT e1.Emp_Name AS Employee_1, e2.Emp_Name AS Employee_2, e1.Dept_ID
FROM Employee e1 JOIN Employee e2
  ON e1.Dept_ID = e2.Dept_ID AND e1.Emp_ID < e2.Emp_ID;

SELECT e.Emp_Name, d.Dept_Name, p.Project_Name
FROM Employee e
JOIN Department d ON d.Dept_ID = e.Dept_ID
JOIN Employee_Project ep ON ep.Emp_ID = e.Emp_ID
JOIN Project p ON p.Project_ID = ep.Project_ID;

SELECT e.Emp_ID, e.Emp_Name, e.Salary
FROM Employee e
WHERE e.Salary > (
    SELECT AVG(e2.Salary) FROM Employee e2 WHERE e2.Dept_ID = e.Dept_ID
);

SELECT d.Dept_Name
FROM Department d
WHERE EXISTS (SELECT 1 FROM Employee e WHERE e.Dept_ID = d.Dept_ID AND e.Salary > 95000);

SELECT e.Emp_Name
FROM Employee e
WHERE EXISTS (SELECT 1 FROM Employee_Project ep WHERE ep.Emp_ID = e.Emp_ID)
  AND NOT EXISTS (SELECT 1 FROM Employee_Project ep WHERE ep.Emp_ID = e.Emp_ID AND ep.Project_ID = 201);

EXPLAIN SELECT e.Emp_Name, d.Dept_Name
FROM Employee e JOIN Department d ON d.Dept_ID = e.Dept_ID
WHERE e.Salary > 85000;

