/* Query 1 */
select E.Fname,
	E.Minit
from EMPLOYEE E
where E.Dno in (
		select D.Dnumber
		from DEPARTMENT D
		where D.Dname = "Research"
	);

/* Query 2 */
select E1.Ssn,
	E1.Fname,
	E2.Ssn,
	E2.Fname
from EMPLOYEE E1,
	EMPLOYEE E2
where E1.Super_ssn = E2.Ssn;

/* Query 3 */
select distinct E.Salary
from EMPLOYEE E;

/* Query 4 */
select distinct W.Pno
from WORKS_ON W
where W.Essn in (
		select E.Ssn
		from EMPLOYEE E
		where E.Lname = "Smith"
	)
	or W.Pno in (
		select P.Pnumber
		from PROJECT P
		where P.Dnum in (
				select E.Dno
				from EMPLOYEE E
				where E.Lname = "Smith"
			)
	);

/* Query 5 */
update EMPLOYEE E
set E.Salary = E.Salary * 1.15
where E.Ssn in (
		select W.Essn
		from WORKS_ON W,
			PROJECT P
		where P.Pname = "ProductX"
			and W.Pno = P.Pnumber
	);

/* Query 6 */
select E.Dno,
	E.Lname,
	E.Fname,
	P.Pname
from EMPLOYEE E,
	PROJECT P
where E.Ssn in (
		select Ssn
		from EMPLOYEE
		where Ssn in (
				select W.Essn
				from WORKS_ON W
				where W.Pno = P.Pnumber
			)
		order by Lname,
			Fname
	)
order by E.Dno;

/* Query 7 */
select E.Fname
from EMPLOYEE E,
	DEPENDENT D
where E.Fname = D.Dependent_name
	and E.Sex = D.Sex
	and D.Essn = E.Ssn;

/* Query 8 */
select E.Fname
from EMPLOYEE E
where E.Ssn not in (
		select distinct D.Essn
		from DEPENDENT D
	);

/* Query 9 */
select E.Fname
from EMPLOYEE E
where exists (
		select *
		from DEPENDENT D
		where E.Ssn = D.Essn
	);

/* Query 10 */
select E.Fname
from EMPLOYEE E,
	DEPARTMENT Dpmnt
where E.Ssn = Dpmnt.Mgr_ssn
	and exists (
		select *
		from DEPENDENT D
		where E.Ssn = D.Essn
	);