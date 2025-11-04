-- set 2
CREATE DATABASE HospitalManagement;
USE HospitalManagement;

CREATE TABLE Doctors (
  DoctorID INT PRIMARY KEY,
  Name VARCHAR(100),
  Specialization VARCHAR(50),
  Phone VARCHAR(15),
  JoiningDate DATE
);

CREATE TABLE Patients (
  PatientID INT PRIMARY KEY,
  Name VARCHAR(100),
  DOB DATE,
  Gender VARCHAR(10),
  Phone VARCHAR(15)
);

CREATE TABLE Appointments (
  AppointmentID INT PRIMARY KEY,
  PatientID INT,
  DoctorID INT,
  Date DATE,
  Time TIME,
  Status VARCHAR(20),
  FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
  FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

CREATE TABLE Departments (
  DeptID INT PRIMARY KEY,
  DeptName VARCHAR(50),
  Location VARCHAR(100)
);

CREATE TABLE Bills (
  BillID INT PRIMARY KEY,
  PatientID INT,
  Amount DECIMAL(10, 2),
  BillDate DATE,
  PaymentStatus VARCHAR(20),
  FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

-- Insert data into Doctors
INSERT INTO Doctors VALUES
  (1, 'Dr. Asha Patel', 'Cardiology', '9876543210', '2018-06-15'),
  (2, 'Dr. Raj Singh', 'Neurology', '9812345678', '2021-09-10'),
  (3, 'Dr. Meera Kulkarni', 'Orthopedics', '9823456789', '2015-02-05'),
  (4, 'Dr. Vikram Desai', 'Cardiology', '9898765432', '2019-11-20'),
  (5, 'Dr. Sunita Rao', 'Pediatrics', '9801234567', '2022-01-03');

-- Insert data into Patients
INSERT INTO Patients VALUES
  (1, 'Anil Kumar', '1950-04-12', 'Male', '9123456789'),
  (2, 'Sunita Sharma', '1985-08-20', 'Female', '9234567890'),
  (3, 'Rajesh Singh', '1970-12-30', 'Male', '9345678901'),
  (4, 'Pooja Joshi', '2001-06-15', 'Female', '9456789012'),
  (5, 'Mohit Verma', '1940-01-22', 'Male', '9567890123');

-- Insert data into Appointments
INSERT INTO Appointments VALUES
  (1, 1, 1, '2025-09-04', '10:00:00', 'Scheduled'),
  (2, 2, 2, '2025-09-04', '11:30:00', 'Cancelled'),
  (3, 3, 3, '2025-09-01', '09:00:00', 'Completed'),
  (4, 4, 4, '2025-08-30', '14:00:00', 'Completed'),
  (5, 5, 5, '2025-09-02', '10:30:00', 'Scheduled');

-- Insert data into Departments
INSERT INTO Departments VALUES
  (1, 'Cardiology', 'Floor 1'),
  (2, 'Neurology', 'Floor 2'),
  (3, 'Orthopedics', 'Floor 3'),
  (4, 'Pediatrics', 'Floor 4'),
  (5, 'Radiology', 'Floor 5');

-- Insert data into Bills
INSERT INTO Bills VALUES
  (1, 1, 7000.50, '2025-08-15', 'Paid'),
  (2, 2, 3200.00, '2025-08-20', 'Unpaid'),
  (3, 3, 12000.00, '2025-07-10', 'Paid'),
  (4, 4, 4500.25, '2025-08-25', 'Unpaid'),
  (5, 5, 6000.00, '2025-09-01', 'Paid');

-- 1. List doctors with specialization 'Cardiology'.
SELECT * FROM Doctors WHERE Specialization = 'Cardiology';

-- 2. Show all patients above 60 years old.
SELECT * FROM Patients WHERE DOB <= CURDATE() - INTERVAL 60 YEAR;

-- 3. Find appointments scheduled for today.
SELECT * FROM Appointments WHERE Date = CURDATE();

-- 4. Count total patients per department (based on doctors assigned to department by specialization).
SELECT d.DeptName, COUNT(DISTINCT a.PatientID) AS TotalPatients
FROM Departments d
LEFT JOIN Doctors doc ON d.DeptName = doc.Specialization
LEFT JOIN Appointments a ON doc.DoctorID = a.DoctorID
GROUP BY d.DeptID, d.DeptName;

-- 5. Show patients assigned to a specific doctor (DoctorID = 1 example).
SELECT DISTINCT p.*
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
WHERE a.DoctorID = 1;

-- 6. List bills with amount greater than 5000.
SELECT * FROM Bills WHERE Amount > 5000;

-- 7. Display unpaid bills.
SELECT * FROM Bills WHERE PaymentStatus = 'Unpaid';

-- 8. Show the doctor with the maximum appointments.
SELECT doc.Name, COUNT(a.AppointmentID) AS AppointmentCount
FROM Doctors doc
JOIN Appointments a ON doc.DoctorID = a.DoctorID
GROUP BY doc.DoctorID, doc.Name
ORDER BY AppointmentCount DESC
LIMIT 1;

-- 9. List patients without appointments.
SELECT * FROM Patients WHERE PatientID NOT IN (SELECT DISTINCT PatientID FROM Appointments);

-- 10. Find oldest patient.
SELECT * FROM Patients ORDER BY DOB ASC LIMIT 1;

-- 11. Show average bill amount per department (linked through patient's appointments and doctors).
SELECT d.DeptName, AVG(b.Amount) AS AvgBill
FROM Departments d
JOIN Doctors doc ON d.DeptName = doc.Specialization
JOIN Appointments a ON doc.DoctorID = a.DoctorID
JOIN Bills b ON a.PatientID = b.PatientID
GROUP BY d.DeptID, d.DeptName;

-- 12. List doctors joined after 2020.
SELECT * FROM Doctors WHERE JoiningDate > '2020-12-31';

-- 13. Find patients whose name starts with 'A'.
SELECT * FROM Patients WHERE Name LIKE 'A%';

-- 14. Show all cancelled appointments.
SELECT * FROM Appointments WHERE Status = 'Cancelled';

-- 15. Count appointments per day.
SELECT Date, COUNT(*) AS AppointmentCount
FROM Appointments
GROUP BY Date;

-- 16. Find patients who visited more than 3 times.
SELECT p.PatientID, p.Name, COUNT(a.AppointmentID) AS VisitCount
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
GROUP BY p.PatientID, p.Name
HAVING VisitCount > 3;

-- 17. Show department names with their doctors.
SELECT d.DeptName, doc.Name AS DoctorName
FROM Departments d
LEFT JOIN Doctors doc ON d.DeptName = doc.Specialization
ORDER BY d.DeptName;

-- 18. Find doctors working in 'Neurology'.
SELECT * FROM Doctors WHERE Specialization = 'Neurology';

-- 19. Display total bills for each patient.
SELECT p.PatientID, p.Name, SUM(b.Amount) AS TotalBills
FROM Patients p
LEFT JOIN Bills b ON p.PatientID = b.PatientID
GROUP BY p.PatientID, p.Name;

-- 20. Show top 5 highest billing patients.
SELECT p.PatientID, p.Name, SUM(b.Amount) AS TotalBills
FROM Patients p
JOIN Bills b ON p.PatientID = b.PatientID
GROUP BY p.PatientID, p.Name
ORDER BY TotalBills DESC
LIMIT 5;

-- 21. List appointments with doctor and patient names.
SELECT a.AppointmentID, p.Name AS PatientName, doc.Name AS DoctorName, a.Date, a.Time, a.Status
FROM Appointments a
JOIN Patients p ON a.PatientID = p.PatientID
JOIN Doctors doc ON a.DoctorID = doc.DoctorID;

-- 22. Find departments without doctors.
SELECT d.*
FROM Departments d
LEFT JOIN Doctors doc ON d.DeptName = doc.Specialization
WHERE doc.DoctorID IS NULL;

-- 23. List doctors with phone starting with '98'.
SELECT * FROM Doctors WHERE Phone LIKE '98%';

-- 24. Show patients admitted in last 7 days (assuming admission means appointment date).
SELECT DISTINCT p.*
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
WHERE a.Date >= CURDATE() - INTERVAL 7 DAY;

-- 25. Display doctors and their total billing amounts.
SELECT doc.DoctorID, doc.Name, SUM(b.Amount) AS TotalBilling
FROM Doctors doc
JOIN Appointments a ON doc.DoctorID = a.DoctorID
JOIN Bills b ON a.PatientID = b.PatientID
GROUP BY doc.DoctorID, doc.Name;
