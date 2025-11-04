-- Set 4: Hospital Patient Records

CREATE DATABASE HospitalPatientRecords;
USE HospitalPatientRecords;

CREATE TABLE PatientRecords (
    PatientID INT,
    PatientName VARCHAR(100),
    Age INT,
    DoctorName VARCHAR(100),
    DoctorSpecialization VARCHAR(100),
    AppointmentDate DATE,
    Treatment VARCHAR(200),
    MedicinePrescribed VARCHAR(200),
    BillAmount DECIMAL(10,2));

INSERT INTO PatientRecords 
VALUES
(501,'Sunil Kumar',45,'Dr. Sharma','Cardiology','2025-09-05','ECG','Aspirin',1500.00),
(502,'Meera Joshi',30,'Dr. Rao','Orthopedics','2025-09-07','X-Ray','Painkiller',800.00),
(501,'Sunil Kumar',45,'Dr. Sharma','Cardiology','2025-10-01','Follow-up','Aspirin',500.00),
(503,'Akhil Singh',60,'Dr. Varma','Geriatrics','2025-09-20','Checkup','Vitamins',1200.00),
(504,'Nisha Patel',28,'Dr. Rao','Orthopedics','2025-08-30','Physiotherapy','Painkiller',2000.00);

INSERT INTO Patients 
VALUES 
(501,'Sunil Kumar',45),(502,'Meera Joshi',30),(503,'Akhil Singh',60),(504,'Nisha Patel',28);

INSERT INTO Doctors (DoctorID,DoctorName,DoctorSpecialization) 
VALUES
(1,'Dr. Sharma','Cardiology'),
(2,'Dr. Rao','Orthopedics'),
(3,'Dr. Varma','Geriatrics');

INSERT INTO Appointments (PatientID,DoctorID,AppointmentDate,Treatment,BillAmount) 
VALUES
(501,1,'2025-09-05','ECG',1500.00),
(502,2,'2025-09-07','X-Ray',800.00),
(501,1,'2025-10-01','Follow-up',500.00),
(503,3,'2025-09-20','Checkup',1200.00),
(504,2,'2025-08-30','Physiotherapy',2000.00);

INSERT INTO Medicines (MedicineName) 
VALUES 
('Aspirin'),('Painkiller'),('Vitamins');

INSERT INTO AppointmentMedicines 
VALUES
(1,1),(2,2),(3,1),(4,3),(5,2);

-- 1. Identify anomalies (insert, update, delete).
-- Insertion Anomaly: You can't add a new doctor to the system unless they have at least one patient appointment. Similarly, you can't record a new medicine until it's prescribed in an appointment. This is an issue because the hospital needs to keep track of all its staff and available medicines regardless of current patient activity.
-- Update Anomaly: If a doctor's specialization changes, you must update every row where that doctor's name appears. For example, if Dr. Rao's specialization changes, you would need to change it for both of his patient records, which is inefficient and prone to error.
-- Deletion Anomaly: Deleting the last patient record for a specific doctor will also delete the doctor's information (name, specialization). For example, if the last record for PatientID 503 is removed, the information about Dr. Varma is lost.

-- 2. Does schema satisfy 1NF? Why/why not?
-- No, the PatientRecords schema fails 1NF because the MedicinePrescribed attribute contains multiple, non-atomic values. For example, a patient might be prescribed multiple medicines, which would be represented as a comma-separated list, violating the single-value-per-cell rule.

-- 3. Rewrite schema in 1NF.
-- To satisfy 1NF, we need to ensure each column holds a single, atomic value. This involves creating a separate Medicines table and a linking table for AppointmentMedicines to handle the many-to-many relationship between appointments and medicines.

-- 4. State primary key.
-- The primary key for this unnormalized table is a composite key of (PatientID, AppointmentDate, DoctorName). This combination uniquely identifies each patient's visit.

-- 5. Write functional dependencies.
-- The functional dependencies (FDs) are:
-- {PatientID} -> {PatientName, Age}
-- {DoctorName} -> {DoctorSpecialization}
-- {PatientID, AppointmentDate, DoctorName} -> {Treatment, MedicinePrescribed, BillAmount}

-- 6. Remove partial dependencies (2NF).
-- The table fails 2NF due to partial dependencies. Non-prime attributes are dependent on only part of the composite primary key.
-- PatientName and Age depend only on PatientID.
-- DoctorSpecialization depends only on DoctorName.
-- Treatment, MedicinePrescribed, and BillAmount depend on the full key.
-- To fix this, we split the schema into separate tables for patients, doctors, and a core table for appointments.

-- 7. Create SQL for 2NF schema.
CREATE TABLE Patients (
  PatientID INT PRIMARY KEY,
  PatientName VARCHAR(100),
  Age INT);

CREATE TABLE Doctors (
  DoctorName VARCHAR(100) PRIMARY KEY,
  DoctorSpecialization VARCHAR(100));

CREATE TABLE PatientAppointments (
  PatientID INT,
  DoctorName VARCHAR(100),
  AppointmentDate DATE,
  Treatment VARCHAR(200),
  MedicinePrescribed VARCHAR(200),
  BillAmount DECIMAL(10,2),
  PRIMARY KEY (PatientID, DoctorName, AppointmentDate),
  FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
  FOREIGN KEY (DoctorName) REFERENCES Doctors(DoctorName));
  
-- 8. Identify transitive dependencies.
-- The 2NF schema still has a transitive dependency. In the PatientAppointments table, DoctorSpecialization depends on DoctorName, and DoctorName is a non-key attribute in this table. This is a transitive dependency.

-- 9. Convert schema to 3NF.
-- To convert to 3NF, we must remove the transitive dependency by creating a separate Doctors table with a DoctorID primary key. The Appointments table will then reference this key. MedicinePrescribed will also be split into a separate table to fully satisfy 1NF. The provided normalized schema represents a full 3NF (and BCNF) design.
    
-- 10. Write SQL for 3NF schema.
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    PatientName VARCHAR(100),
    Age INT);

CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY AUTO_INCREMENT,
    DoctorName VARCHAR(100) UNIQUE,
    DoctorSpecialization VARCHAR(100));

CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATE,
    Treatment VARCHAR(200),
    BillAmount DECIMAL(10,2),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID));

CREATE TABLE Medicines (
    MedicineID INT PRIMARY KEY AUTO_INCREMENT,
    MedicineName VARCHAR(200) UNIQUE);

CREATE TABLE AppointmentMedicines (
    AppointmentID INT,
    MedicineID INT,
    PRIMARY KEY (AppointmentID, MedicineID),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID),
    FOREIGN KEY (MedicineID) REFERENCES Medicines(MedicineID));

-- 11. Check if schema is BCNF.
-- Yes, the final 3NF schema also satisfies BCNF. For every functional dependency, the determinant (the left side) is a superkey. There are no non-trivial dependencies where a non-superkey determines an attribute, so the schema is in its highest form of normalization

-- 12. Query: List patients with their doctors.
SELECT p.PatientID,p.PatientName,d.DoctorName,d.DoctorSpecialization,a.AppointmentDate,a.Treatment,a.BillAmount
FROM Appointments a
JOIN Patients p ON a.PatientID=p.PatientID
JOIN Doctors d ON a.DoctorID=d.DoctorID;

-- 13. Query: Count patients per doctor.
SELECT d.DoctorName, COUNT(DISTINCT a.PatientID) AS PatientCount
FROM Doctors d LEFT JOIN Appointments a ON d.DoctorID=a.DoctorID
GROUP BY d.DoctorName;

-- 14. Query: List treatments done by "Dr. Sharma".
SELECT p.PatientName,a.Treatment,a.AppointmentDate
FROM Appointments a JOIN Doctors d ON a.DoctorID=d.DoctorID JOIN Patients p ON a.PatientID=p.PatientID
WHERE d.DoctorName='Dr. Rao';

-- 15. Query: Find patients prescribed more than 2 medicines.
SELECT p.PatientID,p.PatientName, COUNT(am.MedicineID) AS MedCount
FROM Appointments a
JOIN AppointmentMedicines am ON a.AppointmentID=am.AppointmentID
JOIN Patients p ON a.PatientID=p.PatientID
GROUP BY p.PatientID,p.PatientName
HAVING COUNT(am.MedicineID) > 2;

-- 16. Query: List all specializations of doctors treating patients.
-- 17. Query: Find highest bill amount.
-- 18. Query: Average bill per doctor.
SELECT d.DoctorName, AVG(a.BillAmount) AS AvgBill
FROM Doctors d JOIN Appointments a ON d.DoctorID=a.DoctorID
GROUP BY d.DoctorName;

-- 19. Query: Patients treated by doctors of "Cardiology".
SELECT DISTINCT p.PatientID, p.PatientName
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
JOIN Doctors d ON a.DoctorID = d.DoctorID
WHERE d.DoctorSpecialization = 'Cardiology';

-- 20. Explain redundancy reduction after normalization.
-- Normalization significantly reduces data redundancy. In the unnormalized table, information about patients (name, age) and doctors (name, specialization) is repeated for every appointment. Sunil Kumar's details, for example, are stored twice. The normalized schema eliminates this by storing each piece of information only once in its own dedicated table (Patients, Doctors, Medicines). The Appointments table then links them using foreign keys, avoiding data duplication. This makes the database more efficient, improves data integrity, and prevents the anomalies that were present in the single, unnormalized table.