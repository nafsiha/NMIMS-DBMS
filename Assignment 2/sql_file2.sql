USE college;

USE instagram;

CREATE TABLE user_information (
id INT,
age INT,
uname VARCHAR(30) NOT NULL,
email VARCHAR(30) UNIQUE,
followers INT DEFAULT 0,
ufollowing INT,
CONSTRAINT age_check CHECK (age >= 13)
);

CREATE TABLE user_information1 (
id INT PRIMARY KEY,
age INT,
uname VARCHAR(30) NOT NULL,
email VARCHAR(30) UNIQUE,
followers INT DEFAULT 0,
ufollowing INT,
CONSTRAINT CHECK (age >= 13)
);

CREATE TABLE user_information2 (
id INT,
age INT,
uname VARCHAR(30) NOT NULL,
email VARCHAR(30) UNIQUE,
followers INT DEFAULT 0,
ufollowing INT,
CONSTRAINT age_check CHECK (age >= 13),
PRIMARY KEY (id)
);

CREATE TABLE post (
p_id INT PRIMARY KEY,
content VARCHAR(100),
user_id INT,
FOREIGN KEY (user_id) REFERENCES user_information2 (id)
);

