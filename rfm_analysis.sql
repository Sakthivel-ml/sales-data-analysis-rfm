-- SET GLOBAL SQL MODE
SET GLOBAL sql_mode = '';

-- USE DATABASE
USE project_one;

-- CREATE STAGING TABLE
SELECT * FROM sales_data_sample;
CREATE TABLE sales_data_sample_stage LIKE sales_data_sample;
INSERT INTO sales_data_sample_stage SELECT * FROM sales_data_sample;

-- UPDATE AND CONVERT `ORDERDATE` FORMAT
UPDATE sales_data_sample_stage 
SET ORDERDATE = STR_TO_DATE(ORDERDATE, '%m/%d/%Y %H:%i');

ALTER TABLE sales_data_sample_stage MODIFY ORDERDATE DATETIME;
SELECT * FROM sales_data_sample_stage;

-- INSPECTING DATA
SELECT DISTINCT STATUS FROM sales_data_sample_stage;
SELECT DISTINCT YEAR_ID FROM sales_data_sample_stage;
SELECT DISTINCT PRODUCTLINE FROM sales_data_sample_stage;
SELECT DISTINCT COUNTRY FROM sales_data_sample_stage;
SELECT DISTINCT TERRITORY FROM sales_data_sample_stage;

-- ANALYSIS

-- GROUPING SALES BY PRODUCTLINE
SELECT 
    PRODUCTLINE, 
    SUM(SALES) AS Revenue
FROM 
    sales_data_sample_stage
GROUP BY 
    PRODUCTLINE
ORDER BY 
    Revenue DESC;

-- GROUPING SALES BY YEAR
SELECT 
    YEAR_ID, 
    SUM(SALES) AS Revenue
FROM 
    sales_data_sample_stage
GROUP BY 
    YEAR_ID
ORDER BY 
    Revenue DESC;

-- GROUPING SALES BY DEALSIZE
SELECT 
    DEALSIZE, 
    SUM(SALES) AS Revenue
FROM 
    sales_data_sample_stage
GROUP BY 
    DEALSIZE
ORDER BY 
    Revenue DESC;

-- BEST MONTH FOR SALES IN A SPECIFIC YEAR
SELECT 
    MONTH_ID, 
    SUM(SALES) AS Revenue, 
    COUNT(ORDERNUMBER) AS Frequency
FROM 
    sales_data_sample_stage
WHERE 
    YEAR_ID = 2003
GROUP BY 
    MONTH_ID
ORDER BY 
    Revenue DESC;

-- BEST PRODUCTS SOLD IN NOVEMBER
SELECT 
    MONTH_ID, 
    PRODUCTLINE, 
    SUM(SALES) AS Revenue, 
    COUNT(ORDERNUMBER) AS Frequency
FROM 
    sales_data_sample_stage
WHERE 
    YEAR_ID = 2003 AND MONTH_ID = 11
GROUP BY 
    MONTH_ID, PRODUCTLINE
ORDER BY 
    Revenue DESC;

-- RFM ANALYSIS

-- IDENTIFYING BEST CUSTOMERS
SELECT 
    CUSTOMERNAME, 
    SUM(SALES) AS MONETARY_VALUES,  
    AVG(SALES) AS AVG_MONETARY_VALUES,
    COUNT(ORDERNUMBER) AS Frequency, 
    MAX(ORDERDATE) AS Last_Order,
    (SELECT MAX(ORDERDATE) FROM sales_data_sample_stage) AS Max_Order,
    DATEDIFF(
        (SELECT MAX(ORDERDATE) FROM sales_data_sample_stage), 
        MAX(ORDERDATE)
    ) AS Recency
FROM 
    sales_data_sample_stage
GROUP BY 
    CUSTOMERNAME;

-- CREATE TEMPORARY TABLE FOR RFM ANALYSIS
DROP TABLE IF EXISTS rfm;

CREATE TEMPORARY TABLE rfm AS 
WITH rfm_recency AS (
    SELECT 
        CUSTOMERNAME, 
        SUM(SALES) AS MONETARY_VALUES,  
        AVG(SALES) AS AVG_MONETARY_VALUES,
        COUNT(ORDERNUMBER) AS Frequency, 
        MAX(ORDERDATE) AS Last_Order,
        (SELECT MAX(ORDERDATE) FROM sales_data_sample_stage) AS Max_Order,
        DATEDIFF(
            (SELECT MAX(ORDERDATE) FROM sales_data_sample_stage), 
            MAX(ORDERDATE)
        ) AS Recency
    FROM 
        sales_data_sample_stage
    GROUP BY 
        CUSTOMERNAME
),
ranked_data AS (
    SELECT 
        r.*,
        ROW_NUMBER() OVER (ORDER BY Recency DESC) AS Recency_Rank,
        ROW_NUMBER() OVER (ORDER BY Frequency DESC) AS Frequency_Rank,
        ROW_NUMBER() OVER (ORDER BY AVG_MONETARY_VALUES DESC) AS Avg_Monetary_Rank,
        FLOOR((ROW_NUMBER() OVER (ORDER BY Recency DESC) - 1) / (COUNT(*) OVER() / 4)) + 1 AS Recency_Bucket,
        FLOOR((ROW_NUMBER() OVER (ORDER BY Frequency DESC) - 1) / (COUNT(*) OVER() / 4)) + 1 AS Frequency_Bucket,
        FLOOR((ROW_NUMBER() OVER (ORDER BY AVG_MONETARY_VALUES DESC) - 1) / (COUNT(*) OVER() / 4)) + 1 AS Avg_Monetary_Bucket
    FROM 
        rfm_recency r
)
SELECT 
    r.*, 
    Recency_Bucket + Frequency_Bucket + Avg_Monetary_Bucket AS RFM_Cell,
    CONCAT(
        CAST(Recency_Bucket AS CHAR), 
        CAST(Frequency_Bucket AS CHAR), 
        CAST(Avg_Monetary_Bucket AS CHAR)
    ) AS RFM_Code
FROM 
    ranked_data r;

-- CLASSIFY CUSTOMERS INTO SEGMENTS
SELECT 
    CUSTOMERNAME,
    RFM_Cell, 
    CASE 
        WHEN RFM_Cell > 9 THEN 'High Value Customers'
        WHEN RFM_Cell BETWEEN 5 AND 8 THEN 'Potential Churners'
        WHEN RFM_Cell < 5 THEN 'Lost Customers'
        WHEN RFM_Cell BETWEEN 7 AND 9 THEN 'Active Customers' 
    END AS RFM_Segment
FROM 
    rfm;

-- FREQUENTLY SOLD PRODUCTS TOGETHER
SELECT DISTINCT 
    s.ORDERNUMBER, 
    TRIM(BOTH ',' FROM 
        GROUP_CONCAT(p.PRODUCTCODE ORDER BY p.PRODUCTCODE SEPARATOR ',')
    ) AS ProductCodes
FROM 
    sales_data_sample_stage s
JOIN 
    sales_data_sample_stage p ON p.ORDERNUMBER = s.ORDERNUMBER
WHERE 
    s.ORDERNUMBER IN (
        SELECT ORDERNUMBER
        FROM (
            SELECT 
                ORDERNUMBER, 
                COUNT(*) AS rn
            FROM 
                sales_data_sample_stage
            WHERE 
                STATUS = 'Shipped'
            GROUP BY 
                ORDERNUMBER
        ) m
        WHERE rn = 3
    )
GROUP BY 
    s.ORDERNUMBER
ORDER BY 
    ProductCodes DESC;
