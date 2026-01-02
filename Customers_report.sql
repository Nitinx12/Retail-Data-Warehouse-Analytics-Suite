CREATE VIEW Customers_report AS 
WITH basequery AS (
	SELECT
		C.customer_key,
		S.order_number,
		S.product_key,
		S.order_date,
		S.sales_amount,
		S.quantity,
		C.customer_number,
		CONCAT(C.first_name, ' ', C.last_name) AS full_name,
		EXTRACT(YEAR FROM AGE(birthdate)) AS customer_age
	FROM sales AS S
	LEFT JOIN customers AS C
	ON C.customer_key = S.customer_key
	WHERE S.order_date IS NOT NULL
),
Customer_agg AS (
	SELECT
		customer_key,
		customer_number,
		full_name,
		customer_age,
		COUNT(DISTINCT order_number) AS total_order,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity,
		COUNT(DISTINCT product_key) AS total_products,
		MAX(order_date) AS last_order_date,
		(EXTRACT(YEAR FROM AGE(MAX(order_date),MIN(order_date))) * 12
		+EXTRACT(MONTH FROM AGE(MAX(order_date),MIN(order_date)))) AS life_span
	FROM basequery
	GROUP BY 1, 2, 3, 4
)
	SELECT
		customer_key,
		customer_number,
		full_name,
		customer_age,
		CASE
			WHEN customer_age < 20 THEN 'Under 20'
			WHEN customer_age BETWEEN 20 AND 29 THEN '20-29'
			WHEN customer_age BETWEEN 30 AND 39 THEN '30-39'
			WHEN customer_age BETWEEN 40 AND 49 THEN '40-49'
			ELSE '50 and above'
		END AS age_group,
		CASE
			WHEN life_span >= 12 AND total_sales > 5000 THEN 'VIP'
			WHEN life_span >= 12 AND total_sales <= 5000 THEN 'Regular'
			ELSE 'New'
		END AS customer_segment,
		total_order,
		total_sales,
		total_quantity,
		total_products,
		last_order_date,
		(SELECT MAX(order_date) FROM sales) - last_order_date AS recency,
		life_span,
		CASE
			WHEN total_order = 0 THEN 0
			ELSE ROUND(total_sales / total_order,2)
		END AS avg_order_value,
		CASE
			WHEN life_span = 0 THEN total_sales
			ELSE ROUND(total_sales / life_span,2)
		END AS avg_monthly_spend
	FROM Customer_agg
		