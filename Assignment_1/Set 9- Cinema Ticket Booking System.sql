-- set 9
CREATE DATABASE CinemaTicketBooking;
USE CinemaTicketBooking;

CREATE TABLE Movies (
  MovieID INT PRIMARY KEY,
  Title VARCHAR(150),
  Genre VARCHAR(50),
  Language VARCHAR(50),
  Duration INT, -- in minutes
  ReleaseDate DATE
);

CREATE TABLE Screens (
  ScreenID INT PRIMARY KEY,
  ScreenName VARCHAR(50),
  Capacity INT
);

CREATE TABLE Showtimes (
  ShowID INT PRIMARY KEY,
  MovieID INT,
  ScreenID INT,
  ShowDate DATE,
  ShowTime TIME,
  Price DECIMAL(10,2),
  FOREIGN KEY (MovieID) REFERENCES Movies(MovieID),
  FOREIGN KEY (ScreenID) REFERENCES Screens(ScreenID)
);

CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  Name VARCHAR(100),
  Email VARCHAR(100),
  Phone VARCHAR(15)
);

CREATE TABLE Tickets (
  TicketID INT PRIMARY KEY,
  ShowID INT,
  CustomerID INT,
  SeatNo VARCHAR(10),
  BookingDate DATE,
  Status VARCHAR(20),
  FOREIGN KEY (ShowID) REFERENCES Showtimes(ShowID),
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Insert sample Movies
INSERT INTO Movies VALUES
  (1, 'Fast Action', 'Action', 'English', 120, '2022-05-10'),
  (2, 'Romantic Saga', 'Romance', 'Hindi', 140, '2023-03-15'),
  (3, 'Mystery Night', 'Thriller', 'English', 110, '2021-11-22'),
  (4, 'Comedy Central', 'Comedy', 'Hindi', 90, '2024-01-05'),
  (5, 'Animated Fun', 'Animation', 'English', 80, '2020-09-30');

-- Insert sample Screens
INSERT INTO Screens VALUES
  (1, 'Screen A', 100),
  (2, 'Screen B', 80),
  (3, 'Screen C', 150);

-- Insert sample Showtimes
INSERT INTO Showtimes VALUES
  (1, 1, 1, '2025-09-04', '18:00:00', 300.00),
  (2, 2, 2, '2025-09-04', '20:00:00', 250.00),
  (3, 3, 1, '2025-09-04', '21:00:00', 200.00),
  (4, 4, 3, '2025-09-05', '17:00:00', 150.00),
  (5, 5, 2, '2025-09-06', '19:00:00', 180.00);

-- Insert sample Customers
INSERT INTO Customers VALUES
  (1, 'Amit Sharma', 'amit@mail.com', '9876543210'),
  (2, 'Priya Singh', 'priya@mail.com', '9812345678'),
  (3, 'Rajesh Kumar', 'rajesh@mail.com', '9900112233'),
  (4, 'Sneha Verma', 'sneha@mail.com', '9888776655'),
  (5, 'John Doe', 'john@mail.com', '9654321789');

-- Insert sample Tickets
INSERT INTO Tickets VALUES
  (1, 1, 1, 'A1', '2025-09-01', 'Booked'),
  (2, 1, 2, 'A2', '2025-09-01', 'Booked'),
  (3, 2, 3, 'B1', '2025-09-02', 'Booked'),
  (4, 3, 4, 'A3', '2025-09-03', 'Cancelled'),
  (5, 4, 5, 'C1', '2025-09-03', 'Booked'),
  (6, 1, 1, 'A4', '2025-09-02', 'Booked');

-- 1. List movies in 'Action' genre.
SELECT * FROM Movies WHERE Genre = 'Action';

-- 2. Show movies released after 2020.
SELECT * FROM Movies WHERE ReleaseDate > '2020-12-31';

-- 3. Find shows scheduled for today.
SELECT * FROM Showtimes WHERE ShowDate = CURDATE();

-- 4. Show top 3 highest priced shows.
SELECT * FROM Showtimes ORDER BY Price DESC LIMIT 3;

-- 5. Count tickets sold for each show.
SELECT ShowID, COUNT(TicketID) AS TicketsSold
FROM Tickets
WHERE Status = 'Booked'
GROUP BY ShowID;

-- 6. Find customers who booked more than 5 tickets.
SELECT CustomerID, COUNT(TicketID) AS TicketsBooked
FROM Tickets
GROUP BY CustomerID
HAVING TicketsBooked > 5;

-- 7. Show shows with available seats (Capacity - Tickets sold).
SELECT s.ShowID, m.Title, sc.ScreenName,
  sc.Capacity - COUNT(t.TicketID) AS AvailableSeats
FROM Showtimes s
JOIN Screens sc ON s.ScreenID = sc.ScreenID
JOIN Movies m ON s.MovieID = m.MovieID
LEFT JOIN Tickets t ON s.ShowID = t.ShowID AND t.Status = 'Booked'
GROUP BY s.ShowID, m.Title, sc.ScreenName, sc.Capacity;

-- 8. List customers who booked tickets for a given movie ('Fast Action').
SELECT DISTINCT c.*
FROM Customers c
JOIN Tickets t ON c.CustomerID = t.CustomerID
JOIN Showtimes s ON t.ShowID = s.ShowID
JOIN Movies m ON s.MovieID = m.MovieID
WHERE m.Title = 'Fast Action';

-- 9. Show movies with no shows.
SELECT * FROM Movies m
WHERE NOT EXISTS (
  SELECT 1 FROM Showtimes s WHERE s.MovieID = m.MovieID
);

-- 10. Display tickets with customer and movie names.
SELECT t.TicketID, c.Name AS CustomerName, m.Title AS MovieTitle, t.SeatNo, t.BookingDate, t.Status
FROM Tickets t
JOIN Customers c ON t.CustomerID = c.CustomerID
JOIN Showtimes s ON t.ShowID = s.ShowID
JOIN Movies m ON s.MovieID = m.MovieID;

-- 11. Find customers without any bookings.
SELECT * FROM Customers
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Tickets);

-- 12. Show daily ticket sales totals.
SELECT BookingDate, COUNT(*) AS TicketsSold
FROM Tickets
WHERE Status = 'Booked'
GROUP BY BookingDate;

-- 13. Find movies with duration greater than 2 hours.
SELECT * FROM Movies WHERE Duration > 120;

-- 14. Show most popular movie (most tickets sold).
SELECT m.Title, COUNT(t.TicketID) AS TicketsSold
FROM Movies m
JOIN Showtimes s ON m.MovieID = s.MovieID
JOIN Tickets t ON s.ShowID = t.ShowID AND t.Status = 'Booked'
GROUP BY m.MovieID, m.Title
ORDER BY TicketsSold DESC
LIMIT 1;

-- 15. List top 5 customers by tickets purchased.
SELECT c.Name, COUNT(t.TicketID) AS TicketsBought
FROM Customers c
JOIN Tickets t ON c.CustomerID = t.CustomerID AND t.Status = 'Booked'
GROUP BY c.CustomerID, c.Name
ORDER BY TicketsBought DESC
LIMIT 5;

-- 16. Show cancelled tickets.
SELECT * FROM Tickets WHERE Status = 'Cancelled';

-- 17. Find shows in a specific screen (ScreenID = 1).
SELECT * FROM Showtimes WHERE ScreenID = 1;

-- 18. Show average price per genre.
SELECT Genre, AVG(Price) AS AvgPrice
FROM Movies m
JOIN Showtimes s ON m.MovieID = s.MovieID
GROUP BY Genre;

-- 19. List movies in 'Hindi' language.
SELECT * FROM Movies WHERE Language = 'Hindi';

-- 20. Show shows in the next 7 days.
SELECT * FROM Showtimes WHERE ShowDate BETWEEN CURDATE() AND CURDATE() + INTERVAL 7 DAY;

-- 21. Find customers who booked tickets for multiple movies.
SELECT c.Name, COUNT(DISTINCT s.MovieID) AS MoviesBooked
FROM Customers c
JOIN Tickets t ON c.CustomerID = t.CustomerID
JOIN Showtimes s ON t.ShowID = s.ShowID
GROUP BY c.CustomerID, c.Name
HAVING MoviesBooked > 1;

-- 22. Show earliest showtime for each movie.
SELECT m.Title, MIN(s.ShowTime) AS EarliestShowtime
FROM Movies m
JOIN Showtimes s ON m.MovieID = s.MovieID
GROUP BY m.MovieID, m.Title;

-- 23. Find movies with shows in multiple screens.
SELECT m.Title, COUNT(DISTINCT s.ScreenID) AS ScreenCount
FROM Movies m
JOIN Showtimes s ON m.MovieID = s.MovieID
GROUP BY m.MovieID, m.Title
HAVING ScreenCount > 1;

-- 24. Display ticket booking trends by month.
SELECT YEAR(BookingDate) AS Year, MONTH(BookingDate) AS Month, COUNT(*) AS TicketsBooked
FROM Tickets
GROUP BY Year, Month
ORDER BY Year, Month;

-- 25. Show movies that have been screened more than 10 times.
SELECT m.Title, COUNT(s.ShowID) AS ShowCount
FROM Movies m
JOIN Showtimes s ON m.MovieID = s.MovieID
GROUP BY m.MovieID, m.Title
HAVING ShowCount > 10;
