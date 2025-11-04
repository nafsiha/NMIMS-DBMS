-- Set 2: Employee Project Assignment

CREATE DATABASE EmployeeProjectAssignment;
USE EmployeeProjectAssignment; 

CREATE TABLE EmployeeProject (
    EmpID INT,
    EmpName VARCHAR(100),
    Department VARCHAR(50),
    DeptLocation VARCHAR(50),
    ProjectID INT,
    ProjectName VARCHAR(100),
    ProjectManager VARCHAR(100),
    HoursWorked INT,
    SkillSet VARCHAR(200));

INSERT INTO EmployeeProject 
VALUES
(201,'Rita Singh','IT','Mumbai',301,'Website Revamp','Arjun Mehta',25,'HTML,CSS,JS'),
(202,'Suresh Kumar','IT','Mumbai',302,'Network Upgrade','Neha Patel',40,'Networking,Firewalls'),
(203,'Anita Desai','HR','Pune',303,'Onboarding','Ritu Shah',10,'Communication,MS-Excel'),
(201,'Rita Singh','IT','Mumbai',304,'Mobile App','Karan Joshi',30,'ReactNative,JS'),
(204,'Vikram Rao','Finance','Mumbai',305,'Audit','Meera Iyer',15,'Accounting');

INSERT INTO Departments (DeptID, DeptName, DeptLocation) 
VALUES
(1,'IT','Mumbai'),(2,'HR','Pune'),(3,'Finance','Mumbai');

INSERT INTO Employees (EmpID, EmpName, DeptID) 
VALUES
(201,'Rita Singh',1),(202,'Suresh Kumar',1),(203,'Anita Desai',2),(204,'Vikram Rao',3);

INSERT INTO Projects (ProjectID, ProjectName, ProjectManager) 
VALUES
(301,'Website Revamp','Arjun Mehta'),
(302,'Network Upgrade','Neha Patel'),
(303,'Onboarding','Ritu Shah'),
(304,'Mobile App','Karan Joshi'),
(305,'Audit','Meera Iyer');

INSERT INTO EmployeeProjects (EmpID, ProjectID, HoursWorked) 
VALUES
(201,301,25),(202,302,40),(203,303,10),(201,304,30),(204,305,15);

INSERT INTO Skills (SkillID, SkillName) 
VALUES
(1,'HTML'),(2,'CSS'),(3,'JS'),(4,'Networking'),(5,'Firewalls'),(6,'Communication'),(7,'MS-Excel'),(8,'ReactNative'),(9,'Accounting');

INSERT INTO EmployeeSkills 
VALUES
(201,1),(201,2),(201,3),(201,8),
(202,4),(202,5),
(203,6),(203,7),
(204,9); 

-- 1. Identify insertion anomalies in this table.
-- You cannot add a new employee to the database without assigning them to a project. Similarly, you cannot add a new department or a new skill without it being tied to an existing employee. This makes the database rigid and incomplete.

-- 2. Identify update anomalies.
-- To change a piece of information, you must update it in multiple places. For example, if Rita Singh's department location changes from Mumbai to Pune, you would have to update this information in every row she appears in. If you miss even one row, you introduce a data inconsistency.

-- 3. Identify deletion anomalies.
-- Deleting a row can cause the loss of important information. If the only row for a project is deleted (e.g., the row for ProjectID 305 with Vikram Rao), the information about that project (ProjectName, ProjectManager) is also lost.

-- 4. Does this schema satisfy 1NF? Explain.
-- No, the schema does not satisfy 1NF because the SkillSet attribute is not atomic. It contains a comma-separated list of skills, which violates the rule that each cell should hold a single, indivisible value.

-- 5. Normalize to 1NF.
-- To normalize to 1NF, the SkillSet attribute must be broken down. The best way is to create a separate table for skills and a linking table for EmployeeSkills. This removes the multi-valued attribute.

-- 6. State the primary key.
-- The primary key for the unnormalized EmployeeProject table would be a composite key of (EmpID, ProjectID). This combination uniquely identifies each row, as an employee is uniquely linked to a project for a certain number of hours.

-- 7. Write functional dependencies (FDs).
-- {EmpID} -> {EmpName, Department, DeptLocation, SkillSet}
-- {ProjectID} -> {ProjectName, ProjectManager}
-- {EmpID, ProjectID} -> {HoursWorked}
-- {Department} -> {DeptLocation}

-- 8. Identify partial dependencies.
-- The table does not satisfy 2NF due to partial dependencies. Non-prime attributes (those not part of the primary key) are dependent on only a part of the composite primary key (EmpID, ProjectID).
-- EmpName, Department, DeptLocation, and SkillSet are dependent on EmpID only.
-- ProjectName and ProjectManager are dependent on ProjectID only.

-- 9. Convert schema into 2NF.
-- To achieve 2NF, we split the table to eliminate partial dependencies:
-- Employees: {EmpID, EmpName, Department, DeptLocation, SkillSet}
-- Projects: {ProjectID, ProjectName, ProjectManager}
-- EmployeeProjects: {EmpID, ProjectID, HoursWorked}

-- 10. Write SQL for 2NF tables.
-- This step is not a full normalization, as SkillSet is not atomic. A better 2NF representation would involve separate tables for skills and departments to fully satisfy 1NF. The tables would look like the provided normalized schema: Employees, Departments, Projects, EmployeeProjects, Skills, and EmployeeSkills.

-- 11. Explain why transitive dependencies still exist.
-- In the 2NF schema (specifically the Employees table with Department and DeptLocation), a transitive dependency exists. A transitive dependency is when a non-prime attribute depends on another non-prime attribute. In this case, DeptLocation is dependent on Department, and Department is dependent on EmpID. This means DeptLocation is transitively dependent on EmpID.

-- 12. Convert schema into 3NF.
-- To convert to 3NF, we must remove transitive dependencies. This involves splitting out departments into their own table. SkillSet also needs to be split further as it's a multi-valued attribute, which is a key part of the 1NF violation. The final 3NF schema is the one provided in the prompt's CREATE TABLE statements for the normalized schema.

-- 13. Write SQL for 3NF tables.
CREATE TABLE Departments (
    DeptID INT PRIMARY KEY AUTO_INCREMENT,
    DeptName VARCHAR(50) UNIQUE,
    DeptLocation VARCHAR(50));

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(100),
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID));

CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100),
    ProjectManager VARCHAR(100));

CREATE TABLE EmployeeProjects (
    EmpID INT,
    ProjectID INT,
    HoursWorked INT,
    PRIMARY KEY (EmpID, ProjectID),
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID));

CREATE TABLE Skills (
    SkillID INT PRIMARY KEY AUTO_INCREMENT,
    SkillName VARCHAR(100) UNIQUE);

CREATE TABLE EmployeeSkills (
    EmpID INT,
    SkillID INT,
    PRIMARY KEY (EmpID, SkillID),
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID),
    FOREIGN KEY (SkillID) REFERENCES Skills(SkillID));
    
-- 14. Check if schema satisfies BCNF. Modify if needed.
-- The provided 3NF schema, consisting of Departments, Employees, Projects, EmployeeProjects, Skills, and EmployeeSkills tables, satisfies BCNF. This is because for every functional dependency, the determinant (the left side of the arrow) is a superkey. No further modification is needed.

-- 15. Query: List employees with their projects.
SELECT e.EmpID,e.EmpName,p.ProjectName,ep.HoursWorked
FROM EmployeeProjects ep
JOIN Employees e ON ep.EmpID=e.EmpID
JOIN Projects p ON ep.ProjectID=p.ProjectID;

-- 16. Query: Count projects per employee.
SELECT e.EmpID,e.EmpName,COUNT(ep.ProjectID) AS ProjectsCount
FROM Employees e LEFT JOIN EmployeeProjects ep ON e.EmpID=ep.EmpID
GROUP BY e.EmpID,e.EmpName;

-- 17. Query: Find employees with more than 1 skill.
SELECT e.EmpID,e.EmpName,COUNT(es.SkillID) AS SkillCount
FROM Employees e JOIN EmployeeSkills es ON e.EmpID=es.EmpID
GROUP BY e.EmpID,e.EmpName
HAVING COUNT(es.SkillID)>1;

-- 18. Query: Find managers handling multiple projects.
SELECT ProjectManager, COUNT(*) AS NumProjects
FROM Projects
GROUP BY ProjectManager
HAVING COUNT(*)>1;

-- 19. Query: Find employees working > 40 hours.
SELECT e.EmpID,e.EmpName, SUM(ep.HoursWorked) AS TotalHours
FROM Employees e JOIN EmployeeProjects ep ON e.EmpID=ep.EmpID
GROUP BY e.EmpID,e.EmpName
HAVING SUM(ep.HoursWorked) > 40;

-- 20. Discuss redundancy before vs. after normalization.
-- Normalization dramatically reduces data redundancy. In the unnormalized EmployeeProject table, employee details (name, department, location, skills) are repeated for every project they are on. For example, Rita Singh's information is repeated twice. After normalization, each piece of data is stored once in its own dedicated table. Employee details are in the Employees table, project details in the Projects table, and so on. The EmployeeProjects table then links these entities using foreign keys, eliminating the repetition of data. This makes the database more efficient, maintains data integrity, and prevents the anomalies that plagued the original table.