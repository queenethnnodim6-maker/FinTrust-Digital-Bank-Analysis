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

-- Week 3 — Advanced SQL Analysis
-- 1. Customer Transaction Frequency and Value
-- Business question
-- Which customers are the most active and how much transaction value do they generate?

ALTER TABLE fintrust_cust
RENAME COLUMN ï»¿Customer_ID TO Customer_ID;

SELECT
    c.Customer_ID,
    c.Customer_Name,
    c.Customer_Segment,
    COUNT(t.Transaction_ID) AS Total_Transactions,
    SUM(t.Amount_NGN) AS Total_Transaction_Value,
    ROUND(AVG(t.Amount_NGN), 2) AS Average_Transaction_Value,
    SUM(CASE 
            WHEN t.Transaction_Status = 'Successful' THEN 1
            ELSE 0
        END) AS Successful_Transactions
FROM FinTrust_Cust c
JOIN FinTrust_Trans t
    ON c.Customer_ID = t.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Customer_Name,
    c.Customer_Segment
ORDER BY Total_Transaction_Value DESC;

-- Customer Ibrahim Mohammed generated ₦17,139,42 in transaction value across 10 transactions. 8 Successful transactions out of 10 
-- with an average transaction value of ₦17,139,4.20

-- Customer Segmentation by Transaction Behaviour
-- Business question
-- Can customers be classified based on how frequently and how much they transact?

-- We'll create three behavioural groups:
-- High Activity — 20+ transactions
-- Medium Activity — 10–19
-- Low Activity — below 10

WITH Customer_Activity AS 
(
    SELECT
        c.Customer_ID,
        c.Customer_Name,
        c.Customer_Segment,
        COUNT(t.Transaction_ID) AS Total_Transactions,
        SUM(t.Amount_NGN) AS Total_Transaction_Value,
        ROUND(AVG(t.Amount_NGN), 2) AS Average_Transaction_Value
    FROM FinTrust_Cust c
    JOIN FinTrust_Trans t
        ON c.Customer_ID = t.Customer_ID
    GROUP BY
        c.Customer_ID,
        c.Customer_Name,
        c.Customer_Segment)

SELECT
    Customer_ID,
    Customer_Name,
    Customer_Segment,
    Total_Transactions,
    Total_Transaction_Value,
    Average_Transaction_Value,
    CASE
        WHEN Total_Transactions >= 20 THEN 'High Activity'
        WHEN Total_Transactions >= 10 THEN 'Medium Activity'
        ELSE 'Low Activity'
    END AS Activity_Level
FROM Customer_Activity
ORDER BY Total_Transactions DESC;

-- Fatima Adeyemi, an Everday customer, has the highest activity recorderd with up to 20 total transactions
-- Customer Tunde Garba, a student, had 19 total transactions

-- 3. Channel Performance: Volume + Value + Success
-- Business question
-- Which transaction channels deliver the best combination of volume, value and successful transactions?

SELECT
    Channel,
    COUNT(*) AS Total_Transactions,
    SUM(Amount_NGN) AS Total_Transaction_Value,
    ROUND(AVG(Amount_NGN), 2) AS Average_Transaction_Value,
    SUM(CASE
            WHEN Transaction_Status = 'Successful' THEN 1
            ELSE 0
        END) AS Successful_Transactions,
    ROUND(SUM(
			CASE
                WHEN Transaction_Status = 'Successful' THEN 1
                ELSE 0
            END) * 100.0 / COUNT(*), 2) AS Success_Rate_Pct
FROM FinTrust_Trans
GROUP BY Channel
ORDER BY Success_Rate_Pct DESC;

-- Business insight
-- ATM channel has high transaction volume of 83,942,354, and the highest success rate perecentage of 91.70

-- 4. High-Value Transaction Analysis
-- Business question
-- What proportion of FinTrust transactions are high-value transactions, and how successful are they?
-- We'll define a high-value transaction as ₦100,000 or more.

WITH Transaction_Category AS (
    SELECT
        Transaction_ID,
        Amount_NGN,
        Transaction_Type,
        Channel,
        Transaction_Status,
        Risk_Review_Flag,
        CASE
            WHEN Amount_NGN >= 100000 THEN 'High Value'
            WHEN Amount_NGN >= 50000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS Value_Category
FROM FinTrust_Trans)

SELECT
    Value_Category,
    COUNT(*) AS Total_Transactions,
    SUM(Amount_NGN) AS Total_Value,
    ROUND(AVG(Amount_NGN), 2) AS Average_Value,
    ROUND(SUM(
            CASE
                WHEN Transaction_Status = 'Successful' THEN 1
                ELSE 0
            END) * 100.0 / COUNT(*), 2) AS Success_Rate_Pct,
    ROUND(SUM(
            CASE
                WHEN Risk_Review_Flag = 'Yes' THEN 1
                ELSE 0
            END) * 100.0 / COUNT(*), 2) AS Risk_Rate_Pct
FROM Transaction_Category
GROUP BY Value_Category
ORDER BY Total_Value DESC;

-- 5. Risk Exposure Among High-Value Transactions
-- Week 2 work examined risk rates by transaction type, channel, location and device
-- Business question: Are high-value transactions more likely to be flagged for risk review?

WITH Transaction_Value_Groups AS (
    SELECT
        Transaction_ID,
        Amount_NGN,
        Risk_Review_Flag,
        CASE
            WHEN Amount_NGN >= 100000 THEN 'High Value'
            WHEN Amount_NGN >= 50000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS Value_Category
    FROM FinTrust_Trans
)
SELECT
    Value_Category,
    COUNT(*) AS Total_Transactions,
    SUM(Amount_NGN) AS Total_Value,
    SUM(
        CASE
            WHEN Risk_Review_Flag = 'Yes' THEN 1
            ELSE 0
        END) AS Risk_Flagged,
    ROUND(SUM(
            CASE
                WHEN Risk_Review_Flag = 'Yes' THEN 1
                ELSE 0
            END) * 100.0 / COUNT(*), 2) AS Risk_Rate_Pct
FROM Transaction_Value_Groups
GROUP BY Value_Category
ORDER BY Risk_Rate_Pct DESC;
-- Why this matters to the management
-- If risk exposure increases significantly with transaction value, FinTrust may need stronger monitoring around high-value transactions
-- ATM channel which has the highest transaction value also has the highest risk flagged transactions and risk rate percentage.

-- 6. Device Performance Analysis 
-- Week 2 dataset includes Device_Type, and I already analysed risk percentage by device.
-- Business question: Which device types have the strongest and weakest transaction outcomes?

SELECT
    Device_Type,
    COUNT(*) AS Total_Transactions,
    SUM(Amount_NGN) AS Total_Transaction_Value,
    ROUND(AVG(Amount_NGN), 2) AS Average_Transaction_Value,
    SUM(
        CASE
            WHEN Transaction_Status = 'Successful' THEN 1
            ELSE 0
        END) AS Successful_Transactions,
    SUM(
        CASE
            WHEN Transaction_Status = 'Failed' THEN 1
            ELSE 0
        END
    ) AS Failed_Transactions,

    ROUND(
        SUM(
            CASE
                WHEN Transaction_Status = 'Successful' THEN 1
                ELSE 0
            END) * 100.0 / COUNT(*), 2) AS Success_Rate_Pct,
    ROUND(
        SUM(
            CASE
                WHEN Risk_Review_Flag = 'Yes' THEN 1
                ELSE 0
            END) * 100.0 / COUNT(*), 2) AS Risk_Rate_Pct
FROM FinTrust_Trans
GROUP BY Device_Type
ORDER BY Success_Rate_Pct DESC;

-- Web Browser has the highest success rate percentage (92.26) and a high risk rate percentage of 20.11
-- ATM Terminal has the highest risk rate percentage of 21.64

-- 7. Customers With High Failure Rates
-- Business question: Which customers experience unusually high transaction failure rates?

WITH Customer_Transaction_Performance AS (
    SELECT
        c.Customer_ID,
        c.Customer_Name,
        c.Customer_Segment,
        COUNT(t.Transaction_ID) AS Total_Transactions,
        SUM(
            CASE
                WHEN t.Transaction_Status = 'Successful'
                THEN 1 ELSE 0
            END
        ) AS Successful_Transactions,

        SUM(
            CASE
                WHEN t.Transaction_Status = 'Failed'
                THEN 1 ELSE 0
            END
        ) AS Failed_Transactions
    FROM FinTrust_Cust c
    JOIN FinTrust_Trans t
        ON c.Customer_ID = t.Customer_ID
    GROUP BY
        c.Customer_ID,
        c.Customer_Name,
        c.Customer_Segment)
SELECT
    Customer_ID,
    Customer_Name,
    Customer_Segment,
    Total_Transactions,
    Successful_Transactions,
    Failed_Transactions,
    ROUND(
        Failed_Transactions * 100.0 / Total_Transactions,
        2) AS Failure_Rate_Pct
FROM Customer_Transaction_Performance
WHERE Total_Transactions >= 5
ORDER BY Failure_Rate_Pct DESC;
-- This shows the total transactions of various customers. Emeka Ojo and Blessing Eze had the highest failure rate percentage of 42.86

-- 8. Monthly Transaction Trends
-- Week 2 looked at transaction activity by date, day and hour.
-- Now we'll move to monthly business trends.
-- Business question: How do transaction volume, transaction value and success rate change over time?

WITH Monthly_Transactions AS (
    SELECT
        DATE_FORMAT(Transaction_Date, '%Y-%m') AS Transaction_Month,
        COUNT(*) AS Total_Transactions,
        SUM(Amount_NGN) AS Total_Transaction_Value,
        SUM(
            CASE
                WHEN Transaction_Status = 'Successful'
                THEN 1 ELSE 0
            END
        ) AS Successful_Transactions
    FROM FinTrust_Trans
    GROUP BY DATE_FORMAT(Transaction_Date, '%Y-%m')
)
SELECT
    Transaction_Month,
    Total_Transactions,
    Total_Transaction_Value,
    Successful_Transactions,
    ROUND(
        Successful_Transactions * 100.0 / Total_Transactions,
        2) AS Success_Rate_Pct,
    ROUND(
        Total_Transaction_Value /
        Total_Transactions,
        2) AS Average_Transaction_Value
FROM Monthly_Transactions
ORDER BY Transaction_Month;
-- January and March had the same number of transactions of 4133.