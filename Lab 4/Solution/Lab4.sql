use company_SD

--1
select a.Dependent_name , a.[Sex]
from [Dependent]a inner join Employee b 
on SSN=ESSN and a.Sex='F'
where a. [Sex] ='F'
union all
select a.Dependent_name, a.Sex from 
[Dependent] a inner join Employee b
on [SSN]= [ESSN] and b.Sex='M'
where a. [Sex] ='M'

--2
select P.Pname, sum(W.Hours) [Project Hours]
from Project P, Works_for W
where P.Pnumber = W.Pno
group by P.Pname

--3
select D.*
from Employee E, Departments D
where D.Dnum = E.Dno and E.SSN = (select min(SSN) from Employee where Dno is not null)

--4
select D.Dname, Max(Salary) [Max Salary],MIN(Salary)[min Salary],AVG(Salary)[Average Salary]
from Employee E, Departments D
where D.Dnum = E.Dno
group by D.Dname

--5
select E.Lname 
from Employee E ,Departments D
where E.SSN =D.MGRSSN
and E.SSN not in (select ESSN from Dependent)

--6
select D.Dnum,D.Dname,Count(E.SSN)[Number of Employees]
from Departments D,Employee E
where D.Dnum=E.Dno
group by D.Dnum, D.Dname
having avg(E.Salary) <(select AVG(Salary) from Employee)

--7
select*
from Employee E, Works_for W, Project P
where E.SSN= W.ESSn and P.Pnumber = W.Pno
order by E.Dno, E.Fname, E.Lname

--8
select max(Salary)
from Employee
union
select max(salary)
from Employee
where Salary <(select max(Salary) from Employee)


--9 
select concat (E.Fname, ' ', E.Lname) as Full_Name
from Employee E, Dependent D
where concat (E.Fname, ' ' ,E.Lname) like D. Dependent_name

--10
select Distinct concat (E.Fname, ' ',E.Lname) as Full_Name , E.SSN
from Employee E , Dependent D
where E.SSN = D. ESSN and exists (select ESSN from Dependent)

--11
insert into Departments values ('DEPT IT', 100, 112233, '1-11-2006')

--12
---a
update Departments 
set MGRSSN =968574
where Dnum=100

---b
update Departments 
set MGRSSN =102672
where Dnum = 20

---c
update Employee
set Superssn =102672
where SSN = 102660

--13
update Departments
set MGRSSN = 102672
where MGRSSN = 223344

delete from Dependent where ESSN =223344

update Employee
set. Superssn = 102672
where Superssn = 223344

update Works_for
set ESSn = 102672
where ESSn =223344

delete Employee where SSN= 223344

--14
update Employee
set Salary+= Salary*0.3
from Employee E, Works_for W, Project P
where E.SSN = W.ESSn and P.Pnumber = W.Pno and P.Pname like 'Al Rabwah'