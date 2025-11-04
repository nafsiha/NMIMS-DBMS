create table CourseDetails(
CourseID TINYINT Primary Key,
CourseName varchar(20) NOT NULL,
Amount SMALLINT
);

INSERT INTO CourseDetails 
VALUES(01, 'SQL', 15000), (02, 'Power-BI', 12000);

SELECT * FROM CourseDetails;

CREATE TABLE StudentDetails(
SID INT Primary Key,
SName VARCHAR(20) NOT NULL,
Age TINYINT check(Age > 18),
Gender VARCHAR(20) check (Gender = 'Male' OR Gender = 'Female'),
CourseID TINYINT,
FOREIGN KEY(CourseID) references CourseDetails(CourseID)
);
