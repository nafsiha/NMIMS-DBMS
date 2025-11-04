Use Practise;

create table Department(
DepartmentID INT,
DeptName VARCHAR(20) 
);

alter table Department Modify Column DepartmentID INT Primary Key;

create table Employee(
EmpID INT,
EmpName VARCHAR(20),
DepartmentID INT,
FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

INSERT INTO Department values 
(101, 'IT'),
(102, 'HR'),
(103, 'Sales'),
(104, 'Marketing');

INSERT INTO Employee values 
(01, 'Ram', 101),
(02, 'Sham', 102),
(03, 'Peter', 101),
(04, 'John', 103);

SELECT e.EmpID, e.EmpName, d.DeptName 
FROM Employee as e 
INNER JOIN Department as d
ON e.DepartmentID = d.DepartmentID;

SELECT e.EmpID, e.EmpName, d.DepartmentID, d.DeptName
FROM Employee as e
LEFT JOIN Department as d
on e.DepartmentID = d.DepartmentID;

SELECT e.EmpID, e.EmpName, d.DepartmentID, d.DeptName
FROM Employee as e
RIGHT JOIN Department as d
on e.DepartmentID = d.DepartmentID;

SELECT e.EmpID, e.EmpName, d.DepartmentID, d.DeptName
FROM Employee as e
LEFT JOIN Department as d
on e.DepartmentID = d.DepartmentID
UNION
SELECT e.EmpID, e.EmpName, d.DepartmentID, d.DeptName
FROM Employee as e
RIGHT JOIN Department as d
on e.DepartmentID = d.DepartmentID;

SELECT e.EmpID, e.EmpName, d.DepartmentID, d.DeptName
FROM Employee as e
CROSS JOIN Department as d
on e.DepartmentID = d.DepartmentID;


create table Company(
EmpID INT Primary Key,
EmpName varchar(20),
ManagerID INT
);

INSERT INTO Company VALUES
(1, 'Ram', 0),
(2, 'Sana', 1),
(3, 'Bob', 1),
(4, 'Mary', 2);


SELECT c.EmpName as EmployeeName, 
	   m.EmpName as ManagerName
FROM Company c
LEFT JOIN Company m
ON c.ManagerID = m.EmpID;

