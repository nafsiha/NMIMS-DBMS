-- set 3
CREATE DATABASE UniversityManagement;
USE UniversityManagement;

CREATE TABLE Departments (
  DeptID INT PRIMARY KEY,
  DeptName VARCHAR(100),
  HOD VARCHAR(100)
);

CREATE TABLE Students (
  StudentID INT PRIMARY KEY,
  Name VARCHAR(100),
  DOB DATE,
  Gender VARCHAR(10),
  DeptID INT,
  Email VARCHAR(100),
  FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);

CREATE TABLE Courses (
  CourseID INT PRIMARY KEY,
  CourseName VARCHAR(100),
  DeptID INT,
  Credits INT,
  FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);

CREATE TABLE Faculty (
  FacultyID INT PRIMARY KEY,
  Name VARCHAR(100),
  DeptID INT,
  Email VARCHAR(100),
  FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);

CREATE TABLE Enrollments (
  EnrollmentID INT PRIMARY KEY,
  StudentID INT,
  CourseID INT,
  Semester VARCHAR(10),
  Grade CHAR(2),
  FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
  FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Insert sample Departments
INSERT INTO Departments VALUES
  (1, 'Computer Science', 'Dr. R. Gupta'),
  (2, 'Physics', 'Dr. S. Mehta'),
  (3, 'Mathematics', 'Dr. A. Sharma'),
  (4, 'Chemistry', 'Dr. T. Rao'),
  (5, 'Biology', 'Dr. N. Singh');

-- Insert sample Students
INSERT INTO Students VALUES
  (1, 'Sandeep Kumar', '2002-05-12', 'Male', 1, 'sandeep@uni.edu'),
  (2, 'Anjali Sharma', '2001-11-30', 'Female', 2, 'anjali@uni.edu'),
  (3, 'Rohan Singh', '2003-07-22', 'Male', 3, 'rohan@uni.edu'),
  (4, 'Pooja Patel', '2000-09-15', 'Female', 1, 'pooja@uni.edu'),
  (5, 'Simran Kaur', '2004-02-12', 'Female', 4, 'simran@uni.edu');

-- Insert sample Courses
INSERT INTO Courses VALUES
  (1, 'Data Structures', 1, 4),
  (2, 'Quantum Mechanics', 2, 3),
  (3, 'Linear Algebra', 3, 4),
  (4, 'Organic Chemistry', 4, 3),
  (5, 'Genetics', 5, 3);

-- Insert sample Faculty
INSERT INTO Faculty VALUES
  (1, 'Dr. R. Gupta', 1, 'rgupta@uni.edu'),
  (2, 'Dr. S. Mehta', 2, 'smehta@uni.edu'),
  (3, 'Dr. A. Sharma', 3, 'asharma@uni.edu'),
  (4, 'Dr. T. Rao', 4, 'trao@uni.edu'),
  (5, 'Dr. N. Singh', 5, 'nsingh@uni.edu');

-- Insert sample Enrollments
INSERT INTO Enrollments VALUES
  (1, 1, 1, '2025S1', 'A'),
  (2, 2, 2, '2025S1', 'B'),
  (3, 3, 3, '2025S1', 'C'),
  (4, 4, 1, '2025S1', 'B'),
  (5, 5, 4, '2025S1', 'A'),
  (6, 1, 3, '2025S1', 'A'),
  (7, 4, 3, '2025S1', 'B');

-- 1. List students in 'Computer Science' department.
SELECT s.*
FROM Students s
JOIN Departments d ON s.DeptID = d.DeptID
WHERE d.DeptName = 'Computer Science';

-- 2. Show courses with more than 3 credits.
SELECT * FROM Courses WHERE Credits > 3;

-- 3. Find students born after 2000.
SELECT * FROM Students WHERE DOB > '2000-01-01';

-- 4. Show average grade per course.
SELECT c.CourseName, AVG(CASE
  WHEN e.Grade = 'A' THEN 4
  WHEN e.Grade = 'B' THEN 3
  WHEN e.Grade = 'C' THEN 2
  WHEN e.Grade = 'D' THEN 1
  ELSE 0 END) AS AvgGradePoint
FROM Courses c
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseName;

-- 5. List faculty members in 'Physics' department.
SELECT f.*
FROM Faculty f
JOIN Departments d ON f.DeptID = d.DeptID
WHERE d.DeptName = 'Physics';

-- 6. Count total students per department.
SELECT d.DeptName, COUNT(s.StudentID) AS StudentCount
FROM Departments d
LEFT JOIN Students s ON d.DeptID = s.DeptID
GROUP BY d.DeptName;

-- 7. Show courses taught by a given faculty (Assuming faculty teaches courses with matching dept).
SELECT c.*
FROM Courses c
JOIN Faculty f ON c.DeptID = f.DeptID
WHERE f.Name = 'Dr. R. Gupta';

-- 8. List students with no enrollments.
SELECT * FROM Students
WHERE StudentID NOT IN (SELECT StudentID FROM Enrollments);

-- 9. Show top 3 scorers in a course (CourseID = 1 example).
SELECT s.Name, e.Grade FROM Enrollments e
JOIN Students s ON e.StudentID = s.StudentID
WHERE e.CourseID = 1
ORDER BY CASE e.Grade
  WHEN 'A' THEN 1
  WHEN 'B' THEN 2
  WHEN 'C' THEN 3
  WHEN 'D' THEN 4
  ELSE 5 END
LIMIT 3;

-- 10. Display students enrolled in more than 4 courses.
SELECT s.StudentID, s.Name, COUNT(e.CourseID) AS CourseCount
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY s.StudentID, s.Name
HAVING CourseCount > 4;

-- 11. Find courses with no enrollments.
SELECT c.*
FROM Courses c
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
WHERE e.EnrollmentID IS NULL;

-- 12. Show department names with total faculty.
SELECT d.DeptName, COUNT(f.FacultyID) AS FacultyCount
FROM Departments d
LEFT JOIN Faculty f ON d.DeptID = f.DeptID
GROUP BY d.DeptName;

-- 13. List all courses taken by a specific student (StudentID = 1 example).
SELECT c.*
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
WHERE e.StudentID = 1;

-- 14. Find students whose name starts with 'S'.
SELECT * FROM Students WHERE Name LIKE 'S%';

-- 15. Show the youngest student.
SELECT * FROM Students ORDER BY DOB DESC LIMIT 1;

-- 16. List students and their average grade.
SELECT s.Name, AVG(CASE
  WHEN e.Grade = 'A' THEN 4
  WHEN e.Grade = 'B' THEN 3
  WHEN e.Grade = 'C' THEN 2
  WHEN e.Grade = 'D' THEN 1
  ELSE 0 END) AS AvgGradePoint
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY s.StudentID, s.Name;

-- 17. Find departments without students.
SELECT d.*
FROM Departments d
LEFT JOIN Students s ON d.DeptID = s.DeptID
WHERE s.StudentID IS NULL;

-- 18. Show faculty email addresses.
SELECT Email FROM Faculty;

-- 19. List students enrolled in 'Mathematics' course (CourseName example).
SELECT s.*
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName = 'Mathematics';

-- 20. Show total credits taken by each student.
SELECT s.Name, SUM(c.Credits) AS TotalCredits
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
GROUP BY s.StudentID, s.Name;

-- 21. Find students with failing grades (assuming 'D' and below is failing).
SELECT DISTINCT s.*
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.Grade IN ('D', 'F');

-- 22. List courses with maximum students.
SELECT c.CourseName, COUNT(e.StudentID) AS NumStudents
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseName
ORDER BY NumStudents DESC
LIMIT 1;

-- 23. Show grade distribution per course.
SELECT c.CourseName, e.Grade, COUNT(*) AS GradeCount
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseName, e.Grade;

-- 24. Display students and their department names.
SELECT s.Name, d.DeptName
FROM Students s
JOIN Departments d ON s.DeptID = d.DeptID;

-- 25. Find the oldest faculty member.
SELECT * FROM Faculty ORDER BY FacultyID ASC LIMIT 1;
