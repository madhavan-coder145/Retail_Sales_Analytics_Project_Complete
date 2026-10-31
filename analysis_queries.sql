-- Retail Sales & Customer Performance Analytics
-- SQL dialect: PostgreSQL / standard SQL style

-- 1. Total sales, profit and orders
SELECT
    COUNT(DISTINCT Order_ID) AS total_orders,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales),0) * 100, 2) AS profit_margin_pct
FROM retail_sales;

-- 2. Monthly sales trend
SELECT
    DATE_TRUNC('month', Order_Date) AS month,
    SUM(Sales) AS sales,
    SUM(Profit) AS profit
FROM retail_sales
GROUP BY 1
ORDER BY 1;

-- 3. Category performance
SELECT
    Category,
    SUM(Sales) AS sales,
    SUM(Profit) AS profit,
    SUM(Quantity) AS units_sold
FROM retail_sales
GROUP BY Category
ORDER BY sales DESC;

-- 4. City performance
SELECT
    City,
    SUM(Sales) AS sales,
    SUM(Profit) AS profit,
    COUNT(DISTINCT Customer_ID) AS customers
FROM retail_sales
GROUP BY City
ORDER BY sales DESC;

-- 5. Top 10 products by sales
SELECT
    Product,
    Category,
    SUM(Sales) AS sales,
    SUM(Profit) AS profit
FROM retail_sales
GROUP BY Product, Category
ORDER BY sales DESC
LIMIT 10;

-- 6. Customer value
SELECT
    Customer_ID,
    COUNT(DISTINCT Order_ID) AS orders,
    SUM(Sales) AS sales,
    SUM(Profit) AS profit
FROM retail_sales
GROUP BY Customer_ID
ORDER BY sales DESC
LIMIT 20;

-- 7. Payment method analysis
SELECT
    Payment_Method,
    COUNT(*) AS transactions,
    SUM(Sales) AS sales
FROM retail_sales
GROUP BY Payment_Method
ORDER BY sales DESC;

-- 8. Loss / low-margin products
SELECT
    Product,
    Category,
    SUM(Sales) AS sales,
    SUM(Profit) AS profit,
    ROUND(SUM(Profit)/NULLIF(SUM(Sales),0)*100,2) AS margin_pct
FROM retail_sales
GROUP BY Product, Category
HAVING SUM(Sales) > 0
ORDER BY margin_pct ASC;

-- 9. Month-over-month sales growth
WITH monthly AS (
    SELECT DATE_TRUNC('month', Order_Date) AS month, SUM(Sales) AS sales
    FROM retail_sales
    GROUP BY 1
)
SELECT
    month,
    sales,
    LAG(sales) OVER (ORDER BY month) AS previous_month_sales,
    ROUND(
        (sales - LAG(sales) OVER (ORDER BY month))
        / NULLIF(LAG(sales) OVER (ORDER BY month),0) * 100, 2
    ) AS mom_growth_pct
FROM monthly
ORDER BY month;

-- 10. Repeat customers
SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT Customer_ID
    FROM retail_sales
    GROUP BY Customer_ID
    HAVING COUNT(DISTINCT Order_ID) > 1
) x;
