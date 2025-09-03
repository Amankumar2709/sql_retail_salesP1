-- SQL Retail Sales Analysis - P1--
show databases;
use sql_project;
show tables;
select * from retail_sales;

SELECT * FROM retail_sales
LIMIT 10;

SELECT 
    COUNT(*) 
FROM retail_sales;

-- Data Cleaning
SELECT * FROM retail_sales
WHERE transaction_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT COUNT(*) AS rows_to_delete
FROM retail_sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales;

-- How many uniuque customers we have ?
SELECT COUNT(DISTINCT customer_id) as total_sale 
FROM retail_sales;


-- How many uniuque category we have ?
SELECT DISTINCT category 
FROM retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * 
FROM retail_sales
where sale_date = '2022-11-05' ;

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022

select 
* FROM retail_sales
WHERE category = 'Clothing' -- category
AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11' -- month of Nov-2022
AND quantity >=4; --  quantity sold is more than or equal to 4 

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select 
	category,
    SUM(total_sale) AS NET_SALE,
    count(*) AS TOTAL_ORDERS
FROM retail_sales
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select 
	round(AVG(age),2) AS Average_Age
    FROM retail_sales
    where category = 'Beauty';
    
    -- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
    select *
    from retail_sales
    WHERE total_sale > 1000
    order by 1;
    
    -- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
    SELECT  
    gender,
    category,
    COUNT(transaction_id) AS Total_transactions
FROM retail_sales
GROUP BY gender, category
ORDER BY  1;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
WITH monthly_avg AS(
    SELECT 
        YEAR(sale_date)   AS yr,
        MONTH(sale_date)  AS mn,
        AVG(total_sale)   AS avg_total_sale
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT 
    yr,
    mn,
    avg_total_sale
FROM (
    SELECT 
        yr,
        mn,
        avg_total_sale,
        RANK() OVER (PARTITION BY yr ORDER BY avg_total_sale DESC) AS rnk
    FROM monthly_avg
) ranked
WHERE rnk = 1
ORDER BY yr;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
customer_id,
sum(total_sale) AS TOTAL_SALES
 FROM retail_sales
GROUP BY 1 
ORDER BY 2 desc
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
category,
COUNT(DISTINCT customer_id) as Unique_customer
FROM retail_sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;

