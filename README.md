# Customer Retention Analysis

## Project Overview

This project analyzes customer retention and purchasing behavior using the UCI Online Retail dataset. The objective was to understand how well customers are retained after acquisition, identify revenue concentration among customers, and examine trends in customer growth and purchasing activity.

---

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

---

## Tools Used

- R
- SQL (MySQL)
- Power BI

---

## Methodology

### Data Cleaning

- Removed transactions with missing Customer IDs
- Removed returns and negative quantities
- Removed transactions with zero prices
- Created transaction-level revenue measures

### Cohort Analysis

- Assigned customers to acquisition cohorts
- Calculated monthly retention rates
- Created cohort retention heatmaps
- Calculated average retention trends

### SQL Analysis

- Monthly revenue trends
- Customer growth trends
- Average order value analysis
- Revenue concentration analysis
- Country analysis

### Dashboard Development

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

### Geographic Insights

- The United Kingdom generated the vast majority of revenue.
- Ireland and the Netherlands showed exceptionally high revenue per customer.

---

## Dashboard

[Insert Dashboard Screenshot Here]

---

## Repository Structure

Brief explanation of folders and contents.
