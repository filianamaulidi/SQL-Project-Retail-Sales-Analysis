SELECT * FROM retail;

-- DATABASE SET UP 
-- 1. Modify column name
alter table retail change column ï»¿transactions_id transaction_id int;
alter table retail change column quantiy quantity int;

-- 2. Modify column data type
alter table retail modify column transaction_id int primary key;
alter table retail modify column sale_date date;
alter table retail modify column sale_time time;
alter table retail modify column price_per_unit float;
alter table retail modify column cogs float;
alter table retail modify column total_sale float;
describe retail;


-- DATA EXPLORATION AND CLEANING
-- 1. How many sales we have
SELECT COUNT(*) total_sale FROM retail;
-- 2. How many unique customers we have
SELECT COUNT(DISTINCT (customer_id)) AS total_sales FROM retail;
-- 3. Mention categories
SELECT DISTINCT (category) AS categories FROM retail;
-- 4. NULL values check
SELECT 
    *
FROM
    retail
WHERE
    transaction_id IS NULL
        OR sale_date IS NULL
        OR sale_time IS NULL
        OR customer_id IS NULL
        OR gender IS NULL
        OR category IS NULL
        OR quantity IS NULL
        OR price_per_unit IS NULL
        OR cogs IS NULL
        OR total_sale IS NULL;
    
SET SQL_SAFE_UPDATES = 0;
DELETE FROM retail 
WHERE
    transaction_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
SET SQL_SAFE_UPDATES = 1;


-- How many sales we have
SELECT 
    COUNT(*) total_sale
FROM
    retail;

-- DATA ANALYSIS & BUSINESS KEY PROBLEMS AND ANSWERS 
-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT 
    *
FROM
    retail
WHERE
    sale_date = '2022-11-05';

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
-- retrieve all data that satisfied the condition
SELECT 
  *
FROM retail
WHERE 
    category = 'Clothing'
    AND 
    sale_date like '2022_11%'
    AND
    quantity >= 4;

-- show only the sum of data satisfied the condition
SELECT  
  category, sum(quantity)
FROM retail
WHERE 
    category = 'Clothing'
    AND 
    sale_date like '2022_11%'
    AND
    quantity >= 4
group by 1;

-- 3. Write a SQL query to calculate the total sales (total_sale) for each category
SELECT 
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_order
FROM
    retail
GROUP BY category;

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT 
    ROUND(AVG(age), 2) AS avg_age
FROM
    retail
WHERE
    category = 'Beauty';

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000
SELECT 
    *
FROM
    retail
WHERE
    total_sale > 1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
SELECT 
    category, gender, COUNT(transaction_id) AS total_transaction
FROM
    retail
GROUP BY 1 , 2;

-- 7. Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
    customer_id, SUM(total_sale)
FROM
    retail
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 8. Write a SQL query to find the number of unique customers who purchased items from each category
SELECT 
    category,
    COUNT(DISTINCT (customer_id)) AS count_of_unique_cs
FROM
    retail
GROUP BY category;

-- 9. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
-- All Data
SELECT 
    transaction_id,
    sale_time,
    COUNT(transaction_id) AS number_of_orders,
    CASE
        WHEN sale_time < '12:00:00' THEN 'Morning'
        WHEN sale_time BETWEEN '12:00:00' AND '17:00:00' THEN 'Afternoon'
        WHEN sale_time > '17:00:00' THEN 'Evening'
    END shift_category
FROM
    retail
GROUP BY transaction_id;

-- Per Shift
WITH hourly_sale
AS
(
SELECT *,
CASE
	when sale_time < '12:00:00' then 'Morning'
	when sale_time between '12:00:00' and '17:00:00' then 'Afternoon' 
	when sale_time > '17:00:00' then 'Evening'
END as shift
FROM retail
)
SELECT 
    shift,
    COUNT(transaction_id) as total_orders    
FROM hourly_sale
GROUP BY shift;