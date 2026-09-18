# FinTrust Digital Bank Analysis

## Turning Transaction Data into Business Insights

![Excel](https://img.shields.io/badge/Excel-Data%20Cleaning%20%26%20Exploration-217346?style=flat&logo=microsoftexcel&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-Data%20Analysis-4479A1?style=flat&logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboarding-F2C811?style=flat&logo=powerbi&logoColor=black)
![Status](https://img.shields.io/badge/Project-Completed%20%2F%20In%20Progress-blue?style=flat)

---

## 📌 Project Overview

FinTrust is a financial services business with transaction-level data containing information about customer transactions, transaction values, channels, locations, devices, transaction outcomes, and risk-review flags.

The purpose of this project is to transform raw transaction records into meaningful business insights that can help stakeholders understand:

- Customer transaction behaviour
- Transaction activity and volume
- Transaction value
- Channel usage
- Transaction outcomes
- Location-based activity
- Risk-review patterns
- Operational areas that may require further investigation

The project follows a practical analytics workflow:

**Excel → MySQL → Power BI**

Excel is used for initial data inspection, cleaning, validation, and exploration.

MySQL is used for structured analysis and answering business questions.

Power BI is used to transform the analysis into an interactive dashboard for communication and decision-making.

---

# 🎯 Business Problem

FinTrust has a large amount of transaction data, but raw transaction records alone do not provide an easy way for stakeholders to understand what is happening across the business.

The business needs to understand:

- How frequently customers transact
- Which transaction types are most common
- Which channels customers use most
- How much transaction value is being processed
- How transaction activity changes over time
- Which transaction types or channels experience more reversals
- Where transaction activity is concentrated
- Where risk-review flags occur most frequently
- How transaction outcomes differ between risk-flagged and non-risk-flagged transactions

The analysis therefore focuses on converting transaction-level data into structured insights that can support informed business and operational decisions.

---

# Project Objective

The objective of this project is to analyze FinTrust's transaction data to uncover patterns in:

- Customer behaviour
- Transaction activity
- Transaction value
- Channel usage
- Transaction outcomes
- Location patterns
- Risk-review activity

The analysis will transform raw transaction records into meaningful insights that can be communicated through SQL analysis and an interactive Power BI dashboard.

---

# Dataset

The dataset contains transaction-level information.

### Dataset Columns

| Column | Description |
|---|---|
| `Transaction_ID` | Unique identifier for each transaction |
| `Customer_ID` | Identifier for the customer who performed the transaction |
| `Transaction_DateTime` | Date and time the transaction occurred |
| `Transaction_Type` | Type of transaction performed |
| `Amount_NGN` | Transaction amount in Nigerian Naira |
| `Channel` | Channel through which the transaction occurred |
| `Device_Type` | Device used to perform the transaction |
| `Location` | Location associated with the transaction |
| `International_Transaction` | Indicates whether the transaction was international |
| `Transaction_Status` | Outcome/status of the transaction |
| `Risk_Review_Flag` | Indicates whether the transaction was flagged for risk review |

---

# 🔎 Business Questions

The analysis is designed to answer the following questions:

### 1. Customer Activity

Which customers make the most transactions, and which transaction types or channels do they use most?

### 2. Transaction Trends

How does transaction volume change over time, and which dates or hours experience the highest activity?

### 3. Transaction Value

Which transaction types generate the highest total transaction value and average transaction value?

### 4. Channel Performance

Which transaction channels are used most frequently, and which channels process the highest transaction value?

### 5. Transaction Outcomes

What proportion of transactions are successful, reversed, or unsuccessful?

Which transaction types or channels have higher reversal rates?

### 6. Location Analysis

Which locations have the highest transaction volume and transaction value?

### 7. Risk Patterns

Which transaction types, channels, locations, or device types have the highest proportion of risk-flagged transactions?

### 8. Risk and Transaction Outcomes

How do transaction outcomes differ between risk-flagged and non-risk-flagged transactions?

---

# Key Performance Indicators (KPIs)

The following KPIs are used to measure transaction performance.

| KPI | Definition | Purpose |
|---|---|---|
| **Total Transaction Volume** | Total number of transactions | Measures overall transaction activity |
| **Total Transaction Value** | Sum of all transaction amounts | Measures total value processed |
| **Average Transaction Value** | Average transaction amount | Shows the typical transaction size |
| **Transaction Success Rate** | Successful transactions ÷ total transactions | Measures transaction completion |
| **Reversal Rate** | Reversed transactions ÷ total transactions | Highlights reversal patterns |
| **Channel Usage Rate** | Transactions by channel ÷ total transactions | Measures channel preference |
| **Risk Flag Rate** | Risk-flagged transactions ÷ total transactions | Measures the proportion requiring risk review |
| **Risk-Flagged Transaction Value** | Total value of risk-flagged transactions | Measures monetary value associated with flagged activity |

> **Important:** A risk-review flag is not treated as proof of fraud. It indicates that a transaction was flagged for review.

---

# 🧹 Data Preparation & Cleaning

Before performing analysis, the dataset was inspected and prepared for reliable analysis.

The data preparation process included:

- Reviewing the dataset structure
- Checking column names and data types
- Checking for missing values
- Checking for duplicate transaction IDs
- Reviewing transaction categories for consistency
- Validating transaction amounts
- Reviewing transaction dates and times
- Checking transaction status values
- Checking risk-review flag values
- Preparing date and time fields for analysis
- Validating the dataset before deeper analysis

### Data Quality Considerations

Particular attention was given to:

- Duplicate transaction IDs
- Missing values
- Incorrect data types
- Inconsistent categorical values
- Invalid transaction amounts
- Date/time formatting
- Unexpected transaction statuses

---

# Tools & Technologies

## Microsoft Excel

Excel was used for:

- Initial data inspection
- Data cleaning
- Data validation
- Exploratory analysis
- PivotTables
- Basic transaction summaries
- Identifying potential data-quality issues

### Excel's role

**Prepare → Inspect → Validate**

---

## MySQL

MySQL was used for:

- Structured querying
- Aggregations
- Grouping
- Filtering
- Customer-level analysis
- Transaction-type analysis
- Channel analysis
- Location analysis
- Risk analysis
- Transaction-status analysis
- Business-question analysis

### Example SQL analysis

```sql
SELECT 
    Transaction_Type,
    COUNT(*) AS Transaction_Count,
    SUM(Amount_NGN) AS Total_Value,
    AVG(Amount_NGN) AS Average_Value
FROM fintrust_transactions
GROUP BY Transaction_Type
ORDER BY Total_Value DESC;
