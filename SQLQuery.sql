CREATE TABLE df_orders(
	[order_id] INT PRIMARY KEY
	,[order_date] DATE
	,[ship_mode] VARCHAR(20)
	,[segment] VARCHAR(20)
	,[country] VARCHAR(20)
	,[city] VARCHAR(20)
	,[state] VARCHAR(20)
	,[postal_code] VARCHAR(20)
	,[region] VARCHAR(20)
	,[category] VARCHAR(20)
	,[sub_category] VARCHAR(20)
	,[product_id] VARCHAR(50)
	,[quantity] INT
	,[discount] DECIMAL(7,2)
	,[sale_price] DECIMAL(7,2)
	,[profit] DECIMAL(7,2)
	);

SELECT * FROM df_orders;


-- find top 10 highest revenue generating products
SELECT TOP 10
	product_id, 
	SUM(sale_price) AS Revenue
FROM 
	df_orders
GROUP BY product_id
ORDER BY Revenue DESC;


-- find top 5 highest selling products in each region

select * from df_orders;

WITH cte as(
SELECT 
	region,
	product_id,
	SUM(sale_price) sale
FROM
	df_orders
GROUP BY region,product_id
)
SELECT * FROM(
SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY region ORDER BY sale DESC) as rn
FROM cte
 ) A
 
 WHERE rn <= 5;


-- find month over month growth comparision for 2022 and 2023 sales 

with cte as
(
select
year(order_date) as order_year, month(order_date) as order_month, sum(sale_price) as sales
from df_orders
group by year(order_date), month(order_date)
)

select order_month,
sum(case when order_year = 2022 then sales else 0 end) as sales_2022,
sum(case when order_year = 2023 then sales else 0 end) as sales_2023
from cte
group by order_month
order by order_month
;

-- month names

WITH cte AS (
    SELECT 
        YEAR(order_date) AS order_year, 
        MONTH(order_date) AS order_month, 
        DATENAME(MONTH, order_date) AS month_name, -- Get month name
        SUM(sale_price) AS sales
    FROM df_orders
    GROUP BY YEAR(order_date), MONTH(order_date), DATENAME(MONTH, order_date)
)

SELECT 
    order_month, -- Month number
    month_name, -- Month name
    SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022,
    SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023
FROM cte
GROUP BY order_month, month_name
ORDER BY order_month; -- Ensure correct sorting by month number

-- for each category which month had highest sales
with cte2 as (
select
category, sum(sale_price) as sales,
format(order_date,'yyyyMM') as order_year_month
from df_orders
group by format(order_date,'yyyyMM'), category
)
select
*
from(
select
*,
row_number() over(partition by category order by sales desc) as rn
from cte2
) a
where rn=1;

-- which sub - category has highest growth by profit in 2023 compared to 2022

with cte as
(select 
sub_category, year(order_date) as yearorder, sum(sale_price) as sales
from df_orders
group by sub_category, year(order_date))

, cte2 as (
select
sub_category
,sum(case when yearorder = 2022 then sales else 0 end) as year_2022
,sum(case when yearorder = 2023 then sales else 0 end) as year_2023

from
cte
group by sub_category
)

select top 1 *,
(year_2023-year_2022)*100/year_2022
from cte2
order by (year_2023-year_2022)*100/year_2022 desc;