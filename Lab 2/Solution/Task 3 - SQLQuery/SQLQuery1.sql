USE Company_SD;
--1
SELECT* FROM Employee;

--2
SELECT Fname, Lname, Salary, Dno FROM Employee;

--3
SELECT Pname, Plocation, Dnum FROM Project;

--4
SELECT Fname+' '+Lname NAME , Salary*12 AS [ANNUAL SALARY] FROM Employee;

--5
SELECT SSN, Fname+' '+Lname NAME ,Salary FROM Employee WHERE Salary > 1000;

--6
SELECT SSN, Fname+' '+Lname NAME , Salary*12 [Annual Salary] FROM Employee WHERE Salary*12 > 10000;

--7
SELECT Fname+' '+Lname NAME , Salary FROM Employee WHERE Sex = 'F';

--8
SELECT Dnum, Dname FROM Departments WHERE MGRSSN = 968574;

--9
SELECT Pnumber, Pname, Plocation FROM Project WHERE Dnum = 10;