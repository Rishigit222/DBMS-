SOURCE company_db_setup.sql;
USE CompanyDB;

SELECT * FROM Employee WHERE Salary > 90000;
SELECT * FROM Employee WHERE Dept_ID = 1;
SELECT Emp_Name, Job_Title, Salary FROM Employee ORDER BY Salary DESC;
SELECT AVG(Salary) AS Average_Salary, MAX(Salary) AS Highest_Salary,
       MIN(Salary) AS Lowest_Salary, SUM(Salary) AS Total_Salary,
       COUNT(*) AS Employee_Count
FROM Employee;
SELECT Dept_ID, COUNT(*) AS Employee_Count, AVG(Salary) AS Average_Salary
FROM Employee GROUP BY Dept_ID HAVING AVG(Salary) > 75000;
SELECT Emp_Name, Salary,
       CASE WHEN Salary >= 90000 THEN 'High'
            WHEN Salary >= 75000 THEN 'Medium'
            ELSE 'Entry' END AS Salary_Category
FROM Employee ORDER BY Salary DESC;
SELECT Dept_ID, COUNT(*) AS Headcount
FROM Employee GROUP BY Dept_ID ORDER BY Headcount DESC, Dept_ID;

