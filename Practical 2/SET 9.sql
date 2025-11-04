-- Set 9: Travel Agency Booking

CREATE DATABASE Travel_Agency_Booking;
USE Travel_Agency_Booking;

CREATE TABLE TravelBooking (
    BookingID INT,
    CustomerID INT,
    CustomerName VARCHAR(100),
    Phone VARCHAR(20),
    Destination VARCHAR(100),
    PackageName VARCHAR(100),
    PackagePrice DECIMAL(10,2),
    HotelName VARCHAR(100),
    TransportMode VARCHAR(50),
    TravelDate DATE);

INSERT INTO TravelBooking 
VALUES
(1101,2001,'Rahul Mehra','9878000001','Goa','Beach Delight',15000.00,'SeaView Resort','Flight','2025-12-10'),
(1102,2002,'Sadia Khan','9878000002','Manali','Snow Escape',18000.00,'HillTop Hotel','Bus','2026-01-15'),
(1103,2001,'Rahul Mehra','9878000001','Goa','Adventure Pack',12000.00,'SeaView Resort','Flight','2026-02-20'),
(1104,2003,'Kiran Bose','9878000003','Kerala','Backwaters',20000.00,'Lakeside Hotel','Train','2025-11-05'),
(1105,2004,'Nina Roy','9878000004','Goa','Beach Delight',15000.00,'SeaView Resort','Flight','2026-01-10');

INSERT INTO Customers 
VALUES
(2001,'Rahul Mehra','9878000001'),
(2002,'Sadia Khan','9878000002'),
(2003,'Kiran Bose','9878000003'),
(2004,'Nina Roy','9878000004');

INSERT INTO Hotels (HotelID,HotelName) 
VALUES 
(1,'SeaView Resort'),(2,'HillTop Hotel'),(3,'Lakeside Hotel');

INSERT INTO Packages (PackageID,Destination,PackageName,PackagePrice,HotelID,TransportMode) 
VALUES
(1,'Goa','Beach Delight',15000.00,1,'Flight'),
(2,'Manali','Snow Escape',18000.00,2,'Bus'),
(3,'Goa','Adventure Pack',12000.00,1,'Flight'),
(4,'Kerala','Backwaters',20000.00,3,'Train');

INSERT INTO Bookings 
VALUES
(1101,2001,1,'2025-12-10'),
(1102,2002,2,'2026-01-15'),
(1103,2001,3,'2026-02-20'),
(1104,2003,4,'2025-11-05'),
(1105,2004,1,'2026-01-10');

-- 1. Identify anomalies.
-- Insertion Anomaly: You can't add a new customer or a new travel package to the system unless a booking is made. For example, a new travel package can't be added to the catalog until a customer books it.
-- Update Anomaly: If a package's price or a customer's phone number changes, you must update every record containing that package or customer. For instance, if the price of the 'Beach Delight' package changes, it must be updated in all rows that include that package. This is inefficient and prone to error.
-- Deletion Anomaly: Deleting the last booking for a customer or a package will also delete all information about that customer or package.

-- 2. Does schema meet 1NF? Why/why not?
-- Yes, the TravelBooking table is in 1NF. All values in the table are atomic (indivisible), and there are no repeating groups. Each cell holds a single, indivisible value.

-- 3. Normalize to 1NF.
-- Since the table is already in 1NF, no normalization is needed at this stage.

-- 4. State primary key.
-- The primary key for this unnormalized table is BookingID, as it uniquely identifies each travel booking.

-- 5. Write FDs.
-- The functional dependencies (FDs) are:
-- {BookingID} -> {CustomerID, CustomerName, Phone, Destination, PackageName, PackagePrice, HotelName, TransportMode, TravelDate}
-- {CustomerID} -> {CustomerName, Phone}
-- {PackageName} (assuming unique) -> {Destination, PackagePrice, HotelName, TransportMode}

-- 6. Identify partial dependencies.
-- The table fails 2NF due to partial dependencies. Non-prime attributes are dependent on only part of the primary key. In this case, attributes like CustomerName and Phone are dependent on CustomerID, which is itself a non-prime attribute in the table. The same applies to package details. To fix this, we need to create separate tables for customers, packages, and hotels.

-- 7. Convert schema to 2NF.
-- To achieve 2NF, we split the table to eliminate partial dependencies.
-- Customers: {CustomerID, CustomerName, Phone}
-- Packages: {PackageName, Destination, PackagePrice, HotelName, TransportMode}
-- Bookings: {BookingID, CustomerID, PackageName, TravelDate}

-- 8. Write SQL for 2NF schema.
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Phone VARCHAR(20));

CREATE TABLE Packages (
    PackageName VARCHAR(100) PRIMARY KEY,
    Destination VARCHAR(100),
    PackagePrice DECIMAL(10,2),
    HotelName VARCHAR(100),
    TransportMode VARCHAR(50));

CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY,
    CustomerID INT,
    PackageName VARCHAR(100),
    TravelDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (PackageName) REFERENCES Packages(PackageName));

-- 9. Identify transitive dependencies.
-- The 2NF schema still has a transitive dependency in the Packages table. HotelName is dependent on PackageName, and if we had a dependency like HotelName -> HotelAddress, then HotelAddress would be transitively dependent on PackageName.

-- 10. Convert to 3NF.
-- To achieve 3NF, we must remove the transitive dependency by creating a separate Hotels table. The Packages table will then reference a HotelID from the Hotels table as a foreign key. The provided normalized schema represents a full 3NF design.

-- 11. Write SQL for 3NF schema.
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Phone VARCHAR(20));

CREATE TABLE Hotels (
    HotelID INT PRIMARY KEY AUTO_INCREMENT,
    HotelName VARCHAR(100) UNIQUE);

CREATE TABLE Packages (
    PackageID INT PRIMARY KEY AUTO_INCREMENT,
    Destination VARCHAR(100),
    PackageName VARCHAR(100),
    PackagePrice DECIMAL(10,2),
    HotelID INT,
    TransportMode VARCHAR(50),
    FOREIGN KEY (HotelID) REFERENCES Hotels(HotelID));

CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY,
    CustomerID INT,
    PackageID INT,
    TravelDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (PackageID) REFERENCES Packages(PackageID));

-- 12. Check BCNF compliance.
-- The 3NF schema provided meets BCNF. For every functional dependency, the determinant is a superkey. There are no non-trivial dependencies where a non-superkey determines a key or a non-key attribute.

-- 13. Query: List all bookings with hotel and transport.
SELECT b.BookingID,c.CustomerName,p.Destination,p.PackageName,p.PackagePrice,h.HotelName,p.TransportMode,b.TravelDate
FROM Bookings b
JOIN Customers c ON b.CustomerID=c.CustomerID
JOIN Packages p ON b.PackageID=p.PackageID
JOIN Hotels h ON p.HotelID=h.HotelID;

-- 14. Query: Count bookings per destination.
SELECT p.Destination, COUNT(b.BookingID) AS BookingsCount
FROM Packages p JOIN Bookings b ON p.PackageID=b.PackageID
GROUP BY p.Destination;

-- 15. Query: Find customers who booked more than once.
SELECT c.CustomerID,c.CustomerName,COUNT(b.BookingID) AS TimesBooked
FROM Customers c JOIN Bookings b ON c.CustomerID=b.CustomerID
GROUP BY c.CustomerID,c.CustomerName
HAVING COUNT(b.BookingID) > 1;

-- 16. Query: Find average package price per destination.
SELECT p.Destination, AVG(p.PackagePrice) AS AvgPrice
FROM Packages p
GROUP BY p.Destination;

-- 17. Query: Most popular transport mode.
SELECT TransportMode, COUNT(BookingID) AS BookingCount
FROM Packages p
JOIN Bookings b ON p.PackageID = b.PackageID
GROUP BY TransportMode
ORDER BY BookingCount DESC
LIMIT 1;

-- 18. Query: Hotels booked more than 5 times.
SELECT h.HotelName, COUNT(b.BookingID) AS TimesBooked
FROM Hotels h JOIN Packages p ON h.HotelID=p.HotelID
JOIN Bookings b ON p.PackageID=b.PackageID
GROUP BY h.HotelName
HAVING COUNT(b.BookingID) > 5;

-- 19. Query: List all customers traveling in December.
SELECT c.CustomerName, b.TravelDate
FROM Customers c
JOIN Bookings b ON c.CustomerID = b.CustomerID
WHERE b.TravelDate LIKE '2025-12%';

-- 20. Compare redundancy before & after normalization.
-- Normalization drastically reduces data redundancy. In the unnormalized TravelBooking table, customer details (name, phone) and package details (destination, price, hotel, transport) are repeated for every booking. For example, Rahul Mehra's information is stored twice. The normalized schema eliminates this by storing each type of entity (customers, packages, hotels, bookings) in its own table. These tables are then linked together using foreign keys. This reduces storage space, improves data integrity, and makes the database more efficient and easier to manage and query.