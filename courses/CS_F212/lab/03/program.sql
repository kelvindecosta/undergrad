create table EMPLOYEE (
	Fname varchar(20),
	Minit char,
	Lname varchar(20),
	Ssn varchar(10),
	Bdate date,
	Address varchar(30),
	Sex char,
	Salary int,
	Super_ssn varchar(10),
	Dno int,
	primary key (Ssn)
);

alter table EMPLOYEE
add foreign key (Dno) references DEPARTMENT(Dnumber);

alter table EMPLOYEE
add foreign key (Super_ssn) references EMPLOYEE(Ssn);

drop table EMPLOYEE;

select *
from EMPLOYEE;

drop table EMPLOYEE,
DEPARTMENT;

insert into EMPLOYEE
values(
		"John",
		"B",
		"Smith",
		"123456789",
		"1965-01-09",
		"731 Foundren, Houston, TX",
		"M",
		30000,
		"333445555",
		5
	);

insert into EMPLOYEE
values(
		"Franklin",
		"T",
		"Wong",
		"333445555",
		"1955-12-08",
		"638 Voss, Houston, TX",
		"M",
		40000,
		"888665555",
		5
	);

insert into EMPLOYEE
values(
		"Alicia",
		"J",
		"Zelaya",
		"999887777",
		"1968-01-19",
		"3321 Castle, Spring, TX",
		"F",
		25000,
		"987654321",
		4
	);

insert into EMPLOYEE
values(
		"Jennifer",
		"S",
		"Wallace",
		"987654321",
		"1941-06-20",
		"291 Berry,Bellaire, TX",
		"F",
		43000,
		"888665555",
		4
	);

insert into EMPLOYEE
values(
		"Ramesh",
		"K",
		"Narayan",
		"666884444",
		"1962-09-15",
		"975 Fire Oak, Humble, TX ",
		"M",
		38000,
		"333445555",
		5
	);

insert into EMPLOYEE
values(
		"Joyce",
		"A",
		"English",
		"453453453",
		"1972-07-31",
		"5631 Rice, Houston, TX",
		"F",
		25000,
		"333445555",
		5
	);

insert into EMPLOYEE
values(
		"Ahmad",
		"V",
		"Jabbar",
		"987987987",
		"1969-03-29",
		"980 Dallas, Houston, TX",
		"M",
		25000,
		"987654321",
		4
	);

insert into EMPLOYEE
values(
		"James",
		"E",
		"Borg",
		"888665555",
		"1937-11-10",
		"450 Stone, Houston, TX",
		"M",
		55000,
		null,
		1
	);

delete from EMPLOYEE
where Ssn = "99988777";

/* DEPARTMENT */
create table DEPARTMENT (
	Dname varchar(20),
	Dnumber int,
	Mgr_ssn varchar(10),
	Mgr_start_date date,
	primary key(Dnumber)
);

alter table DEPARTMENT
add foreign key (Mgr_ssn) references EMPLOYEE(Ssn);

drop table DEPARTMENT;

select *
from DEPARTMENT;

insert into DEPARTMENT
values("Research", 5, "333445555", "1988-05-22");

insert into DEPARTMENT
values("Administration", 4, "987654321", "1995-01-01");

insert into DEPARTMENT
values("Headquarters", 1, "888665555", "1981-06-19");

/* DEPT_LOCATIONS */
create table DEPT_LOCATIONS (
	Dnumber int,
	Dlocation varchar(20),
	foreign key(Dnumber) references DEPARTMENT(Dnumber),
	constraint Dept_Locations_PK primary key (Dnumber, Dlocation)
);

select *
from DEPT_LOCATIONS;

insert into DEPT_LOCATIONS
values(1, "Houston");

insert into DEPT_LOCATIONS
values(4, "Stafford");

insert into DEPT_LOCATIONS
values(5, "Bellaire");

insert into DEPT_LOCATIONS
values(5, "Sugarland");

insert into DEPT_LOCATIONS
values(5, "Houston");

/* WORKS_NO */
create table WORKS_ON (
	Essn varchar(10),
	Pno int,
	Hours float,
	foreign key(Pno) references PROJECT(Pnumber),
	constraint Works_on_PK primary key(Essn, Pno),
	foreign key (Essn) references EMPLOYEE(Ssn)
);

select *
from WORKS_ON;

drop table WORKS_ON;

insert into WORKS_ON
values("123456789", 1, 32.5);

insert into WORKS_ON
values("123456789", 2, 7.5);

insert into WORKS_ON
values("666884444", 3, 40.0);

insert into WORKS_ON
values("453453453", 1, 20.0);

insert into WORKS_ON
values("453453453", 2, 20.0);

insert into WORKS_ON
values("333445555", 2, 10.0);

insert into WORKS_ON
values("333445555", 3, 10.0);

insert into WORKS_ON
values("333445555", 10, 10.0);

insert into WORKS_ON
values("333445555", 20, 10.0);

insert into WORKS_ON
values("999887777", 30, 30.0);

insert into WORKS_ON
values("999887777", 10, 10.0);

insert into WORKS_ON
values("987987987", 10, 35.0);

insert into WORKS_ON
values("987987987", 30, 5.0);

insert into WORKS_ON
values("987654321", 30, 20.0);

insert into WORKS_ON
values("987654321", 20, 10.0);

insert into WORKS_ON
values("888665555", 20, 0);

delete from WORKS_ON;

/* PROJECT */
create table PROJECT (
	Pname varchar(20),
	Pnumber int,
	Plocation varchar(20),
	Dnum int,
	primary key(Pnumber),
	foreign key(Dnum) references DEPARTMENT(Dnumber)
);

select *
from PROJECT;

insert into PROJECT
values("ProductX", 1, "Bellaire", 5);

insert into PROJECT
values("ProductY", 2, "Sugarland", 5);

insert into PROJECT
values("ProductZ", 3, "Houston", 5);

insert into PROJECT
values("Computerization", 10, "Stafford", 4);

insert into PROJECT
values("Reorganization", 20, "Houston", 1);

insert into PROJECT
values("Newbenefits", 30, "Stafford", 4);

/*  DEPENDENT */
create table DEPENDENT (
	Essn varchar(10),
	Dependent_name varchar(20),
	Sex char,
	Bdate date,
	Relationship varchar(20),
	constraint Dependent_PK primary key(Essn, Dependent_name),
	foreign key (Essn) references EMPLOYEE(Ssn)
);

select *
from DEPENDENT;

insert into DEPENDENT
values(
		"333445555",
		"Alice",
		"F",
		"1986-04-05",
		"Daughter"
	);

insert into DEPENDENT
values(
		"333445555",
		"Theodore",
		"M",
		"1983-10-25",
		"Son"
	);

insert into DEPENDENT
values("333445555", "Joy", "F", "1958-05-03", "Spouse");

insert into DEPENDENT
values(
		"987654321",
		"Abner",
		"M",
		"1942-02-28",
		"Spouse"
	);

insert into DEPENDENT
values(
		"123456789",
		"Michael",
		"M",
		"1988-01-04",
		"Son"
	);

insert into DEPENDENT
values(
		"123456789",
		"Alice",
		"F",
		"1988-12-30",
		"Daughter"
	);

insert into DEPENDENT
values(
		"123456789",
		"Elizabeth",
		"F",
		"1967-05-05",
		"Spouse"
	);

delete from DEPENDENT;

/* Search Queries */
/* Query 1 */
select *
from DEPT_LOCATIONS
where Dlocation = "Bellaire";

/* Query 2 */
select distinct Fname,
	Ssn
from EMPLOYEE as E,
	DEPENDENT as D
where E.Ssn = D.Essn;

/* Query 3 */
select Fname
from EMPLOYEE as E,
	WORKS_ON as W
where E.Ssn = W.Essn
	and W.Pno = 2;

/* Query 4 */
select distinct Fname,
	Ssn
from EMPLOYEE as E,
	DEPENDENT as D
where E.Ssn = D.Essn
	and D.Sex = "F";

/* Query 5 */
select Fname,
	Salary
from EMPLOYEE
where Salary > 30000;

/* Query 6 */
select Dname
from DEPARTMENT
order by Dnumber;

/* Query 7 */
select Fname
from EMPLOYEE
where Dno = 5
	and Address like "%Houston, TX";

/* Query 8 */
select Fname
from EMPLOYEE as E,
	WORKS_ON as W
where E.Ssn = W.Essn
	and W.Hours > 30;

/* Query 9 */
select Fname
from EMPLOYEE as E,
	DEPARTMENT as D
where E.Ssn = D.Mgr_ssn
	and D.Mgr_start_date > '1990-12-31';

/* Query 10 */
select Fname
from EMPLOYEE as E,
	WORKS_ON as W
where E.Ssn = W.Essn
	and W.Pno = 2
	and W.Hours > 10;