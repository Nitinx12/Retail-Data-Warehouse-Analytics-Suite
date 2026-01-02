-- Changes over time

WITH months AS (
	SELECT
		TO_CHAR(order_date, 'YYYY-MM') AS sales_month,
		SUM(sales_amount) AS current_month_sales
	FROM sales
	WHERE order_date IS NOT NULL
	GROUP BY 1
)
	SELECT
		sales_month,
		current_month_sales,
		COALESCE(previous_month_sales, 0) AS previous_month_sales,
		CASE
			WHEN previous_month_sales IS NULL THEN 0
			ELSE ROUND((current_month_sales - previous_month_sales) / previous_month_sales * 100,2)
		END AS growth_rate
	FROM(SELECT
			sales_month,
			current_month_sales,
			LAG(current_month_sales) OVER(ORDER BY sales_month) AS previous_month_sales
		FROM months) AS X



	
	 





	