WITH yearly_product_sales AS (
	SELECT
		EXTRACT(YEAR FROM S.order_date) AS order_year,
		P.product_name,
		SUM(S.sales_amount) AS current_sales
	FROM sales AS S
	LEFT JOIN products AS P ON
	S.product_key = P.product_key
	WHERE S.order_date IS NOT NULL
	GROUP BY 1, 2
)
	SELECT
		order_year,
		product_name,
		current_sales,
		ROUND(AVG(current_sales) OVER(PARTITION BY product_name),2) AS avg_sales,
		current_sales - ROUND(AVG(current_sales) OVER(PARTITION BY product_name),2) AS diff_avg,
		CASE
			WHEN current_sales - ROUND(AVG(current_sales) OVER(PARTITION BY product_name),2) > 0 THEN 'Above Average'
			WHEN current_sales - ROUND(AVG(current_sales) OVER(PARTITION BY product_name),2) < 0 THEN 'Below Average'
			ELSE 'Average'
		END AS avg_changes,
		COALESCE(LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year),0) AS py_sales,
		COALESCE(current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year),0) AS diff_py,
		CASE
			WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
			WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
			ELSE 'No change'
		END AS py_changes
	FROM yearly_product_sales
	ORDER BY product_name, order_year