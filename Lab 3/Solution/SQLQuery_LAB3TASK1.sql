USE Company_SD;

/*1- Display the Department id, name and id and the name of its manager.*/
SELECT D.Dnum, D.Dname, [MGRSSN]= E.SSN, [MGRName] = CONCAT ( E.Fname, ' ' , E.Lname) 
FROM Departments D INNER JOIN Employee E
ON E.SSN= D.MGRSSN

/*2- Display the name of the departments and the name of the projects under its control.*/
SELECT D.Dname, P.Pname
FROM Departments D INNER JOIN Project P
ON D.Dnum = P.Dnum

/*3- Display the full data about all the dependence associated with the name of the employee they depend on him/her.*/
SELECT D.*, [Dependent on] = CONCAT(E.Fname, ' ',E.Lname)
FROM Dependent D INNER JOIN Employee E
ON E.SSN =D.ESSN

/*4- Display the Id, name and location of the projects in Cairo or Alex city.*/
SELECT P.Pnumber, P.Pname , P.Plocation
FROM Project P
WHERE City IN ('Cairo', 'Alex')

/*5- Display the Projects full data of the projects with a name starts with "a" letter.*/
SELECT *
FROM Project P
WHERE P.Pname LIKE 'a%'

/*6- Display all the employees in department 30 whose salary from 1000 to 2000 LE monthly*/
SELECT *
FROM Employee
WHERE DNo = 30 AND salary BETWEEN 1000 AND 2000

/* 7- Retrieve the names of all employees in department 10 who works more than or equal 10 hours per week on "AL Rabwah" project.*/
SELECT CONCAT (E.Fname, ' ' ,E.Lname) AS [Employee Name]
FROM Employee E INNER JOIN Works_for W ON E.SSN = W.ESSn AND E.Dno = 10
INNER JOIN Project P ON W.Pno = P.Pnumber AND P.Pname = 'AL Rabwah' AND W.Hours >= 10

/* 8- Find the names of the employees who directly supervised with Kamel Mohamed.*/
SELECT CONCAT (E.Fname, ' ' ,E.Lname) AS [Employee Name]
FROM Employee E , Employee Super
WHERE Super.SSN = E.Superssn
AND Super.Fname = 'Kamel' AND Super.Lname = 'Mohamed'

/*9- Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.*/
SELECT CONCAT (E.Fname, ' ' ,E.Lname) AS [Employee Name], P.Pname AS [Project Name]
FROM Employee E , Works_for W , Project P
WHERE E.SSN = W.ESSn AND P.Pnumber = W.Pno
ORDER BY P.Pname

/* 10- For each project located in Cairo City , find the project number, the controlling department name ,the department manager last name ,address and birthdate.*/
SELECT P.Pnumber , D.Dname, E.Lname, E.Address, E.Bdate
FROM Project P, Departments D, Employee E
WHERE D.Dnum = P.Dnum AND E.SSN = D.MGRSSN AND P.City = 'Cairo'

/*11-Display All Data of the managers*/
SELECT E.*
FROM Employee E , Departments D
WHERE E.SSN = D.MGRSSN

/*12- Display All Employees data and the data of their dependents even if they have no dependents*/
SELECT E.*, D.*
FROM Employee E LEFT OUTER JOIN Dependent D
ON E.SSN = D.ESSN;

/* 13- Insert your personal data to the employee table as a new employee in department number 30, SSN = 102672, Superssn = 112233, salary=3000.*/
INSERT INTO Employee ( Fname, Lname, SSN, Bdate, Address, Sex, Salary, Superssn, Dno)
VALUES ('Mohamed', 'Nabil', '102672', '1996-05-27', 'Sidi Bishr, Alex', 'M', 3000, 112233, 30);

/* 14- Insert another employee with personal data your friend as new employee in department number 30, SSN = 102660, but don’t enter any value for salary or supervisor number to him.*/
INSERT INTO Employee ( Fname, Lname, SSN, Bdate, Address, Sex, Dno)
VALUES ('Ahmed', 'Osama', '102660', '1999-03-21', 'Montazah, Alex', 'M', 30);

/*15-Upgrade your salary by 20 % of its last value.*/
UPDATE Employee
SET Salary += (Salary * 0.2)
WHERE SSN = 102672;
