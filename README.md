# SQL Project Retail Sales Analysis
## Project Overview
The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. The data table contains 11 columns that include the detail of the retail sales data. Those columns, specified by each data type, are written below:
+ **int**: transaction_id, customer_id, age, quantity
+ **date**: sale_date
+ **time**: sale_time
+ **varchar()**: gender, category
+ **float**: price_per_unit, cogs, total_sale

## Objectives
1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Let's do the project!
### 1. Database Setup
+ **Database Creation**: Here, I use the old database that I have made before named "Perusahaan".
+ **Data uploaded**: The csv file of the retail sales data is uploaded directly from MySQL. The data table is named as "retail".
+ **Modify table**: Right after uploading the data, the table was checked  to see if there any mistake in column naming or wrong data type. I did some corrections for the errors as shown in the following.
``` js
-- modify column name
alter table retail change column ï»¿transactions_id transaction_id int;
alter table retail change column quantiy quantity int;

-- modify data type
alter table retail modify column transaction_id int primary key;
alter table retail modify column sale_date date;
alter table retail modify column sale_time time;
alter table retail modify column price_per_unit float;
alter table retail modify column cogs float;
alter table retail modify column total_sale float;
describe retail;
```

### 2. Data Exploration & Cleaning
+ **Record Count**: Determine the total number of records in the dataset.
+ **Customer Count**: Find out how many unique customers are in the dataset.
+ **Category Count**: Identify all unique product categories in the dataset.
+ **Null Value Check**: Check for any null values in the dataset and delete records with missing data.
```js
SELECT COUNT(*) total_sale FROM retail;
SELECT COUNT(DISTINCT (customer_id)) AS total_sales FROM retail;
SELECT DISTINCT(category) AS categories FROM retail;

SELECT * FROM retail
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
```
### 3. Data Analysis and Findings
Here are some questions to answer the business question and help to develop the business.
**1. Write a SQL query to retrieve all columns for sales made on '2022-11-05**
``` js
SELECT 
    *
FROM
    retail
WHERE
    sale_date = '2022-11-05';
```
**2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**
```js
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

-- show only the sum of quantity of data satisfied the condition
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
```
**3. Write a SQL query to calculate the total sales (total_sale) for each category**
```js
SELECT 
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_order
FROM
    retail
GROUP BY category;
```
**4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category**
```js
SELECT 
    ROUND(AVG(age), 2) AS avg_age
FROM
    retail
WHERE
    category = 'Beauty';
```
**5. Write a SQL query to find all transactions where the total_sale is greater than 1000**
```js
SELECT 
    *
FROM
    retail
WHERE
    total_sale > 1000;
```
**6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category**
```js
SELECT 
    category, gender, COUNT(transaction_id) AS total_transaction
FROM
    retail
GROUP BY 1 , 2;
```
**7. Write a SQL query to find the top 5 customers based on the highest total sales**
```js
SELECT 
    customer_id, SUM(total_sale)
FROM
    retail
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
```
**8. Write a SQL query to find the number of unique customers who purchased items from each category**
```js
SELECT 
    category,
    COUNT(DISTINCT (customer_id)) AS count_of_unique_cs
FROM
    retail
GROUP BY category;
```
**9. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**
```js
-- Syntax to show all the transaction and sale time data specified with the shift category.
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

-- Other syntax shows just how much the transaction done for each shift.
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
```

## What we get from the analysis?
+ **Customer Demographics**: The dataset shows customers of diverse ages, and sales are distributed over several categories, including Clothing and Beauty.
+ **High-Value Transactions**: A few of these transactions involved premium purchases, with the total sale amount exceeding $1,000.
+ **Sales Trends**: Monthly analysis helps determine peak seasons by displaying variances in sales.
+ **Customer insights**: The analysis determines the most popular product categories and the highest-spending clients.

## Conclusion
Database setup, data cleaning, exploratory data analysis, and business-driven SQL queries are all covered in this project, which provides a comprehensive introduction to SQL for data analysts. By comprehending sales trends, consumer behavior, and product performance, this can help us in understanding the business potential.
the project's findings can inform corporate choices.

