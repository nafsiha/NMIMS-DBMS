create table student(
StudentID INT,
Name VARCHAR(20),
Age INT,
Gender VARCHAR(20));

ALTER TABLE student 
ADD Location VARCHAR(20);

SELECT * from student;

drop table student;

truncate table Student;

select * from Student;

drop database Practise;

CREATE DATABASE Practise;
Use Practise;

create table student(
StudentID INT,
Name VARCHAR(20),
Age INT,
Gender VARCHAR(20));

INSERT INTO student(StudentID, Name, Age, Gender)
VALUES
(01, 'Ram', 20, 'Male'),
(02, 'Sana', 21, 'Female'),
(03, 'John', 21, 'Male'),
(04, 'Peter', 20, 'Male');

ALTER TABLE student 
ADD Location VARCHAR(20);

UPDATE student 
SET Location = 'Bangalore'
WHERE StudentID IN (1,3);

UPDATE student 
SET Location = 'Bangalore'
WHERE StudentID = 2;

UPDATE student 
SET Location = 'Bangalore'
WHERE StudentID = 4;

DELETE FROM student 
WHERE StudentID = 4;

SELECT * FROM student;

SELECT Name, Location, Gender
FROM student;

SELECT COUNT(*) AS No_of_students
FROM student;

SELECT StudentID, Name 
FROM student 
WHERE location = 'Bangalore';

SELECT DISTINCT Location
from student;

SELECT Name FROM student 
LIMIT 2;

SET AUTOCOMMIT = 0;

START TRANSACTION;

SELECT * FROM student;

DELETE FROM student 
WHERE StudentID = 4;

ROLLBACK;

COMMIT;

SET AUTOCOMMIT = 0;

START TRANSACTION;

SAVEPOINT A;

SELECT * FROM Students;

SAVEPOINT B;

DELETE FROM Student;

select * from Student;

Rollback to B;

select * from Student;

COMMIT;
