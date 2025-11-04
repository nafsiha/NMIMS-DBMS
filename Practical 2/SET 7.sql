-- Set 7: Movie Ticket Booking

CREATE DATABASE Movie_Ticket_Booking;
USE Movie_Ticket_Booking;

CREATE TABLE TicketBooking (
    BookingID INT,
    CustomerName VARCHAR(100),
    CustomerPhone VARCHAR(20),
    MovieID INT,
    MovieTitle VARCHAR(200),
    Genre VARCHAR(50),
    ShowTime DATETIME,
    ScreenNo INT,
    SeatNo VARCHAR(10),
    TicketPrice DECIMAL(10,2));

INSERT INTO TicketBooking 
VALUES
(901,'Ritu Anand','9877000001',601,'Avengers','Action','2025-09-15 18:30:00',1,'A10',350.00),
(902,'Vikram Shah','9877000002',602,'Comedy Nights','Comedy','2025-09-15 20:00:00',2,'B5',250.00),
(903,'Ritu Anand','9877000001',601,'Avengers','Action','2025-09-15 18:30:00',1,'A11',350.00),
(904,'Sana Mirza','9877000003',603,'Romance Tale','Romance','2025-09-16 17:00:00',3,'C3',200.00),
(905,'Aman Verma','9877000004',604,'Sci-Fi World','Sci-Fi','2025-09-16 21:00:00',1,'A12',400.00);

INSERT INTO Customers (CustomerID,CustomerName,CustomerPhone) 
VALUES
(1,'Ritu Anand','9877000001'),(2,'Vikram Shah','9877000002'),(3,'Sana Mirza','9877000003'),(4,'Aman Verma','9877000004');

INSERT INTO Movies 
VALUES 
(601,'Avengers','Action'),(602,'Comedy Nights','Comedy'),(603,'Romance Tale','Romance'),(604,'Sci-Fi World','Sci-Fi');

INSERT INTO Screens 
VALUES 
(1,200),(2,150),(3,120);

INSERT INTO Shows (ShowID,MovieID,ScreenNo,ShowTime) 
VALUES
(1,601,1,'2025-09-15 18:30:00'),
(2,602,2,'2025-09-15 20:00:00'),
(3,603,3,'2025-09-16 17:00:00'),
(4,604,1,'2025-09-16 21:00:00');

INSERT INTO Bookings 
VALUES
(901,1,1,'A10',350.00),
(902,2,2,'B5',250.00),
(903,1,1,'A11',350.00),
(904,3,3,'C3',200.00),
(905,4,4,'A12',400.00);

-- 1. Identify anomalies.
-- Insertion Anomaly: You cannot add a new movie or a new customer to the database without a booking being made. For example, a new movie can't be added to the catalog until a ticket is sold for it.
-- Update Anomaly: If a movie's genre or a customer's phone number changes, you must update every row where that movie or customer appears. This is inefficient and can easily lead to data inconsistencies.
-- Deletion Anomaly: Deleting the last booking for a specific movie will also delete all information about that movie (title, genre).

-- 2. Does schema meet 1NF? Why/why not?
-- Yes, the TicketBooking table is in 1NF. All values in each column are atomic, and there are no repeating groups. Each cell holds a single, indivisible value.

-- 3. Normalize to 1NF.
-- Since the table is already in 1NF, no normalization is required at this stage.

-- 4. State primary key.
-- The primary key for this unnormalized table is the composite key of (BookingID, ShowTime, SeatNo). This combination uniquely identifies a single booked seat for a specific show.

-- 5. Write FDs.
-- The functional dependencies (FDs) are:
-- {BookingID} -> {CustomerName, CustomerPhone, MovieID, ShowTime, ScreenNo, SeatNo, TicketPrice}
-- {CustomerID, ShowID, SeatNo} (or similar key) -> {BookingID}
-- {MovieID} -> {MovieTitle, Genre}
-- {ShowTime, ScreenNo} -> {MovieID, TicketPrice}
-- {CustomerName} -> {CustomerPhone} (or CustomerID -> CustomerName, CustomerPhone)
-- {BookingID} is the primary key and determines all other attributes.

-- 6. Remove partial dependencies (2NF).
-- The table fails 2NF due to partial dependencies. Non-prime attributes are dependent on only part of the composite key. To fix this, we split the schema into separate tables for customers, movies, shows, and bookings.

-- 7. Write SQL for 2NF schema.
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    CustomerPhone VARCHAR(20));

CREATE TABLE Movies (
    MovieID INT PRIMARY KEY,
    MovieTitle VARCHAR(200),
    Genre VARCHAR(50));

CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY,
    CustomerID INT,
    MovieID INT,
    ShowTime DATETIME,
    ScreenNo INT,
    SeatNo VARCHAR(10),
    TicketPrice DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID));

-- 8. Identify transitive dependencies.
-- The 2NF schema still has transitive dependencies. In the Bookings table: {MovieID} -> {MovieTitle, Genre}. This is a transitive dependency because MovieID is a non-key attribute in this table, and it determines other attributes. To properly normalize, we need to split movies and show times into their own tables. The final 3NF schema, provided in the prompt, correctly handles this.

-- 9. Convert to 3NF.
-- To achieve 3NF, we must remove transitive dependencies. This involves creating a separate Shows table that links MovieID, ScreenNo, and ShowTime. The Bookings table then references the ShowID. This leads to the schema provided in the prompt's CREATE TABLE statements for the normalized schema.

-- 10. Write SQL for 3NF schema.
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(100),
    CustomerPhone VARCHAR(20) UNIQUE);

CREATE TABLE Movies (
    MovieID INT PRIMARY KEY,
    MovieTitle VARCHAR(200),
    Genre VARCHAR(50));

CREATE TABLE Screens (
    ScreenNo INT PRIMARY KEY,
    Capacity INT);

CREATE TABLE Shows (
    ShowID INT PRIMARY KEY AUTO_INCREMENT,
    MovieID INT,
    ScreenNo INT,
    ShowTime DATETIME,
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID),
    FOREIGN KEY (ScreenNo) REFERENCES Screens(ScreenNo));

CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY,
    CustomerID INT,
    ShowID INT,
    SeatNo VARCHAR(10),
    TicketPrice DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ShowID) REFERENCES Shows(ShowID));
    
-- 11. Check BCNF compliance.
-- The 3NF schema provided meets BCNF. For every functional dependency, the determinant (the left side) is a superkey. There are no non-trivial dependencies where a non-superkey determines a key or a non-key attribute.

-- 12. Query: List all customers with their movies.
SELECT c.CustomerName, m.MovieTitle, s.ShowTime, b.SeatNo
FROM Bookings b
JOIN Customers c ON b.CustomerID = c.CustomerID
JOIN Shows s ON b.ShowID = s.ShowID
JOIN Movies m ON s.MovieID = m.MovieID;

-- 13. Query: Find number of tickets booked per movie.
SELECT m.MovieTitle, COUNT(b.BookingID) AS TicketsSold
FROM Movies m JOIN Shows s ON m.MovieID=s.MovieID
JOIN Bookings b ON s.ShowID=b.ShowID
GROUP BY m.MovieTitle;

-- 14. Query: Find customers booking more than 2 tickets.
SELECT c.CustomerName, COUNT(*) AS TicketsBooked
FROM Customers c JOIN Bookings b ON c.CustomerID=b.CustomerID
GROUP BY c.CustomerName
HAVING COUNT(*) > 2;

-- 15. Query: Find movies of "Action" genre booked most.
SELECT m.MovieTitle, COUNT(b.BookingID) AS TotalBookings
FROM Movies m
JOIN Shows s ON m.MovieID = s.MovieID
JOIN Bookings b ON s.ShowID = b.ShowID
WHERE m.Genre = 'Action'
GROUP BY m.MovieTitle
ORDER BY TotalBookings DESC
LIMIT 1;

-- 16. Query: Find screens showing multiple movies.
SELECT ScreenNo, COUNT(DISTINCT MovieID) AS TotalMovies
FROM Shows
GROUP BY ScreenNo
HAVING COUNT(DISTINCT MovieID) > 1;

-- 17. Query: Find average ticket price per genre.
SELECT m.Genre, AVG(b.TicketPrice) AS AvgPrice
FROM Movies m JOIN Shows s ON m.MovieID=s.MovieID
JOIN Bookings b ON s.ShowID=b.ShowID
GROUP BY m.Genre;

-- 18. Query: Highest revenue generating movie.
SELECT m.MovieTitle, SUM(b.TicketPrice) AS TotalRevenue
FROM Movies m
JOIN Shows s ON m.MovieID = s.MovieID
JOIN Bookings b ON s.ShowID = b.ShowID
GROUP BY m.MovieTitle
ORDER BY TotalRevenue DESC
LIMIT 1;

-- 19. Query: Find seats booked by a customer.
SELECT s.ShowTime, s.ScreenNo, b.SeatNo, m.MovieTitle
FROM Bookings b
JOIN Customers c ON b.CustomerID = c.CustomerID
JOIN Shows s ON b.ShowID = s.ShowID
JOIN Movies m ON s.MovieID = m.MovieID
WHERE c.CustomerName = 'Ritu Anand';

-- 20. Discuss improvements after normalization.
-- Normalization drastically reduces data redundancy. In the unnormalized TicketBooking table, customer details (name, phone) and movie details (title, genre) are repeated for every ticket booked. For example, Ritu Anand's details are stored twice because she booked two seats for the same show. The normalized schema eliminates this by storing each entity (customers, movies, shows, bookings) in a dedicated table. This reduces storage space, improves data integrity by preventing update anomalies, and makes the database easier to manage and query. The relationships between entities are maintained through foreign keys, which is a far more efficient and robust approach.