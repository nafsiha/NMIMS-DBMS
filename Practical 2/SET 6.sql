-- Set 6: University Faculty Teaching

CREATE DATABASE University_Faculty_Teaching; 
USE University_Faculty_Teaching; 

CREATE TABLE FacultyTeaching (
    FacultyID INT,
    FacultyName VARCHAR(100),
    Department VARCHAR(50),
    CourseID INT,
    CourseName VARCHAR(100),
    Semester VARCHAR(20),
    Classroom VARCHAR(20),
    StudentCount INT,
    DeanName VARCHAR(100));
    
INSERT INTO FacultyTeaching 
VALUES
(801,'Dr. Mehta','Computer Science',401,'Data Structures','Fall 2025','C101',45,'Dr. Kapoor'),
(802,'Dr. Roy','Computer Science',402,'Algorithms','Fall 2025','C102',40,'Dr. Kapoor'),
(803,'Dr. Iyer','Maths',403,'Discrete Math','Fall 2025','M201',35,'Dr. Sengupta'),
(801,'Dr. Mehta','Computer Science',404,'DBMS','Spring 2026','C101',50,'Dr. Kapoor'),
(804,'Dr. Singh','Physics',405,'Mechanics','Fall 2025','P301',30,'Dr. Rao');

INSERT INTO Departments (DeptID,DeptName,DeanName) 
VALUES 
(1,'Computer Science','Dr. Kapoor'),(2,'Maths','Dr. Sengupta'),(3,'Physics','Dr. Rao');

INSERT INTO Faculty 
VALUES 
(801,'Dr. Mehta',1),(802,'Dr. Roy',1),(803,'Dr. Iyer',2),(804,'Dr. Singh',3);

INSERT INTO Courses 
VALUES 
(401,'Data Structures','C101'),(402,'Algorithms','C102'),(403,'Discrete Math','M201'),(404,'DBMS','C101'),(405,'Mechanics','P301');

INSERT INTO TeachingAssignments 
VALUES
(801,401,'Fall 2025',45),
(802,402,'Fall 2025',40),
(803,403,'Fall 2025',35),
(801,404,'Spring 2026',50),
(804,405,'Fall 2025',30);

-- 1. Identify insertion anomalies.
-- You can't add a new department or a new dean unless a faculty member is associated with them. For example, a new department can't be added to the system until a faculty member teaches a course there.

-- 2. Identify update anomalies.
-- If a dean's name or a department's name changes, you must update every record for faculty in that department. For example, if Dr. Kapoor is replaced, her name would need to be updated in every row for Dr. Mehta and Dr. Roy. This is inefficient and prone to errors.

-- 3. Identify deletion anomalies.
-- Deleting the last teaching record for a department can cause the loss of information about that department and its dean. For instance, if Dr. Iyer's record is deleted, the information about the Maths department and Dean Dr. Sengupta is lost.

-- 4. Does this schema satisfy 1NF? Explain.
-- Yes, the FacultyTeaching table satisfies 1NF. All values are atomic; each cell contains a single, indivisible value. There are no repeating groups or lists within the columns.

-- 5. Convert schema to 1NF.
-- The table is already in 1NF, so no conversion is needed. The next step is to normalize to 2NF.

-- 6. State primary key.
-- The primary key for this unnormalized table is the composite key (FacultyID, CourseID, Semester). This combination uniquely identifies a specific teaching assignment.

-- 7. Write FDs.
-- The functional dependencies (FDs) are:
-- {FacultyID} -> {FacultyName, Department, DeanName}
-- {CourseID} -> {CourseName, Classroom}
-- {FacultyID, CourseID, Semester} -> {StudentCount}
-- {Department} -> {DeanName}

-- 8. Identify partial dependencies.
-- The table fails 2NF due to partial dependencies. Non-prime attributes depend on only part of the composite primary key (FacultyID, CourseID, Semester).
-- FacultyName, Department, and DeanName depend only on FacultyID.
-- CourseName and Classroom depend only on CourseID.

-- 9. Convert schema to 2NF.
-- To achieve 2NF, we split the table to eliminate partial dependencies.
-- Faculty: {FacultyID, FacultyName, Department, DeanName}
-- Courses: {CourseID, CourseName, Classroom}
-- TeachingAssignments: {FacultyID, CourseID, Semester, StudentCount}

-- 10. Write SQL for 2NF schema.
CREATE TABLE Faculty (
    FacultyID INT PRIMARY KEY,
    FacultyName VARCHAR(100),
    Department VARCHAR(50),
    DeanName VARCHAR(100));

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    Classroom VARCHAR(20));

CREATE TABLE TeachingAssignments (
    FacultyID INT,
    CourseID INT,
    Semester VARCHAR(20),
    StudentCount INT,
    PRIMARY KEY (FacultyID, CourseID, Semester),
    FOREIGN KEY (FacultyID) REFERENCES Faculty(FacultyID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID));
    
-- 11. Identify transitive dependencies.
-- The 2NF schema has a transitive dependency in the Faculty table. DeanName is dependent on Department, and Department is dependent on FacultyID. This means DeanName is transitively dependent on FacultyID.

-- 12. Convert schema to 3NF.
-- To achieve 3NF, we must remove the transitive dependency by creating a separate Departments table. The Faculty table will then reference the DeptID from the Departments table as a foreign key. The provided normalized schema represents a full 3NF design.

-- 13. Write SQL for 3NF schema.
CREATE TABLE Departments (
    DeptID INT PRIMARY KEY AUTO_INCREMENT,
    DeptName VARCHAR(50) UNIQUE,
    DeanName VARCHAR(100));

CREATE TABLE Faculty (
    FacultyID INT PRIMARY KEY,
    FacultyName VARCHAR(100),
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID));

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    Classroom VARCHAR(20));

CREATE TABLE TeachingAssignments (
    FacultyID INT,
    CourseID INT,
    Semester VARCHAR(20),
    StudentCount INT,
    PRIMARY KEY (FacultyID, CourseID, Semester),
    FOREIGN KEY (FacultyID) REFERENCES Faculty(FacultyID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID));
    
-- 14. Check if schema is BCNF.
-- 15. Query: List courses taught by each faculty.
SELECT f.FacultyID,f.FacultyName,c.CourseName,t.Semester,t.StudentCount
FROM TeachingAssignments t
JOIN Faculty f ON t.FacultyID=f.FacultyID
JOIN Courses c ON t.CourseID=c.CourseID;

-- 16. Query: Count students per course.
SELECT c.CourseID,c.CourseName, SUM(t.StudentCount) AS TotalStudentsAcrossSemesters
FROM Courses c JOIN TeachingAssignments t ON c.CourseID=t.CourseID
GROUP BY c.CourseID,c.CourseName;

-- 17. Query: Find departments with more than 5 courses.
SELECT d.DeptName, COUNT(DISTINCT c.CourseID) AS CourseCount
FROM Departments d
JOIN Faculty f ON f.DeptID=d.DeptID
JOIN TeachingAssignments t ON t.FacultyID=f.FacultyID
JOIN Courses c ON t.CourseID=c.CourseID
GROUP BY d.DeptName
HAVING COUNT(DISTINCT c.CourseID)>5;

-- 18. Query: List classrooms used by multiple departments.
SELECT c.Classroom
FROM Courses c
JOIN TeachingAssignments t ON c.CourseID = t.CourseID
JOIN Faculty f ON t.FacultyID = f.FacultyID
GROUP BY c.Classroom
HAVING COUNT(DISTINCT f.DeptID) > 1;

-- 19. Query: Find deans handling multiple departments.
SELECT DeanName, COUNT(*) AS DepartmentCount
FROM Departments
GROUP BY DeanName
HAVING COUNT(*) > 1;

-- 20. Explain redundancy removal via normalization.
-- Normalization drastically reduces data redundancy. In the unnormalized FacultyTeaching table, information about faculty (name, department), departments (dean name), and courses (name, classroom) is repeated for every teaching assignment. For example, Dr. Mehta's details are stored twice because he teaches two courses. The normalized schema eliminates this by storing each piece of information once in its own dedicated table (Departments, Faculty, Courses). The TeachingAssignments table then links them using foreign keys. This makes the database more efficient, ensures data integrity, and makes it easier to update information without risking inconsistency.