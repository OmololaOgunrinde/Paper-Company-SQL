#  Paper Company SQL Analysis

**Tools Used:** PostgreSQL  
**Core Skills:** Complex JOINs, CTEs, Window Functions, Data Aggregation, Subqueries, Segmentations

---

##  Project Overview

As a data analyst for a fictional paper distribution company, I was tasked with extracting actionable business intelligence from the company's database. The goal of this project was to answer 14 targeted business questions across four difficulty tiers—ranging from basic customer value analysis to advanced regional performance breakdowns and sales rep efficiency metrics.

### Database Schema
The database consists of 5 related tables: `accounts`, `orders`, `sales_reps`, `region`, and `web_events`.

![Database ERD](/Screenshots/Paper_Company_ERD.jpeg)

---

##  Key Insights & Recommendations

**1. High-Traffic Conversion Success**
* **Insight:** All accounts with more than 20 web events successfully placed at least two orders. There is a 100% conversion rate among high-traffic website visitors.
* **Recommendation:** Stop spending ad money on people who already visit the site. Instead, put the entire marketing budget into campaigns that attract brand-new visitors.

**2. The Retention Risk**
* **Insight:** 18 distinct accounts (including major companies like Delta Air Lines and CBS) placed exactly one order and never returned.
* **Recommendation:** Implement a mandatory 30-day post-purchase follow-up for first-time buyers to improve retention and reduce churn.

**3. Volume vs. Efficiency in Sales**
* **Insight:** While Earlie Schleusner generated the highest total revenue ($1.09M across 11 accounts), Cordell Rieder is the most efficient rep, averaging roughly $149k per account across just 3 accounts.
* **Recommendation:** Cross-train the sales team on Cordell’s upselling strategies. Consider rebalancing account loads so highly efficient reps can manage more clients.

**4. The Midwest Regional Gap**
* **Insight:** There is a massive revenue gap between regions. The Northeast dominates with $7.74M in total revenue, while the Midwest severely lags behind at $3.01M. 
* **Recommendation:** Audit the Midwest territory to figure out why they are $4.7M behind. Determine if the gap is due to a smaller market size, lower headcount, or ineffective sales leadership.

---

##  Business Questions Answered

**Section A: Core Analysis**
* Which customers have a lifetime spend above $100,000?
* Who are the top 3 sales reps by total revenue?
* Which accounts have high web engagement (10+ events)?
* Which accounts have never placed an order?
* Which accounts ordered in the last 30 days?

**Section B: Business Insights**
* Which regions generate the most revenue, and which are below average?
* What is the revenue breakdown by paper type (standard, glossy, poster)?
* What does the monthly sales trend look like across all years?
* Which marketing channels drive the most web events?

**Section C: Advanced Logic**
* Which orders are above the average order value?
* How do customers segment into High Value (>100,000), Medium Value (50,000–100,000), Low Value (<50,000). Return account name, total spend, and segment. 
* What percentage of total company revenue does each account contribute?
* How many accounts does each sales rep manage?
* Which customers have placed only one order?
* What is the account name and date of first order? 

**Section D: Challenge Queries**
* For each region, which account has the highest total spend?
* Which accounts have 20+ web events but less than 2 orders?
* What is each sales rep's average revenue per account?

---

## 🛠️ SQL Techniques Demonstrated

* **Data Aggregation & Filtering:** `GROUP BY`, `HAVING`, `WHERE`
* **Table Linking:** `INNER JOIN` and `LEFT JOIN` (used strategically to retain non-converting customers for accurate segmentation).
* **Advanced Calculations:** Standardizing decimal outputs using `CAST(... AS NUMERIC)` and `ROUND()`.
* **Flow Control:** Categorizing data using `CASE WHEN` logic.
* **Temporary Result Sets:** Utilizing Common Table Expressions (`WITH` clauses) to keep complex queries readable.
* **Window Functions:** Leveraging `RANK() OVER (PARTITION BY ...)` to solve Greatest-N-Per-Group problems without data loss.

---

## 🚀 How to Use This Repository

1. Clone this repository to your local machine.
2. Open your preferred PostgreSQL environment.
3. Run the `CREATE TABLE` scripts located at the top of the `Paper_Company_SQL.sql` file to build the schema.
4. Import the provided CSV files from the `/Paper_Company_Datasets` folder into their respective tables.
5. Execute the queries sequentially to view the analysis.
Or download the files directly by clicking the green Code button → Download ZIP.


---

## 📂 Files & Code

- [`Paper_Company_SQL.sql`](Paper_Company_SQL.sql) — Full SQL script containing all database setup and query answers.
- [`/Paper_Company_Datasets`](/Paper_Company_Datasets) — Folder containing the 5 raw CSV files used for the analysis.

---

## 📸 Query Screenshots

**Section A1: Customer Lifetime Spend**
![Customer Lifetime Spend](/Screenshots/A1_customer_lifetime_spend.png)

**Section A4: Inactive Customers**
![Inactive Customers](/Screenshots/A4_inactive_customers.png)

**Section B1: Regions Below Average**
![Regions Below Average](/Screenshots/B1_regions_below_average.png)

**Section C2: Customer Segmentation**
![Customer Segmentation](/Screenshots/C2_customer_segmentation.png)

**Section C3: Revenue Contribution**
![Revenue Contribution](/Screenshots/C3_revenue_contribution.png)

**Section D1: Top Customer Per Region (Query)**
![Top Customer Per Region Query](/Screenshots/D1_top_customer_per_region_query.png)

**Section D1: Top Customer Per Region (Output)**
![Top Customer Per Region Output](/Screenshots/D1_top_customer_per_region_output.png)

**Section D3: Sales Rep Efficiency**
![Sales Rep Efficiency](/Screenshots/D3_sales_rep_efficiency.png)

---
