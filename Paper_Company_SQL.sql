-- DATABASE SETUP
-- Create the Region table
CREATE TABLE Region (
 "id" INT Primary key, 
 "name" VARCHAR (200));
 
-- Create the Sales_reps table to store employee data and link them to regions
CREATE TABLE Sales_reps (
"id" INT Primary key,
"name" VARCHAR (200),
region_id INT,
FOREIGN KEY (region_id) REFERENCES Region("id"));

-- Create the Accounts table to store customer details and their assigned sales rep
CREATE TABLE Accounts( 
"id" INT Primary key,
"name" VARCHAR (200),
Website VARCHAR (1000),
Lat DECIMAL,
Long DECIMAL,
Primary_poc VARCHAR,
Sales_rep_id INT,
FOREIGN KEY (Sales_rep_id) REFERENCES Sales_reps("id"));

-- Create the Web_events table to track customer website visits and marketing channels
CREATE TABLE Web_events (
"id" INT Primary key,
Account_id INT,
FOREIGN KEY (Account_id) REFERENCES Accounts("id"),
Occurred_at Timestamp,
Channel VARCHAR (200));

-- Create the Orders table to track purchase history, quantities, and revenue per paper type
CREATE TABLE Orders (
"id" INT Primary Key,
Account_id INT,
FOREIGN KEY (Account_id) REFERENCES Accounts("id"),
Occured_at Timestamp,
Standard_qty INT,
Glossy_qty INT,
Poster_qty INT,
Total INT,
Standard_amt_usd NUMERIC,
Gloss_amt_usd NUMERIC,
Poster_amt_usd NUMERIC,
Total_amt_usd NUMERIC );

SELECT * FROM Region
SELECT * FROM Sales_reps
SELECT * FROM Accounts
SELECT * FROM Web_events
SELECT * FROM Orders

-- SECTION A: CORE ANALYSIS

--Section A: Q1 - Customer Value Analysis
-- Evaluates customers total purchase history with total spend greater than $100,000.
SELECT a.name AS Account_name,
SUM (o.Total_amt_usd) As Total_lifetime_spend
FROM Accounts a
JOIN Orders o
ON a.id = o.Account_id
GROUP BY a.id
HAVING SUM(o.Total_amt_usd) > 100000
ORDER BY Total_lifetime_spend DESC;

--Section A: Q2 - Sales Rep Performance
-- Evaluates employee performance by calculating total revenue generated per rep and returning the top 3.
SELECT s.name AS Sales_rep_name, 
SUM (o.Total_amt_usd) As Total_revenue_generated
FROM Sales_reps s
JOIN Accounts a
ON s.id = a.sales_rep_id
JOIN Orders o
ON a.id = o.account_id
GROUP BY s.id
ORDER BY Total_revenue_generated DESC
LIMIT 3;

--Section A: Q3 - Customer Engagement
-- Analyzes engagement by comparing website visits to actual purchases for highly active accounts (>10 web events).
SELECT a.name AS Account_name, 
COUNT(Distinct w.id) AS No_of_web_events,
COUNT(Distinct o.id) AS No_of_orders
FROM Web_events w
JOIN Accounts a 
ON w.account_id = a.id
LEFT JOIN Orders o
ON a.id = o.account_id
GROUP BY a.id
HAVING COUNT(Distinct w.id) > 10;

--Section A: Q4 - Inactive Customers
-- Isolates non-active accounts by finding customers who exist in the database but have zero matching order records.
SELECT a.id, a.name, total_amt_usd
FROM Accounts a
LEFT JOIN Orders o
ON a.id = o.account_id
where o.Account_id is NULL;

--Section A: Q5 - Recently Active Customers
-- Returns all active buyers, filtering for orders placed within 30 days of the newest record.
Select a.id, a.name, o.occured_at
From Accounts a 
JOIN Orders o
ON a.id = o.account_id
WHERE Occured_at >= (Select MAX(occured_at) - INTERVAL '30 days'FROM Orders)
ORDER BY o.occured_at;

-- SECTION B: BUSINESS INSIGHTS

--Section B: Q1 - Regional Performance 
-- Calculates the total gross revenue grouped by region name.
SELECT r.name As Region_name,
SUM (Total_amt_usd) as Total_revenue
FROM Region r
JOIN Sales_reps s
ON r.id = s.region_id
JOIN Accounts a
ON s.id = a.sales_rep_id
JOIN Orders o
ON a.id = o.account_id
GROUP by r.id
ORDER By Total_revenue;

-- using CTE
WITH Account_total AS(
SELECT Account_id,
SUM (Total_amt_usd) as Account_revenue
FROM Orders
GROUP BY Account_id)

SELECT r.name As Region_name,
SUM (ac.Account_revenue) as Total_revenue
FROM Region r
JOIN Sales_reps s
On r.id = s.region_id
JOIN Accounts a
on s.id = a.sales_rep_id
JOIN Account_total ac
on a.id = ac.account_id
GROUP By r.id
ORDER By total_revenue;

--Section B: Q1(b) - Below Average Regions
-- Identifies underperforming regions by comparing their total revenue to the global average across all regions.
WITH Regional_total AS (
SELECT r.name As Region_name,
SUM (o.total_amt_usd) as Total_revenue
FROM Region r
JOIN Sales_reps s
On r.id = s.region_id
JOIN Accounts a
on s.id = a.sales_rep_id
JOIN orders o
on a.id = o.account_id
GROUP by r.id)

SELECT Region_name, Total_revenue
FROM Regional_total
WHERE Total_revenue < (Select AVG (Total_revenue)
FROM Regional_total);

--Section B: Q2 - Product Revenue Breakdown
-- Aggregates total revenue strictly by paper type to determine product performance in a single row.
SELECT SUM (standard_amt_usd) AS Total_standard_revenue,
SUM (poster_amt_usd) AS Total_poster_revenue,
SUM (gloss_amt_usd) AS Total_glossy_revenue
FROM Orders;

--Section B: Q3 - Monthly Sales Trend
-- Extracts year and month to track revenue trends over time.
SELECT EXTRACT (year FROM occured_at) AS Year,
EXTRACT (month FROM occured_at) AS Month,
SUM (total_amt_usd) AS Total_revenue
FROM Orders
GROUP BY EXTRACT (year FROM occured_at),
EXTRACT (month FROM occured_at)
ORDER BY Year, Month;

--Section B: Q4 - Channel Effectiveness
-- Measures marketing success by counting the total number of customer interactions per channel.
SELECT Channel,
Count (id) AS Number_of_events
FROM Web_events 
GROUP BY channel
ORDER BY Number_of_events DESC;

-- SECTION C: ADVANCED LOGIC

--Section C: - Q1 Above Average Orders
-- Lists individual transactions that exceed the average value of a single order.
SELECT id, Total_amt_usd
FROM Orders
WHERE Total_amt_usd > (Select AVG(Total_amt_usd)
FROM Orders);


--Section C: Q2 - Customer Segmentation
-- Categorizes all accounts into value tiers based on total spend. Uses LEFT JOIN to ensure $0 spenders are included.
SELECT a.name AS account_name,
COALESCE (SUM(o.total_amt_usd), 0) AS Total_spend,
CASE 
WHEN SUM(o.total_amt_usd) > 100000 THEN 'High Value'
WHEN SUM(o.total_amt_usd) >= 50000 THEN 'Medium Value'
ELSE 'Low Value' END AS Segment
FROM accounts a
LEFT JOIN orders o
ON a.id = O.account_id
GROUP BY a.id
ORDER BY Total_spend DESC;

--Section C: Q3 - Revenue Contribution
-- Determines what percentage of company revenue is attributed to each specific account name.
SELECT a.name AS account_name,
COALESCE(SUM(o.total_amt_usd), 0) AS Total_spend,
ROUND(CAST((COALESCE(SUM(o.total_amt_usd), 0) / (SELECT SUM(total_amt_usd) FROM Orders)) * 100 AS NUMERIC), 2)
AS Percentage_contribution
FROM Accounts a
LEFT JOIN Orders o
ON a.id = o.account_id
GROUP By a.id
ORDER By Percentage_contribution DESC;

--Section C: Q4 - Sales Rep Portfolio Size
-- Counts the exact number of unique customer accounts currently assigned to each sales representative.
SELECT s.name As Sales_rep_name,
COUNT (a.id) AS Num_of_accounts
FROM Sales_reps s
JOIN Accounts a
on S.id = a.sales_rep_id
GROUP By s.id
ORDER By Num_of_accounts;

--Section C: Q5 - One-Order Customers
-- Identifies accounts with exactly one order.
SELECT a.name AS account_name,
COUNT (o.id) AS total_orders
FROM accounts a
JOIN orders o 
ON a.id = o.account_id
GROUP BY a.id
HAVING COUNT (o.id) = 1
ORDER BY a.name;

--Section C: Q6 - First Order per Customer
-- Retrieves account name and date of first order.
SELECT a.name AS account_name,
MIN (o.occured_at) AS First_order_date
FROM accounts a
JOIN orders o 
ON  a.id = o.account_id
GROUP BY a.id
ORDER BY a.name;

-- SECTION D: THE CHALLENGE

-- Section D: Q1 - Regional High-Value Customers
-- Returns the account with highest total spend, for each region,
WITH account_regional_spend AS(
SELECT r.name AS Region_name,
a.name AS Account_name,
SUM (o.total_amt_usd) AS Total_spend
FROM region r
JOIN Sales_reps s
ON r.id = s.region_id
JOIN Accounts a 
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY r.name,a.name),

ranked_accounts AS (
SELECT region_name, account_name,total_spend,
RANK() OVER (PARTITION BY region_name 
ORDER BY total_spend DESC) AS spending_rank
FROM account_regional_spend)

SELECT region_name,account_name,total_spend
FROM ranked_accounts
WHERE spending_rank = 1;

-- Section D: Q2 - Conversion Insight
--Find accounts that have more than 20 web events but less than 2 orders.
SELECT a.name AS account_name,
COUNT(DISTINCT w.id) AS total_web_events,
COUNT(DISTINCT o.id) AS total_orders
FROM accounts a
JOIN web_events w ON a.id = w.account_id
LEFT JOIN orders o ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING COUNT(DISTINCT w.id) > 20 
AND COUNT(DISTINCT o.id) < 2
ORDER BY total_web_events DESC;

-- Section D: Q3 - Sales Rep Efficiency
--Return sales rep name, total revenue, number of accounts, and average revenue per account.
SELECT s.name AS sales_rep_name,
SUM(o.total_amt_usd) AS total_revenue,
COUNT(DISTINCT a.id) AS num_accounts,
ROUND((SUM(o.total_amt_usd) / COUNT(DISTINCT a.id))::NUMERIC, 2) AS avg_revenue_per_account
FROM sales_reps s
JOIN accounts a ON s.id = a.sales_rep_id
JOIN orders o ON a.id = o.account_id
GROUP BY s.id, s.name
ORDER BY avg_revenue_per_account DESC;














