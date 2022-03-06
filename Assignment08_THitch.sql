--*************************************************************************--
-- Title: Assignment08
-- Author: THitch
-- Desc: This file demonstrates how to use Stored Procedures
-- Change Log: When,Who,What
-- 2022-03-01,THitch,Created File
-- 2022-03-05,THitch, Continued creation of file Categories Procedures
-- 2022-03-06,THitch, Completed creation of file Inventories, 
--					  Employees and Products Procedures
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment08DB_THitch')
	 Begin 
	  Alter Database [Assignment08DB_THitch] set Single_user With Rollback Immediate;
	  Drop Database Assignment08DB_THitch;
	 End
	Create Database Assignment08DB_THitch;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment08DB_THitch;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [money] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL -- New Column
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
-- NOTE: We are starting without data this time!

-- Adding Views (Module 06) -- 
Create View vCategories With SchemaBinding
 AS
  Select CategoryID, CategoryName From dbo.Categories;
go
Create View vProducts With SchemaBinding
 AS
  Select ProductID, ProductName, CategoryID, UnitPrice From dbo.Products;
go
Create View vEmployees With SchemaBinding
 AS
  Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID From dbo.Employees;
go
Create View vInventories With SchemaBinding 
 AS
  Select InventoryID, InventoryDate, EmployeeID, ProductID, [Count] From dbo.Inventories;
go

/********************************* Questions and Answers *********************************/
/* NOTE:Use the following template to create your stored procedures and plan on this taking ~2-3 hours

Create Procedure <pTrnTableName>
 -- (<@P1 int = 0>)
 -- Author: <THitch>
 -- Desc: Processes <Desc text>
 -- Change Log: When,Who,What
 -- <2022-03-05>,<THitch>,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	-- Transaction Code --
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go
*/

-- Question 1 (20 pts): How can you create Insert, Update, and Delete Transactions Store Procedures  
-- for the Categories table?


--Create Procedure pInsCategories
--< Place Your Code Here!>--
go
Use Assignment08DB_THitch
go
Create OR ALTER Procedure pInsCategories
 @CategoryName nvarchar(100) = ' '
 -- Author: <THitch>
 -- Desc: Processes, Categories table insert 
 -- Change Log: When,Who,What
 -- <2022-03-05>,<THitch>,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	INSERT INTO Categories(CategoryName)
	VALUES (@CategoryName);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go
-- pInsCategories 'Soda'
-- SELECT * FROM VCategories
-------------------------------------------------------------------------------

--Create Procedure pUpdCategories
--< Place Your Code Here!>--
go
Use Assignment08DB_THitch
go
Create Procedure pUpdCategories
(@CategoryID int = 0, @CategoryName nvarchar(100)=' ')
 -- Author: <THitch>
 -- Desc: Processes Updating category names
 -- Change Log: When,Who,What
 -- <2022-03-05>,<THitch>,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	UPDATE Categories
	SET CategoryName = @CategoryName
	WHERE Categoryid = @CategoryID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go
-- pInsCategories 'Soda'
-- pUpdCategories 1, 'Drinks'
-- SELECT * FROM VCategories
-- DELETE FROM Categories
-------------------------------------------------------------------------------

--Create Procedure pDelCategories
--< Place Your Code Here!>--
-- DDOP
go
Use Assignment08DB_THitch
go
Create Procedure pDelCategories
(@CategoryID int = 0, @CategoryName nvarchar(100)=' ')
 -- Author: <THitch>
 -- Desc: Processes Deleting Categories
 -- Change Log: When,Who,What
 -- <2022-03-05>,<THitch>,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	DELETE Categories
	WHERE Categoryid = @CategoryID AND CategoryName = @CategoryName;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go
-- pInsCategories 'Dry Goods'
-- pUpdCategories 1, 'Drinks'
-- SELECT * FROM VCategories
-- pDelCategories 1, 'Drinks'
-------------------------------------------------------------------------------

-- Question 2 (20 pts): How can you create Insert, Update, and Delete Transactions Store Procedures  
-- for the Products table?


--Create Procedure pInsProducts
--< Place Your Code Here!>--
go
Use Assignment08DB_THitch
go
Create Procedure pInsProducts
(@ProductName nvarchar(100)=' ', @CategoryID int = 0, @UnitPrice money = 0)
 -- Author: <THitch>
 -- Desc: Inserting Updating Product Table
 -- Change Log: When,Who,What
 -- <2022-03-06>,<THitch>,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	INSERT INTO Products
	(ProductName, CategoryID, UnitPrice)
	VALUES
	(@ProductName, @CategoryID, @UnitPrice);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go
-- EXEC pInsProducts 'Dog Food', 1, 9.99
-- SELECT * FROM vProducts
-------------------------------------------------------------------------------
--Create Procedure pUpdProducts
--< Place Your Code Here!>--
go
Use Assignment08DB_THitch
go
Create Procedure pUpdProducts
	(@ProductID int = 0, @ProductName nvarchar(100)=' '
	, @CategoryID int = 0, @UnitPrice money = 0)
 -- Author: <THitch>
 -- Desc: Inserting Updating Product Table
 -- Change Log: When,Who,What
 -- <2022-03-06>,<THitch>,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	UPDATE Products
	SET ProductName = @ProductName, CategoryID = @CategoryID, UnitPrice = @UnitPrice
	WHERE CategoryID = @CategoryID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go
-- EXEC pInsProducts 'Dog Food', 2, 9.99
-- SELECT * FROM vProducts
-- EXEC pUpdProducts 3, 'Cat Food', 2, 8.99
-- SELECT * FROM vProducts

-------------------------------------------------------------------------------
--Create Procedure pDelProducts
--< Place Your Code Here!>--
go
Use Assignment08DB_THitch
go
Create Procedure pDelProducts
	(@ProductID int = 0, @ProductName nvarchar(100)=' ')
 -- Author: <THitch>
 -- Desc: Inserting Deleting From Product Table
 -- Change Log: When,Who,What
 -- <2022-03-06>,<THitch>,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	DELETE Products
	WHERE ProductName = @ProductName AND ProductID = @ProductID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go
-- SELECT * FROM vProducts
-- EXEC pDelProducts 3, 'Cat Food'

-------------------------------------------------------------------------------
-- Question 3 (20 pts): How can you create Insert, Update, and Delete Transactions Store Procedures  
-- for the Employees table?
--Create Procedure pInsEmployees
--< Place Your Code Here!>--
go
Use Assignment08DB_THitch
go

Create Procedure pInsEmployees
	(@EmployeeFirstName nvarchar(100) = ' '
	, @EmployeeLastName nvarchar(100) = ' ', @ManagerID int = 0)
 -- Author: <THitch>
 -- Desc: Inserting Into the Employee Table
 -- Change Log: When,Who,What
 -- <2022-03-06>,<THitch>,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	INSERT INTO Employees
	(EmployeeFirstName, EmployeeLastName, ManagerID)
	VALUES
	(@EmployeeFirstName, @EmployeeLastName, @ManagerID)
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go
-- EXEC pInsEmployees 'Tim', 'Smith', 1
-- SELECT * FROM vEmployees
-------------------------------------------------------------------------------

--Create Procedure pUpdEmployees
--< Place Your Code Here!>--
go
Use Assignment08DB_THitch
go

Create Procedure pUpdEmployees
	(@EmployeeID int = 0, @EmployeeFirstName nvarchar(100) = ' '
	, @EmployeeLastName nvarchar(100) = ' ', @ManagerID int = 0)
 -- Author: <THitch>
 -- Desc: Update the Employee Table
 -- Change Log: When,Who,What
 -- <2022-03-06>,<THitch>,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	UPDATE Employees
	SET
	EmployeeFirstName = @EmployeeFirstName
	, EmployeeLastName = @EmployeeLastName
	, ManagerID = @ManagerID
	WHERE
	EmployeeID = @EmployeeID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go
--SELECT * FROM vEmployees
--EXEC pUpdEmployees 1,'Tim','Hitch',1 
-------------------------------------------------------------------------------

--Create Procedure pDelEmployees
--< Place Your Code Here!>--
go
Use Assignment08DB_THitch
go

Create Procedure pDelEmployees
	(@EmployeeID int = 0, @EmployeeFirstName nvarchar(100) = ' '
	, @EmployeeLastName nvarchar(100) = ' ')
 -- Author: <THitch>
 -- Desc: Delete From the Employee Table
 -- Change Log: When,Who,What
 -- <2022-03-06>,<THitch>,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	DELETE Employees
	WHERE
	EmployeeID = @EmployeeID 
	AND EmployeeFirstName = @EmployeeFirstName 
	AND EmployeeLastName = @EmployeeLastName;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go
-- SELECT * FROM vEmployees
-- EXEC pDelEmployees 2, 'Tim', 'Smith'
-------------------------------------------------------------------------------

-- Question 4 (20 pts): How can you create Insert, Update, and Delete Transactions Store Procedures  
-- for the Inventories table?
--Create Procedure pInsInventories
--< Place Your Code Here!>--
go
Use Assignment08DB_THitch
go

Create Procedure pInsInventories
	(@InventoryDate date = '1.1.1900', @EmployeeID int = 0
	, @ProductID int = 0, @Count int = 0 )
 -- Author: <THitch>
 -- Desc: Insert Into Inventories
 -- Change Log: When,Who,What
 -- <2022-03-06>,<THitch>,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	INSERT INTO Inventories
	(InventoryDate,EmployeeID, ProductID, Count)
	VALUES
	(@InventoryDate, @EmployeeID, @ProductID, @Count)
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go
--SELECT * FROM vProducts
--EXEC pInsInventories '3.26.2022', 1, 2, 5
--SELECT * FROM vInventories

-------------------------------------------------------------------------------
--Create Procedure pUpdInventories
--< Place Your Code Here!>--
go
Use Assignment08DB_THitch
go

Create Procedure pUpdInventories
	(@InventoryID int = 0, @InventoryDate date = '1.1.1900', @EmployeeID int = 0
	, @ProductID int = 0, @Count int = 0 )
 -- Author: <THitch>
 -- Desc: Update Inventories
 -- Change Log: When,Who,What
 -- <2022-03-06>,<THitch>,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	UPDATE Inventories
	SET InventoryDate = @InventoryDate
	, EmployeeID = @EmployeeID
	, ProductID = @ProductID
	, Count = @Count
	WHERE InventoryID = @InventoryID;	
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go
--SELECT * FROM vInventories
--EXEC pUpdInventories 2, '01.01.2021', 1, 2, 5000
-------------------------------------------------------------------------------

--Create Procedure pDelInventories
--< Place Your Code Here!>--
go
Use Assignment08DB_THitch
go

Create Procedure pDelInventories
	(@InventoryID int = 0, @InventoryDate date = '1.1.1900')
 -- Author: <THitch>
 -- Desc: Delete Inventories
 -- Change Log: When,Who,What
 -- <2022-03-06>,<THitch>,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	DELETE Inventories
	WHERE InventoryID = @InventoryID AND InventoryDate = @InventoryDate;	
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go
--SELECT * FROM vInventories
--EXEC pDelInventories 2, '1.1.2021'
-------------------------------------------------------------------------------

-- Question 5 (20 pts): How can you Execute each of your Insert, Update, and Delete stored procedures? 
-- Include custom messages to indicate the status of each sproc's execution.

-- Here is template to help you get started:
/*
Declare @Status int;
Exec @Status = <SprocName>
                @ParameterName = 'A'
Select Case @Status
  When +1 Then '<TableName> Insert was successful!'
  When -1 Then '<TableName> Insert failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From <ViewName> Where ColID = 1;
go
*/


--< Test Insert Sprocs >--
-- Test [dbo].[pInsCategories]
Declare @Status int;
Exec @Status = pInsCategories
                @CategoryName = 'A'
Select Case @Status
  When +1 Then 'Categories Insert was successful!'
  When -1 Then 'Categories Insert failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From vCategories Where CategoryID = @@IDENTITY;
go

-- Test [dbo].[pInsProducts]
Declare @Status int;
Exec @Status = pInsProducts
                @ProductName = 'A', @CategoryID = 1, @UnitPrice = 9.99
Select Case @Status
  When +1 Then 'Products Insert was successful!'
  When -1 Then 'Products Insert failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From vProducts Where ProductID = @@IDENTITY;
go

-- Test [dbo].[pInsEmployees]
Declare @Status int;
Exec @Status = pInsEmployees
                @EmployeeFirstName = 'Abe', @EmployeeLastName = 'Archer', @ManagerID = 1
Select Case @Status
  When +1 Then 'Employee Insert was successful!'
  When -1 Then 'Employee Insert failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From vEmployees Where EmployeeID = @@IDENTITY;
go

-- Test [dbo].[pInsInventories]
Declare @Status int;
Exec @Status = pInsInventories
                @InventoryDate = '1.1.2017', @EmployeeID = 1, @ProductID = 1, @Count = 42
Select Case @Status
  When +1 Then 'Inventories Insert was successful!'
  When -1 Then 'Inventories Insert failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From vInventories Where InventoryID = @@IDENTITY;
go

--< Test Update Sprocs >--
-- Test Update [dbo].[pUpdCategories]
Declare @Status int;
Exec @Status = pUpdCategories
                @Categoryid = 1, @CategoryName = 'B'
Select Case @Status
  When +1 Then 'Categories Update was successful!'
  When -1 Then 'Categories Update failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From vCategories Where CategoryID = 1;
go

-- Test [dbo].[pUpdProducts]
Declare @Status int;
Exec @Status = pUpdProducts
                @Productid = 1, @ProductName = 'B', @CategoryID = 1, @UnitPrice = 1.00
Select Case @Status
  When +1 Then 'Products Update was successful!'
  When -1 Then 'Products Update failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From vProducts Where ProductID = 1;
go

-- Test [dbo].[pUpdEmployees]
Declare @Status int;
Exec @Status = pUpdEmployees
               @EmployeeID = 1, @EmployeeFirstName = 'Abe', @EmployeeLastName = 'Arch', @ManagerID = 1
Select Case @Status
  When +1 Then 'Employee Update was successful!'
  When -1 Then 'Employee Update failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From vEmployees Where EmployeeID =1;
go

-- Test [dbo].[pUpdInventories]
Declare @Status int;
Exec @Status = pUpdInventories
                @InventoryID = 1, @InventoryDate = '1.2.2017', @EmployeeID = 1, @ProductID = 1, @Count = 43
Select Case @Status
  When +1 Then 'Inventories Update was successful!'
  When -1 Then 'Inventories Update failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From vInventories Where InventoryID = 1;
go

--< Test Delete Sprocs >--
-- Test [dbo].[pDelInventories]
Declare @Status int;
Exec @Status = pDelInventories
                @InventoryID = 1, @InventoryDate = '1.2.2017'
Select Case @Status
  When +1 Then 'Inventories Delete was successful!'
  When -1 Then 'Inventories Delete failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From vInventories;
go

-- Test [dbo].[pDelEmployees]
Declare @Status int;
Exec @Status = pDelEmployees
               @EmployeeID = 1, @EmployeeFirstName = 'Abe', @EmployeeLastName = 'Arch'
Select Case @Status
  When +1 Then 'Employee Delete was successful!'
  When -1 Then 'Employee Delete failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From vEmployees;
go

-- Test [dbo].[pDelProducts]
Declare @Status int;
Exec @Status = pDelProducts
                @Productid = 1, @ProductName = 'B'
Select Case @Status
  When +1 Then 'Products Delete was successful!'
  When -1 Then 'Products Delete failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From vProducts;
go

-- Test [dbo].[pDelCategories]
Declare @Status int;
Exec @Status = pDelCategories
                @Categoryid = 1, @CategoryName = 'B'
Select Case @Status
  When +1 Then 'Categories Delete was successful!'
  When -1 Then 'Categories Delete failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From vCategories;
go

--{ IMPORTANT!!! }--
-- To get full credit, your script must run without having to highlight individual statements!!!  

/***************************************************************************************/