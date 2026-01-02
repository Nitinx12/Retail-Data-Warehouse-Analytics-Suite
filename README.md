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

## 🚀 Features

- **Automated Data Ingestion:** A robust Python ETL script utilizing Pandas and SQLAlchemy to ingest raw CSV data into a relational database.
  
- **Advanced Sales Analytics:** Implementation of Window Functions and Common Table Expressions (CTEs) to calculate Month-Over-Month (MoM) growth and Year-Over-Year (YoY) trends.

- **Customer Segmentation:** Logic to profile customers based on purchasing behavior, age groups, and lifecycle span (VIP vs. New vs. Regular).

- **Inventory Optimization:** Price bracketing and segmentation analysis to assist in inventory distribution strategies.

- **Cumulative Performance Tracking:** Recursive SQL queries to track running totals and moving averages (7-day rolling average) for daily revenue.

## 🧑‍💻 Tech Stack
Language: Python 3.x, SQL

Libraries: Pandas, SQLAlchemy, Psycopg2

Database: PostgreSQL

Data Formats: CSV, Structured Tables
