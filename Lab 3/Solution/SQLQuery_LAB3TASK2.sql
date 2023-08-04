create database LAB3TASK2
use LAB3TASK2

create table Instructor
(
IID int primary key identity (1,1), 
FName varchar (20),
LName varchar (20),
BirthDate date,
Overtime int unique,
Salary int default 3000,
Hiredate date default getdate (),
IAddress varchar (20),
Age as (year (getdate () ) -year (BirthDate) ) ,
Netsal as (isnull (salary, 0)+isnull (overtime, 0)) persisted, 
constraint C_Adress check (IAddress in('Alex', 'Cairo')),
constraint C_Salary check (Salary between 1000 and 5000), 
)

create table Course
(
CID int primary key identity (1,1),
CName varchar (20), 
Duration int unique
)

create table Teach
(
I_ID int,
C_ID int,
constraint C_Teach primary key (I_ID, C_ID),
constraint C_CID_FK foreign key (C_ID) references Course (CID),
constraint C_IID_FK foreign key (I_ID) references Instructor (IID)
)

create table Lab 
(
LID int identity (1,1),
LLocation varchar (20),
Capacity int,
C_ID int,
constraint C_Primary_Lab primary key (LID, C_ID),
constraint C_Capacity check (Capacity < 20),
constraint C_CID_FKey foreign key (C_ID) references Course (CID)
on delete cascade on update cascade
)