CREATE DATABASE college_db;  
USE college_db;             

CREATE TABLE departments (
    dept_id   INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name       VARCHAR(50) NOT NULL,
    age        INT CHECK (age >= 17),
    city       VARCHAR(50),
    dept_id    INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    title     VARCHAR(80) NOT NULL,
    credits   INT DEFAULT 3,
    dept_id   INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE enrollments (
    student_id INT,
    course_id  INT,
    marks      INT,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id)  REFERENCES courses(course_id)
);

-- Insert Sample Data
INSERT INTO departments VALUES 
(1,'CSE'),
(2,'ECE'),
(3,'Mechanical'),
(4,'Civil');

INSERT INTO students VALUES
(101,'Aarav',20,'Roorkee',1),
(102,'Diya',21,'Dehradun',1),
(103,'Kabir',19,'Haridwar',2),
(104,'Meera',22,'Roorkee',1),
(105,'Rohan',20,'Delhi',3),
(106,'Sana',21,'Dehradun',2),
(107,'Vikram',23,'Jaipur',NULL),
(108,'Isha',19,'Roorkee',2);

INSERT INTO courses VALUES
(201,'Data Structures',4,1),
(202,'Operating Systems',4,1),
(203,'Digital Electronics',3,2),
(204,'Thermodynamics',3,3),
(205,'Machine Learning',4,1);

INSERT INTO enrollments VALUES
(101,201,88),(101,202,76),(101,205,91),
(102,201,67),(102,205,72),
(103,203,81),
(104,201,95),(104,202,89),
(105,204,58),
(106,203,74),
(108,203,66);


-- ==========================================
-- Part A: DDL (Data Definition Language)
-- ==========================================

-- A1: Create faculty table
CREATE TABLE faculty (
    faculty_id INT PRIMARY KEY,
    name       VARCHAR(50) NOT NULL,
    email      VARCHAR(100) UNIQUE,
    salary     DECIMAL(10, 2),
    dept_id    INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- A2: Add phone column
ALTER TABLE faculty ADD phone VARCHAR(15);

-- A3: Rename phone column to contact_no
ALTER TABLE faculty RENAME COLUMN phone TO contact_no;

-- A4: Drop column contact_no
ALTER TABLE faculty DROP COLUMN contact_no;

-- A5: Drop faculty table
DROP TABLE faculty;


-- ==========================================
-- Part B: DML (Data Manipulation Language)
-- ==========================================

-- B1: Insert a new student
INSERT INTO students VALUES (109, 'Neha', 20, 'Roorkee', 1);

-- B2: Insert a student without specifying city (Value stored will be NULL)
INSERT INTO students (student_id, name, age, dept_id) VALUES (110, 'Amit', 22, 2);

-- B3: Update city of student 105 to 'Roorkee'
UPDATE students SET city = 'Roorkee' WHERE student_id = 105;

-- B4: Increase marks by 5 for course 203
UPDATE enrollments SET marks = marks + 5 WHERE course_id = 203;

-- B5: Delete test students
DELETE FROM students WHERE student_id IN (109, 110);


-- ==========================================
-- Part C: Querying with SELECT
-- ==========================================

-- C1: Display all columns of all students
SELECT * FROM students;

-- C2: Display name and city
SELECT name, city FROM students;

-- C3: List students from Roorkee
SELECT * FROM students WHERE city = 'Roorkee';

-- C4: List students aged between 20 and 22
SELECT * FROM students WHERE age BETWEEN 20 AND 22;

-- C5: List students from Roorkee or Dehradun
SELECT * FROM students WHERE city IN ('Roorkee', 'Dehradun');

-- C6: List students whose name starts with 'A'
SELECT * FROM students WHERE name LIKE 'A%';

-- C7: List students with no department assigned
SELECT * FROM students WHERE dept_id IS NULL;

-- C8: Display distinct cities
SELECT DISTINCT city FROM students;

-- C9: Display students sorted by age DESC, name ASC
SELECT * FROM students ORDER BY age DESC, name ASC;

-- C10: Display top 3 oldest students
SELECT * FROM students ORDER BY age DESC LIMIT 3;

-- C11: Display with column aliases
SELECT name AS "Student Name", age AS "Age" FROM students;


-- ==========================================
-- Part D: Functions and Aggregation
-- ==========================================

-- D1: Total number of students
SELECT COUNT(*) AS total_students FROM students;

-- D2: Average, minimum, and maximum marks
SELECT AVG(marks) AS avg_marks, MIN(marks) AS min_marks, MAX(marks) AS max_marks FROM enrollments;

-- D3: Count of students in each city
SELECT city, COUNT(*) AS student_count FROM students GROUP BY city;

-- D4: Average marks for each course
SELECT course_id, AVG(marks) AS avg_marks FROM enrollments GROUP BY course_id;

-- D5: Cities with more than one student
SELECT city, COUNT(*) AS student_count FROM students GROUP BY city HAVING COUNT(*) > 1;

-- D6: Total credits offered by each department
SELECT dept_id, SUM(credits) AS total_credits FROM courses GROUP BY dept_id;

-- D7: Student names in uppercase and their length
SELECT UPPER(name) AS upper_name, LENGTH(name) AS name_length FROM students;


-- ==========================================
-- Part E: Joins
-- ==========================================

-- E1: INNER JOIN student name and department name
SELECT s.name, d.dept_name 
FROM students s 
INNER JOIN departments d ON s.dept_id = d.dept_id;

-- E2: LEFT JOIN showing all students (Vikram shows NULL for department)
SELECT s.name, d.dept_name 
FROM students s 
LEFT JOIN departments d ON s.dept_id = s.dept_id;

-- E3: LEFT JOIN showing all departments (including those with no students)
SELECT d.dept_name, s.name 
FROM departments d 
LEFT JOIN students s ON d.dept_id = s.dept_id;

-- E4: Join students, enrollments, and courses
SELECT s.name, c.title, e.marks 
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

-- E5: Students enrolled in 'Data Structures'
SELECT s.name 
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.title = 'Data Structures';

-- E6: Students not enrolled in any course
SELECT s.name 
FROM students s 
LEFT JOIN enrollments e ON s.student_id = e.student_id 
WHERE e.course_id IS NULL;

-- E7: Number of students per course (including zero)
SELECT c.course_id, c.title, COUNT(e.student_id) AS enrolled_students 
FROM courses c 
LEFT JOIN enrollments e ON c.course_id = e.course_id 
GROUP BY c.course_id, c.title;

-- E8: Department with number of students and average age
SELECT d.dept_id, d.dept_name, COUNT(s.student_id) AS total_students, AVG(s.age) AS avg_age 
FROM departments d 
LEFT JOIN students s ON d.dept_id = s.dept_id 
GROUP BY d.dept_id, d.dept_name;


-- ==========================================
-- Part F: Subqueries
-- ==========================================

-- F1: Students older than average age
SELECT * FROM students WHERE age > (SELECT AVG(age) FROM students);

-- F2: Student(s) with highest marks
SELECT s.name, e.marks 
FROM students s 
JOIN enrollments e ON s.student_id = e.student_id 
WHERE e.marks = (SELECT MAX(marks) FROM enrollments);

-- F3: Courses with at least one enrollment
SELECT * FROM courses WHERE course_id IN (SELECT DISTINCT course_id FROM enrollments);

-- F4: Students enrolled in more than 2 courses
SELECT name FROM students WHERE student_id IN (
    SELECT student_id FROM enrollments GROUP BY student_id HAVING COUNT(course_id) > 2
);

-- F5: Department with highest number of students
SELECT dept_id, COUNT(*) AS total_students 
FROM students 
WHERE dept_id IS NOT NULL 
GROUP BY dept_id 
ORDER BY total_students DESC 
LIMIT 1;

-- F6: Correlated subquery - students scoring above course average
SELECT e1.student_id, e1.course_id, e1.marks 
FROM enrollments e1 
WHERE e1.marks > (
    SELECT AVG(e2.marks) FROM enrollments e2 WHERE e2.course_id = e1.course_id
);


-- ==========================================
-- Part G: Indexes, Views and Transactions
-- ==========================================

-- G1: Create index and analyze query plan
CREATE INDEX idx_city ON students(city);
EXPLAIN SELECT * FROM students WHERE city = 'Roorkee';

-- G2: Create student_marks view
CREATE VIEW student_marks AS
SELECT s.name AS student_name, c.title AS course_title, e.marks
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

-- G3: Query view for marks > 80
SELECT * FROM student_marks WHERE marks > 80;

-- G4: Drop view and index
DROP VIEW student_marks;
DROP INDEX idx_city ON students;

-- G5: Transaction with ROLLBACK
START TRANSACTION;
UPDATE enrollments SET marks = 100 WHERE student_id = 101 AND course_id = 201;
ROLLBACK;
SELECT * FROM enrollments WHERE student_id = 101 AND course_id = 201;

-- G6: Transaction with COMMIT
START TRANSACTION;
UPDATE enrollments SET marks = 100 WHERE student_id = 101 AND course_id = 201;
COMMIT;
SELECT * FROM enrollments WHERE student_id = 101 AND course_id = 201;


-- ==========================================
-- Part H: Challenge Problems (Optional)
-- ==========================================

-- H1: Rank list of students by total marks
SELECT 
    s.student_id,
    s.name, 
    SUM(e.marks) AS total_marks,
    RANK() OVER (ORDER BY SUM(e.marks) DESC) AS rank_num,
    DENSE_RANK() OVER (ORDER BY SUM(e.marks) DESC) AS dense_rank_num
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.name;

-- H2: Assign grade using CASE statement
SELECT 
    s.name, 
    c.title, 
    e.marks,
    CASE 
        WHEN e.marks >= 90 THEN 'A'
        WHEN e.marks >= 75 THEN 'B'
        WHEN e.marks >= 60 THEN 'C'
        ELSE 'D'
    END AS grade
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- H3: Pairs of students from the same city (Self Join)
SELECT s1.name AS student_1, s2.name AS student_2, s1.city
FROM students s1
JOIN students s2 ON s1.city = s2.city AND s1.student_id < s2.student_id;

-- H4: Second highest marks without using LIMIT
SELECT MAX(marks) AS second_highest_marks 
FROM enrollments 
WHERE marks < (SELECT MAX(marks) FROM enrollments);