-- SQL_DAY5 ITI
Use ITI
--1
SELECT COUNT (st_age)
FROM Student

--2
SELECT DISTINCT (Ins_Name)
FROM Instructor

--3
SELECT [Student ID]= St_ID,
[Student Fullname] = ISNULL(St_Fname + ' '+ St_Lname, 'Not Found'),
[Department Name] = D.Dept_Name
FROM Student S , Department D
WHERE D.Dept_Id= S.Dept_Id

--4
SELECT I.Ins_Name, D.Dept_Name
FROM Instructor I,Department D 
WHERE D.Dept_ID = I.Dept_Id

--5
SELECT CONCAT (St_Fname, ' ' , St_Lname) AS [Student Fullname], Crs_Name AS [Course Name], Sc.Grade AS [Course Grade]
FROM Student S, Course C,  Stud_Course Sc
WHERE S.St_Id = Sc.St_Id AND C.Crs_Id= Sc.Crs_Id AND Sc.Grade IS NOT NULL

--6
SELECT T.Top_Name, COUNT (Crs_Id ) AS[NO. of Courses]
FROM Course C, Topic T
WHERE T.Top_Id = C.Top_Id
GROUP BY Top_Name

--7 
SELECT MAX(Salary) AS [Max Inst. Salary], MIN(Salary) As [Min Inst. Salary]
FROM Instructor

--8 
SELECT * from Instructor
WHERE Salary < (SELECT AVG(Salary) FROM Instructor)

--9 
SELECT D.Dept_Name
FROM Department D, Instructor I 
WHERE D.Dept_Id = I.Dept_Id 
AND I.Salary = (SELECT MIN(Salary) FROM Instructor)

--10 
SELECT TOP(2) Salary 
FROM Instructor
ORDER BY Salary desc

--11
SELECT Ins_Name , coalesce(cast (salary AS VARCHAR(10)),'Instructor Bones') AS Salary 
FROM Instructor

--12
SELECT AVG(salary) FROM Instructor

--13
SELECT S.St_Fname , I.*
FROM Student AS S  left join Instructor AS I
ON S.St_Id = I.Ins_Id

--14
SELECT *,ROW_NUMBER() OVER (ORDER BY salary DESC) AS RN
FROM Instructor

--15
SELECT St_Fname , DepartmentName
FROM ( SELECT D.Dept_Name AS DepartmentName, S.St_Fname, ROW_NUMBER() OVER (PARTITION BY S.Dept_Id ORDER BY NEWID()) AS RN
FROM Student AS S INNER JOIN Department AS D ON S.Dept_Id = D.Dept_Id) AS RankedStudents
WHERE RN = 1
