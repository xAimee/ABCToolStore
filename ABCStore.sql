--Create a new Database for ABC Tool Store--
CREATE DATABASE ABCToolStore


-- Use the database--
USE ABCToolStore

--No need to create a new schema you can use the default .dbo schema--

-- Create a tool category table--
CREATE TABLE ToolCat
(ToolCatID int Identity(1,1) not null,
ToolCatName varchar(25) not null
Primary Key (ToolCatID)

);

-- Create a tool table--
CREATE TABLE Tool
(ToolID int Identity(1,1) not null,
ToolName varchar(25) not null,
/* change datatype*/
UnitPrice int not null,
ToolCatID int,
Primary Key (ToolID),
Constraint FK_ToolCat Foreign Key (ToolCatID)
References ToolCat(ToolCatID)
);

-- Create a customer table--
CREATE TABLE Customer
(CustID int identity(1,1) not null,
Primary Key (CustID),
CustName varchar(25) not null,
CustSurname varchar(30) not null,
CustIDNumber float not null,
CustNumber int not null,

/*Foreign Key for Tool Table*/
ToolID int,
Constraint FK_ToolCust Foreign Key (ToolID)
References Tool(ToolID),
);

--Create table for Roles--
CREATE TABLE Roles
(RoleID int Identity(1,1) not null,
Primary Key (RoleID),
RoleInCompany varchar(25));

-- Create Table for Staff--
CREATE TABLE Staff
(
StaffID int Identity(1,1) not null,
Primary Key (StaffID),
StaffName varchar(25) not null,
StaffSurname varchar(25) not null,
StaffIDNumber float not null,

/*Foreign Key for Roles Table*/
RoleID int,
Constraint FK_RoleStaff Foreign Key (RoleID)
References Roles(RoleID)

)

-- Create Purchase Table-- 
CREATE TABLE Purchase 
(
PurcID int Identity(1,1) not null,
Primary Key (PurcID),
[DateAndTime] TimeStamp,
Quantity int,

/*Foreign Key for Customer Table*/
CustID int,
Constraint FK_CustPurc Foreign Key (CustID)
References Customer(CustID),


/*Foreign Key for Staff Table*/
StaffID int,
Constraint FK_StaffPurc Foreign Key (StaffID)
References Staff(StaffID),

/*Foreign Key for Tool Table*/
ToolID int,
Constraint FK_ToolPurc Foreign Key (ToolID)
References Tool(ToolID)
)

-- Create a non clustered index for the staff table
Create Nonclustered index[NClustered_Staff]
 on Staff([StaffID]ASC)

--Insert default values into the ToolCat Table--
INSERT INTO ToolCat(ToolCatName)
VALUES('Screwdriver'),
	  ('Pliers'),
	  ('Tool Storage'),
      ('Cutting Tools'), 
      ('Measuring Tools')


--Insert default values into the Tool Table--
INSERT INTO Tool(ToolName, UnitPrice,ToolCatID)
VALUES
('Phillips', 29,1),
('Pozi', 35,1),
('Slotted', 30,1),
('Long Nose', 49,2),
('Locking', 55,2),
('7 Drawer Mobile Cabinet', 899,3),
('Hacksaw', 155,4),
('Utility Knife', 65,4),
('Tape Measuring', 75,5)

--Insert default values into the Customer Table--
Insert Into Customer(CustIDNumber, CustName, CustSurname, CustNumber, ToolID)
VALUES
(8809034534534, 'Dean', 'Jones', 0614747625, 2),
(9203033535531, 'Sieth', 'Groban',  0614545670,4)

--Insert default values into the roles table--
INSERT INTO Roles(RoleInCompany)
VALUES('Clerk'),
('Manager'),
('Assistant Manager'),
('Supervisor')

--Insert default values into the Staff table--
INSERT INTO Staff(StaffName, StaffSurname, StaffIDNumber, RoleID)
Values
('Julia', 'Kanosa', 6502109293944, 1),
('Quentin','Alessa',8808067743352,3) 


--Insert default values into the Purchase table--
Insert Into Purchase(DateAndTime, ToolID ,Quantity, StaffID, CustID)
Values
(Default, 1, 4,1,2 ),
(Default, 2, 4, 2,1)





--Total Column for Purchase
Select Purchase.PurcID, Purchase.DateAndTime, Tool.UnitPrice, Purchase.Quantity, Tool.ToolName, Tool.UnitPrice * Purchase.Quantity As Total
From Purchase 
Inner Join Tool 
On Purchase.ToolID = Tool.ToolID
 



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- Create Insert Staff Procedure 
CREATE Procedure StaffInsert

@StaffName varchar(25),
@StaffSurname varchar(25),
@StaffIDNumber float,
@RoleID int

AS

INSERT INTO [dbo].[Staff] 
           ([StaffName] ,[StaffSurname] ,[StaffIDNumber] ,[RoleID] )
     VALUES
           (@StaffName, 
           @StaffSurname, 
           @StaffIDNumber, 
           @RoleID)
GO


-- Execute StaffInsert Procedure 

Exec StaffInsert

@StaffName = 'Jill',
@StaffSurname = 'Scott',
@StaffIDNumber = 2342348234212,
@RoleID = 5




-- View all products Procedure 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure ViewProducts
@ToolID int

AS

Select * from Tool


--Execute ViewProducts 

Exec ViewProducts

@ToolID = 1

--Use ABCToolStore

Create View [CustToolPurc_View] AS
Select Tool.ToolName,Customer.CustID , Customer.CustName, Customer.CustSurname, Staff.StaffID, Staff.StaffName, StaffSurname
From Tool
Inner Join Purchase
On Purchase.ToolID = Tool.ToolID
Inner Join Customer
On Customer.CustID = Purchase.CustID
Inner join Staff
on Staff.StaffID = Purchase.StaffID

--               Drop View [CustToolPurc_View]

select * from CustToolPurc_View