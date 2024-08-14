use AdventureWorks2022;

use AdventureWorks2022;

select * from [HumanResources].[Department];

select * from [HumanResources].[EmployeePayHistory];

-- employee who are having vaccation hr more than 120:
select * from HumanResources.Employee where VacationHours > 120;

-- find max vacation hrs:
select max(VacationHours) from [humanresources].[employee];
 

-- find all employee who works in dept sales:

-- using case values:
select concat(LoginID, ' ', OrganizationLevel),
	NationalIDNumber,
	vacationHours,
	HireDate,
	case when VacationHours > 70 then 'more vacations'
		when VacationHours between 40 and 70 then'average vacations'
	else 'less vacations'
	end as "VACATION LIMIT"
from [HumanResources].[Employee];

-- cast funtion 
select PurchaseOrderID, ModifiedDate
from Purchasing.PurchaseOrderDetail
where CAST(ModifiedDate as date) between '2014-02-03' and '2015-08-12';

-----------------------------------------------------

select * from Production.Product;

select * from Production.Product where ProductNumber like 'L_';

-- below 2 queries have same result:
select * from Production.Product where ProductNumber like 'L[IJKLMN]%';

select * from Production.Product where ProductNumber like 'L[I-N]%';

select * from Production.Product where ProductNumber like 'L[A-Z]-[0-9]%';

select * from Production.Product where ProductNumber like 'L[I-N]-[135]%';

--find department wise count of employee:
select count(BusinessEntityID) as no_of_employee, HumanResources.EmployeeDepartmentHistory.DepartmentID, 
 HumanResources.Department.Name
from HumanResources.EmployeeDepartmentHistory
inner join HumanResources.Department 
on HumanResources.EmployeeDepartmentHistory.DepartmentID = HumanResources.Department.DepartmentID
group by HumanResources.EmployeeDepartmentHistory.DepartmentID, HumanResources.Department.Name;

--second way:
SELECT DEPT.Name, COUNT(*)
  FROM [AdventureWorks2022].[HumanResources].[Employee] EMP
INNER JOIN 
[AdventureWorks2022].[HumanResources].[EmployeeDepartmentHistory] EMPDEPT ON EMP.BusinessEntityID=EMPDEPT.BusinessEntityID
INNER JOIN
[AdventureWorks2022].[HumanResources].[Department] DEPT ON EMPDEPT.DepartmentID=DEPT.DepartmentID
GROUP BY DEPT.Name

-- find details of emp where dept name is eng and prod:
select (select e.BusinessEntityID from HumanResources.Employee e
where e.BusinessEntityID = ed.BusinessEntityID)
from HumanResources.EmployeeDepartmentHistory ed
where DepartmentID in (select DepartmentID from HumanResources.Department d 
						where Name in ('Engineering', 'Production'))


-- windows funtions(lag and lead):
-- lag:
select BusinessEntityID,
	lag(Rate, 2, 0) over (partition by BusinessEntityID order by BusinessEntityID) as pre_emp_rate,
	case when ep.Rate > lag(Rate) over (partition by BusinessEntityID order by BusinessEntityID) then 'Higher rate than previous'
	when ep.Rate < lag(Rate) over (partition by BusinessEntityID order by BusinessEntityID) then 'lesser than previous'
	when ep.Rate = lag(Rate) over (partition by BusinessEntityID order by BusinessEntityID) then 'same rate'
	else 'single value for this BusinessEntityID'
	end as rate_range
from HumanResources.EmployeePayHistory ep;


select BusinessEntityID,
	lag(Rate, 2, 0) over (partition by BusinessEntityID order by BusinessEntityID) as pre_emp_rate,
	case when ep.Rate > lag(Rate) over (partition by BusinessEntityID order by BusinessEntityID) then 'Higher rate than previous'
	when ep.Rate < lag(Rate) over (partition by BusinessEntityID order by BusinessEntityID) then 'lesser than previous'
	when ep.Rate = lag(Rate) over (partition by BusinessEntityID order by BusinessEntityID) then 'same rate'
	end as rate_range
from HumanResources.EmployeePayHistory ep;


-- lead:
select BusinessEntityID,RATE,lead(rate) over(partition by BusinessEntityID order by rate) as lead_value,
case when Rate > lead(rate) over(partition by BusinessEntityID order by rate) then 'highest_vales'
when Rate < lead(rate) over(partition by BusinessEntityID order by rate) then 'less_vales'
when rate = lead(rate) over(partition by BusinessEntityID order by rate) then 'equal'
else 'single value for this BusinessEntityID'
end as comparision
from [HumanResources].[EmployeePayHistory];


select * from HumanResources.Employee;
-- full name, address, birthdate of employee:
select e.BusinessEntityID, p.FirstName + ' ' + p.MiddleName + ' ' + p.LastName as full_name,
		a.AddressLine1+' '+a.City+' '+a.PostalCode as Address,
		e.BirthDate
from HumanResources.Employee e
inner join Person.Person p on e.BusinessEntityID = p.BusinessEntityID
inner join Person.BusinessEntityAddress b on e.BusinessEntityID = b.BusinessEntityID
inner join Person.Address a on e.BusinessEntityID = a.AddressID;


-- just filtering the birthdate > 1985:
select * from (select e.BusinessEntityID, p.FirstName + ' ' + p.MiddleName + ' ' + p.LastName as full_name,
		a.AddressLine1+' '+a.City+' '+a.PostalCode as Address,
		e.BirthDate
		from HumanResources.Employee e
		inner join Person.Person p on e.BusinessEntityID = p.BusinessEntityID
		inner join Person.BusinessEntityAddress b on e.BusinessEntityID = b.BusinessEntityID
		inner join Person.Address a on e.BusinessEntityID = a.AddressID) ab
	where ab.BirthDate > '1985'
	order by ab.BusinessEntityID;


-- find the year wise average standerd cost based on product name:
select * from Production.ProductCostHistory;

select year(c.StartDate) as yr, month(c.StartDate) as mnt, avg(c.StandardCost), p.Name
from Production.ProductCostHistory c
inner join Production.Product p on c.ProductID = p.ProductID
group by year(StartDate), month(StartDate), p.Name;

---------------------------------------------------------------------------------------------------------------------------
-- DAY 2 Questions:


-- 1) find the average currency rate conversion from USD to Algerian Dinar and Australian Doller:
select * from Sales.CurrencyRate;
select * from Sales.Currency;
select * from Sales.CountryRegionCurrency;

select S.CurrencyRateID, S.AverageRate, S.FromCurrencyCode, S.ToCurrencyCode from Sales.CurrencyRate S
where S.FromCurrencyCode = 'USD' and (S.ToCurrencyCode in (select c.CurrencyCode from Sales.Currency c 
														where c.Name ='Algerian Dinar' or c.Name ='Australian Dollar'));



-- 2) Find the products having offer on it and display product name , safety Stock Level, Listprice,  and product model id, 
--	type of discount,  percentage of discount,  offer start date and offer end date
select * from Sales.SpecialOffer;
select * from Sales.SpecialOfferProduct;
select * from Production.Product;

select p.Name, p.SafetyStockLevel, p.ListPrice, p.ProductModelID, o.Type, o.DiscountPct, o.StartDate, o.EndDate
from Production.Product p
inner join Sales.SpecialOfferProduct op on p.ProductID = op.ProductID
inner join Sales.SpecialOffer o on o.SpecialOfferID = op.SpecialOfferID; 

-- 3)create  view to display Product name and Product review
create view V_product_name_review  
as select pp.ProductID , pp.Name , ppr.Comments AS Review from Production.Product pp
inner join Production.ProductReview ppr
ON pp.ProductID = ppr.ProductID;

select * from V_product_name_review;

-- 4) find out the vendor for product  paint, Adjustable Race and blade
select * from Purchasing.Vendor;
select * from Production.Product;
select * from Purchasing.ProductVendor;

select * from Purchasing.Vendor v
inner join Purchasing.ProductVendor pv on v.BusinessEntityID = pv.BusinessEntityID
inner join Production.Product p on pv.ProductID = p.ProductID where p.Name in (select ProductID from Production.Product pp 
											where pp.Name like 'Paint%' or pp.Name like 'Blade' or pp.Name like 'Adjustable%');

select pp.Name , pv.Name from Production.Product pp
Inner Join Purchasing.ProductVendor  ppv
ON pp.ProductID = ppv.ProductID
Inner Join Purchasing.Vendor pv
On ppv.BusinessEntityID = pv.BusinessEntityID
Where pp.Name Like 'Paint%' OR pp.name Like 'Adjustable Race' OR pp.Name Like 'Blade'
 
-- 5) find product details shipped through ZY - EXPRESS
select * from Purchasing.ShipMethod;
select * from Purchasing.PurchaseOrderDetail;
select * from Purchasing.PurchaseOrderHeader;

select distinct p.ProductID , p.Name , oh.ShipMethodID , sm.ShipMethodID , sm.Name from Production.Product p
inner join Purchasing.PurchaseOrderDetail od on p.ProductID = od.ProductID
inner join Purchasing.PurchaseOrderHeader oh on oh.PurchaseOrderID = od.PurchaseOrderID
inner join Purchasing.ShipMethod sm
on oh.ShipMethodID = sm.ShipMethodID
where sm.Name = 'ZY - EXPRESS'


-- 6) find the tax amt for products where order data and ship data are on the same day
select * from Production.Product;
select * from Purchasing.PurchaseOrderDetail;
select * from Purchasing.PurchaseOrderHeader;

select p.ProductID, p.Name, ph.TaxAmt from Production.Product p 
inner join Purchasing.PurchaseOrderDetail pd on p.ProductID = pd.ProductID
inner join Purchasing.PurchaseOrderHeader ph on pd.PurchaseOrderID = ph.PurchaseOrderID
where ph.OrderDate = ph.ShipDate;

-- 7) find the average days required to ship the product based on shipment type.
select * from Purchasing.ShipMethod;
select * from Purchasing.PurchaseOrderHeader;

select s.Name, avg(Datediff(day, ph.OrderDate, ph.ShipDate)) as avg_days from Purchasing.ShipMethod s
inner join Purchasing.PurchaseOrderHeader ph on s.ShipMethodID = ph.ShipMethodID
group by s.Name;

-- 8) find the name of employees working in day shift:
select * from HumanResources.Shift;
select * from HumanResources.EmployeeDepartmentHistory;
select * from HumanResources.Employee;
select * from Person.Person;

select * from Person.Person p 
inner join HumanResources.EmployeeDepartmentHistory ed on p.BusinessEntityID = ed.BusinessEntityID
inner join HumanResources.Shift s on ed.ShiftID = s.ShiftID
where s.Name = 'Day';

-- 9) based on product and product cost history find the name , service provider time and average Standardcost  
select * from Production.Product;
select * from Production.ProductCostHistory;

select p.Name, avg(pc.StandardCost) as Avg_Standard_cost, avg(datediff(day, pc.StartDate, pc.EndDate)) as Avg_days 
from Production.Product p
inner join Production.ProductCostHistory pc on p.ProductID = pc.ProductID
group by p.Name;

-- 10) find products with average cost more than 500
select p.name, avg(pc.StandardCost) from Production.Product p 
inner join Production.ProductCostHistory pc on p.ProductID = pc.ProductID
group by p.name
having avg(pc.StandardCost)>500;

-- 11) find the employee name and ID who worked in multiple territory
select * from Sales.SalesTerritory;
select * from Sales.SalesTerritoryHistory;
select * from Person.Person;

select p.BusinessEntityID, p.FirstName, count(st.TerritoryID) from Person.Person p 
inner join Sales.SalesTerritoryHistory st on p.BusinessEntityID = st.BusinessEntityID
group by p.BusinessEntityID, p.FirstName
having count(st.TerritoryID) > 1;

-- 12) find out the Product model name,  product description for culture  as Arabic 
select * from Production.ProductModel;
select * from Production.ProductDescription;
select * from Production.Culture;
select * from Production.ProductModelProductDescriptionCulture;

select m.ProductModelID, m.Name, d.Description, c.Name from Production.ProductModel m
inner join Production.ProductModelProductDescriptionCulture mdc on m.ProductModelID = mdc.ProductModelID
inner join Production.ProductDescription d on mdc.ProductDescriptionID = d.ProductDescriptionID
inner join Production.Culture c on mdc.CultureID = c.CultureID
where c.Name = 'Arabic';