USE CompanyDB;

DROP TABLE IF EXISTS Salary_Audit;
CREATE TABLE Salary_Audit (
    Audit_ID INT AUTO_INCREMENT PRIMARY KEY,
    Emp_ID INT NOT NULL,
    Old_Salary DECIMAL(10, 2) NOT NULL,
    New_Salary DECIMAL(10, 2) NOT NULL,
    Changed_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP PROCEDURE IF EXISTS transfer_employee;
DROP TRIGGER IF EXISTS before_employee_salary_update;
DROP TRIGGER IF EXISTS after_employee_salary_update;

DELIMITER $$
CREATE PROCEDURE transfer_employee(IN p_emp_id INT, IN p_new_dept_id INT)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Employee WHERE Emp_ID = p_emp_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee does not exist';
    ELSEIF NOT EXISTS (SELECT 1 FROM Department WHERE Dept_ID = p_new_dept_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Department does not exist';
    ELSE
        UPDATE Employee SET Dept_ID = p_new_dept_id WHERE Emp_ID = p_emp_id;
    END IF;
END$$

CREATE TRIGGER before_employee_salary_update
BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF NEW.Salary < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Salary cannot be negative';
    END IF;
END$$

CREATE TRIGGER after_employee_salary_update
AFTER UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF OLD.Salary <> NEW.Salary THEN
        INSERT INTO Salary_Audit (Emp_ID, Old_Salary, New_Salary)
        VALUES (OLD.Emp_ID, OLD.Salary, NEW.Salary);
    END IF;
END$$
DELIMITER ;

CALL transfer_employee(101, 2);
SELECT * FROM Employee WHERE Emp_ID = 101;
UPDATE Employee SET Salary = Salary + 1000 WHERE Emp_ID = 101;
SELECT * FROM Salary_Audit ORDER BY Audit_ID DESC;

