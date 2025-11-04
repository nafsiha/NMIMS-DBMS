CREATE DATABASE ELearningPlatform;
USE ELearningPlatform;

CREATE TABLE Courses (
  CourseID INT PRIMARY KEY,
  Title VARCHAR(150),
  Category VARCHAR(50),
  DurationWeeks INT,
  Price DECIMAL(10, 2)
);

CREATE TABLE Instructors (
  InstructorID INT PRIMARY KEY,
  Name VARCHAR(100),
  Email VARCHAR(100),
  Specialty VARCHAR(50)
);

CREATE TABLE Students (
  StudentID INT PRIMARY KEY,
  Name VARCHAR(100),
  Email VARCHAR(100),
  City VARCHAR(50)
);

CREATE TABLE Enrollments (
  EnrollmentID INT PRIMARY KEY,
  StudentID INT,
  CourseID INT,
  EnrollDate DATE,
  Status VARCHAR(20),
  FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
  FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

CREATE TABLE Assignments (
  AssignmentID INT PRIMARY KEY,
  CourseID INT,
  Title VARCHAR(150),
  DueDate DATE,
  MaxMarks INT,
  FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Insert sample Courses
INSERT INTO Courses VALUES
  (1, 'Data Science 101', 'Data Science', 10, 12000.00),
  (2, 'Python for Beginners', 'Programming', 8, 8000.00),
  (3, 'Advanced AI', 'Artificial Intelligence', 12, 15000.00),
  (4, 'Web Development', 'Programming', 6, 7000.00),
  (5, 'Machine Learning Basics', 'Artificial Intelligence', 9, 10000.00);

-- Insert sample Instructors
INSERT INTO Instructors VALUES
  (1, 'Dr. Rajesh Kumar', 'rajesh@elearning.com', 'Data Science'),
  (2, 'Ms. Anita Singh', 'anita@elearning.com', 'Python'),
  (3, 'Prof. Suresh Patel', 'suresh@elearning.com', 'AI'),
  (4, 'Mr. Ajay Mehta', 'ajay@elearning.com', 'Web Development'),
  (5, 'Dr. Neha Sharma', 'neha@elearning.com', 'Machine Learning');

-- Insert sample Students
INSERT INTO Students VALUES
  (1, 'Amit Gupta', 'amit@domain.com', 'Mumbai'),
  (2, 'Priya Verma', 'priya@domain.com', 'Delhi'),
  (3, 'Rahul Singh', 'rahul@domain.com', 'Bangalore'),
  (4, 'Sneha Joshi', 'sneha@domain.com', 'Mumbai'),
  (5, 'John Doe', 'john@domain.com', 'Chennai');

-- Insert sample Enrollments
INSERT INTO Enrollments VALUES
  (1, 1, 1, '2025-07-01', 'Completed'),
  (2, 2, 2, '2025-07-15', 'In Progress'),
  (3, 3, 3, '2025-08-01', 'Completed'),
  (4, 4, 4, '2025-08-10', 'In Progress'),
  (5, 5, 5, '2025-08-20', 'Completed'),
  (6, 1, 2, '2025-08-25', 'In Progress'),
  (7, 4, 1, '2025-08-28', 'Completed');

-- Insert sample Assignments
INSERT INTO Assignments VALUES
  (1, 1, 'Intro to Data Science', '2025-09-10', 100),
  (2, 1, 'Data Wrangling', '2025-09-17', 100),
  (3, 2, 'Python Basics', '2025-09-12', 50),
  (4, 3, 'Neural Networks', '2025-09-20', 100),
  (5, 4, 'HTML & CSS', '2025-09-15', 50);

-- 1. List courses in 'Data Science' category.
SELECT * FROM Courses WHERE Category = 'Data Science';

-- 2. Show instructors specializing in 'Python'.
SELECT * FROM Instructors WHERE Specialty = 'Python';

-- 3. Find students from 'Mumbai'.
SELECT * FROM Students WHERE City = 'Mumbai';

-- 4. List enrollments in the last month.
SELECT * FROM Enrollments WHERE EnrollDate >= CURDATE() - INTERVAL 1 MONTH;

-- 5. Show courses with duration more than 8 weeks.
SELECT * FROM Courses WHERE DurationWeeks > 8;

-- 6. Find top 3 most expensive courses.
SELECT * FROM Courses ORDER BY Price DESC LIMIT 3;

-- 7. Show students enrolled in a given course (CourseID = 1).
SELECT s.*
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.CourseID = 1;

-- 8. List instructors teaching multiple courses (assuming assignments table as proxy).
SELECT i.Name, COUNT(DISTINCT a.CourseID) AS CoursesTaught
FROM Instructors i
JOIN Assignments a ON i.Specialty = (SELECT Category FROM Courses WHERE CourseID = a.CourseID LIMIT 1) -- approximate link
GROUP BY i.InstructorID, i.Name
HAVING CoursesTaught > 1;

-- 9. Show assignments with due date in next week.
SELECT * FROM Assignments WHERE DueDate BETWEEN CURDATE() AND CURDATE() + INTERVAL 7 DAY;

-- 10. Find students who completed all assignments in a course. 
-- (Assuming detailed submissions table not present, placeholder.)

-- 11. Show average marks per course. 
-- (Assuming marks table not present, placeholder.)

-- 12. Find students without enrollments.
SELECT * FROM Students WHERE StudentID NOT IN (SELECT StudentID FROM Enrollments);

-- 13. Show total enrollments per course.
SELECT c.Title, COUNT(e.EnrollmentID) AS TotalEnrollments
FROM Courses c
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseID, c.Title;

-- 14. Display instructors with no courses assigned.
SELECT * FROM Instructors
WHERE Specialty NOT IN (SELECT Category FROM Courses);

-- 15. Show students with more than 3 enrollments.
SELECT s.Name, COUNT(e.EnrollmentID) AS EnrollmentCount
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY s.StudentID, s.Name
HAVING EnrollmentCount > 3;

-- 16. Find courses with no students.
SELECT * FROM Courses
WHERE CourseID NOT IN (SELECT CourseID FROM Enrollments);

-- 17. Show most popular course.
SELECT c.Title, COUNT(e.EnrollmentID) AS Enrollments
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseID, c.Title
ORDER BY Enrollments DESC
LIMIT 1;

-- 18. List assignments per course.
SELECT c.Title, a.Title AS AssignmentTitle, a.DueDate
FROM Courses c
JOIN Assignments a ON c.CourseID = a.CourseID;

-- 19. Show students who submitted assignments late.
-- (Assuming submission table not present, placeholder.)

-- 20. Display courses and their instructor names.
-- (Assuming a linking table not present, approximate by specialty-category.)
SELECT c.Title, i.Name AS InstructorName
FROM Courses c
LEFT JOIN Instructors i ON c.Category = i.Specialty;

-- 21. Find courses under 5000 in price.
SELECT * FROM Courses WHERE Price < 5000;

-- 22. Show courses with 'AI' in the title.
SELECT * FROM Courses WHERE Title LIKE '%AI%';

-- 23. Find students who enrolled in multiple categories.
SELECT s.Name, COUNT(DISTINCT c.Category) AS CategoryCount
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
GROUP BY s.StudentID, s.Name
HAVING CategoryCount > 1;

-- 24. Show monthly enrollment counts.
SELECT YEAR(EnrollDate) AS Year, MONTH(EnrollDate) AS Month, COUNT(*) AS EnrollmentCount
FROM Enrollments
GROUP BY Year, Month
ORDER BY Year, Month;

-- 25. Find instructors teaching courses in multiple categories.
SELECT i.Name, COUNT(DISTINCT c.Category) AS CategoryCount
FROM Instructors i
JOIN Courses c ON i.Specialty = c.Category
GROUP BY i.InstructorID, i.Name
HAVING CategoryCount > 1;
