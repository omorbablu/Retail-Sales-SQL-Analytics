# 🛒 Retail Sales SQL Analytics

A retail sales SQL analytics project using Microsoft SQL Server (SSMS). This project explores monthly sales trends, best-selling categories, and top-performing months using real-world styled data.

---

## 📊 Project Overview

This project includes SQL queries to:

- Analyze average monthly sales
- Identify best-selling months per year
- Filter sales by category and quantity
- Practice date manipulation and window functions

Designed for:
- SQL learners and analysts
- Business intelligence enthusiasts
- Interview preparation and SQL portfolio building

---

## 🧰 Technologies Used

- **SQL Server (SSMS)**
- T-SQL (Transact-SQL)
- Window Functions
- Common Table Expressions (CTEs)
- Aggregation & Ranking

---

## 📁 Files Included

- `best_selling_month.sql` – Finds best-selling month for each year using RANK
- `clothing_sales_nov.sql` – Filters clothing sales for Nov-2022 with quantity conditions
- `monthly_avg_sales.sql` – Calculates monthly average sales
- `README.md` – Project documentation

---

## 📌 Example Query: Best-Selling Month Per Year

```sql
SELECT 
    year,
    month,
    avg_sale
FROM 
(    
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rank
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS t
WHERE rank = 1;
