CREATE DATABASE IF NOT EXISTS CompanyDB;
USE CompanyDB;

DROP TABLE IF EXISTS Employee_Project;
DROP TABLE IF EXISTS Project;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Department;

CREATE TABLE Department (
    Dept_ID INT PRIMARY KEY,
    Dept_Name VARCHAR(100) NOT NULL UNIQUE,
    Location VARCHAR(100)
);

CREATE TABLE Employee (
    Emp_ID INT PRIMARY KEY,
    Emp_Name VARCHAR(100) NOT NULL,
    Job_Title VARCHAR(100),
    Salary DECIMAL(10, 2) NOT NULL CHECK (Salary >= 0),
    Hire_Date DATE,
    Dept_ID INT NOT NULL,
    FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID)
);

CREATE TABLE Project (
    Project_ID INT PRIMARY KEY,
    Project_Name VARCHAR(150) NOT NULL,
    Budget DECIMAL(12, 2) NOT NULL CHECK (Budget >= 0),
    Dept_ID INT NOT NULL,
    FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID)
);

CREATE TABLE Employee_Project (
    Emp_ID INT NOT NULL,
    Project_ID INT NOT NULL,
    Hours_Worked DECIMAL(7, 2) DEFAULT 0 CHECK (Hours_Worked >= 0),
    PRIMARY KEY (Emp_ID, Project_ID),
    FOREIGN KEY (Emp_ID) REFERENCES Employee(Emp_ID),
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID)
);

INSERT INTO Department VALUES
    (1, 'Artificial Intelligence', 'Bengaluru'),
    (2, 'Software Development', 'Pune'),
    (3, 'Cyber Security', 'Hyderabad'),
    (4, 'Data Science', 'Mumbai'),
    (5, 'Human Resources', 'Delhi');

INSERT INTO Employee (Emp_ID, Emp_Name, Job_Title, Salary, Hire_Date, Dept_ID) VALUES
    (101, 'Aarav Sharma', 'AI Engineer', 86000, '2021-01-15', 1),
    (102, 'Priya Verma', 'ML Engineer', 92000, '2021-03-20', 1),
    (103, 'Rohan Gupta', 'AI Developer', 80000, '2022-02-10', 1),
    (104, 'Ananya Singh', 'Research Engineer', 105000, '2020-07-01', 1),
    (105, 'Karan Mehta', 'ML Engineer', 88000, '2022-08-12', 1),
    (106, 'Neha Kapoor', 'AI Analyst', 72000, '2023-01-09', 1),
    (107, 'Rahul Kumar', 'Software Engineer', 76000, '2021-04-14', 2),
    (108, 'Sneha Patel', 'Backend Developer', 82000, '2021-06-11', 2),
    (109, 'Aditya Jain', 'Frontend Developer', 65000, '2023-02-04', 2),
    (110, 'Simran Kaur', 'Full Stack Developer', 95000, '2020-11-18', 2),
    (111, 'Vivek Mishra', 'Software Engineer', 78000, '2022-05-25', 2),
    (112, 'Ishita Rao', 'QA Engineer', 69000, '2023-03-17', 2),
    (113, 'Arjun Malhotra', 'Security Engineer', 90000, '2021-02-08', 3),
    (114, 'Megha Joshi', 'Security Analyst', 81000, '2022-09-05', 3),
    (115, 'Yash Thakur', 'Security Consultant', 98000, '2020-05-13', 3),
    (116, 'Pooja Nair', 'SOC Analyst', 68000, '2023-04-21', 3),
    (117, 'Dev Patel', 'Threat Analyst', 87000, '2021-10-19', 3),
    (118, 'Tanvi Shah', 'Security Engineer', 91000, '2022-11-07', 3);

INSERT INTO Project VALUES
    (201, 'AI Recommendation System', 250000, 1),
    (202, 'Computer Vision Platform', 300000, 1),
    (203, 'E-Commerce Platform', 450000, 2),
    (204, 'Mobile Banking Application', 350000, 2),
    (205, 'Cyber Threat Detection', 275000, 3),
    (206, 'Security Monitoring System', 225000, 3);

INSERT INTO Employee_Project VALUES
    (101, 201, 120), (102, 201, 160), (103, 202, 140),
    (104, 202, 180), (107, 203, 150), (108, 203, 175),
    (110, 204, 160), (111, 204, 130), (113, 205, 155),
    (115, 205, 170), (117, 206, 120), (118, 206, 145);
