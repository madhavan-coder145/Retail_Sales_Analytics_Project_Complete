-- RETAIL SALES & CUSTOMER PERFORMANCE ANALYTICS
-- SQL DIALECT: MySQL 8.0+

USE retail_analytics;

-- 1. DATA OVERVIEW

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT Order_ID) AS total_orders,
    COUNT(DISTINCT Customer_ID) AS unique_customers,
    COUNT(DISTINCT Product) AS unique_products
FROM retail_sales;


-- 2. DATA QUALITY CHECK

SELECT
    COUNT(*) AS total_records,
    SUM(Order_ID IS NULL) AS missing_order_id,
    SUM(Order_Date IS NULL) AS missing_order_date,
    SUM(Customer_ID IS NULL) AS missing_customer_id,
    SUM(Discount IS NULL) AS missing_discount,
    SUM(Payment_Method IS NULL) AS missing_payment_method
FROM retail_sales;


-- 3. TOTAL SALES AND PROFIT

SELECT
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    SUM(Quantity) AS total_quantity,
    COUNT(DISTINCT Order_ID) AS total_orders,
    ROUND(SUM(Sales) /
    NULLIF(COUNT(DISTINCT Order_ID), 0), 2) AS average_order_value,
    ROUND(SUM(Profit) /
    NULLIF(SUM(Sales), 0) * 100, 2) AS profit_margin
FROM retail_sales;


-- 4. MONTHLY SALES TREND

SELECT
    DATE_FORMAT(Order_Date, '%Y-%m') AS sales_month,
    ROUND(SUM(Sales), 2) AS monthly_sales,
    ROUND(SUM(Profit), 2) AS monthly_profit
FROM retail_sales
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY sales_month;


-- 5. CATEGORY PERFORMANCE

SELECT
    Category,
    SUM(Quantity) AS units_sold,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) /
    NULLIF(SUM(Sales), 0) * 100, 2) AS profit_margin
FROM retail_sales
GROUP BY Category
ORDER BY total_sales DESC;


-- 6. CITY-WISE PERFORMANCE

SELECT
    City,
    COUNT(DISTINCT Order_ID) AS total_orders,
    COUNT(DISTINCT Customer_ID) AS total_customers,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM retail_sales
GROUP BY City
ORDER BY total_sales DESC;


-- 7. TOP 10 PRODUCTS BY REVENUE

SELECT
    Product,
    Category,
    SUM(Quantity) AS units_sold,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM retail_sales
GROUP BY Product, Category
ORDER BY total_sales DESC
LIMIT 10;


-- 8. CUSTOMER PERFORMANCE

SELECT
    Customer_ID,
    COUNT(DISTINCT Order_ID) AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM retail_sales
GROUP BY Customer_ID
ORDER BY total_sales DESC
LIMIT 20;


-- 9. PAYMENT METHOD ANALYSIS

SELECT
    Payment_Method,
    COUNT(*) AS total_transactions,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM retail_sales
GROUP BY Payment_Method
ORDER BY total_transactions DESC;


-- 10. PRODUCT PROFITABILITY ANALYSIS

SELECT
    Product,
    Category,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) /
    NULLIF(SUM(Sales), 0) * 100, 2) AS profit_margin
FROM retail_sales
GROUP BY Product, Category
ORDER BY profit_margin ASC;


-- 11. MONTH-OVER-MONTH SALES GROWTH

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(Order_Date, '%Y-%m') AS sales_month,
        SUM(Sales) AS total_sales
    FROM retail_sales
    GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
),
sales_growth AS (
    SELECT
        sales_month,
        total_sales,
        LAG(total_sales) OVER (ORDER BY sales_month) AS previous_month_sales
    FROM monthly_sales
)
SELECT
    sales_month,
    ROUND(total_sales, 2) AS current_sales,
    ROUND(previous_month_sales, 2) AS previous_sales,
    ROUND(
        (total_sales - previous_month_sales) /
        NULLIF(previous_month_sales, 0) * 100, 2
    ) AS growth_percentage
FROM sales_growth
ORDER BY sales_month;


-- 12. REPEAT CUSTOMER ANALYSIS

SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT Customer_ID
    FROM retail_sales
    GROUP BY Customer_ID
    HAVING COUNT(DISTINCT Order_ID) > 1
) AS customer_orders;


-- 13. YEARLY SALES PERFORMANCE

SELECT
    YEAR(Order_Date) AS sales_year,
    ROUND(SUM(Sales), 2) AS yearly_sales,
    ROUND(SUM(Profit), 2) AS yearly_profit,
    COUNT(DISTINCT Order_ID) AS total_orders
FROM retail_sales
GROUP BY YEAR(Order_Date)
ORDER BY sales_year;


-- 14. LOSS-MAKING PRODUCTS

SELECT
    Product,
    Category,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM retail_sales
GROUP BY Product, Category
HAVING SUM(Profit) < 0
ORDER BY total_profit ASC;


-- 15. AVERAGE CATEGORY PERFORMANCE

SELECT
    Category,
    ROUND(AVG(Sales), 2) AS average_sales,
    ROUND(AVG(Profit), 2) AS average_profit,
    ROUND(AVG(Discount), 2) AS average_discount
FROM retail_sales
GROUP BY Category
ORDER BY average_sales DESC;
