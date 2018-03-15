/* Queries */
/* Query 1 */
select E.Fname,
    E.Lname
from EMPLOYEE E
where not exists(
        select *
        from PROJECT P
        where P.Dnum = 5
            and not exists(
                select *
                from WORKS_ON W
                where W.Pno = P.Pnumber
                    and E.Ssn = W.Essn
            )
    );

/* Query 2 */
select W.Essn
from WORKS_ON W
where W.Pno = all (
        select P.Pnumber
        from PROJECT P
        where P.Pnumber in (1, 2, 3)
    );

/* Query 3 */
select sum(E.Salary) as SalarySum,
    max(E.Salary) as MaxSalary,
    min(E.Salary) as MinSalary,
    avg(E.Salary) as AvgSalary
from EMPLOYEE E;

/* Query 4 */
select sum(E.Salary) as SalarySum,
    max(E.Salary) as MaxSalary,
    min(E.Salary) as MinSalary,
    avg(E.Salary) as AvgSalary
from EMPLOYEE E,
    DEPARTMENT D
where E.Dno = D.Dnumber
    and D.Dname = 'Research';

/* Query 5 */
select E.Fname,
    E.Lname
from EMPLOYEE E
where (
        select count(*)
        from DEPENDENT D
        where D.Essn = E.Ssn
    ) > 2;

/* Query 6 */
select D.Dnumber,
    (
        select count(*)
        from EMPLOYEE E
        where E.Dno = D.Dnumber
    ) as No_Employees,
    (
        select avg(E.Salary)
        from EMPLOYEE E
        where E.Dno = D.Dnumber
    ) as AvgSalary
from DEPARTMENT D;

/* Query 7 */
select P.Pnumber,
    P.Pname,
    (
        select count(*)
        from WORKS_ON W
        where W.Pno = P.Pnumber
    ) as No_Employees
from PROJECT P;

/* Query 8 */
select P.Pnumber,
    P.Pname,
    count(W.Essn) as counter
from PROJECT P,
    WORKS_ON W
where P.Pnumber = W.Pno
group by P.Pnumber
having counter > 2;

/* Query 9 */
select P.Pnumber,
    P.Pname,
    count(W.Essn) as counter
from PROJECT P,
    WORKS_ON W
where P.Pnumber = W.Pno
    and P.Dnum = 5
group by P.Pnumber;

/* Query 10 */
select count(*)
from EMPLOYEE E
where E.Salary > 20000
group by E.Dno
having count(*) > 5;