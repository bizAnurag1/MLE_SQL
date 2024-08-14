Select * from Purchasing.PurchaseOrderHeader;

Select * from Purchasing.PurchaseOrderDetail;

--all and any:

select PurchaseOrderID, DueDate, UnitPrice
from Purchasing.PurchaseOrderDetail
where DueDate <> all(Select ORderDate from Purchasing.PurchaseOrderHeader);

select PurchaseOrderID, DueDate, UnitPrice
from Purchasing.PurchaseOrderDetail
where DueDate >= any(Select ORderDate from Purchasing.PurchaseOrderHeader);


-- create Database--> Schema--> Table:
create database Bizmetric;
create table Biz.employee(
		eid int primary key,
		ename varchar(200),
		salary int
);

-- not-null & check constraints:
create table Biz.dept(
		did int not null,
		dname varchar(100),
		dsize int check(dsize <= 20));

-- amrita's query:

CREATE TABLE BIZ.Stores (
 
	StoreId INT IDENTITY , 
	StoreNumber VARCHAR(50) , 
	PhoneNumber VARCHAR(13) , 
	Email VARCHAR(50)  , 
	Address VARCHAR(50) , 
	city varchar(50) , 
	State Varchar(10) , 
	Zipcode INT
);
 
select * from BIZ.stores;
 
 
-- check constraints
 
CREATE TABLE BIZ.CheckItems(
 
	ItemId INT IDENTITY(100 , 3) , 
	ItemName Varchar(255) NOT NULL UNIQUE , 
	MinQty INT CHECK(MinQty >= 10)
);

-- creating constraint:

-- view:
CREATE VIEW View_emp_data 
as select * from HumanResources.Employee
where BusinessEntityID < 50
 
 
select * from View_emp_data
