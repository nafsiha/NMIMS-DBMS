-- Set 1: Student Enrollment

CREATE DATABASE StudentEnrollment;
USE StudentEnrollment;

CREATE TABLE StudentEnrollment (
    StudentID INT,
    StudentName VARCHAR(100),
    Phone VARCHAR(20),
    CourseID INT,
    CourseName VARCHAR(100),
    Instructor VARCHAR(100),
    InstructorPhone VARCHAR(20),
    Semester VARCHAR(20),
    Grade VARCHAR(5)
);

INSERT INTO StudentEnrollment 
VALUES
(1, 'Amit Sharma', '9876543210', 101, 'Database Systems', 'Dr. Rao', '9876500001', 'Fall 2025', 'A'),
(1, 'Amit Sharma', '9876543210', 102, 'Computer Networks', 'Dr. Gupta', '9876500002', 'Fall 2025', 'B'),
(2, 'Priya Patel', '9876501234', 101, 'Database Systems', 'Dr. Rao', '9876500001', 'Fall 2025', 'A'),
(3, 'Rohan Mehta', '9876511111', 103, 'Operating Systems', 'Dr. Iyer', '9876500003', 'Spring 2026', 'C'),
(3, 'Rohan Mehta', '9876511111', 101, 'Database Systems', 'Dr. Rao', '9876500001', 'Fall 2025', 'B');

INSERT INTO Students (StudentID, StudentName, Phone) 
VALUES
(1,'Amit Sharma','9876543210'),
(2,'Priya Patel','9876501234'),
(3,'Rohan Mehta','9876511111');

INSERT INTO Instructors (InstructorID, InstructorName, InstructorPhone) 
VALUES
(1,'Dr. Rao','9876500001'),
(2,'Dr. Gupta','9876500002'),
(3,'Dr. Iyer','9876500003');

INSERT INTO Courses (CourseID, CourseName, InstructorID) 
VALUES
(101,'Database Systems',1),
(102,'Computer Networks',2),
(103,'Operating Systems',3);

INSERT INTO Enrollments (StudentID, CourseID, Semester, Grade) 
VALUES
(1,101,'Fall 2025','A'),
(1,102,'Fall 2025','B'),
(2,101,'Fall 2025','A'),
(3,103,'Spring 2026','C'),
(3,101,'Fall 2025','B');

-- 1. Identify insertion anomalies in the table.
-- You can't add a new course without a student enrolling in it, or a new instructor without a course being associated with them. For example, to add a new course like 'Data Structures' with Dr. Kumar as the instructor, you'd need a student to enroll first.

-- 2. Identify update anomalies in the table.
-- To change a single piece of information, you have to update it in multiple places. If Dr. Rao's phone number changes, you must update it for every row where 'Dr. Rao' is the instructor, which is inefficient and risks data inconsistency.

-- 3. Identify deletion anomalies in the table.
-- Deleting a row might unintentionally remove other important information. If the last student enrolled in 'Operating Systems' is deleted, information about the course (103, 'Operating Systems') and its instructor (Dr. Iyer) is also lost.

-- 4. Does this schema satisfy 1NF? Why or why not?
-- Yes, the original StudentEnrollment table satisfies 1NF because all its values are atomic. An attribute is atomic if it cannot be further subdivided. Each cell contains a single value (e.g., 'Amit Sharma' is a single string, 'A' is a single grade). There are no repeating groups or lists within a single cell.

-- 5. Rewrite the schema to achieve 1NF.
-- The provided StudentEnrollment table is already in 1NF. Therefore, it does not need to be rewritten to achieve 1NF. The next step in normalization would be to move to 2NF.

-- 6. Define the primary key for this unnormalized table.
-- The primary key for the unnormalized table is a composite key of (StudentID, CourseID, Semester), as this combination uniquely identifies each row (a student's enrollment in a specific course during a specific semester).

-- 7. List the functional dependencies (FDs) in this dataset.
-- {StudentID} -> {StudentName, Phone}
-- {CourseID} -> {CourseName, Instructor, InstructorPhone}
-- {StudentID, CourseID, Semester} -> {Grade}
-- {Instructor} -> {InstructorPhone}

-- 8. Explain why this table does not satisfy 2NF.
-- The table does not satisfy 2NF because there are partial dependencies. A partial dependency occurs when a non-prime attribute (an attribute not part of the primary key) is dependent on only a part of the composite primary key. In this case:
-- StudentName and Phone are dependent on StudentID, but not on the full key (StudentID, CourseID, Semester).
-- CourseName, Instructor, and InstructorPhone are dependent on CourseID, but not on the full key (StudentID, CourseID, Semester).

-- 9. Split the table into 2NF tables.
-- To convert to 2NF, we split the table to eliminate these partial dependencies. This results in the following tables:
-- Students: {StudentID, StudentName, Phone}
-- Courses: {CourseID, CourseName, Instructor, InstructorPhone}
-- Enrollments: {StudentID, CourseID, Semester, Grade}. 

-- 10. Create SQL CREATE TABLE statements for 2NF schema.
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(100),
    Phone VARCHAR(20)
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    Instructor VARCHAR(100),
    InstructorPhone VARCHAR(20)
);

CREATE TABLE Enrollments (
    StudentID INT,
    CourseID INT,
    Semester VARCHAR(20),
    Grade VARCHAR(5),
    PRIMARY KEY (StudentID, CourseID, Semester),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- 11. Show how transitive dependencies exist in this dataset.
-- In the Courses table of the 2NF schema, a transitive dependency exists. A transitive dependency is when a non-prime attribute depends on another non-prime attribute.
-- InstructorPhone is dependent on Instructor (e.g., given the instructor, you know their phone number).
-- Instructor is dependent on CourseID.
-- Therefore, InstructorPhone is transitively dependent on CourseID.

-- 12. Convert the schema to 3NF.
-- To achieve 3NF, we must remove the transitive dependency by creating a separate table for instructors. This yields the following tables:
-- Students: {StudentID, StudentName, Phone}
-- Instructors: {InstructorID, InstructorName, InstructorPhone}
-- Courses: {CourseID, CourseName, InstructorID}
-- Enrollments: {StudentID, CourseID, Semester, Grade}. 

-- 13. Write SQL CREATE TABLE for 3NF schema.
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(100),
    Phone VARCHAR(20));

CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY AUTO_INCREMENT,
    InstructorName VARCHAR(100),
    InstructorPhone VARCHAR(20));

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    InstructorID INT,
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID));

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    CourseID INT,
    Semester VARCHAR(20),
    Grade VARCHAR(5),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    UNIQUE (StudentID, CourseID, Semester));
    
-- 14. Check if the 3NF schema also satisfies BCNF. If not, modify it.
-- The 3NF schema, as designed, also satisfies BCNF. BCNF is a stricter form of 3NF. A table is in BCNF if for every functional dependency A -> B, A is a superkey (a set of attributes that uniquely identifies a row). In our 3NF schema, all dependencies follow this rule:
-- StudentID -> StudentName, Phone (StudentID is a superkey for the Students table)
-- CourseID -> CourseName, InstructorID (CourseID is a superkey for the Courses table)
-- InstructorID -> InstructorName, InstructorPhone (InstructorID is a superkey for the Instructors table)
-- (StudentID, CourseID, Semester) -> Grade ((StudentID, CourseID, Semester) is a superkey for the Enrollments table)
-- Since all functional dependencies have a superkey on the left-hand side, the schema is in BCNF.

-- 15. Write a SQL query (using normalized schema) to list all students with their courses and instructors.
SELECT s.StudentID, s.StudentName, c.CourseID, c.CourseName, i.InstructorName, e.Semester, e.Grade
FROM Enrollments e
JOIN Students s ON e.StudentID = s.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
JOIN Instructors i ON c.InstructorID = i.InstructorID;

-- 16. Write a query to find all courses taken by a specific student.
SELECT c.CourseID, c.CourseName, e.Semester, e.Grade
FROM Enrollments e
JOIN Students s ON e.StudentID = s.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE s.StudentName = 'Amit Sharma';

-- 17. Write a query to count number of students enrolled in each course.
SELECT c.CourseID, c.CourseName, COUNT(DISTINCT e.StudentID) AS NumStudents
FROM Enrollments e JOIN Courses c ON e.CourseID = c.CourseID
GROUP BY c.CourseID, c.CourseName;

-- 18. Write a query to find instructors who teach more than one course.
SELECT i.InstructorName, COUNT(*) AS NumCourses
FROM Courses c JOIN Instructors i ON c.InstructorID = i.InstructorID
GROUP BY i.InstructorName
HAVING COUNT(*) > 1;

-- 19. Write a query to list all students who received grade "A" in any course.
SELECT s.StudentID, s.StudentName
FROM Enrollments e
JOIN Students s ON e.StudentID = s.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE e.Grade='A' AND c.CourseName='Database Systems';

-- 20. Explain how the normalized schema reduces redundancy compared to the unnormalized one.
-- Normalizing the schema significantly reduces data redundancy. In the unnormalized StudentEnrollment table, student details (name, phone) and course details (name, instructor, instructor phone) are repeated for every enrollment record. For example, Amit Sharma's name and phone number appear twice because he's enrolled in two courses.
-- In the normalized schema, each piece of information is stored only once in its own dedicated table. The Students table stores student details just once per student. The Courses table stores course information once, and the Instructors table stores instructor details once. The Enrollments table then uses foreign keys to link to these other tables, eliminating the need to repeat data. This makes the database more efficient, easier to maintain, and ensures data consistency by preventing the anomalies discussed earlier.