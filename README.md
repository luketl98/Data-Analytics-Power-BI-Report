# Data Analytics Power BI Report

This project showcases a **multi-page Power BI report** for an international retailer, incorporating **ETL, star-schema data modelling, DAX-driven insights, SQL queries, and interactive visuals**. It includes:
- **C-suite summaries**
- **Customer segmentation**
- **Product performance analysis**
- **Retail performance mapping**
- **SQL querying** for deeper insights

---

## Step 1: Importing and Transforming Data

### Data Sources & Import Methods
- **Orders Table:** Imported from **Azure SQL Database**
- **Products Table:** Loaded from a **CSV file** via Power BI’s Get Data feature
- **Stores Table:** Imported from an **Azure Blob Storage** container
- **Customers Table:** Combined multiple CSV files using the Folder data connector

### Key Transformations
The following transformations were made using **Power Query**.
- **Orders:**
  - Removed sensitive data (Card Number column)
  - Split Order Date and Shipping Date into separate Date and Time columns
  - Filtered out null values in the Order Date column
  - Renamed columns to align with Power BI naming conventions
- **Products:**
  - Removed duplicate values in the Product Code column
  - Renamed columns for consistency
- **Stores:**
  - Standardised region names using Replace Values
  - Renamed columns for consistency
- **Customers:**
  - Combined First Name and Last Name into a Full Name column
  - Removed unnecessary columns
  - Renamed columns to match Power BI naming conventions

*Screenshot: Power Query* 

---

## Step 2: Creating the Data Model (Star Schema)

### Establishing Relationships
A **Star Schema** was implemented to optimise filtering and aggregation performance.

**Relationships Created:**
- `Products[Product Code]` → `Orders[Product Code]`
- `Stores[Store Code]` → `Orders[Store Code]`
- `Customers[User UUID]` → `Orders[User ID]`
- `Dates[Date]` → `Orders[Order Date]`
- `Dates[Date]` → `Orders[Shipping Date]` _(Inactive)_

**Key Considerations:**
- `Orders[Order Date]` was set as the **active relationship** for accurate time-based reporting.
- **One-to-many relationships** with single filter direction flow from dimension to fact tables.

*Screenshot: Star Schema Data Model*

### Creating the Date Table (DAX)
A **custom Date Table** was created to enable time intelligence functions:
```DAX
Date Table = ADDCOLUMNS(
    CALENDAR(DATE(YEAR(MIN(Orders[Order Date])),1,1), DATE(YEAR(MAX(Orders[Shipping Date])),12,31)),
    "Day of Week", FORMAT(Dates[Date], "dddd"),
    "Month Name", FORMAT(Dates[Date], "mmmm"),
    "Month Number", MONTH(Dates[Date]),
    "Start of Month", STARTOFMONTH(Dates[Date]),
    "Start of Quarter", STARTOFQUARTER(Dates[Date]),
    "Start of Week", Dates[Date] - WEEKDAY(Dates[Date], 2) + 1,
    "Start of Year", STARTOFYEAR(Dates[Date]),
    "Quarter", QUARTER(Dates[Date]),
    "Year", YEAR([Date])
)
```

---

## Step 3: Creating Measures & Heirarchies

### Examples of Key DAX Measures
```DAX
Total Revenue = SUMX(Orders, Orders[Product Quantity] * RELATED(Products[Sale Price]))
Profit YTD = TOTALYTD([Total Profit], Dates[Date])
Previous Quarter Revenue = 
CALCULATE(
    [Total Revenue], 
    DATESQTD(DATEADD(Dates[Date], -1, QUARTER))
)
```

### Creating Hierarchies
- **Date Hierarchy:** Year > Quarter > Month > Week > Day
- **Geography Hierarchy:** Region > Country > Province

---

## Step 4: Building Report Pages

### **1. 'Executive Summary' page**
The Executive Summary Page provides a high-level overview of the company's performance, designed for C-suite executives to quickly assess key business metrics. The report helps executives track revenue, profit, and order performance over time and compare them against business targets.

#### Key Objectives
- Provide a **quick summary** of business performance.
- Allow **drill-down analysis** for revenue trends.
- Show **KPIs** for revenue, profit, and orders vs. previous quarter targets.

#### Components & Visuals
- **Card visuals**: Total Revenue, Profit, Orders
- **Line Chart**: Revenue trends over time
- **KPIs**: Previous quarter vs. targets - with conditional formatting
- **Bar Chart**: For Orders by Product Category
- **Donut Charts**: For Revenue Breakdown by Country and Store Type

*Screenshot: Executive Summary Page*

---

### **2. 'Customer Detail' page**
This page is focused on customer-level analysis. It includes various visuals to provide insights into customer behavior, revenue distribution, and trends.

#### Key Objectives
- 

#### Components & Visuals
- **Card Visuals**: Unique Customers and Revenue per Customer
- **Donut Charts**: Customers by Country & Product Category
- **Line Chart**: Customer trends over time
- **Table**: Top 20 customers by revenue
- **Customer Insight Cards**: Three card visuals to display the top customer by revenue; Name, Total Orders, Total Revenue
- **Date Slicer**: Allows users to filter the report by Date

*Screenshot: Customer Detail Page*

---

### **3. 'Product Detail' page**
The Product Detail Page provides an in-depth view of product performance, helping stakeholders identify top-performing products and analyse sales trends.

#### Key Objectives
- Track **Revenue, Orders, and Profit** at the product level.
- Identify **top-selling products** and **high-profit items**.
- Enable **region and product-based filtering** for deeper insights

#### Components & Visuals
- **Gauge Charts**: Revenue, Orders, Profit vs. Targets - with conditional formatting
- **Scatter Chart**: Profit per Item vs. Quantity Sold
- **Table**: Top 10 products by revenue
- **Area Chart**: Analyse revenue trends by category over time
- **Pop-out Slicer toolbar**: Hidden slicer panel created using Power BI bookmarks, allowing users to toggle the slicers via a navigation bar.
Allowing users to filter for:
- Product Category (multi-select enabled)
- Country (includes "Select All" option)

*Screenshot: Product Performance Page*
+ 
*Screenshot: Product Performance Page - Showing filter/slicer*

---

### **4. 'Stores Map' page**
The Stores Map Page allows regional managers to analyse store profitability and sales trends. Also allows users to Drillthrough for a more detailed analysis.

#### Key Objectives
- Provide a **visual representation of store performance** using a **map visualisation**.
- Enable **drillthrough analysis** for individual store details.
- Allow users to **compare stores based on revenue, profit, and orders**.

#### Components & Visuals
- **Bubble Map**: Store locations, size by Profit YTD
- **Drillthrough**: Store-level analysis
- **Custom Tooltip**: Profit YTD vs. Target

*Screenshot: Stores Map page* Showing custom tooltip
+
*Screenshot: Drillthrough page

---

## Step 5: Enhancing Navigation & UX

**Custom sidebar with navigation buttons** for seamless page transitions:
- Four buttons were added, one for each page of the report.
- PNG icons were used for the buttons.
- A hover effect was then applied to each button.

**Cross-filtering optimised** to prevent unintended interactions:
Power BI's default cross-filtering and highlighting were modified to ensure that only relevant visuals interact with each other, preventing unintended filtering.

*Screenshot: Navigation Sidebar*

---

## Step 6: SQL Queries for Additional Insights
In this section, I connected to an Azure PostgreSQL database and used SQL queries to answer business-related questions. The results were exported to CSV files and stored on GitHub.

### Questions Answered Using SQL:
1. How many staff are there in all UK stores?
2. Which month in 2022 had the highest revenue?
3. Which German store type had the highest revenue for 2022?
4. Create a view with store types, total sales, percentage of total sales, and order count.
5. Which product category generated the most profit for the "Wiltshire, UK" region in 2021?

**5. Most Profitable Product Category in Wiltshire, UK (2021)**
This query calculates the most profitable product category in Wiltshire for 2021 by subtracting cost from sale price and multiplying by quantity sold.

```sql
SELECT dim_products.category, 
       SUM((dim_products.sale_price - dim_products.cost_price) * orders.product_quantity) AS total_profit
FROM orders
JOIN dim_stores ON orders.store_code = dim_stores.store_code
JOIN dim_products ON orders.product_code = dim_products.product_code
JOIN dim_date 
    ON TO_DATE(orders.order_date, 'DD/MM/YYYY') = TO_DATE(dim_date.date, 'DD/MM/YYYY')
WHERE dim_stores.country_region = 'Wiltshire' 
AND dim_stores.country = 'United Kingdom' 
AND EXTRACT(YEAR FROM TO_DATE(orders.order_date, 'DD/MM/YYYY')) = 2021
GROUP BY dim_products.category
ORDER BY total_profit DESC
LIMIT 1;
```

## Summary
This project highlights **ETL, data modelling, DAX measures, report design, UX enhancements, and SQL querying** to deliver **insightful business intelligence solutions**. Screenshots and detailed step-by-step breakdowns make it easy to follow and replicate.
