# Sales Data Analysis with RFM (Recency, Frequency, Monetary) Model

This project analyzes sales data using SQL queries and visualizes the results using Tableau dashboards. The objective is to explore the sales data and segment customers into different groups based on RFM analysis, which helps businesses understand their customer behavior and optimize marketing strategies.

## SQL Analysis

The following analysis was performed using SQL:

### 1. **Data Preparation**
   - Created a staging table for sales data.
   - Converted `ORDERDATE` format to `DATETIME` for easier manipulation.

### 2. **Sales Analysis by Product Line, Year, and Deal Size**
   - Grouped sales data by product line to determine revenue per product category.
   - Grouped sales data by year to determine revenue trends over time.
   - Analyzed deal sizes to determine revenue by deal size category.

### 3. **Best Month for Sales in 2003**
   - Identified the best month for sales in 2003 by revenue and frequency of orders.

### 4. **Best Products Sold in November 2003**
   - Analyzed the best-selling products for November 2003 based on revenue and order frequency.

### 5. **RFM (Recency, Frequency, Monetary) Analysis**
   - Performed RFM analysis to segment customers:
     - **Recency**: How recently a customer made a purchase.
     - **Frequency**: How often a customer makes a purchase.
     - **Monetary**: How much money a customer spends.
   - Identified best customers based on RFM scores and classified them into segments like 'High Value Customers', 'Potential Churners', and 'Lost Customers'.

### 6. **Frequent Product Bundles**
   - Identified product bundles that are frequently sold together by analyzing orders with 3 items.

## Tableau Dashboards

The results of this analysis have been visualized using Tableau in two interactive dashboards:

- **Dashboard 1**: Provides insights into sales by product line, deal size, and year. It highlights key trends in revenue over time and identifies top-performing product categories.
  
- **Dashboard 2**: Focuses on customer segmentation based on the RFM model. It visualizes the customer distribution across different RFM segments, helping businesses target marketing efforts based on customer behavior.

You can find the Tableau workbooks [here](./Sales_product_1_Dashboard.twbx) and [here](./Sales_product_2_Dashboard.twbx).

## Setup

1. Clone this repository to your local machine.
2. Ensure you have a MySQL database set up and the `sales_data_sample` table imported.
3. Run the SQL queries provided in the `SQL_analysis.sql` file.
4. Open the Tableau workbooks to view the interactive dashboards.

## Future Improvements
- Add predictive analytics to forecast future sales based on historical data.
- Implement machine learning models to predict customer churn or identify cross-sell opportunities.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

