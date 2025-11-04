USE instagram;

CREATE TABLE user_information3 (
id INT,
age INT,
uname VARCHAR(30) NOT NULL,
email VARCHAR(30) UNIQUE,
followers INT DEFAULT 0,
ufollowing INT,
CONSTRAINT age_check CHECK (age >= 13),
PRIMARY KEY (id)
);

SELECT * 
FROM USER;

INSERT INTO USER
(id, age, uname, email, followers, ufollowing)
VALUES 
(1, 14, "adam", "adam@gmail.com", 100, 200),
(2, 13, "eve", "evem@gmail.com", 100, 200),
(3, 15, "jess", "jem@gmail.com", 100, 200),
(4, 16, "bob", "bobbym@gmail.com", 100, 200),
(5, 17, "jacob", "jj@gmail.com", 100, 200)

INSERT INTO USER 
(id, age, uname, email)
VALUES 
(8, 14, "adam", "adam@gmail.com")

SELECT id, uname, email
FROM USER;
SELECT DISTINCT age
FROM USER;
SELECT DISTINCT age, uname 
FROM USER;

SELECT *
FROM USER 
WHERE ufollowing > 100;
SELECT uname, ufollowing, email
FROM USER 
WHERE ufollowing > 100;
SELECT uname, ufollowing, email
FROM USER 
WHERE age < 15;
SELECT *
FROM USER 
WHERE age+1 = 15;
SELECT uname, age 
FROM USER 
WHERE age > 14 AND followers >= 100;
SELECT uname, age 
FROM USER 
WHERE age BETWEEN 13 AND 15;
SELECT *
FROM USER 
WHERE email IN ("adam@gmail.com");
SELECT * 
FROM USER 
WHERE email NOT IN ("adam@gmail.com");
SELECT * 
FROM USER 
WHERE age NOT IN (13,15);
SELECT * 
FROM USER 
WHERE age > 13
LIMIT 3;

SELECT * 
FROM USER 
ORDER BY age ASC;
SELECT * 
FROM USER 
ORDER BY age DESC;

SELECT max(age), uname
FROM USER;
SELECT max(age)
FROM USER;
SELECT min(age)
FROM USER;

SELECT count(age)
FROM USER
WHERE age = 14;
SELECT count(age)
FROM USER
WHERE age >= 16;

SELECT AVG(followers)
FROM USER;

SELECT sum(followers)
FROM USER;

SELECT * FROM USER;
SELECT age, count(id)
FROM USER
GROUP BY age;
SELECT age
FROM USER
GROUP BY age;
SELECT uname, age, max(followers)
FROM USER
GROUP BY age;

SELECT age, max(followers)
FROM USER
GROUP BY age
HAVING max(followers) > 50;

SELECT age, max(followers)
FROM USER
GROUP BY age
HAVING max(followers) > 50
ORDER BY age DESC;

SET SQL_SAFE_UPDATES = 0;

UPDATE USER
SET followers = 500
WHERE age = 16;

UPDATE USER
SET followers = 400
WHERE age BETWEEN 13 AND 15;

DELETE FROM USER 
WHERE age = 13;

ALTER TABLE USER 
ADD COLUMN city VARCHAR(20) DEFAULT "mumbai";

ALTER TABLE USER 
RENAME TO instauser;

ALTER TABLE instauser
RENAME TO USER;

ALTER TABLE USER 
CHANGE COLUMN ufollowing follow INT DEFAULT 0;

ALTER TABLE USER
MODIFY follow INT DEFAULT 5;

INSERT INTO USER 
(id, uname, followers)
VALUES
(10, "ravi", 650);

TRUNCATE TABLE USER;