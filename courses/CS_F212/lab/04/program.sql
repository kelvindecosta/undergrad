create table Student (
	Id int unsigned auto_increment,
	Name varchar (10),
	Age int unsigned,
	Department varchar (20),
	Dateofadmin Date,
	Fee int unsigned,
	Sex char,
	primary key (Id)
);

insert into Student (Name, Age, Department, Dateofadmin, Fee, Sex)
values("Pankaj", 24, "Computer", "1997-10-01", 120, "M");

insert into Student (Name, Age, Department, Dateofadmin, Fee, Sex)
values("Shalini", 21, "EEE", "1998-03-24", 200, "F");

insert into Student (Name, Age, Department, Dateofadmin, Fee, Sex)
values("Sanjay", 25, "BioTech", "1996-12-12", 300, "M");

insert into Student (Name, Age, Department, Dateofadmin, Fee, Sex)
values("Sudha", 22, "EEE", "1999-01-07", 400, "F");

insert into Student (Name, Age, Department, Dateofadmin, Fee, Sex)
values("Rakesh", 30, "BioTech", "1997-05-09", 250, "M");

insert into Student (Name, Age, Department, Dateofadmin, Fee, Sex)
values("Shakeel", 34, "EEE", "1998-06-27", 300, "M");

insert into Student (Name, Age, Department, Dateofadmin, Fee, Sex)
values("Surya", 22, "Computer", "1997-02-25", 210, "M");

insert into Student (Name, Age, Department, Dateofadmin, Fee, Sex)
values("Shikha", 23, "BioTech", "1997-07-31", 210, "F");

/* Queries */
/* Query 1 */
select *
from Student
where Department = "EEE";

/* Query 2 */
select Name
from Student
where Sex = "F"
	and Department = "BioTech";

/* Query 3 */
select Name
from Student
order by Dateofadmin asc;

/* Query 4 */
select Name,
	Fee,
	Age
from Student
where Sex = "M";

/* Query 5 */
select count(*)
from Student
where Age < 23;

/* Query 6 */
insert into Student (Name, Age, Department, Dateofadmin, Fee, Sex)
values("Zaheer", 36, "Computer", "1997-12-03", 230, "M");

/* Query 7 */
select count(distinct Department)
from Student;

/* Query 8 */
select max(Age)
from Student
where Sex = "F";

/* Query 9 */
select avg(Fee) as Average
from Student
where Department = "EEE";