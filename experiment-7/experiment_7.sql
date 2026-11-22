-- ============================================================================
-- Experiment 7: Database Normalization (UNF to 1NF, 2NF, and 3NF)
-- Aim: Normalize a denormalized student registration table step-by-step
--      from UNF to 1NF, 2NF, and 3NF. Verify lossless join decomposition
--      and functional dependency preservation using SQL queries.
-- Note: While the original syllabus aim references BCNF, the practical
--       decomposition achieves 3NF, where all determinants are already candidate
--       keys (hence satisfying BCNF without requiring further decomposition).
-- ============================================================================

CREATE DATABASE IF NOT EXISTS NormalizationDB;
USE NormalizationDB;

-- Clean up existing tables to ensure repeatable execution
DROP TABLE IF EXISTS Registrations;
DROP TABLE IF EXISTS Courses_3NF;
DROP TABLE IF EXISTS Instructors;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Registration_1NF;
DROP TABLE IF EXISTS Registration_UNF;

-- ----------------------------------------------------------------------------
-- Step 1: Create Denormalized Table (UNF)
-- ----------------------------------------------------------------------------
CREATE TABLE Registration_UNF (
    registration_id INT,
    student_id INT,
    student_name VARCHAR(100),
    course_id INT,
    course_name VARCHAR(100),
    instructor_id INT,
    instructor_name VARCHAR(100),
    department VARCHAR(100),
    semester VARCHAR(20),
    grade CHAR(2)
);

-- Insert Sample Data from Original Lab Practical
INSERT INTO Registration_UNF VALUES
(501, 101, 'Ankan Bhattacharjee', 201, 'Database Systems', 301, 'Dr Mehta', 'CSE', 'Semester 3', 'A'),
(502, 102, 'Unnati Mishra', 202, 'Operating Systems', 302, 'Dr Rao', 'CSE', 'Semester 3', 'B'),
(503, 103, 'Riya Patel', 203, 'Computer Networks', 303, 'Dr Sen', 'IT', 'Semester 4', 'A'),
(504, 104, 'Isha Gupta', 201, 'Database Systems', 301, 'Dr Mehta', 'CSE', 'Semester 3', 'B'),
(505, 105, 'Arjun Das', 204, 'Artificial Intelligence', 304, 'Dr Nair', 'AIML', 'Semester 5', 'A'),
(506, 101, 'Aarav Sharma', 202, 'Operating Systems', 302, 'Dr Rao', 'CSE', 'Semester 3', 'A');

SELECT * FROM Registration_UNF;

-- ----------------------------------------------------------------------------
-- Data Anomaly Resolution Note:
-- In the raw unnormalized data above, registration 506 assigned student_id 101
-- to 'Aarav Sharma', while registration 501 assigned student_id 101 to
-- 'Ankan Bhattacharjee'. This represents an update/insertion anomaly in UNF
-- violating the functional dependency: student_id -> student_name.
-- If uncorrected, creating the Students table with student_id as PRIMARY KEY
-- fails with Error 1062: Duplicate entry '101' for key 'PRIMARY'.
-- Furthermore, the original submission PDF output tables (pages 6-8) only
-- display registrations 501-505 and students 101-105.
-- To ensure valid execution while preserving all records, registration 506
-- is updated to student_id = 106.
-- ----------------------------------------------------------------------------
UPDATE Registration_UNF
SET student_id = 106
WHERE registration_id = 506 AND student_name = 'Aarav Sharma';

-- ----------------------------------------------------------------------------
-- Step 2: First Normal Form (1NF)
-- Attributes are atomic, each record is unique, and repeating groups are eliminated.
-- ----------------------------------------------------------------------------
CREATE TABLE Registration_1NF AS
SELECT * FROM Registration_UNF;

SELECT * FROM Registration_1NF;

-- ----------------------------------------------------------------------------
-- Step 3: Second Normal Form (2NF)
-- Eliminate partial functional dependencies: non-prime attributes must depend
-- fully on candidate keys, decomposed into Students, Courses, and Registrations.
-- ----------------------------------------------------------------------------
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL
);

INSERT INTO Students
SELECT DISTINCT student_id, student_name
FROM Registration_UNF;

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    instructor_id INT,
    instructor_name VARCHAR(100),
    department VARCHAR(100)
);

INSERT INTO Courses
SELECT DISTINCT
    course_id,
    course_name,
    instructor_id,
    instructor_name,
    department
FROM Registration_UNF;

CREATE TABLE Registrations (
    registration_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    semester VARCHAR(20),
    grade CHAR(2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

INSERT INTO Registrations
SELECT DISTINCT
    registration_id,
    student_id,
    course_id,
    semester,
    grade
FROM Registration_UNF;

-- ----------------------------------------------------------------------------
-- Step 4: Third Normal Form (3NF)
-- Eliminate transitive dependencies: course_id -> instructor_id -> instructor_name, department.
-- Separate Instructor attributes into an Instructors entity table.
-- ----------------------------------------------------------------------------
CREATE TABLE Instructors (
    instructor_id INT PRIMARY KEY,
    instructor_name VARCHAR(100) NOT NULL,
    department VARCHAR(100)
);

INSERT INTO Instructors
SELECT DISTINCT
    instructor_id,
    instructor_name,
    department
FROM Registration_UNF;

CREATE TABLE Courses_3NF (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    instructor_id INT,
    FOREIGN KEY (instructor_id) REFERENCES Instructors(instructor_id)
);

INSERT INTO Courses_3NF
SELECT DISTINCT
    course_id,
    course_name,
    instructor_id
FROM Registration_UNF;

-- Re-link Registrations foreign key to Courses_3NF
ALTER TABLE Registrations
DROP FOREIGN KEY registrations_ibfk_2;

ALTER TABLE Registrations
ADD CONSTRAINT fk_registrations_courses_3nf
FOREIGN KEY (course_id) REFERENCES Courses_3NF(course_id);

-- Verify Normalized Tables
SELECT * FROM Students;
SELECT * FROM Instructors;
SELECT * FROM Courses_3NF;
SELECT * FROM Registrations;

-- ----------------------------------------------------------------------------
-- Step 5: Verifying Lossless Join Decomposition
-- Joining decomposed tables must recreate the exact original unnormalized relation
-- without producing spurious or missing tuples.
-- ----------------------------------------------------------------------------
SELECT
    r.registration_id,
    s.student_id,
    s.student_name,
    c.course_id,
    c.course_name,
    i.instructor_id,
    i.instructor_name,
    i.department,
    r.semester,
    r.grade
FROM Registrations r
JOIN Students s
    ON r.student_id = s.student_id
JOIN Courses_3NF c
    ON r.course_id = c.course_id
JOIN Instructors i
    ON c.instructor_id = i.instructor_id
ORDER BY r.registration_id;

-- ----------------------------------------------------------------------------
-- Step 6: Verifying Functional Dependency Preservation
-- Each functional dependency X -> Y can be enforced within a single table.
-- Any violation would return rows in the queries below (expecting 0 rows).
-- ----------------------------------------------------------------------------

-- 1. Student dependency: student_id -> student_name
SELECT student_id
FROM Students
GROUP BY student_id
HAVING COUNT(DISTINCT student_name) > 1;

-- 2. Instructor dependency: instructor_id -> instructor_name, department
SELECT instructor_id
FROM Instructors
GROUP BY instructor_id
HAVING COUNT(DISTINCT instructor_name) > 1
   OR COUNT(DISTINCT department) > 1;

-- 3. Course dependency: course_id -> course_name, instructor_id
SELECT course_id
FROM Courses_3NF
GROUP BY course_id
HAVING COUNT(DISTINCT course_name) > 1
   OR COUNT(DISTINCT instructor_id) > 1;

-- 4. Registration uniqueness: registration_id -> student_id, course_id, semester, grade
SELECT registration_id
FROM Registrations
GROUP BY registration_id
HAVING COUNT(*) > 1;

-- ----------------------------------------------------------------------------
-- Step 7: Final Joined Table (Clean Business Projection)
-- ----------------------------------------------------------------------------
SELECT
    r.registration_id,
    s.student_name,
    c.course_name,
    i.instructor_name,
    i.department,
    r.semester,
    r.grade
FROM Registrations r
JOIN Students s
    ON r.student_id = s.student_id
JOIN Courses_3NF c
    ON r.course_id = c.course_id
JOIN Instructors i
    ON c.instructor_id = i.instructor_id
ORDER BY r.registration_id;
