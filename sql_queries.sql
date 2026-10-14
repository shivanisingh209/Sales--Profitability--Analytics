USE SALES_ANALYSIS;

-- ================= SECTION 1: DATA CLEANING =================
-- 1. Duplicates
SELECT Order_ID, COUNT(*) FROM Orders GROUP BY Order_ID HAVING COUNT(*) > 1;
-- 2. Null Check
SELECT COUNT(*) FROM Orders WHERE Revenue IS NULL OR Profit IS NULL;
-- 3. TRIM Check
-- UPDATE Orders SET Category = TRIM(Category);

-- =====================================================
-- PROJECT 1 - SALES ANALYSIS
-- =====================================================

USE SALES_ANALYSIS;


-- =====================================================
-- FINDING 1 - TOTAL REVENUE & PROFIT
-- =====================================================

SELECT
    SUM(Revenue) AS Total_Revenue,
    SUM(Profit) AS Total_Profit
FROM Orders;


-- =====================================================
-- FINDING 2 - HIGHEST DISCOUNT REGION
-- =====================================================

SELECT
    Region,
    ROUND(AVG(Discount_Pct) * 100, 2) AS Avg_Discount
FROM Orders
GROUP BY Region
ORDER BY Avg_Discount DESC;


-- =====================================================
-- FINDING 3 - HIGHEST RETURN-RATE REGION
-- =====================================================

SELECT
    Region,
    COUNT(*) AS Total_Orders,
    SUM(
        CASE
            WHEN Return_Flag = 'Yes' THEN 1
            ELSE 0
        END
    ) AS Returned_Orders,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN Return_Flag = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS Return_Rate
FROM Orders
GROUP BY Region
ORDER BY Return_Rate DESC;


-- =====================================================
-- FINDING 4 - REVENUE VS PROFIT BY REGION
-- =====================================================

SELECT
    Region,
    SUM(Revenue) AS Revenue,
    SUM(Profit) AS Profit
FROM Orders
GROUP BY Region
ORDER BY Revenue DESC;


-- =====================================================
-- FINDING 5 - MOST PROFITABLE PRODUCT
-- =====================================================

SELECT
    Product,
    SUM(Profit) AS Profit
FROM Orders
GROUP BY Product
ORDER BY Profit DESC
LIMIT 1;


-- =====================================================
-- FINDING 6 - LOW-MARGIN PRODUCTS
-- =====================================================

SELECT
    Product,
    SUM(Revenue) AS Revenue,
    SUM(Profit) AS Profit,
    ROUND(
        100.0 * SUM(Profit)
        / NULLIF(SUM(Revenue), 0),
        2
    ) AS Profit_Margin
FROM Orders
GROUP BY Product
ORDER BY Profit_Margin ASC;


-- =====================================================
-- FINDING 7 - DISCOUNT IMPACT
-- =====================================================

SELECT
    Product,
    ROUND(AVG(Discount_Pct) * 100, 2) AS Avg_Discount,
    SUM(Revenue) AS Revenue,
    SUM(Profit) AS Profit,
    ROUND(
        100.0 * SUM(Profit)
        / NULLIF(SUM(Revenue), 0),
        2
    ) AS Profit_Margin
FROM Orders
GROUP BY Product
ORDER BY Avg_Discount DESC
LIMIT 10;


-- =====================================================
-- FINDING 8 - PROFIT LEAKAGE
-- HIGH REVENUE + HIGH DISCOUNT + LOW MARGIN
-- =====================================================

SELECT
    Product,
    SUM(Revenue) AS Revenue,
    SUM(Profit) AS Profit,
    ROUND(AVG(Discount_Pct) * 100, 2) AS Avg_Discount,
    ROUND(
        100.0 * SUM(Profit)
        / NULLIF(SUM(Revenue), 0),
        2
    ) AS Profit_Margin
FROM Orders
GROUP BY Product
ORDER BY Profit_Margin ASC;

-- Finding 9-Top  customer by revenue
SELECT
    Customer_ID,
    Customer_Name,
    SUM(Revenue) AS Total_Revenue
FROM Orders
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Revenue DESC
LIMIT 10;

-- Finding 10- Top customer by profit
SELECT
    Customer_ID,
    Customer_Name,
    SUM(Profit) AS Total_Profit
FROM Orders
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Profit DESC
LIMIT 10;

-- Finding 11- City with high revenue but low profit margin

SELECT
    City,
    SUM(Revenue) AS Revenue,
    SUM(Profit) AS Profit,
    ROUND(
        100.0 * SUM(Profit) / NULLIF(SUM(Revenue), 0),
        2
    ) AS Profit_Margin
FROM Orders
GROUP BY City
ORDER BY Revenue DESC;

 -- Finding 12 -City with highest return rate
 SELECT
    City,
    COUNT(*) AS Total_Orders,
    SUM(CASE WHEN Return_Flag = 'Yes' THEN 1 ELSE 0 END) AS Returned_Orders,
    ROUND(
        100.0 * SUM(CASE WHEN Return_Flag = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS Return_Rate
FROM Orders
GROUP BY City
ORDER BY Return_Rate DESC;

-- Finding 13 -Highest-revenue month
SELECT
    DATE_FORMAT(Order_Date, '%Y-%m') AS Month,
    SUM(Revenue) AS Revenue
FROM Orders
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY Month;

-- Finding 14- Highest-profit month

SELECT
    DATE_FORMAT(Order_Date, '%Y-%m') AS Month,
    SUM(Profit) AS Profit
FROM Orders
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY Month;

-- Finding 15 - FY 2024–25 vs FY 2025–26 revenue change

SELECT
    CASE
        WHEN MONTH(Order_Date) >= 4
            THEN CONCAT(YEAR(Order_Date), '-', RIGHT(YEAR(Order_Date) + 1, 2))
        ELSE CONCAT(YEAR(Order_Date) - 1, '-', RIGHT(YEAR(Order_Date), 2))
    END AS Financial_Year,
    
    SUM(Revenue) AS Revenue,
    SUM(Profit) AS Profit

FROM Orders

GROUP BY Financial_Year
ORDER BY Financial_Year;
-- Finding 16 Month with lowest profit margin

SELECT
    DATE_FORMAT(Order_Date, '%Y-%m') AS Month,
    SUM(Revenue) AS Revenue,
    SUM(Profit) AS Profit,
    ROUND(
        100.0 * SUM(Profit) / NULLIF(SUM(Revenue), 0),
        2
    ) AS Profit_Margin
FROM Orders
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY Month;
-- Finding 18 Month with highest return rate
SELECT
    DATE_FORMAT(Order_Date, '%Y-%m') AS Month,
    COUNT(*) AS Total_Orders,
    SUM(CASE WHEN Return_Flag = 'Yes' THEN 1 ELSE 0 END) AS Returned_Orders,
    ROUND(
        100.0 * SUM(CASE WHEN Return_Flag = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS Return_Rate
FROM Orders
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY Month;