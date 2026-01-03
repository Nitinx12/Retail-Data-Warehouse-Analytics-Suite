-- Data Segmentation

WITH products_segment AS (
	SELECT
		product_key,
		product_name,
		cost,
		CASE
			WHEN cost < 100 THEN 'Below 100'
			WHEN cost BETWEEN 100 AND 500 THEN '100-500'
			WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
			ELSE 'Above 1000'
		END AS cost_range
	FROM products 
)
	SELECT
		cost_range,
		COUNT(product_key) AS total_products
	FROM products_segment
	GROUP BY 1
	ORDER BY 2 DESC
	
WITH Customer_spending AS (
	SELECT
		C.customer_key,
		SUM(S.sales_amount) AS total_spending,
		MIN(S.order_date) AS first_order,
		MAX(S.order_date) AS last_order,
		(EXTRACT(YEAR FROM AGE(MAX(S.order_date),MIN(S.order_date))) * 12
		+EXTRACT(MONTH FROM AGE(MAX(S.order_date),MIN(S.order_date)))) AS life_span
	FROM sales AS S
	LEFT JOIN customers AS C 
	ON C.customer_key = S.customer_key
	GROUP BY 1
)
	SELECT
		customer_segment,
		COUNT(customer_key) AS total_customers
	FROM(SELECT
			customer_key,
			CASE
				WHEN life_span >= 12 AND total_spending > 5000 THEN 'VIP'
				WHEN life_span >= 12 AND total_spending <= 5000 THEN 'Regular'
				ELSE 'New'
			END AS customer_segment
		FROM Customer_spending) AS X
	GROUP BY 1
	ORDER BY 2 DESC

		















