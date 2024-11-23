# Sales Data Analysis with RFM (Recency, Frequency, Monetary) Analysis

This project involves analyzing sales data to understand customer behavior and sales trends, using SQL and Tableau for data manipulation and visualization. The key analysis performed in this project includes:

- **Sales Data Analysis**: Aggregating and summarizing sales data by different categories such as product line, year, and deal size.
- **RFM Analysis**: Segmenting customers based on their recency, frequency, and monetary value of purchases to identify valuable and at-risk customers.

## Dashboards

This project includes two Tableau dashboards that provide visual insights into the analysis:

1. **Sales Overview Dashboard**  
   This dashboard displays high-level sales metrics, including:
   - Total revenue by product line, year, and deal size.
   - Insights into the best-selling months and products, helping to identify sales patterns over time.

2. **Customer Segmentation Dashboard**  
   This dashboard focuses on customer behavior:
   - RFM analysis, classifying customers into segments such as "High Value Customers," "Potential Churners," and "Lost Customers."
   - Customer trends based on recency, frequency, and monetary values to help businesses target and retain customers effectively.

## Project Files

The project includes the following key files:

- **SQL Code**: The SQL code for data manipulation, aggregation, and RFM analysis.
- **Tableau Dashboards**: The Tableau workbooks containing the dashboards.
  
## Setup Instructions

### 1. Database Setup
To run the SQL queries, ensure that you have a database set up with the required `sales_data_sample` table. If you are using MySQL:

```sql
CREATE DATABASE project_one;
USE project_one;
```
Then, insert your sales data into the sales_data_sample table, and you can begin running the SQL code for analysis.
# Tableau Setup
Import the sales_data_sample data into Tableau to begin creating the dashboards. The dashboards can be customized based on your specific needs.
# SQL Queries
This project uses the following SQL queries for analysis:

**Aggregating Sales by Product Line**
**Grouping Sales by Year**
**RFM Analysis for Customer Segmentation**

# Example SQL for RFM Analysis:
```sql
-- IDENTIFYING BEST CUSTOMERS
SELECT 
    CUSTOMERNAME, 
    SUM(SALES) AS MONETARY_VALUES,  
    AVG(SALES) AS AVG_MONETARY_VALUES,
    COUNT(ORDERNUMBER) AS Frequency, 
    MAX(ORDERDATE) AS Last_Order,
    DATEDIFF(MAX(ORDERDATE), (SELECT MAX(ORDERDATE) FROM sales_data_sample)) AS Recency
FROM 
    sales_data_sample_stage
GROUP BY 
    CUSTOMERNAME;
```
# License
This project is licensed under the MIT License - see the LICENSE file for details.

