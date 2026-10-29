USE CompanyDB;

ALTER TABLE Employee ADD COLUMN Manager_ID INT NULL;
ALTER TABLE Employee
    ADD CONSTRAINT fk_employee_manager
    FOREIGN KEY (Manager_ID) REFERENCES Employee(Emp_ID);

UPDATE Employee SET Manager_ID = 101 WHERE Emp_ID IN (102, 103);
UPDATE Employee SET Manager_ID = 102 WHERE Emp_ID IN (104, 105);
UPDATE Employee SET Manager_ID = 103 WHERE Emp_ID = 106;
UPDATE Employee SET Manager_ID = 110 WHERE Emp_ID IN (107, 108);
UPDATE Employee SET Manager_ID = 107 WHERE Emp_ID IN (109, 111);
UPDATE Employee SET Manager_ID = 108 WHERE Emp_ID = 112;
UPDATE Employee SET Manager_ID = 115 WHERE Emp_ID IN (113, 114);
UPDATE Employee SET Manager_ID = 113 WHERE Emp_ID IN (117, 118);

CREATE OR REPLACE VIEW Department_Salary_Summary AS
SELECT d.Dept_ID, d.Dept_Name, COUNT(e.Emp_ID) AS Employee_Count,
       SUM(e.Salary) AS Total_Salary, AVG(e.Salary) AS Average_Salary,
       MIN(e.Salary) AS Minimum_Salary, MAX(e.Salary) AS Maximum_Salary
FROM Department d LEFT JOIN Employee e ON e.Dept_ID = d.Dept_ID
GROUP BY d.Dept_ID, d.Dept_Name;

CREATE OR REPLACE VIEW Employee_Hierarchy AS
SELECT e.Emp_ID, e.Emp_Name AS Employee_Name, e.Job_Title, e.Dept_ID,
       d.Dept_Name, e.Manager_ID, m.Emp_Name AS Manager_Name
FROM Employee e
LEFT JOIN Department d ON d.Dept_ID = e.Dept_ID
LEFT JOIN Employee m ON m.Emp_ID = e.Manager_ID;

CREATE OR REPLACE VIEW Employee_Basic AS
SELECT Emp_ID, Emp_Name, Job_Title, Salary, Dept_ID FROM Employee;

SELECT * FROM Department_Salary_Summary;
SELECT * FROM Employee_Hierarchy ORDER BY Dept_ID, Manager_ID, Emp_ID;
WITH RECURSIVE EmployeeTree AS (
    SELECT Emp_ID, Emp_Name, Manager_ID, 0 AS Level
    FROM Employee WHERE Manager_ID IS NULL
    UNION ALL
    SELECT e.Emp_ID, e.Emp_Name, e.Manager_ID, t.Level + 1
    FROM Employee e JOIN EmployeeTree t ON e.Manager_ID = t.Emp_ID
)
SELECT REPEAT('  ', Level) AS Indent, Emp_ID, Emp_Name, Level
FROM EmployeeTree ORDER BY Level, Emp_ID;
