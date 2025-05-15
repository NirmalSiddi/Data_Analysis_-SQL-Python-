# Data_Analysis_-SQL-Python-
End to End Data Analysis using Python and SQL

# Kaggle Data Analysis Project 🚀

## 📌 Overview
This project involves extracting data from Kaggle using Python, performing data cleaning, and conducting exploratory data analysis (EDA) using SQL. The primary focus is to gain insights into sales data and trends.

## 📊 Data Processing Steps
- **Data Extraction:** Retrieved dataset from Kaggle using Python.
- **Data Cleaning:** Processed and cleaned data to ensure consistency and accuracy.
- **SQL-Based EDA:** Executed SQL queries to generate insights related to sales, profit, and trends.

## 🔍 Key SQL Queries
### 1️⃣ Top 10 Highest Revenue Generating Products
```sql
SELECT TOP 10 product_id, SUM(sale_price) AS Revenue
FROM df_orders
GROUP BY product_id
ORDER BY Revenue DESC;

### 1️⃣**Top 5 Highest Selling Products in Each Region**
WITH cte AS (
    SELECT region, product_id, SUM(sale_price) AS sale
    FROM df_orders
    GROUP BY region, product_id
)
SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY region ORDER BY sale DESC) AS rn
    FROM cte
) A
WHERE rn <= 5;

### 1️⃣ **Month-over-Month Sales Growth Comparison (2022 vs. 2023)**
WITH cte AS (
    SELECT YEAR(order_date) AS order_year, MONTH(order_date) AS order_month, SUM(sale_price) AS sales
    FROM df_orders
    GROUP BY YEAR(order_date), MONTH(order_date)
)
SELECT order_month,
    SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022,
    SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023
FROM cte
GROUP BY order_month
ORDER BY order_month;
```


🏆 **Insights Extracted**
- Identified the top revenue-generating products.
- Discovered region-wise best-selling products.
- Analyzed month-over-month sales trends for two consecutive years.
- Determined the best-performing product categories in various months.
- Found the sub-category with the highest profit growth in 2023.

🛠️ **Technologies Used**
- Python (For data extraction and preprocessing)
- SQL (For executing queries and performing exploratory analysis)
- Kaggle Dataset (Source of raw data)

📂 Project Structure

├── data/                 # Raw dataset from Kaggle

├── scripts/              # Python scripts for data extraction & cleaning

├── sql_queries/          # SQL scripts for EDA

├── README.md             # Project documentation

