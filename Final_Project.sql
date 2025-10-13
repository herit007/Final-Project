drop database if exists finalproject;
create database if not exists finalproject;
use finalproject;

create table departments(
  departmentid int primary key,
  departmentname varchar(100)
);

create table instructors(
  instructorid int primary key,
  firstname varchar(50),
  lastname varchar(50),
  email varchar(50),
  salary decimal(10,2),
  departmentid int
);

create table courses(
  courseid int primary key,
  coursename varchar(100),
  credits int,
  departmentid int
);

create table students(
  studentid int primary key,
  firstname varchar(50),
  lastname varchar(50),
  email varchar(50),
  birthdate date,
  enrollmentdate date
);

create table enrollments(
  enrollmentid int primary key,
  studentid int,
  courseid int
);

alter table instructors
add constraint instructor_department
foreign key (departmentid) references departments(departmentid);

alter table courses
add constraint course_department
foreign key (departmentid) references departments(departmentid);

alter table enrollments
add constraint enrollment_student
foreign key (studentid) references students(studentid),
add constraint enrollment_course
foreign key (courseid) references courses(courseid);

insert into departments(departmentid,departmentname)
values(1,'computer science'),
(2,'mathematics');

insert into instructors(instructorid,firstname,lastname,email,salary,departmentid)
values(1,'alice','johnson','alice.johnson@email.com',75000,1),
(2,'bob','lee','bob.lee@email.com',65000,2);

insert into courses(courseid,coursename,credits,departmentid)
values(101,'SQL',3,1),
(102,'Python',4,1),
(103,'Web Devlopment',3,2),
(104,'Ui/Ux Design',4,2),
(105,'Physics',5,2);

insert into students(studentid,firstname,lastname,email,birthdate,enrollmentdate)
values(1,'john','doe','john.doe@email.com','2002-12-08','2021-06-10'),
(2,'herit','tanna','herit.tanna@email.com','2007-06-18','2023-02-20'),
(3,'ema','queen','ema.queen@email.com','2006-12-25','2024-05-01'),
(4,'bob','walton','bob.walton@email.com','2005-08-05','2022-09-15'),
(5,'max','robber','max.robber@email.com','2007-04-18','2025-03-05');

insert into enrollments(enrollmentid,studentid,courseid,enrollmentdate)
values(1,1,101,'2022-08-05'),
(2,1,102,'2023-08-05'),
(3,2,102,'2023-10-08'),
(4,3,102,'2022-11-12'),
(5,3,102,'2022-07-15'),
(6,4,104,'2022-06-10'),
(7,5,101,'2022-09-22'),
(8,5,102,'2023-12-25'),
(9,5,103,'2022-08-07'),
(10,4,102,'2023-08-05');

-- Query 1 - CRUD for all tables

-- Students CRUD
insert into students(studentid,firstname,lastname,email,birthdate,enrollmentdate)
values (6,'mohan','tivari','mohan.tivari@email.com','2006-05-15','2024-05-15');

select * from students;

update students 
set lastname = 'misra' where studentid = 6;

delete from students where studentid = 6;

-- Course CRUD
insert into courses(courseid,coursename,credits,departmentid)
values(106,'Android Devlopment',3,1);

select * from courses;

update courses
set credits = 4 where courseid= 106;

delete from courses where courseid = 106;

-- Departments CRUD
insert into departments(departmentid,departmentname)
values(3,'Programing');

select * from departments;

update departments
set departmentname = 'IT' where departmentid = 3;

delete from departments where departmentid = 3;

-- Instructors CRUD
insert into instructors(instructorid,firstname,lastname,email,salary,departmentid)
values(3,'mark','robert','mark.robert@email.com',70000,2);

select * from instructors;

update instructors
set departmentid = 1 where instructorid = 3;

delete from instructors where instructorid = 3;

-- Enrollments CRUD
insert into enrollments(enrollmentid,studentid,courseid,enrollmentdate)
values(11,1,104,'2023-12-31');

select * from enrollments;

update enrollments
set courseid = 103 where enrollmentid = 11;

delete from enrollments where enrollmentid = 11;

-- Query 2 - students who enrolled after 2022
select * from students where year(enrollmentdate) > 2022;

-- Query 3 - courses offered by mathematics department
select * from courses c
join departments d on c.departmentid = d.departmentid
where d.departmentname = 'mathematics'
limit 5;

-- Query 4 - number of students enrolled in each course
select c.coursename, count(e.studentid) as total_students
from courses c
join enrollments e on c.courseid = e.courseid
group by c.coursename
having count(e.studentid) > 5;

-- Query 5 - students enrolled in both introduction to sql and data structures
select s.studentid, s.firstname, s.lastname
from students s
join enrollments e1 on s.studentid = e1.studentid
join enrollments e2 on s.studentid = e2.studentid
where e1.courseid = 101 and e2.courseid = 102;

-- Query 6 - students enrolled in either introduction to sql or data structures
select distinct s.studentid, s.firstname, s.lastname
from students s
join enrollments e on s.studentid = e.studentid
join courses c on e.courseid = c.courseid
where c.coursename in ('SQL', 'Data Structures');

-- Query 7 - average credits for all courses
select avg(credits) as avg_credits from courses;


-- Query 8 - maximum salary of instructors in computer science department
select max(i.salary) as max_salary
from instructors i
join departments d on i.departmentid = d.departmentid
where d.departmentname = 'computer science';

-- Query 9 - number of students enrolled in each department
select d.departmentname, count(distinct e.studentid) as total_students
from departments d
join courses c on d.departmentid = c.departmentid
join enrollments e on c.courseid = e.courseid
group by d.departmentname;

-- Query 10 - inner join students and their corresponding courses
select s.firstname, s.lastname, c.coursename
from students s
inner join enrollments e on s.studentid = e.studentid
inner join courses c on e.courseid = c.courseid;

-- Query 11 - left join students and corresponding courses
select s.firstname, s.lastname, c.coursename
from students s
left join enrollments e on s.studentid = e.studentid
left join courses c on e.courseid = c.courseid;

-- Query 12 - subquery: students in courses with more than 5 students
select s.studentid, s.firstname, s.lastname
from students s
where s.studentid in (select e.studentid from enrollments e
where e.courseid
in(select courseid from enrollments group by courseid having count(studentid) > 10));

-- Query 13 - extract year from enrollmentdate
select studentid, firstname, year(enrollmentdate) as enroll_year from students;

-- Query 14 - concatenate instructor's first and last name
select concat(firstname, ' ', lastname) as instructor_name from instructors;

-- Query 15 - running total of students enrolled in courses
select e.courseid, c.coursename,count(e.studentid) as total_students,sum(count(e.studentid))
over(order by c.coursename) as running_total
from enrollments e
join courses c on e.courseid = c.courseid
group by e.courseid, c.coursename;

-- Query 16 - label students as senior or junior
select firstname, lastname,
case
  when year(curdate()) - year(enrollmentdate) > 4 then 'senior'
  else 'junior'
end as status
from students;
