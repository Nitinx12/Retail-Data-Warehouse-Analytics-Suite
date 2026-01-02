-- Part-To-Whole  Analysis

WITH cate_sales AS (
	SELECT
		category,
		SUM(sales_amount) AS total_sales
	FROM sales AS S
	LEFT JOIN products AS P 
	ON S.product_key = P.product_key
	GROUP BY 1
)
	SELECT
		category,
		total_sales,
		SUM(total_sales) OVER() AS overall_sales,
		CONCAT(ROUND(total_sales / SUM(total_sales) OVER() * 100,2),'%') AS percentage_of_total_sales
	FROM cate_sales
	ORDER BY 4 DESC
