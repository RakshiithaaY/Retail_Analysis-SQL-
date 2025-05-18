--- SQL Retail Sales Analysis ---

--Create Table
 CREATE TABLE reatil_sales
 (
     transactions_id INT PRIMARY KEY,	
	 sale_date DATE,
	 sale_time TIME,
	 customer_id INT,
	 gender	VARCHAR(15),
	 age INT,
	 category	VARCHAR(15),
	 quantiy	INT,
	 price_per_unit	FLOAT,
	 cogs	FLOAT,
	 total_sale FLOAT

  )


--- DATA CLEANING---

 SELECT * FROM reatil_sales
 LIMIT 20;

SELECT * FROM reatil_sales
WHERE transactions_id IS NULL
       OR 
	   sale_date IS NULL
	   OR
	   sale_time IS NULL
	   OR
	   customer_id IS NULL
	   OR
	   gender IS NULL
	   OR 
	   age IS NULL
	   OR 
	   category IS NULL
	   OR
	   quantiy IS NULL
	   OR
	   price_per_unit IS NULL
	   OR
	   cogs IS NULL
	   OR 
	   total_sale IS NULL

DELETE FROM reatil_sales
WHERE transactions_id IS NULL
       OR 
	   sale_date IS NULL
	   OR
	   sale_time IS NULL
	   OR
	   customer_id IS NULL
	   OR
	   gender IS NULL
	   OR 
	   age IS NULL
	   OR 
	   category IS NULL
	   OR
	   quantiy IS NULL
	   OR
	   price_per_unit IS NULL
	   OR
	   cogs IS NULL
	   OR 
	   total_sale IS NULL;

SELECT COUNT(*) FROM reatil_sales;

---DATA EXPLORATION---

--Q1. How many Sales we have?--
SELECT COUNT(*) as total_sale FROM reatil_sales

--Q2. How many customers we have?--
SELECT COUNT(DISTINCT customer_id)  as total_sale FROM reatil_sales

--Q3. How many categories we have?--
SELECT DISTINCT category FROM reatil_sales

---DATA ANALYSIS & BUSINESS PROBLEMS---
 -- Q1. Write SQL query to retrieve all columns for sales made on '2022-11-05,'
SELECT * FROM reatil_sales
WHERE sale_date = '2022-11-05'

 --Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov 2022?
SELECT * FROM reatil_sales
WHERE category = 'Clothing'
       AND
	   TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
       AND
	   quantiy >=4


--Q3.  Write a SQL query to find the category with the highest total sales overall.--
SELECT category,
       SUM(total_sale) AS total_sales
FROM reatil_sales
GROUP BY category
ORDER BY total_sales DESC
LIMIT 1;

--Q4. Write a SQL query to calculate the total sales for each category.--
SELECT category,
       SUM(total_sale) as net_sale,
	   COUNT(*) as total_orders
FROM reatil_sales
GROUP BY 1

--Q5. Write a SQL query to find the average age of customers who purchased items from tha 'Beauty' categort--
SELECT ROUND(AVG(age), 2) as avg_age
FROM reatil_sales
WHERE category = 'Beauty'

--Q6. Write a SQL query to find the number of male and female customers who bought more than 3 items in a single order.--
SELECT gender,
       COUNT(*) AS num_orders
FROM reatil_sales
WHERE quantiy > 3
GROUP BY gender;

--Q7. Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM reatil_sales
WHERE total_sale > 1000

--Q8. Write a SQL query to find the total number of transactions made by each gender in each category.--
SELECT category, gender,
      COUNT(*) as total_transactions
FROM reatil_sales
GROUP BY category, gender
ORDER BY 1

--Q9. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.--
SELECT year, month, avg_sale
FROM (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM reatil_sales
    GROUP BY year, month
) AS t1
WHERE rank = 1;

--Q10. Write a SQL query to get the day of the week with the highest number of sales.--
SELECT TO_CHAR(sale_date, 'Day') AS weekday,
       COUNT(*) AS total_orders
FROM reatil_sales
GROUP BY weekday
ORDER BY total_orders DESC
LIMIT 1;

--Q11. Write a SQL query to find the top 5 customers based on the highest total sales.--
SELECT customer_id,
       SUM(total_sale) as total_sales
FROM reatil_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Q12.  Write a SQL query to identify the age group with the highest total sales.--
SELECT 
    CASE 
        WHEN age BETWEEN 0 AND 20 THEN '0-20'
        WHEN age BETWEEN 21 AND 40 THEN '21-40'
        WHEN age BETWEEN 41 AND 60 THEN '41-60'
        WHEN age > 60 THEN '61+'
        ELSE 'Unknown'
    END AS age_group,
    COUNT(*) AS total_transactions,
    SUM(total_sale) AS total_sales
FROM reatil_sales
WHERE age IS NOT NULL
GROUP BY age_group
ORDER BY total_sales DESC;

--Q13. Write a SQL query to find the number of unique customers who purchased items from each category.--
SELECT category,
       COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM reatil_sales
GROUP BY category

--Q14. Write a SQL query to create each shift and number of orders.--
WITH hourly_sale
AS
(
SELECT *,
     CASE
	    WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	 END as shift
FROM reatil_sales
)
SELECT
     shift,
	 COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift


--Q15. Write a SQL query to find the most popular product category (based on quantity sold).--
SELECT category,
       SUM(quantiy) AS total_quantity_sold
FROM reatil_sales
GROUP BY category
ORDER BY total_quantity_sold DESC
LIMIT 1;


------------ END OF PROJECT -----------