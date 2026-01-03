--  Cumulative Analysis

WITH RECURSIVE calander AS (
	SELECT
		MIN(order_date) AS start_date
	FROM sales

	UNION ALL

	SELECT
		(start_date + INTERVAL '1 DAY') :: DATE
	FROM calander
	WHERE start_date < (SELECT MAX(order_date) FROM sales)
),
Daily_revenue AS (
	SELECT
		X.start_date AS order_date,
		COALESCE(SUM(S.sales_amount),0) AS total_sales
	FROM calander AS X
	LEFT JOIN sales AS S ON
	X.start_date = S.order_date
	GROUP BY 1
)
	SELECT
		order_date,
		total_sales,
		SUM(total_sales) 
			OVER(ORDER BY order_date) AS running_total_sales,
		ROUND(AVG(total_sales)
			OVER(ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2) AS moving_7_day_avg
	FROM Daily_revenue
	