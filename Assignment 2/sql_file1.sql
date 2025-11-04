CREATE DATABASE college;
CREATE DATABASE abc_company;

DROP DATABASE abc_company;
DROP DATABASE test;

USE college;
CREATE TABLE student (
rollno INT,
sname VARCHAR(30),
age INT
);

INSERT INTO student
VALUES 
(101,"raj",18),
(102,"rahul",20),
(103,"ria",17);

SELECT * FROM student

CREATE DATABASE college;

CREATE DATABASE IF NOT EXISTS college;

CREATE DATABASE IF NOT EXISTS instagram;

DROP DATABASE abc_company;

DROP DATABASE IF EXISTS abc_company;

SHOW DATABASES;

SHOW TABLES;