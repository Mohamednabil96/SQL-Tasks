use ITI

--1.Create a view that displays student full name, course name if the student has a grade more than 50. 
CREATE VIEW coursesSucceed 
AS
SELECT CONCAT(s.St_Fname, ' ', s.St_Lname) AS studentName, c.Crs_Name AS [Course]
FROM student s ,Stud_Course sc, Course c
WHERE s.st_id = sc.st_id
AND sc.crs_id = c.crs_id
AND sc.grade > 50;
SELECT * FROM coursesSucceed

-------------------------------------------------------

-- 2 - Create an Encrypted view that displays manager names and the topics they teach. 
-- dbo.Department : Dept_Manager --> all values are null
CREATE VIEW mngr_view 
WITH ENCRYPTION
AS
SELECT I.Ins_Name AS [Instrucor], T.Top_Name AS [Topic]
FROM Course C, Topic T,Instructor I,Ins_Course IC
WHERE C.Crs_Id = IC.Crs_Id 
AND I.Ins_Id = IC.Ins_Id
AND  C.Top_Id = T.Top_Id 
SELECT * FROM mngr_view;

-------------------------------------------------------

-- 3 - Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department 
CREATE VIEW ins_dept_view 
AS
SELECT I.Ins_Name, D.Dept_Name
FROM Instructor I
JOIN Department D ON I.Dept_Id = D.Dept_Id
WHERE D.Dept_Name = 'SD' OR D.Dept_Name = 'Java';
SELECT* FROM ins_dept_view 

-------------------------------------------------------

--4 - Create a view “V1” that displays student data for student who lives in Alex or Cairo. 
--Note: Prevent the users to run the following query 
--Update V1 set st_address=’tanta’
--Where st_address=’alex’;

CREATE VIEW V1 AS
SELECT S.St_Id, CONCAT(S.St_Fname, ' ', S.St_Lname) AS studentName, S.St_Address
FROM Student S
WHERE S.St_Address = 'Alex' OR S.St_Address = 'Cairo';

UPDATE V1 SET St_Address = 'Tanta' WHERE St_Address = 'Alex';
SELECT * FROM V1;

-------------------------------------------------------

--5 - Create a view that will display the project name and the number of employees work on it. “Use Company DB”
use Company_SD;
CREATE VIEW project_employee_count AS
SELECT P.Pname AS [Project], COUNT(E.SSN) AS [Employees Count]
FROM Project P,  Works_for WF, Employee E
WHERE P.Pnumber = WF.Pno
GROUP BY P.Pname;
SELECT * FROM project_employee_count

-------------------------------------------------------

--6 - Create the following schema and transfer the following tables to it 
--a.Company Schema 
--     i.Department table (Programmatically)
--     ii.Project table (by wizard)
--b.Human Resource Schema
--     i.Employee table (Programmatically)

--a
CREATE SCHEMA Company;
--i
ALTER SCHEMA Company TRANSFER dbo.Departments
--ii --> wizard --> done..

--b
CREATE SCHEMA Human_Resource;
--i
ALTER SCHEMA Human_Resource TRANSFER dbo.Employee

-------------------------------------------------------

--7 - Create index on column (manager_Hiredate) that allow u to cluster the data in table Department. 
--What will happen? 
use ITI

CREATE NONCLUSTERED INDEX I_Dept_Hd ON Department(manager_Hiredate)
--ITI -> tables -> dbo.Department -> Indexes ->  I_Dept_Hd   -- done..

-------------------------------------------------------

--8 - Create index that allow u to enter unique ages in student table. What will happen?  
use ITI
CREATE UNIQUE INDEX I_St_Age ON Student(St_Age)

-------------------------------------------------------

--9 - Create a cursor for Employee table that increases Employee salary by 10% 
--if Salary <3000 and increases it by 20% if Salary >=3000. 
Use Company_SD

DECLARE @EmpID INT, @Salary DECIMAL
DECLARE emp_cursor CURSOR FOR
SELECT E.SSN, E.Salary FROM Employee E WHERE E.Salary is not null
OPEN emp_cursor

FETCH NEXT FROM emp_cursor INTO @EmpID, @Salary
WHILE @@FETCH_STATUS = 0
BEGIN
    IF (@Salary < 3000)
    BEGIN
        SET @Salary = @Salary * 1.1
    END
    ELSE
    BEGIN
        SET @Salary = @Salary * 1.2
    END
    
    UPDATE Employee SET Salary = @Salary WHERE SSN = @EmpID
    
    FETCH NEXT FROM emp_cursor INTO @EmpID, @Salary
END

CLOSE emp_cursor
DEALLOCATE emp_cursor

-------------------------------------------------------

--10 - Display Department name with its manager name using cursor.
Use ITI 

DECLARE @DeptName VARCHAR(20), @ManagerName VARCHAR(20)

DECLARE dept_cursor CURSOR 
FOR SELECT D.Dept_Name, I.Ins_Name
FROM Department D , Instructor I
WHERE D.Dept_Manager = I.Ins_Id

OPEN dept_cursor
--
FETCH NEXT FROM dept_cursor INTO @DeptName, @ManagerName

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Department Name: ' + @DeptName + ', Manager Name: ' + @ManagerName
    
    FETCH NEXT FROM dept_cursor INTO @DeptName, @ManagerName
END
--
CLOSE dept_cursor
DEALLOCATE dept_cursor

-------------------------------------------------------

-- 11 Try to display all instructor names in one cell separated by comma. Using Cursor . 
Use ITI 

DECLARE Cinstructor CURSOR 
FOR SELECT Ins_Name
FROM Instructor
for read only
DECLARE @InstructorName VARCHAR(20) = ''; DECLARE  @CurrInstructor VARCHAR(20)

OPEN Cinstructor

FETCH NEXT FROM Cinstructor INTO @CurrInstructor

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @InstructorName = CONCAT (@InstructorName , ',', @CurrInstructor)
    
    FETCH NEXT FROM Cinstructor INTO @CurrInstructor
END

CLOSE Cinstructor
--DEALLOCATE Cinstructor

SELECT @InstructorName

-------------------------------------------------------

--12 Try to generate script from DB ITI that describes all tables and views in this DB

--> Script...