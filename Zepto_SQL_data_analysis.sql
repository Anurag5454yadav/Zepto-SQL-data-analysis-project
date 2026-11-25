drop table if exists zepto;


CREATE TABLE zepto(
sku_id serial PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150)NOT NULL,
mrp NUMERIC (8,2),
discountPercentage NUMERIC(5,2),
avilableQuantity INTEGER,
discountedSellingprice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity integer
);

-- data exploration

-- count of rows
SELECT COUNT(*) FROM zepto;

-- sample data
SELECT * FROM zepto 
ORDER BY sku_id ASC LIMIT 10;

-- NULL VALUE
SELECT * FROM zepto
WHERE name is null 
or
category is null 
or
mrp is null 
or
discountpercentage is null 
or
avilablequantity is null 
or
discountedsellingprice is null 
or
weightingms is null 
or
outofstock is null 
or
quantity is null;

-- different product category
select DISTINCT category
from zepto
ORDER BY category ASC;

-- PRODUCT IN STIOC VS PRODUCT  OUT OF STOCK
SELECT outofstock, count(sku_id)
FROM zepto
GROUP BY outofstock;

-- product name present multipul times
select name , count(sku_id) AS NUMBER_OF_SKUs
from zepto
group by name 
having count (sku_id)>1
order by count(sku_id) DESC;

-- DATA CLEANING

-- product with price = 0
SELECT * FROM zepto
WHERE mrp = 0 or discountedsellingprice = 0;

delete from zepto
WHERE MRP = 0;

--CONVERT PAISE TO RUPEES
UPDATE zepto
set mrp = mrp/100.0,
discountedsellingprice = discountedsellingprice/100.0;

select mrp ,discountedsellingprice from zepto;

--Q1. Find the top 10 best-value products based on the discount percentage.
select distinct name , mrp ,discountPercentage
from zepto
order by discountPercentage Desc
limit 10;

-- Q2.What are the Products with High MRP but Out of Stock
SELECT DISTINCT name ,mrp
FROM zepto 
where outofstock = 'true' and mrp >300
order by mrp DESC;


-- Q3.Calculate Estimated Revenue for each category
SELECT category ,
SUM(discountedsellingprice*AVILABLEQUANTITY) AS total_revenue
from zepto
GROUP BY category
ORDER BY total_revenue DESC;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT NAME , MRP , discountpercentage
FROM zepto
WHERE mrp > 500 AND discountpercentage < 10
ORDER BY mrp DESC , discountpercentage DESC; 

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category ,
round(avg(discountpercentage),2) as avg_discount
from zepto
group by category
order by avg_discount DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.

SELECT DISTINCT NAME, weightingms , discountedsellingprice, 
ROUND(discountedsellingprice/weightingms,2) as price_per_gram
from zepto
WHERE weightINgms >= 100
order by price_per_gram;

--Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;

--Q8.What is the Total Inventory Weight Per Category 
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;








