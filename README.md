# Customer Retention Analysis

## Project Overview

This project analyzes customer retention and purchasing behavior using the UCI Online Retail dataset. The objective was to understand how well customers are retained after acquisition, identify revenue concentration among customers, and examine trends in customer growth and purchasing activity. The project combined R, SQL, and Power BI to transform raw transaction data into an interactive dashboard highlighting customer retention and revenue trends.

---

## Table of Contents

- [Business Questions](#business-questions)
- [Dataset](#dataset)
- [Tools Used](#tools-used)
- [Step 1: Data Cleaning (R)](#step-1-data-cleaning-r)
- [Step 2: Cohort Analysis (R)](#step-2-cohort-analysis-r)
- [Step 3: SQL Analysis](#step-3-sql-analysis)
- [Step 4: Dashboard Development](#step-4-dashboard-development)
- [Key Results](#key-results)
- [Business Impact](#business-impact)
- [Dashboard](#dashboard)
- [Repository Structure](#repository-structure)
- [What I learned](#what-i-learned)

## Business Questions

1. How well are customers retained after their first purchase?
2. How does retention change over time?
3. Which customers generate the most revenue?
4. How do revenue and customer activity trends evolve over time?
5. Which countries contribute the most revenue?

---

## Dataset

**Source:** UCI Online Retail Dataset

**Time Period:** December 2010 – December 2011

**Records After Cleaning:** 397,884 transactions

The UCI Online Retail dataset contains transactional purchase records from a UK-based online retailer. Each record includes invoice information, product details, quantities purchased, customer identifiers, and country of origin.

---

## Tools Used

- R
- SQL (MySQL)
- Power BI

---

## Methodology

### Step 1: Data Cleaning (R)

- Reduced the dataset from 541,909 transactions to 397,884 cleaned transactions
- Removed transactions with missing Customer IDs
- Removed returns and negative quantities
- Removed transactions with zero prices
- Created transaction-level revenue measures

<img width="381" height="141" alt="image" src="https://github.com/user-attachments/assets/e9ce32f9-a50d-40e1-8a32-ff86a21cc140" />
<img width="416" height="100" alt="image" src="https://github.com/user-attachments/assets/75a15eaf-6be2-471a-8437-fb929f45293a" />
<img width="1445" height="501" alt="image" src="https://github.com/user-attachments/assets/65af4028-be96-45b0-8cf3-a418f10416bd" />


### Step 2: Cohort Analysis (R)

- Assigned customers to acquisition cohorts
- Calculated monthly retention rates
- Created cohort retention heatmaps
- Calculated average retention trends

<img width="543" height="322" alt="image" src="https://github.com/user-attachments/assets/c67c5f66-5587-40c8-afa5-67fe8ff10e84" />
<img width="617" height="242" alt="image" src="https://github.com/user-attachments/assets/530930f6-1cfd-4988-8f96-992aabd00467" />

This code depicts how customer acquisition cohorts were created in R to track retention behavior over time. Tracking retention rates over time formed the foundation of the retention heatmap analysis.

### Step 3: SQL Analysis

SQL was used to aggregate customer and transaction data into business metrics including monthly revenue, customer growth, transaction volume, average order value (AOV), customer revenue concentration, and country-level performance.

  <img width="545" height="292" alt="image" src="https://github.com/user-attachments/assets/f72cd194-e90c-425a-a903-a003308aeadd" />

This SQL code was used to aggregate monthly revenue, customer, and AOV trends. The output of this code was exported to Power BI to create the final dashboard for the project.

### Step 4: Dashboard Development

Built an interactive Power BI dashboard including:

- KPI cards
- Cohort retention heatmap
- Revenue trends
- Customer trends
- Average order value trends
- Revenue concentration analysis

---

## Key Results

### Customer Retention

- Customer retention declined sharply following acquisition.
- Month-1 retention typically ranged between approximately 15% and 35%.

### Revenue Growth

- Monthly revenue nearly doubled between July and November 2011.
- Revenue growth was driven by increases in both customer volume and transaction activity.

### Revenue Concentration

- The highest-spending customer quartile generated approximately 80% of total revenue.
- 95 high-value customers generated ~£2.8 million in revenue.

### Geographic Insights

- The United Kingdom generated the vast majority of revenue.
- Ireland and the Netherlands showed exceptionally high revenue per customer.

---

## Business Impact

The analysis revealed that customer retention dropped substantially after acquisition. Furthermore, monthly revenue and customers increased over the year despite the substantial drop in customer retention, highlighting the importance of customer re-engagement strategies. Revenue growth was primarily driven by increases in customer acquisition and transaction activity, while a relatively small group of high-value customers generated the majority of total revenue. These findings demonstrate how customer retention and spending behavior influence overall business performance.

---

## Dashboard

<img width="1206" height="680" alt="image" src="https://github.com/user-attachments/assets/5736f0a3-486b-424c-9203-42e87bdea891" />

---

## Repository Structure

```text
customer-retention-analysis/
│
├── data/        # Raw and exported datasets used in analysis and Power BI
├── r/           # Data cleaning and cohort analysis scripts
├── sql/         # SQL analysis queries
├── powerbi/     # Dashboard file
└── README.md    # Project documentation
```

---

## What I Learned

- Developed my first cohort retention analysis in R.
- Applied SQL to answer business-focused questions.
- Built my first end-to-end Power BI dashboard.
- Learned how customer acquisition, transaction volume, and average order value interact to drive revenue growth.
- Learned how to organize and document analytical projects using GitHub repositories.

---
