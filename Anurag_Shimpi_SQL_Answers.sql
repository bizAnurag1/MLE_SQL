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

select p.Name, v.Name from Production.Product p
Inner Join Purchasing.ProductVendor  pv ON p.ProductID = pv.ProductID
Inner Join Purchasing.Vendor v On pv.BusinessEntityID = pv.BusinessEntityID
Where p.Name Like 'Paint%' OR p.name Like 'Adjustable Race' OR p.Name Like 'Blade'
 
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
select * from Person.Person;

select p.FirstName + ' ' + p.MiddleName + ' ' + p.LastName as full_name, s.Name from Person.Person p 
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