USE ITI

--1 - Create a scalar function that takes date and returns Month name of that date.
CREATE FUNCTION GetMonthName (@date DATE)
RETURNS VARCHAR(20)
AS BEGIN
    DECLARE @monthName NVARCHAR(20) 
	SET @monthName = FORMAT(@date ,'MMMM')
    RETURN @monthName
END

SELECT dbo.GetMonthName('2023-05-21')
--------------------------------------------------------------
--2 - Create a multi-statements table-valued function that takes 2 integers and returns the values between them.
CREATE FUNCTION GetValuesBetween(@start INT, @end INT)
RETURNS @values TABLE (Value INT)
AS BEGIN
    IF @end < @start
    BEGIN
        WHILE @start >= @end
        BEGIN
            INSERT INTO @values (Value) VALUES (@start)
            SET @start = @start - 1
        END
    END
    ELSE
    BEGIN
        WHILE @start <= @end
        BEGIN
            INSERT INTO @values (Value) VALUES (@start)
            SET @start = @start + 1
        END
    END
    RETURN
END

SELECT * FROM GetValuesBetween(5, 10)
SELECT * FROM GetValuesBetween(15, 10)
--------------------------------------------------------------
--3 - Create inline function that takes Student No and returns Department Name with Student full name.
CREATE FUNCTION GetStudentInfo (@studentId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT  CONCAT(S.St_Fname , ' ' , S.St_Lname) AS FullName, D.Dept_Name
    FROM Student S
    JOIN Department D ON S.Dept_Id = D.Dept_Id
    WHERE s.St_Id = @studentId
)

SELECT * FROM GetStudentInfo(2)
--------------------------------------------------------------
--4 - Create a scalar function that takes Student ID and returns a message to user 
--a.	If first name and Last name are null then display 'First name & last name are null'
--b.	If First name is null then display 'first name is null'
--c.	If Last name is null then display 'last name is null'
--d.	Else display 'First name & last name are not null'

CREATE FUNCTION GetStudentNameMessage (@studentID INT)
RETURNS VARCHAR(50)
AS BEGIN
    DECLARE @firstName VARCHAR(50)
    DECLARE @lastName VARCHAR(50)
    DECLARE @message VARCHAR(50)
    
    SELECT @firstName = St_Fname, @lastName = St_Lname
    FROM Student
    WHERE St_Id = @studentID
    
    IF @firstName IS NULL AND @lastName IS NULL
        SET @message = 'First name & last name are null'
    ELSE IF @firstName IS NULL
        SET @message = 'First name is null'
    ELSE IF @lastName IS NULL
        SET @message = 'Last name is null'
    ELSE
        SET @message = 'First name & last name are not null'
    
    RETURN @message
END

SELECT dbo.GetStudentNameMessage(1)
--------------------------------------------------------------
--5 - Create inline function that takes integer which represents manager ID and displays department name, Manager Name and hiring date 
CREATE FUNCTION GetManagerInfo (@managerID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT D.Dept_Name, I.Ins_Name AS ManagerName, Manager_hiredate
    FROM Instructor I
    JOIN Department D ON I.Dept_Id = D.Dept_Id
    WHERE I.Ins_Id = @managerID
)

SELECT * FROM GetManagerInfo(1)
--------------------------------------------------------------
--6 - Create multi-statements table-valued function that takes a string
--If string='first name' returns student first name
--If string='last name' returns student last name 
--If string='full name' returns Full Name from student table 
--Note: Use “ISNULL” function

CREATE FUNCTION GetStudentNameInfo (@string VARCHAR(20))
RETURNS @res TABLE (NameInfo VARCHAR(50))
AS BEGIN
    IF @string = 'first name'
        INSERT INTO @res (NameInfo) SELECT ISNULL(St_FName, '') FROM Student
    ELSE IF @string = 'last name'
        INSERT INTO @res (NameInfo) SELECT ISNULL(St_Lname, '') FROM Student
    ELSE IF @string = 'full name'
        INSERT INTO @res (NameInfo) SELECT ISNULL(St_FName, '') + ' ' + ISNULL(St_LName, '') FROM Student
    
    RETURN
END

SELECT * FROM GetStudentNameInfo('full name')
--------------------------------------------------------------
--7 - Write a query that returns the Student No and Student first name without the last char
SELECT St_Id, LEFT(St_Fname, LEN(St_Fname) - 1) AS [FirstNameWithoutLastChar] FROM Student
--------------------------------------------------------------
--8 - Wirte query to delete all grades for the students Located in SD Department 
UPDATE Stud_Course 
SET Grade = NULL 
WHERE St_Id IN (
  SELECT St_Id FROM student S, Department D 
  WHERE D.Dept_Id = S.Dept_Id And D.Dept_Id = 'SD')
--------------------------------------------------------------
--9 - Using Merge statement between the following two tables [User ID, Transaction Amount]
Merge into [dbo].[Daily_Transactions] as T 
using [dbo].[Last_Transactions] as S
On T.[UserID]=S.[UserID]

When matched then
update set T.TransactionAmount=S.TransactionAmount

When not matched by target Then 
insert(UserID,TransactionAmount)
values(S.UserID,S.TransactionAmount)

When not matched by Source
Then delete

Output $action,inserted.*,deleted.*;
--------------------------------------------------------------
--10 - Try to Create Login Named(ITIStud) who can access Only student and Course tablesfrom ITI DB 
--then allow him to select and insert data into tables and deny Delete and update
CREATE SCHEMA newUser
ALTER SCHEMA newUser TRANSFER dbo.Student
ALTER SCHEMA newUser TRANSFER dbo.Course





