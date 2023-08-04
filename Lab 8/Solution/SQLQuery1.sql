-- DAY 8

--1.	Create a stored procedure without parameters to show the number of students per department name. [use ITI DB]
USE ITI

CREATE PROC SP_StPerDept @DepartmentName varchar(50) = NULL
AS
IF @DepartmentName IS NOT NULL
SELECT D.Dept_Name , COUNT (S.St_Id) AS [No. Of Students] 
FROM Department D INNER JOIN Student S

ON D.Dept_Id = S.Dept_Id
WHERE D.Dept_Name= @DepartmentName
GROUB BY D.Dept_Name

ELSE IF @DepartmentName IS NULL
SELECT D.Dept_Name, COUNT (S.St_Id) AS [No. Of Students] 
FROM Department D INNER JOIN Student S 
ON D.Dept_Id = S.Dept_Id
group by D.Dept_Name

EXEC SP_StPerDept 'Java'
EXEC SP_StPerDept

-----------------------------------------------------------------------------------

--2.	Create a stored procedure that will check for the # of employees in the
--      project p1 if they are more than 3 print message to the user “'The number 
--      of employees in the project p1 is 3 or more'” if they are less display a 
--      message to the user “'The following employees work for the project p1'” 
--      in addition to the first name and last name of each one. [Company DB] 

USE Company_SD
CREATE PROC SP_EmpInProj @ProjectNo int 
AS
DECLARE @count  int 
SET @count = (SELECT COUNT (WF.ESSn)
FROM Works_for WF 
WHERE WF.Pno = @ProjectNo)

IF @count >= 3 
SELECT (CONCAT('The number of employees in the project ', @ProjectNo , 'is 3 or more') )

ELSE 
    BEGIN
	DECLARE @TABLE TABLE( FirstName varchar(50), LastName varchar(50))
	INSERT INTO @TABLE
	SELECT E.Fname, E.Lname  
	FROM Employee E INNER JOIN Works_for WF
	ON E.SSN = WF.ESSn
	WHERE WF.Pno = @ProjectNo
	SELECT (CONCAT(@count,' of employees in the project ', @ProjectNo ))
	SELECT * FROM @TABLE
	END

SP_EmpInProj 400

-----------------------------------------------------------------------------------

--3.	Create a stored procedure that will be used in case there is an old 
--      employee has left the project and a new one become instead of him.
--      The procedure should take 3 parameters (old Emp. number, new Emp. number and the project number)
--      and it will be used to update works_on table. [Company DB]

CREATE PROC SP_UpdateWF @oldEmpId int, @newEmpId int,@ProjectNo int
AS
UPDATE Works_for
SET ESSn = @newEmpId

WHERE Pno = @ProjectNo AND ESSn = @oldEmpId

SP_UpdateWF 112233, 669955, 100

-----------------------------------------------------------------------------------

--4.add column budget in project table and insert any draft values in it then 
-- then Create an Audit table with the following structure 
--ProjectNo 	UserName 	ModifiedDate 	Budget_Old 	Budget_New 
--   p2           Dbo 	     2008-01-31	       95000      200000 

--This table will be used to audit the update trials on the Budget column (Project table, Company DB)
--Example: If a user updated the budget column then the project number, user name that made that update, 
--the date of the modification and the value of the old and the new budget will be inserted into the Audit table
--Note: This process will take place only if the user updated the budget column
USE Company_SD

CREATE TABLE AuditTable (ProjectNo int, UserName varchar(30), ModificationDate date, OldBudget Float, NewBudget float)

CREATE TRIGGER TR1
ON Project 
AFTER UPDATE 
AS
	IF UPDATE(Budget)
		BEGIN
			DECLARE @oldbudget int , @newBudget int , @project int
			SELECT @oldbudget=Budget from deleted
			SELECT @project =Pnumber from deleted
			SELECT @newBudget=Budget from inserted
			INSERT INTO AuditTable 
			            VALUES(@project,SUSER_NAME(),GETDATE(),@oldbudget,@newBudget)
		END

UPDATE Project SET Budget = 20000  WHERE Pnumber= 100

SELECT * FROM AuditTable
UPDATE Project SET Budget = 20000  WHERE Pnumber= 200

-----------------------------------------------------------------------------------

--5.	Create a trigger to prevent anyone from inserting a new record in the Department table [ITI DB]
--      “Print a message for user to tell him that he can’t insert a new record in that table”
USE ITI
CREATE TRIGGER TR2
ON Department
INSTEAD OF INSERT 
AS
	PRINT 'You can’t insert a new record in that table'

INSERT INTO Department (Dept_Name,Dept_Desc,Dept_Location) values ('Angular','Front-End','Menoufia')

-----------------------------------------------------------------------------------

-- 6.	 Create a trigger that prevents the insertion Process for Employee table in March [Company DB].

USE Company_SD

CREATE TRIGGER TR3
ON Employee 
INSTEAD OF INSERT 
AS
	IF FORMAT(GETDATE(),'MMMM')='MARCH'
		SELECT 'Not allowed'
	ELSE 
		INSERT INTO Employee 
		SELECT * FROM inserted

INSERT INTO Employee (Fname, Lname, SSN)
values ('Mohamed', 'Nabil', 1234)

-----------------------------------------------------------------------------------

--7.	Create a trigger on student table after insert to add Row in Student Audit table (Server User Name , Date, Note) where note will be “[username] Insert New Row with Key=[Key Value] in table [table name]”
-- ServerUserName		Date         Note 
		

CREATE TABLE StAuditTab (ServerUserName varchar(50), InsertDate date, Note varchar(50))

CREATE TRIGGER TR5
ON Student 
AFTER INSERT 
AS 
	INSERT INTO StAuditTab
	VALUES (@@SERVERNAME,GETDATE(),SUSER_NAME())

INSERT INTO Student(St_Fname ,St_Lname,St_Id)
VALUES ('Mohamed','Nabil', 1234)

SELECT * FROM StAuditTab

-----------------------------------------------------------------------------------

--8.	 Create a trigger on student table instead of delete to add Row in Student Audit table 
--      (Server User Name, Date, Note) where note will be“ try to delete Row with Key=[Key Value]”

ALTER TRIGGER TR6
ON Student 
AFTER INSERT 
AS  
    DECLARE @oldSt int
	SELECT @oldSt=St_Id from Student

		INSERT INTO StAuditTab
		VALUES (@@SERVERNAME,GETDATE(),' Try to delete Row with Key = '+CONVERT(nvarchar(20),@oldSt))

DELETE FROM Student where St_Id = 1234 

SELECT * FROM StAuditTab

-----------------------------------------------------------------------------------
