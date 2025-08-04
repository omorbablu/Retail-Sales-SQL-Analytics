-- =========================================================
-- 📊 Retail Sales Analysis in SQL Server (SSMS)
-- Author: [Your Name or GitHub Handle]
-- Description: Full project to load, clean, explore, and analyze retail sales data
-- =========================================================

-- 🧹 Drop table if it already exists to avoid conflicts
IF OBJECT_ID('retail_sales', 'U') IS NOT NULL
    DROP TABLE retail_sales;
GO

-- 🏗️ Create the table for retail sales
CREATE TABLE retail_sales (
    transaction_id     INT PRIMARY KEY,
    sale_date          DATE,
    sale_time          TIME,
    customer_id        INT,
    gender             VARCHAR(15),
    age                INT,
    category           VARCHAR(15),
    quantity           INT,
    price_per_unit     FLOAT,
    cogs               FLOAT,
    total_sale         FLOAT
);

-- 📥 Import CSV file into the table
-- NOTE: Update the path based on your machine setup
BULK INSERT retail_sales
FROM 'C:\Users\User\Desktop\DA_Projects_for_GIT\retail_sales.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- 🔍 View and inspect data
SELECT * FROM retail_sales;
SELECT TOP 10 * FROM retail_sales;

-- ============================
-- 🔍 Basic Exploration
-- ============================

-- 🔢 Total number of sales
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- 🧼 Null check in individual fields
SELECT * FROM retail_sales WHERE transaction_id IS NULL;
SELECT * FROM retail_sales WHERE sale_date IS NULL;
SELECT * FROM retail_sales WHERE sale_time IS NULL;

-- 🔍 Check all critical fields for NULLs
SELECT *
FROM retail_sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- 🗑️ Delete rows with NULLs in critical fields
DELETE FROM retail_sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- ============================
-- 📈 Data Exploration
-- ============================

-- 👥 Unique customers
SELECT DISTINCT customer_id AS unique_customer FROM retail_sales;

-- 🛍️ Distinct product categories
SELECT DISTINCT category AS unique_category FROM retail_sales;

-- ============================
-- 📊 Business Analysis Queries
-- ============================

-- Q1️⃣: Sales made on 2022-11-05
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2️⃣: Clothing category sales (qty >= 4) in Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity >= 4
  AND YEAR(sale_date) = 2022
  AND MONTH(sale_date) = 11;

-- Alternate using FORMAT()
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND FORMAT(sale_date, 'yyyy-MM') = '2022-11'
  AND quantity >= 4;

-- Q3️⃣: Total sales per category
SELECT category,
       SUM(total_sale) AS net_sales,
       COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- Q4️⃣: Average age of customers who bought from 'Beauty'
SELECT AVG(age) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q5️⃣: Transactions with sales > 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q6️⃣: Total transactions by gender and category
SELECT gender,
       category,
       COUNT(transaction_id) AS total_transaction
FROM retail_sales
GROUP BY gender, category
ORDER BY category;

-- Q7️⃣: Best-selling month in each year based on avg sales
WITH monthly_avg AS (
    SELECT YEAR(sale_date) AS sales_year,
           MONTH(sale_date) AS sales_month,
           AVG(total_sale) AS avg_sales,
           RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS ranking
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT sales_year, sales_month, avg_sales
FROM monthly_avg
WHERE ranking = 1;

-- Q8️⃣: Top 5 customers by total sales
SELECT TOP 5
       customer_id,
       SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC;

-- Q9️⃣: Unique customers per category
SELECT category,
       COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

-- Q🔟: Shift-wise order counts
WITH shift_data AS (
    SELECT *,
           CASE 
               WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
               WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
               ELSE 'Evening'
           END AS shift
    FROM retail_sales
)
SELECT shift,
       COUNT(*) AS total_orders
FROM shift_data
GROUP BY shift;

-- ✅ End of Script
