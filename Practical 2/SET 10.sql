-- Set 10: Music Streaming Playlist

CREATE DATABASE Music_Streaming_Playlist;
USE Music_Streaming_Playlist;

CREATE TABLE MusicPlaylist (
    PlaylistID INT,
    UserID INT,
    UserName VARCHAR(100),
    SongID VARCHAR(20),
    SongTitle VARCHAR(200),
    Artist VARCHAR(100),
    Album VARCHAR(100),
    Genre VARCHAR(50),
    Duration TIME,
    AddedDate DATE);

INSERT INTO MusicPlaylist 
VALUES
(1201,3001,'Rakesh','S001','Song A','Artist X','Album 1','Rock','00:03:30','2025-09-01'),
(1201,3001,'Rakesh','S002','Song B','Artist Y','Album 2','Pop','00:04:00','2025-09-01'),
(1202,3002,'Anita','S003','Song C','Artist X','Album 1','Rock','00:05:00','2025-09-02'),
(1201,3001,'Rakesh','S004','Song D','Artist Z','Album 3','Jazz','00:04:20','2025-09-03'),
(1203,3003,'Vivek','S005','Song E','Artist Y','Album 4','Pop','00:03:10','2025-09-04');

CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    UserName VARCHAR(100));

CREATE TABLE Songs (
    SongID VARCHAR(20) PRIMARY KEY,
    SongTitle VARCHAR(200),
    Artist VARCHAR(100),
    Album VARCHAR(100),
    Genre VARCHAR(50),
    Duration TIME);

CREATE TABLE Playlists (
    PlaylistID INT PRIMARY KEY,
    UserID INT,
    PlaylistName VARCHAR(100),
    FOREIGN KEY (UserID) REFERENCES Users(UserID));

CREATE TABLE PlaylistSongs (
    PlaylistID INT,
    SongID VARCHAR(20),
    AddedDate DATE,
    PRIMARY KEY (PlaylistID, SongID),
    FOREIGN KEY (PlaylistID) REFERENCES Playlists(PlaylistID),
    FOREIGN KEY (SongID) REFERENCES Songs(SongID));

INSERT INTO Users 
VALUES 
(3001,'Rakesh'),(3002,'Anita'),(3003,'Vivek');

INSERT INTO Songs 
VALUES
('S001','Song A','Artist X','Album 1','Rock','00:03:30'),
('S002','Song B','Artist Y','Album 2','Pop','00:04:00'),
('S003','Song C','Artist X','Album 1','Rock','00:05:00'),
('S004','Song D','Artist Z','Album 3','Jazz','00:04:20'),
('S005','Song E','Artist Y','Album 4','Pop','00:03:10');

INSERT INTO Playlists (PlaylistID,UserID,PlaylistName) 
VALUES 
(1201,3001,'Rakesh Favs'),(1202,3002,'Anita Mix'),(1203,3003,'Vivek Top');

INSERT INTO PlaylistSongs 
VALUES
(1201,'S001','2025-09-01'),
(1201,'S002','2025-09-01'),
(1202,'S003','2025-09-02'),
(1201,'S004','2025-09-03'),
(1203,'S005','2025-09-04');

-- 1. Identify anomalies.
-- Insertion Anomaly: You cannot add a new user or a new song to the system unless a playlist is created with at least one song for that user. For example, a new song can't be added to the music catalog until a user adds it to their playlist.
-- Update Anomaly: If a song's genre or an artist's name changes, you must update every record containing that song. For instance, if Artist X's name changes, it must be updated in all rows where SongID 'S001' or 'S003' appears. This is inefficient and can easily lead to data inconsistencies.
-- Deletion Anomaly: Deleting a playlist will also delete all information about the songs in that playlist if those songs are not in any other playlist.

-- 2. Does schema meet 1NF? Explain.
-- Yes, the MusicPlaylist table is in 1NF. All values in the table are atomic (indivisible), and there are no repeating groups or lists. Each cell holds a single, indivisible value.

-- 3. Normalize to 1NF.
-- Since the table is already in 1NF, no normalization is needed at this stage.

-- 4. State primary key.
-- The primary key for this unnormalized table is the composite key (PlaylistID, SongID). This combination uniquely identifies a song within a playlist.

-- 5. Write FDs.
-- The functional dependencies (FDs) are:
-- {PlaylistID} -> {UserID, UserName}
-- {SongID} -> {SongTitle, Artist, Album, Genre, Duration}
-- {PlaylistID, SongID} -> {AddedDate}
-- {UserID} -> {UserName}

-- 6. Identify partial dependencies.
-- The table fails 2NF due to partial dependencies. Attributes are dependent on only a part of the composite primary key (PlaylistID, SongID).
-- UserID and UserName depend only on PlaylistID.
-- SongTitle, Artist, Album, Genre, and Duration depend only on SongID.

-- 7. Convert to 2NF.
-- To achieve 2NF, we split the table to eliminate partial dependencies.
-- Users: {UserID, UserName}
-- Playlists: {PlaylistID, UserID}
-- Songs: {SongID, SongTitle, Artist, Album, Genre, Duration}
-- PlaylistSongs: {PlaylistID, SongID, AddedDate}

-- 8. Write SQL for 2NF schema.
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    UserName VARCHAR(100));

CREATE TABLE Playlists (
    PlaylistID INT PRIMARY KEY,
    UserID INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID));

CREATE TABLE Songs (
    SongID VARCHAR(20) PRIMARY KEY,
    SongTitle VARCHAR(200),
    Artist VARCHAR(100),
    Album VARCHAR(100),
    Genre VARCHAR(50),
    Duration TIME);

CREATE TABLE PlaylistSongs (
    PlaylistID INT,
    SongID VARCHAR(20),
    AddedDate DATE,
    PRIMARY KEY (PlaylistID, SongID),
    FOREIGN KEY (PlaylistID) REFERENCES Playlists(PlaylistID),
    FOREIGN KEY (SongID) REFERENCES Songs(SongID));
    
-- 9. Identify transitive dependencies.
-- The 2NF schema does not have any transitive dependencies. Attributes in Users and Playlists depend directly on their primary keys. In the Songs table, Artist and Album are not dependent on Genre or any other non-key attribute. The provided normalized schema is already in 3NF.

-- 10. Convert to 3NF.
-- Since the 2NF schema is already in 3NF, no further conversion is needed.

-- 11. Write SQL for 3NF schema.
-- The SQL for the 3NF schema is the same as the one for the 2NF schema, as they are identical.

-- 12. Check BCNF compliance.
-- The 3NF schema provided meets BCNF. For every functional dependency, the determinant (the left side) is a superkey. There are no non-trivial dependencies where a non-superkey determines a key or a non-key attribute.

-- 13. Query: List songs in each playlist.
SELECT pl.PlaylistID,u.UserName, s.SongID,s.SongTitle,ps.AddedDate
FROM PlaylistSongs ps
JOIN Playlists pl ON ps.PlaylistID=pl.PlaylistID
JOIN Songs s ON ps.SongID=s.SongID
JOIN Users u ON pl.UserID=u.UserID;

-- 14. Query: Count songs per user.
SELECT u.UserID,u.UserName, COUNT(ps.SongID) AS SongCount
FROM Users u JOIN Playlists pl ON u.UserID=pl.UserID
JOIN PlaylistSongs ps ON pl.PlaylistID=ps.PlaylistID
GROUP BY u.UserID,u.UserName;

-- 15. Query: Find most played artist.
SELECT s.Artist, COUNT(*) AS TimesAdded
FROM Songs s JOIN PlaylistSongs ps ON s.SongID=ps.SongID
GROUP BY s.Artist
ORDER BY TimesAdded DESC
LIMIT 1;

-- 16. Query: Find users with playlists > 50 songs.
SELECT u.UserID,u.UserName, COUNT(ps.SongID) AS SongCount
FROM Users u JOIN Playlists pl ON u.UserID=pl.UserID
JOIN PlaylistSongs ps ON pl.PlaylistID=ps.PlaylistID
GROUP BY u.UserID,u.UserName
HAVING COUNT(ps.SongID) > 50;

-- 17. Query: Find average duration of songs per genre.
SELECT Genre, SEC_TO_TIME(AVG(TIME_TO_SEC(Duration))) AS AvgDuration
FROM Songs
GROUP BY Genre;

-- 18. Query: Top 3 albums by number of songs added.
SELECT s.Album, COUNT(ps.SongID) AS TotalSongsAdded
FROM Songs s
JOIN PlaylistSongs ps ON s.SongID = ps.SongID
GROUP BY s.Album
ORDER BY TotalSongsAdded DESC
LIMIT 3;

-- 19. Query: List playlists containing songs of genre "Rock".
SELECT DISTINCT pl.PlaylistID, pl.PlaylistName
FROM Playlists pl
JOIN PlaylistSongs ps ON pl.PlaylistID = ps.PlaylistID
JOIN Songs s ON ps.SongID = s.SongID
WHERE s.Genre = 'Rock';

-- 20. Discuss improvements after normalization.
-- Normalization drastically reduces data redundancy. In the unnormalized MusicPlaylist table, user details (UserName), and song details (SongTitle, Artist, Album, Genre, Duration) are repeated for every entry. For example, Rakesh's details are stored three times because he added three songs to a playlist. The normalized schema eliminates this by storing each entity (users, songs, playlists, playlist songs) in a dedicated table. These tables are linked via foreign keys, which means data is stored only once. This saves storage space, improves data integrity, and makes the database more efficient and easier to manage. For instance, changing an artist's name only requires a single update in the Songs table.