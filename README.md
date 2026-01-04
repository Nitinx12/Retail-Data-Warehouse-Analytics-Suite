# Retail Data Warehouse Analytics Suite
*Leveraging SQL and Python to derive insights for operational efficiency and financial growth.*

![License](https://img.shields.io/badge/license-MIT-blue) ![Version](https://img.shields.io/badge/version-1.0.0-green)

## 📖 About The Project

The Retail Data Warehouse & Analytics Suite is an end-to-end data engineering and business intelligence solution designed to process, store, and analyze high-volume retail transactional data.

The project solves the challenge of deriving actionable business insights from raw CSV logs. It implements a Python-based ETL (Extract, Transform, Load) pipeline to populate a PostgreSQL data warehouse and utilizes advanced SQL scripting to generate key performance indicators (KPIs), such as Year-Over-Year growth, customer lifecycle value, and inventory cost segmentation.

### ✨ Built With
* Python
* SQL (PostgreSQL)
* Pandas
* Sqlalchemy
* Jupyter Notebook
* Matplotlib & Seaborn
* Duckdb

## 🚀 Features

- **Automated Data Ingestion:** A robust Python ETL script utilizing Pandas and SQLAlchemy to ingest raw CSV data into a relational database.
  
- **Advanced Sales Analytics:** Implementation of Window Functions and Common Table Expressions (CTEs) to calculate Month-Over-Month (MoM) growth and Year-Over-Year (YoY) trends.

- **Customer Segmentation:** Logic to profile customers based on purchasing behavior, age groups, and lifecycle span (VIP vs. New vs. Regular).

- **Inventory Optimization:** Price bracketing and segmentation analysis to assist in inventory distribution strategies.

- **Cumulative Performance Tracking:** Recursive SQL queries to track running totals and moving averages (7-day rolling average) for daily revenue.

## 🧑‍💻 Tech Stack
* Language: Python 3.x, SQL
* Libraries: Pandas, SQLAlchemy, Psycopg2
* Database: PostgreSQL
* Data Formats: CSV, Structured Tables

## 📊 Project Structure

```
Retail-Data-Warehouse-Analytics-Suite/
│
├── data/                            # Data storage (gitignored in real projects)
│   ├── raw/                         # Raw CSV files from the 'Dataset' folder
│   │   ├── customers.csv
│   │   ├── products.csv
│   │   └── sales.csv
│   └── processed/                   # Stores processed/cleaned data if needed
│
├── src/                             # Source code for the project
│   ├── etl/                         # Extract, Transform, Load scripts
│   │   ├── __init__.py
│   │   └── load_data.py             # Refactored 'Load_Data_in_database.py'
│   │
│   └── sql/                         # SQL scripts (from 'Advanced Data Analytics')
│       ├── changes_over_time.sql
│       ├── cumulative_analysis.sql
│       ├── customer_report.sql
│       ├── data_segmentation.sql
│       ├── part_to_whole_analysis.sql
│       └── performance_analysis.sql
│
├── notebooks/                       # Jupyter Notebooks
│   ├── eda/                         # From 'Exploratory Data analysis (EDA)' folder
│   │   └── exploratory_analysis.ipynb
│   └── prototyping/                 # Sandbox for testing code before moving to src/
│
├── dashboards/                      # Power BI files
│   └── retail_dashboard.pbix        # From 'Power BI Dashboard' folder
│
├── docs/                            # Documentation and Reference files
│   ├── questions.pdf                # Business requirements document
│   └── data_dictionary.md           # (Optional) Description of data fields
│
├── .gitignore                       # Files to ignore (e.g., venv, __pycache__, local data)
├── requirements.txt                 # Python dependencies (pandas, sqlalchemy, psycopg2)
├── LICENSE
└── README.md                        # Project Overview
```
## ⚙️ Installation & Usage
To replicate this analysis, follow these steps:

1.  **Clone the Repository:**
    ```bash
    git clone [https://github.com/Nitinx12/Retail-Data-Warehouse-Analytics-Suite]
    ```
2.  **Set Up PostgreSQL Database:**
    * Ensure you have PostgreSQL installed.
    * Create a new database (e.g., `Datawarehouseanalytics`).
    * Update the connection string in the `Load_Data_in_database.py` file with your database credentials.
3.  **Load Data:**
    * Place the 3 `.csv` files (`customers`, `products.csv`, etc.) in the `data/` directory.
    * Run the Python script to load the data into your PostgreSQL database:
        ```bash
       Load_Data_in_database.py
        ```
4.  **Run Analysis:**
    * **For SQL Analysis:** Execute the queries in `Customers_report.sql` using a SQL client like DBeaver, pgadmin4 or `psql`.
```sql
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
```


## 📜 License

Distributed under the MIT License. See `LICENSE` for more information.

## 📞 Contact Information

* **LinkedIn:** [https://www.linkedin.com/in/nitin-k-220651351/](https://www.linkedin.com/in/nitin-k-220651351/)
* **GitHub:** [https://github.com/Nitinx12](https://github.com/Nitinx12)
* **Email:** Nitin321x@gmail.com

