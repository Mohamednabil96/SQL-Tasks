USE [master]
GO
/****** Object:  Database [ITI]    Script Date: 5/22/2023 6:44:15 PM ******/
CREATE DATABASE [ITI]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ITI', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\ITI.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'ITI_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\ITI_log.ldf' , SIZE = 8384KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [ITI] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ITI].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ITI] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ITI] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ITI] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ITI] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ITI] SET ARITHABORT OFF 
GO
ALTER DATABASE [ITI] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ITI] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ITI] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ITI] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ITI] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ITI] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ITI] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ITI] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ITI] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ITI] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ITI] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ITI] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ITI] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ITI] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ITI] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ITI] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ITI] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ITI] SET RECOVERY FULL 
GO
ALTER DATABASE [ITI] SET  MULTI_USER 
GO
ALTER DATABASE [ITI] SET PAGE_VERIFY NONE  
GO
ALTER DATABASE [ITI] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ITI] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ITI] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [ITI] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [ITI] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'ITI', N'ON'
GO
ALTER DATABASE [ITI] SET QUERY_STORE = OFF
GO
USE [ITI]
GO
/****** Object:  User [koko]    Script Date: 5/22/2023 6:44:15 PM ******/
CREATE USER [koko] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [ITIStud]    Script Date: 5/22/2023 6:44:15 PM ******/
CREATE USER [ITIStud] FOR LOGIN [ITIStud] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [iti]    Script Date: 5/22/2023 6:44:15 PM ******/
CREATE USER [iti] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Schema [iti]    Script Date: 5/22/2023 6:44:15 PM ******/
CREATE SCHEMA [iti]
GO
/****** Object:  Schema [loginUser]    Script Date: 5/22/2023 6:44:15 PM ******/
CREATE SCHEMA [loginUser]
GO
/****** Object:  UserDefinedFunction [dbo].[CheckStudentNameByStudentId]    Script Date: 5/22/2023 6:44:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [dbo].[CheckStudentNameByStudentId](@StId int)
returns varchar(60) 
begin
    declare @FName   varchar(30)
    declare @LName   varchar(30)
	declare @message varchar(60)

	select @FName=[St_Fname] from [dbo].[Student] where [St_Id]=@StId
	select @LName =[St_Lname] from [dbo].[Student] where [St_Id]=@StId

	if @FName is null  and @LName is null 
	select @message='First name & last name are null'

	else if @FName is null  and @LName is not null
	select @message='first name is null'

	else if @FName is not null  and @LName is null
	select @message='last name is null'

	else
	select @message='First name & last name are not null'
	 
	return @message
end
GO
/****** Object:  UserDefinedFunction [dbo].[GetMonthName]    Script Date: 5/22/2023 6:44:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [dbo].[GetMonthName](@date date)
returns varchar(30)
begin
	declare @NewDate varchar(30)
	select @NewDate= (select FORMAT(@date,'MMMM'))
	return @NewDate

end
GO
/****** Object:  UserDefinedFunction [dbo].[GetStudentDataBasedPassedFormat]    Script Date: 5/22/2023 6:44:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Function [dbo].[GetStudentDataBasedPassedFormat](@Format varchar(20))
Returns @t table
		(
			StdId int,
			StdName varchar(20)
		)

as
	Begin
		if @format = 'first name'
			Insert Into @t
			Select St_Id, isnull(St_FName,'no name')
			from Student
		else if @format = 'last name'
			Insert Into @t
			Select St_Id, isnull(St_LName,'no name')
			from Student
		else if @format = 'full name'
			Insert Into @t
			Select St_Id, Concat(isnull(St_FName,'no name'), ' ', isnull(St_LName,'no name'))
			from Student
		
		return 
	End
GO
/****** Object:  UserDefinedFunction [dbo].[GetValuesBetween]    Script Date: 5/22/2023 6:44:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Function [dbo].[GetValuesBetween](@num1 int, @num2 int )
Returns @t table
		(
			ValuesBetweenThem nvarchar(60)
		)
as
	Begin
		 
		 if  @num1 = @num2
		    Insert Into @t
		    Select 'two integers are equal'
		    
		else if @num1 > @num2
		BEGIN
		     declare @stopInteger int =  @num2
			 WHILE @stopInteger < (@num1 -1)
             BEGIN 
			   set @stopInteger = @stopInteger +1
			    Insert Into @t
			    Select @stopInteger
			 END
        END

		else if @num2 > @num1
      BEGIN
		declare @stopInteger2 int =  @num1
			WHILE @stopInteger2 < (@num2 -1)
             BEGIN
			   set @stopInteger2 = @stopInteger2 +1
			    Insert Into @t
			    Select @stopInteger2
			 END
		END
		return 
	End
GO
/****** Object:  Table [dbo].[Student]    Script Date: 5/22/2023 6:44:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student](
	[St_Id] [int] NOT NULL,
	[St_Fname] [nvarchar](50) NULL,
	[St_Lname] [nchar](10) NULL,
	[St_Address] [nvarchar](100) NULL,
	[St_Age] [int] NULL,
	[Dept_Id] [int] NULL,
	[St_super] [int] NULL,
 CONSTRAINT [PK_Student] PRIMARY KEY CLUSTERED 
(
	[St_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Department]    Script Date: 5/22/2023 6:44:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[Dept_Id] [int] NOT NULL,
	[Dept_Name] [nvarchar](50) NULL,
	[Dept_Desc] [nvarchar](100) NULL,
	[Dept_Location] [nvarchar](50) NULL,
	[Dept_Manager] [int] NULL,
	[Manager_hiredate] [date] NULL,
 CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED 
(
	[Dept_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[GetStudentDataByStudentId]    Script Date: 5/22/2023 6:44:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 Create Function [dbo].[GetStudentDataByStudentId](@StudID int)
Returns Table  
as
	Return
	(
		Select CONCAT([dbo].[Student].[St_Fname],' ',[dbo].[Student].[St_Lname]) [Student full name],[Dept_Name]
		from [dbo].[Student] inner join [dbo].[Department]
		on [dbo].[Department].[Dept_Id]=[dbo].[Student].[Dept_Id]
		Where [St_Id]= @StudID
	)
GO
/****** Object:  Table [dbo].[Instructor]    Script Date: 5/22/2023 6:44:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Instructor](
	[Ins_Id] [int] NOT NULL,
	[Ins_Name] [nvarchar](50) NULL,
	[Ins_Degree] [nvarchar](50) NULL,
	[Salary] [money] NULL,
	[Dept_Id] [int] NULL,
 CONSTRAINT [PK_Instructor] PRIMARY KEY CLUSTERED 
(
	[Ins_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[GetManagerDataByManagerId]    Script Date: 5/22/2023 6:44:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 Create Function [dbo].[GetManagerDataByManagerId](@ManagerID int)
Returns Table  
as
	Return
	(
		Select [Dept_Name],[Ins_Name],[Manager_hiredate]
		from [dbo].[Instructor] inner join [dbo].[Department]
		on [dbo].[Department].[Dept_Manager]=[dbo].[Instructor].[Ins_Id]
		Where [Dept_Manager]= @ManagerID 
	)
GO
/****** Object:  UserDefinedFunction [dbo].[GetStudentDataByInstructorId]    Script Date: 5/22/2023 6:44:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Function [dbo].[GetStudentDataByInstructorId](@Intger int)
Returns Table  
as
	Return
	(
		Select CONVERT(varchar(50),[Manager_hiredate] ,@Intger) as Newdate  ,[Dept_Name],[Manager_hiredate] 
		from  [dbo].[Department]
	)
GO
/****** Object:  Table [dbo].[Course]    Script Date: 5/22/2023 6:44:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Course](
	[Crs_Id] [int] NOT NULL,
	[Crs_Name] [nvarchar](50) NULL,
	[Crs_Duration] [int] NULL,
	[Top_Id] [int] NULL,
 CONSTRAINT [PK_Course] PRIMARY KEY CLUSTERED 
(
	[Crs_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Stud_Course]    Script Date: 5/22/2023 6:44:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stud_Course](
	[Crs_Id] [int] NOT NULL,
	[St_Id] [int] NOT NULL,
	[Grade] [int] NULL,
 CONSTRAINT [PK_Stud_Course] PRIMARY KEY CLUSTERED 
(
	[Crs_Id] ASC,
	[St_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[V1]    Script Date: 5/22/2023 6:44:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[V1]
as
select CONCAT(a.[St_Fname],' ',a.[St_Lname]) [FullName], c.[Crs_Name]
from [dbo].[Student] a inner join [dbo].[Stud_Course] b on a.St_Id = b.St_Id
inner join [dbo].[Course] c on c.Crs_Id= b.Crs_Id
where b.Grade > 50
GO
/****** Object:  Table [dbo].[Topic]    Script Date: 5/22/2023 6:44:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Topic](
	[Top_Id] [int] NOT NULL,
	[Top_Name] [nvarchar](50) NULL,
 CONSTRAINT [PK_Topic] PRIMARY KEY CLUSTERED 
(
	[Top_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ins_Course]    Script Date: 5/22/2023 6:44:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ins_Course](
	[Ins_Id] [int] NOT NULL,
	[Crs_Id] [int] NOT NULL,
	[Evaluation] [nvarchar](50) NULL,
 CONSTRAINT [PK_Ins_Course] PRIMARY KEY CLUSTERED 
(
	[Ins_Id] ASC,
	[Crs_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
