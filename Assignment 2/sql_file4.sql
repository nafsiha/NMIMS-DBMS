create database if not exists college;

use college;

create table teacher (
id int primary key,
name varchar (30),
subject varchar (30),
salary int
);

insert into teacher 
(id, name, subject, salary)
values 
(23, "ajay", "math", 55000),
(47, "bharat", "stat", 50000),
(18, "chetan", "physics", 60000),
(9, "vijay", "chem", 50000);

select * from teacher;

select *
from teacher 
where salary > 50000;

alter table teacher 
change column salary ctc INT;

update teacher 
set ctc = ctc + ctc * 0.25;

alter table teacher 
add column city varchar(20) default "mumbai";

alter table teacher 
drop column ctc;

create table student1 (
	rollno int primary key,
    name varchar(30),
    city varchar(30),
    marks int
);

insert into student1 
(rollno, name, city, marks)
values
(101, "raj", "mumbai", 80),
(102, "rahul", "pune", 90),
(103, "ria", "guwahati", 75),
(104, "ram", "delhi" , 85);

select * from student1;

select * 
from student1
where marks > 75;

select distinct city
from student1;

select city, max(marks)
from student1 
group by city 
 
select avg(marks)
from student1;

alter table student1
add column grade varchar(2);

select * from student1;

update student1
set grade = "O"
where marks >= 80;

update student1
set grade = "A"
where marks >= 70 and marks < 80;

update student1
set grade = "A"
where marks >= 60 and marks < 70;