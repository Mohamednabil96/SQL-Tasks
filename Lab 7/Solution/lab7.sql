create view V1
as
select CONCAT(a.[St_Fname],' ',a.[St_Lname]) [FullName], c.[Crs_Name]
from [dbo].[Student] a inner join [dbo].[Stud_Course] b on a.St_Id = b.St_Id
inner join [dbo].[Course] c on c.Crs_Id= b.Crs_Id
where b.Grade > 50
---------------------------------------------------
-- 2.
create view V2
with encryption
as
select a.[Ins_Name] as [manager name], e.[Top_Name]
from [dbo].[Instructor] a inner join [dbo].[Department] b on a.Ins_Id = b.Dept_Manager
inner join [dbo].[Ins_Course] c on a.Ins_Id= c.Ins_Id
inner join [dbo].[Course] d on d.Crs_Id=c.Crs_Id
inner join [dbo].[Topic] e on e.Top_Id = d.Top_Id
-----------------------------------------------------------------
--3.
create view V3
as
select [Instructor].[Ins_Name] , [Department].[Dept_Name]
from [Instructor]  inner join [Department]  on [Department].[Dept_Id]=[Instructor].Dept_Id
where [Department].[Dept_Name] in ('SD','Java')
----------------------------------------------------------------------
--4.
create view V4
as
select * from [dbo].[Student] 
where [St_Address] in ('Alex','Cairo')
with check option

Update V4 set st_address='tanta'
Where st_address='alex'
--------------------------------------------------
--5.
create view V5
as
select [Pname],COUNT([ESSn]) [number of employees working on it]
from  [dbo].[Project] inner join [dbo].[Works_for] on [Pnumber] = [Pno]
group by [Pname]
----------------------------------------------------------
--6.
create schema Company
create schema HumanResource 

alter schema Company transfer [dbo].[Departments]
alter schema HumanResource transfer [dbo].[Employee]

---------------------------------------------------------
--7.
create nonClustered index i1
on Department([Manager_hiredate])
-- created non unique- nonClustered index on Manager_hiredate, make search faster
select * from [dbo].[Department] where [Manager_hiredate]='2009-01-01'
-------------------------------------------------
--8.
create unique index i2
on [dbo].[Student]([St_Age])

-- error because thare are duplicated values in column, 
---and unique is Constraint and it applied in old data 
--------------------------------------------------------------------
--9.
declare c1 Cursor
for select salary
	from Employee
for update
declare @sal int
open c1
fetch c1 into @sal
while @@fetch_status=0
	begin
		if @sal>=3000
			update Employee
				set salary=@sal*1.20
			where current of c1
		else
			update Employee
				set Salary=@sal*1.10
			where current of c1
		fetch c1 into @sal
	end
close c1
deallocate c1
----------------------------------------------------
--10.
declare c2 Cursor
for Select [Dept_Name],[Ins_Name]
		from [dbo].[Instructor] inner join [dbo].[Department]
		on [dbo].[Instructor].[Ins_Id]=[dbo].[Department].[Dept_Manager]
for read only
declare @Dept varchar(50),@manager varchar(50)
open c2
fetch c2 into @Dept,@manager
while @@fetch_status=0
	begin
	    select @Dept as[Department name],@manager as[manager name]
		fetch c2 into @Dept,@manager
	end
close c2
deallocate c2
------------------------------------------------
--11.
declare c1 cursor
for select distinct Ins_Name
	from Instructor
	where Ins_Name is not null
for read only

declare @name varchar(20),@all_names varchar(300)=''
open c1
fetch c1 into @name
while @@FETCH_STATUS=0
	begin
		set @all_names=concat(@all_names,',',@name)
		fetch c1 into @name   --Next Row 
	end
select @all_names as[all instructor names in one cell]
close c1
deallocate C1
------------------------------------------------
--12.
-- generate script from DB ITI that describes all tables and views not completed because view encryption