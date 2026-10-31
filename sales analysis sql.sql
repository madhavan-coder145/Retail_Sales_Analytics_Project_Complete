USE retail_analytics;

CREATE TABLE IF NOT EXISTS retail_sales (
    Order_ID VARCHAR(20),
    Order_Date DATETIME,
    Customer_ID VARCHAR(20),
    City VARCHAR(50),
    Category VARCHAR(50),
    Product VARCHAR(100),
    Quantity INT,
    Unit_Price DECIMAL(12,2),
    Discount DECIMAL(5,2),
    Sales DECIMAL(14,2),
    Profit DECIMAL(14,2),
    Payment_Method VARCHAR(50)
);
show tables;
USE retail_analytics;

DESCRIBE retail_sales;

USE retail_analytics;

ALTER TABLE retail_sales
ADD COLUMN Profit DECIMAL(14,2),
ADD COLUMN Payment_Method VARCHAR(50);
DESCRIBE retail_sales;

SELECT COUNT(*) AS total_rows
FROM retail_sales;

SELECT COUNT(*) AS total_rows,
       COUNT(Order_ID) AS orders,
       COUNT(Profit) AS profits,
       COUNT(Payment_Method) AS payments
FROM retail_sales;
SELECT MIN(Order_ID) AS first_order,

       MAX(Order_ID) AS last_order
FROM retail_sales;

SELECT COUNT(*) AS total_rows
FROM retail_analytics.retail_sales;

SELECT
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Sales) / COUNT(DISTINCT Order_ID), 2) AS Average_Order_Value,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin
FROM retail_sales;