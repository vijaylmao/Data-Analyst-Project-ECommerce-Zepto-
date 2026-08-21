drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

---data exploration

---count of rows
SELECT COUNT(*) FROM zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--null values
SELECT * FROM zepto
WHERE name is NULL
OR
category is NULL
OR
mrp is NULL
OR
discountPercent is NULL
OR
discountedSellingPrice is NULL
OR
weightInGms is NULL
OR
availableQuantity is NULL
OR
outOfStock is NULL
OR
quantity is NULL;

--different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--products in stock vs out of stock
SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

--product names present multiple times
SELECT name, COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;

--data cleaning

--products with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp, discountedSellingPrice FROM zepto

--Q1. find top 10 best-value products based on discount percentage

SELECT DISTINCT name , mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;


--Q2. what are high-MRP products that are currently out of stock
SELECT 	DISTINCT name, mrp
FROM zepto
WHERE outOfStock = TRUE and mrp > 300
ORDER BY mrp DESC;

--Q3.Estimated potential revenue for each product category
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;


--Q4.Filtered expensive products (MRP > ₹500) with minimal discount
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

--Q5.Ranked top 5 categories offering highest average discounts
SELECT category,
ROUND(AVG(discountPercent),2)  AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

--Q6.Calculated price per gram to identify value-for-money products
SELECT DISTINCT name, weightInGms, discountedSellingprice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM Zepto
WHERE weightInGms >=100
ORDER BY price_per_gram;


--Q7.Grouped products based on weight into Low, Medium, and Bulk categories
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'LOW'
WHEN weightInGms < 5000 THEN 'MEDIUM'
ELSE 'BULK'
END AS weight_category
FROM zepto;

--Q8.Measured total inventory weight per product category
SELECT category,
SUM(weightInGms*availableQuantity) AS Total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;



