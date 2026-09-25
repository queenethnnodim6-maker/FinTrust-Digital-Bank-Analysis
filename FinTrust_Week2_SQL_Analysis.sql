USE analystlab;

SELECT *
FROM fintrust_cust;

SELECT *
FROM fintrust_trans;

ALTER TABLE fintrust_cust
RENAME COLUMN ï»¿Customer_ID TO Customer_ID;

ALTER TABLE fintrust_trans
RENAME COLUMN ï»¿Transaction_ID TO Transaction_ID;

UPDATE fintrust_trans
SET Transaction_Date = STR_TO_DATE(Transaction_Date, '%m/%d/%Y')
WHERE Transaction_Date IS NOT NULL;

UPDATE fintrust_trans
SET Transaction_Type = 'Card Purchase',  Amount_NGN = 5923
WHERE  Transaction_Type = 'Unknown' AND Amount_NGN = 5074;

-- Business Analytical Questions
-- 1. Customer Behaviour:
----- Which customers make the most transactions, and which transaction types and channels do they use most frequently?

-- Customers with the Most Transaction

SELECT 
    c.Customer_ID,
    c.Customer_Name,
    c.Customer_Segment,
    COUNT(t.Transaction_ID) AS Total_Transactions
FROM FinTrust_Cust c
JOIN FinTrust_Trans t 
    ON c.Customer_ID = t.Customer_ID
GROUP BY 
    c.Customer_ID, 
    c.Customer_Name, 
    c.Customer_Segment
ORDER BY Total_Transactions DESC
LIMIT 10;

-- Overall Most Frequent Transaction Types and Channel

-- most frequent transaction type

SELECT
    Customer_ID,
    Transaction_Type,
    COUNT(*) AS Number_of_Transactions
FROM fintrust_trans
GROUP BY Customer_ID, Transaction_Type
ORDER BY Number_of_Transactions DESC
LIMIT 10;

-- most frequent channel

SELECT 
    Channel, 
    COUNT(*) AS Total_Count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM FinTrust_Trans), 2) AS Percentage
FROM FinTrust_Trans
GROUP BY Channel
ORDER BY Total_Count DESC;


-- Transaction Activity:
-- Question 2: How does transaction volume change over time, and which days or hours experience the highest transaction activity?

-- Transaction by date

SELECT
    DATE(Transaction_Date) AS Transaction_Date,
    COUNT(*) AS Transaction_Volume
FROM fintrust_Trans
GROUP BY DATE(Transaction_Date)
ORDER BY Transaction_Date;

-- Transaction per day

SELECT 
    DAYNAME(Transaction_Date) AS Day_Name,
    COUNT(*) AS Total_Transactions
FROM FinTrust_Trans
GROUP BY DAYNAME(Transaction_Date)
ORDER BY Total_Transactions DESC;

-- transaction per hour

SELECT 
    HOUR(Transaction_Time) AS Hour_Of_Day,
    COUNT(*) AS Total_Transactions
FROM FinTrust_Trans
GROUP BY HOUR(Transaction_Time)
ORDER BY Hour_Of_Day ASC;


-- •	Transaction Value:
-- Question 3: Which transaction types have the highest total transaction value and average transaction amount?

-- Transaction Value (Totals & Averages by Type)

SELECT 
    Transaction_Type,
    COUNT(*) AS Total_Transactions,
    SUM(Amount_NGN) AS Total_Value_NGN,
    ROUND(AVG(Amount_NGN), 2) AS Average_Amount_NGN
FROM FinTrust_Trans
GROUP BY Transaction_Type
ORDER BY Total_Value_NGN DESC;

-- •	Transaction Channel:
-- Question 4: Which transaction channels are used most frequently, and which channels process the highest transaction values?

-- channels that process the highest values?

SELECT
    Channel,
    SUM(Amount_NGN) AS Total_Transaction_Value
FROM fintrust_trans
GROUP BY Channel
ORDER BY Total_Transaction_Value DESC;

-- channels that are most frequently used
SELECT
    Channel,
    COUNT(*) AS Transaction_Volume
FROM fintrust_trans
GROUP BY Channel
ORDER BY Transaction_Volume DESC;


-- Transaction Status:
-- Question 5: What proportion of transactions are successful, reversed, or unsuccessful, and which transaction types or channels have the highest reversal or failure rates?

-- Overall Transaction Status 

SELECT
    Transaction_Status,
    COUNT(*) AS Number_of_Transactions
FROM fintrust_trans
GROUP BY Transaction_Status
ORDER BY Number_of_Transactions DESC;

-- proportion/ percentage of transaction status

SELECT 
    Transaction_Status,
    COUNT(*) AS Total_Count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM FinTrust_Trans), 2) AS Percentage
FROM FinTrust_Trans
GROUP BY Transaction_Status
ORDER BY Total_Count DESC;

-- Reversal and Failure Rates by Transaction Type

SELECT
    Transaction_Type,
    Transaction_Status,
    COUNT(*) AS Number_of_Transactions,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (PARTITION BY Transaction_Type),
        2) AS Percentage
FROM fintrust_trans
GROUP BY Transaction_Type, Transaction_Status
ORDER BY Transaction_Type, Percentage DESC;

SELECT * 
FROM fintrust_trans
WHERE Transaction_Type = 'Unknown';


-- Risk Patterns:
-- Question 6: Which transaction types, channels, locations, or device types have the highest proportion of risk-flagged transactions?

-- proportion of risk by transaction type

SELECT
    Transaction_Type,
    COUNT(*) AS Total_Transactions,
    SUM(CASE WHEN Risk_review_Flag = 'Yes' THEN 1 ELSE 0 END) AS Risk_Flagged,
    ROUND(
        SUM(CASE WHEN Risk_review_Flag = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2) AS Risk_Percentage
FROM fintrust_trans
GROUP BY Transaction_Type
ORDER BY Risk_Percentage DESC;

-- Risk Rate by Transaction Type
SELECT 
    Transaction_Type,
    COUNT(*) AS Total_Transactions,
    SUM(CASE WHEN Risk_Review_Flag = 'Yes' THEN 1 ELSE 0 END) AS Flagged_Count,
    ROUND(SUM(CASE WHEN Risk_Review_Flag = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Risk_Flagged_Pct
FROM FinTrust_Trans
GROUP BY Transaction_Type
ORDER BY Risk_Flagged_Pct DESC;

-- Risk Rate by Channel
SELECT 
    Channel,
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(CASE WHEN Risk_Review_Flag = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Risk_Flagged_Pct
FROM FinTrust_Trans
GROUP BY Channel
ORDER BY Risk_Flagged_Pct DESC;

-- risk rate by location

SELECT
    Location,
    COUNT(*) AS Total_Transactions,
    SUM(CASE WHEN Risk_Review_Flag = 'Yes' THEN 1 ELSE 0 END) AS Risk_Flagged,
    ROUND(
        SUM(CASE WHEN Risk_Review_Flag = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2) AS Risk_Percentage
FROM fintrust_trans
GROUP BY Location
ORDER BY Risk_Percentage DESC;

-- risk by device type
SELECT
    Device_Type,
    COUNT(*) AS Total_Transactions,
    SUM(CASE WHEN Risk_Review_Flag = 'Yes' THEN 1 ELSE 0 END) AS Risk_Flagged,
    ROUND(
        SUM(CASE WHEN Risk_Review_Flag = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2) AS Risk_Percentage
FROM fintrust_trans
GROUP BY Device_Type
ORDER BY Risk_Percentage DESC;

-- Risk and Transaction Status:
-- Question 7: How do transaction outcomes differ between risk-flagged and non-risk-flagged transactions?
-- Risk vs. Transaction Status

SELECT 
    Risk_Review_Flag,
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(CASE WHEN Transaction_Status = 'Successful' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Success_Rate_Pct,
    ROUND(SUM(CASE WHEN Transaction_Status = 'Failed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Failure_Rate_Pct,
    ROUND(SUM(CASE WHEN Transaction_Status = 'Reversed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Reversal_Rate_Pct,
    ROUND(SUM(CASE WHEN Transaction_Status = 'Pending' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Pending_Rate_Pct
FROM FinTrust_Trans
GROUP BY Risk_Review_Flag;


