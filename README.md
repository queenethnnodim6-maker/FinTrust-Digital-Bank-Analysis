# FinTrust Digital Bank — End-to-End Transaction Analysis

## Project Overview

FinTrust Digital Bank is a digital banking business seeking to better understand its transaction activity, customer behaviour, transaction channels, risk patterns, and operational performance.

This project presents an end-to-end analysis of FinTrust's transaction data, moving from initial business questions and data quality assessment through SQL analysis, Python exploratory data analysis (EDA), and Power BI dashboard development.

The objective was not simply to describe the dataset, but to transform raw transaction data into actionable business insights that could support decision-making across customer management, digital channels, transaction operations, and risk monitoring.

---

## Business Problem

Digital banks generate large volumes of transaction data across different channels, devices, locations, and transaction statuses.

However, raw transaction records alone do not answer important management questions.

## Key Analytical Questions

The project investigated questions such as:

- What is the total transaction value?
- How many transactions are recorded?
- How many customers are represented?
- What is the average transaction value?
- Which transaction channels are most active?
- Which device types are most commonly used?
- What is the distribution of transaction statuses?
- What proportion of transactions are successful?
- Which locations generate the highest transaction activity?
- How is transaction value distributed across channels and devices?
- Are there notable patterns in risk-flagged transactions?

The FinTrust analysis was designed to answer these questions using multiple analytical tools.


# Project Objectives

The analysis focused on five major objectives:

1. Assess the quality and reliability of the raw transaction data.
2. Analyze transaction activity and customer behaviour using SQL.
3. Explore transaction patterns and distributions using Python.
4. Develop an interactive Power BI management dashboard.
5. Translate analytical results into meaningful business findings and recommendations.

---

# Analytical Workflow

The project followed a structured end-to-end analytics workflow:

```text
Raw Transaction Data
        ↓
Initial Analysis Plan
        ↓
Business Questions
        ↓
Excel Data Quality Assessment
        ↓
Data Cleaning & Validation
        ↓
SQL Transaction Analysis
        ↓
Python Exploratory Data Analysis
        ↓
Power BI Dashboard
        ↓
Business Findings
        ↓
Management Insights & Recommendations

```

### Excel Data Quality Assessment

The raw dataset was first examined in Excel to understand its structure and identify potential data quality issues.

The assessment examined:

- Missing values
- Duplicate records
- Inconsistent categories
- Incorrect data types
- Formatting inconsistencies
- Invalid or unusual values
- Transaction status consistency
- Channel and device categories
- Customer identifiers
- Transaction amounts
- Risk-related fields
- Data Quality Process

The process involved:
- Importing the raw dataset into Excel.
- Inspecting the columns and data types.
- Checking for blank and missing values.
- Identifying duplicate records.
- Standardizing categorical values.
- Checking numerical fields for inconsistencies.
- Validating transaction status categories.
- Reviewing transaction amounts for unusual values.
- Preparing the dataset for further analysis.

The purpose of this stage was to ensure that subsequent SQL, Python, and Power BI analyses were based on reliable and consistent data.

### SQL Transaction Analysis

SQL was used to perform structured analysis of the transaction data.

The analysis focused on aggregating and segmenting transaction activity to identify patterns that would be difficult to understand from raw records alone.

#### SQL Techniques Used

The project applied SQL concepts including:

- SELECT
- WHERE
- GROUP BY
- ORDER BY
- Aggregate functions
- COUNT()
- SUM()
- AVG()
- MIN()
- MAX()
- Conditional logic
- Filtering
- Customer-level aggregation
- Channel analysis
- Device analysis
- Transaction status analysis
- Examples of Questions Answered with SQL

SQL was used to investigate:

- Total transaction value
- Total number of transactions
- Average transaction value
- Transaction activity by channel
- Transaction activity by device
- Transaction status distribution
- Customer transaction behaviour
- High-value customers
- High-frequency customers
- Risk-related transaction patterns

SQL provided the foundation for understanding the numerical and categorical structure of the transaction data.

### Python Exploratory Data Analysis

Python was used to perform exploratory data analysis and provide another perspective on the dataset.

The analysis was performed using Python and pandas, with visualizations used to explore distributions and relationships within the data.

Python EDA Process

The workflow included:

- Importing the dataset.
- Loading the data into pandas.
- Inspecting the dataset structure.
- Checking rows and columns.
- Examining data types.
- Checking missing values.
- Reviewing descriptive statistics.
- Exploring categorical variables.
- Examining transaction amount distributions.
- Creating visualizations for key transaction dimensions.

Areas Explored

The Python analysis examined:

- Transaction amount distribution
- Transaction activity
- Transaction channels
- Device types
- Transaction statuses
- Customer transaction value
Other relevant categorical and numerical patterns

Python helped validate patterns discovered during earlier analysis and provided visual exploration of the dataset.

### Power BI Dashboard

Power BI was used to transform the analytical results into an interactive management dashboard.

The dashboard was designed to provide management with a quick overview of transaction performance while allowing users to explore different dimensions of the data.

Key Dashboard KPIs

The dashboard includes metrics such as:

- Total Customers
- Total Transactions
- Total Transaction Amount
- Average Transaction Value
- Successful Transactions
- Transaction Status
- Channel Activity
- Device Activity

The exact KPI calculations are based on the cleaned transaction dataset.

Dashboard Visualizations

The dashboard was designed to communicate several important dimensions of transaction activity.

Transaction Performance

Visuals were used to understand overall transaction volume and value.

Transaction Status

Status analysis helps identify the distribution of:

- Successful transactions
- Failed transactions
- Pending transactions

This provides an operational view of transaction outcomes.

- Channel Analysis

Transaction channels were compared to understand how customers interact with FinTrust's digital banking services.

- Device Analysis

Device categories were analyzed to understand the technologies customers use when performing transactions.

- Customer Value

Customer-level transaction activity was examined to identify differences in transaction contribution and behaviour.

- Risk Monitoring

Risk-related transaction indicators were incorporated to help identify areas that may require additional investigation.

## Business Findings

The final stage of the project translated analytical results into business findings.

Rather than simply describing what a chart shows, findings were structured using:

Finding → Evidence → Business Meaning

This approach connects the data to a potential management decision.

For example:

### Finding

A particular transaction channel contributes a significant share of overall transaction activity.

### Evidence

The channel records a substantial proportion of the transaction count and/or transaction value compared with other channels.

### Business Meaning

FinTrust may need to prioritize the reliability, usability, and monitoring of this channel because changes in its performance could have a meaningful effect on overall transaction activity.

Key Business Areas Identified

The analysis provides insights across several areas:

- Customer Behaviour

Transaction patterns can help FinTrust understand customer activity and identify customers who contribute significant transaction value or frequency.

- Digital Channel Performance

Comparing transaction channels helps management understand where customers are conducting transactions and where operational resources may be most important.

- Device Usage

Device analysis provides insight into the technologies customers use when accessing FinTrust's services.

- Transaction Operations

Transaction status analysis helps highlight successful, failed, and pending transactions that may require operational monitoring.

- Risk Monitoring

Risk-related indicators provide a starting point for identifying transaction segments that may require additional investigation or monitoring.

- Revenue and Transaction Value

Transaction value analysis helps management understand the monetary scale of activity across different customer and transaction segments.

## Tools & Technologies
- Microsoft Excel: for data quality assessment, cleaning and preliminary analysis
- MySQL: Transaction analysis and customer-level analysis
- Python: Exploratory data analysis and visualization
- Pandas: Data manipulation and analysis
- Numpy: Data manipulation and analysis
- Jupyter Notebook: Data manipulation and analysis
- Matplotlib: For Visualizaton purposes within the Python environment
- Power BI:	Interactive dashboard and management reporting
- GitHub: Project documentation and portfolio prese
