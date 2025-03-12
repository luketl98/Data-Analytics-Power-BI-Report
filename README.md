# Data-Analytics-Power-BI-Report
Power BI Data Analytics Report for an international retailer. This project involves **ETL**, **data modelling (star-schema)**, and creating a **multi-page Power BI report** with **DAX-driven insights**. Includes **C-suite summaries**, **customer segmentation**, **product performance analysis**, and a **retail performance map**.


## Milestone 2: Importing and Transforming Data
### Data Sources and Import Methods
**Orders Table:** Imported from an **Azure SQL Database** using the Database Credentials option.

**Products Table:** Loaded from a **CSV file** via Power BI’s Get Data feature.

**Stores Table:** Imported from an **Azure Blob Storage** container.

**Customers Table:** Combined multiple CSV files using the Folder data connector.

### Transformations Performed
**Orders Table:**
- Removed sensitive data (Card Number column).
- Split Order Date and Shipping Date into separate Date and Time columns.
- Filtered out null values in the Order Date column.
- Renamed columns to align with Power BI naming conventions.

**Products Table:**
- Removed duplicate values in the Product Code column.
- Renamed columns for consistency.

**Stores Table:**
- Standardised region names using Replace Values.
- Renamed columns for consistency.

**Customers Table:**
- Combined First Name and Last Name into a Full Name column.
- Removed unnecessary columns.
- Renamed columns to match Power BI naming conventions.

This milestone ensures a structured, well-prepared dataset ready for data modelling and analysis in subsequent stages.


## Milestone 3: Creating the Data Model
This milestone focused on structuring the **Power BI Data Model**, ensuring it follows a **star schema** and supports time-based analysis.

### Creating the Date Table
To enable **time intelligence functions**, time-based filtering and drill-downs in visualizations, a **Date Table** was created using the following **DAX formula**:

```DAX
DateTable = 
ADDCOLUMNS(
    CALENDAR(
        DATE(YEAR(MIN(Orders[Order Date])), 1, 1), 
        DATE(YEAR(MAX(Orders[Shipping Date])), 12, 31)
    ),
    "Day of Week", FORMAT([Date], "dddd"),
    "Month Number", MONTH([Date]),
    "Month Name", FORMAT([Date], "mmmm"),
    "Quarter", "Q" & FORMAT([Date], "Q"),
    "Year", YEAR([Date]),
    "Start of Year", DATE(YEAR([Date]), 1, 1),
    "Start of Quarter", DATE(YEAR([Date]), SWITCH( TRUE(), 
    MONTH([Date]) IN {1, 2, 3}, 1,
    MONTH([Date]) IN {4, 5, 6}, 4,
    MONTH([Date]) IN {7, 8, 9}, 7,
    MONTH([Date]) IN {10, 11, 12}, 10
), 1),
    "Start of Month", DATE(YEAR([Date]), MONTH([Date]), 1),
    "Start of Week", [Date] - WEEKDAY([Date], 2)
)
```

### Establishing Relationships (Star Schema)

A **Star Schema** was implemented to structure the data model. Relationships were created between fact and dimension tables to ensure **efficient filtering and data aggregation**.

**Relationships Created:**
- `Products[Product Code]` → `Orders[Product Code]`
- `Stores[Store Code]` → `Orders[Store Code]`
- `Customers[User UUID]` → `Orders[User ID]`
- `Dates[Date]` → `Orders[Order Date]`
- `Dates[Date]` → `Orders[Shipping Date]` _(Inactive)_

**Key Considerations:**
- `Orders[Order Date]` was set as the **active relationship** with `Dates[Date]` for accurate time-based reporting.
- All relationships are **one-to-many**, with a **single filter direction** flowing from dimension to fact tables.

**Data Model Screenshot:**
![Star Schema Data Model](INSERT_IMAGE_LINK_HERE)



### Creating the Measures Table

A **dedicated Measures Table** was created to store all **DAX measures**, keeping the data model structured and organized.

**Key Measures Created:**
```DAX
Total Orders = COUNT(Orders[Order ID])

Total Revenue = SUMX(Orders, Orders[Product Quantity] * RELATED(Products[Sale Price]))

Total Profit = SUMX(Orders, (RELATED(Products[Sale Price]) - RELATED(Products[Cost Price])) * Orders[Product Quantity])

Total Customers = DISTINCTCOUNT(Orders[User ID])

Total Quantity = SUM(Orders[Product Quantity])

Profit YTD = TOTALYTD([Total Profit], Dates[Date])

Revenue YTD = TOTALYTD([Total Revenue], Dates[Date])

These measures enable essential business insights, such as profitability, order volume, and customer trends.
```

### Creating the Hierarchies

**Date Hierarchy**
A **Date Hierarchy** was created to enable drill-down analysis in time-based visualizations.

**Hierarchy Levels:**
1. Start of Year
2. Start of Quarter
3. Start of Month
4. Start of Week
5. Date

**Geography Hierarchy**
To support **regional analysis**, a **Geography Hierarchy** was created in the `Stores` table.

**Hierarchy Levels:**
1. **World Region** (Renamed from `Region`)
2. **Country** (Derived from `Country Code`)
3. **Country Region** (State/Province)

Additionally, a **Geography** column was created for **better mapping accuracy**, combining `Country Region` and `Country`.

**DAX Formula for Country Column**
```DAX
Country = 
SWITCH(
    Stores[Country Code],
    "GB", "United Kingdom",
    "US", "United States",
    "DE", "Germany"
)
```


## Milestone 4: Set up the Report

This short milestone involved simply setting up the 4 report pages and adding the background of a  navigation sidebar.

### Create the report pages
- Decided on a theme (colour scheme) here and then created the 4 pages, giving them each their title.
- I then added a rectangle shape to cover a narrow strip on the left of the page, which will act as the shell of our navigation sidebar. Then replicated this across the 4 pages.


## Milestone 5: Build the Customer Detail Page

This milestone focused on creating a report page for customer-level analysis. The page includes various visuals to provide insights into customer behavior, revenue distribution, and trends.

### Headline Card Visuals
- Created two **card visuals**:
  - **Unique Customers**: Displays the total distinct customers.
  - **Revenue per Customer**: Calculated as `Total Revenue / Total Customers`.

### Summary Charts
- **Donut Chart (Customers by Country)**: Displays the number of unique customers per country.
- **Donut Chart (Customers by Product Category)**: Shows customer distribution based on the product category they purchased.

### Customer Trend Line Chart
- **Line Chart (Total Customers Over Time)**:  
  - **X-axis**: Uses the **Date Hierarchy** (drillable to the month level).  
  - **Y-axis**: Displays `Total Customers`.  
  - **Trend Line & Forecast**: A **10-period forecast** was applied with a **95% confidence interval**.

### Top 20 Customers Table
- Created a table to **rank the top 20 customers by revenue**.
- Added **conditional formatting** (data bars) to the revenue column for visual emphasis.

### Top Customer Insights Cards
- Used **three card visuals** to display the **top customer by revenue**:
  - **Name**
  - **Total Orders**
  - **Total Revenue**
- A **DAX measure** was used to retrieve the top customer dynamically.

### Date Slicer
- **Between slicer** added, allowing users to filter the report by year.

---

### **Screenshots**
Below are screenshots of the key visuals and setups:

*(Insert screenshot links here once uploaded to GitHub)*

## Milestone 6: Create an Executive Summary Page

### Overview
The **Executive Summary Page** provides a **high-level** overview of the company's performance, designed for **C-suite executives** to quickly assess key business metrics. The report helps executives track revenue, profit, and order performance over time and compare them against business targets.

### **Key Objectives**
- Provide a **quick summary** of business performance.
- Allow **drill-down analysis** for revenue trends.
- Show **KPIs for revenue, profit, and orders** vs. previous quarter targets.

---

### 📊 **Visuals & Components**
The **Executive Summary Page** contains the following visuals:

### ** 1. Card Visuals for Key Metrics**
- Displays **Total Revenue, Total Profit, and Total Orders**.
- Limited to **2 decimal places** (Revenue & Profit) and **1 decimal place** (Orders).

### ** 2. Line Chart for Revenue Trends**
- X-axis: **Date Hierarchy** (Start of Year, Start of Quarter, Start of Month).
- Y-axis: **Total Revenue**.
- Includes a **trend line** for visualization.

### ** 3.  Donut Charts for Revenue Breakdown**
- **Revenue by Country** (United Kingdom, United States, Germany).
- **Revenue by Store Type** (Super Store, Outlet, Local, etc.).

### ** 4. Bar Chart for Orders by Product Category**
- Initially copied from the **Customer Detail Page**.
- Converted into a **Clustered Bar Chart**.
- X-axis: **Total Orders**.
- Y-axis: **Product Category**.
- Custom **color formatting** applied.

### ** 5. KPI Visuals for Quarterly Targets**
- **KPIs Created for**:
  - **Previous Quarter Revenue**
  - **Previous Quarter Profit**
  - **Previous Quarter Orders**
  - **Target Revenue, Profit, and Orders** (5% growth target)
- **KPI Formatting:**
  - **Red** if the goal is not met.
  - **Black** if the goal is met.
  - Trend Axis set to **Start of Quarter**.
  - Target values displayed.

---

### ⚙️ **DAX Measures Used**
```DAX
Previous Quarter Revenue = 
CALCULATE(
    [Total Revenue], 
    DATEADD(Dates[Date], -1, QUARTER)
)

Previous Quarter Profit = 
CALCULATE(
    [Total Profit], 
    DATEADD(Dates[Date], -1, QUARTER)
)

Previous Quarter Orders = 
CALCULATE(
    [Total Orders], 
    DATEADD(Dates[Date], -1, QUARTER)
)

Target Revenue = [Previous Quarter Revenue] * 1.05
Target Profit = [Previous Quarter Profit] * 1.05
Target Orders = [Previous Quarter Orders] * 1.05

---


## Milestone 7: Creation of the Product Detail Page

The **Product Detail Page** provides an in-depth view of **product performance**, helping stakeholders identify top-performing products and analyze sales trends.

### **Key Objectives**
- Track **Revenue, Orders, and Profit** at the product level.
- Identify **top-selling products** and **high-profit items**.
- Enable **region and product-based filtering** for deeper insights.

### **Visuals & Components**
#### **1. Gauge Charts for Product KPIs**
- **Revenue, Orders, and Profit** tracked against a **10% quarterly growth target**.
- Uses **TotalQTD()** for current quarter values and **DATEADD()** for previous quarter comparisons.
- Conditional formatting applied to highlight **performance gaps**.

#### **2. Area Chart: Revenue by Product Category**
- **X-axis**: `Dates[Start of Quarter]`
- **Y-axis**: `Total Revenue`
- **Legend**: `Products[Category]`
- Used to **analyze revenue trends by category over time**.

#### **3. Top 10 Products Table**
- Displays the **top 10 products by revenue**.
- Columns included:
  - **Product Description**
  - **Total Revenue**
  - **Total Customers**
  - **Total Orders**
  - **Profit per Order**
- `Profit per Order` calculated as:
  ```DAX
  Profit per Order = 
  DIVIDE([Total Profit], [Total Orders], 0)

#### **4. Scatter Chart: Profit per Item vs. Quantity Sold**
- **X-axis**: `Products[Profit per Item]`
- **Y-axis**: `Total Quantity Sold`
- **Legend**: `Products[Category]`
- Helps **identify high-selling and high-profit products** for potential marketing campaigns.

### **Pop-Out Slicer Toolbar**
- Implemented a **hidden slicer panel** to keep the report layout **clean**.
- Created using **Power BI bookmarks**, allowing users to toggle the slicers via a **navigation button**.
- Includes slicers for:
  - **Product Category (multi-select enabled)**
  - **Country (includes "Select All" option)**
- Ensured that bookmarks **do not reset slicer selections**.

### **Screenshots Included**
- **Visual setup for the Product Detail Page.**
- **Step-by-step slicer panel creation & bookmark setup.**


## Milestone 8: Creation of the Stores Map Page

The **Stores Map Page** allows regional managers to analyze **store profitability and sales trends**.

### **Key Objectives**
- Provide a **visual representation of store performance** using a **map visualization**.
- Enable **drillthrough analysis** for individual store details.
- Allow managers to **compare stores based on revenue, profit, and orders**.

### **Visuals & Components**
#### **1. Stores Map**
- **Bubble map displaying store locations**.
- **Bubble size represents Profit YTD**.
- **Auto-Zoom enabled**, with unnecessary map controls disabled.
- **Country Slicer (Tile Style)** placed above the map for easy filtering.

#### **2. Stores Drillthrough Page**
To allow deeper analysis, a **Drillthrough Page** was created for individual store performance.

- **Top 5 Products Table**: Displays best-selling products per store.
- **Column Chart**: Shows **Total Orders by Product Category**.
- **Profit YTD Gauge**: Compares **current YTD profit** to a **20% year-over-year growth target**.
- **Card Visual**: Displays the **selected store**.

#### **3. Custom Tooltip for Store Profitability**
- **Custom Tooltip page created** to show **Profit YTD vs. Target** when hovering over a store on the map.
- **Copied the Profit YTD gauge** to the tooltip page and linked it to the **map visual**.

### **Screenshots Included**
- **Final Stores Map Page layout.**
- **Drillthrough setup.**
- **Tooltip configuration for map visual.**

## Milestone 9: Cross-Filtering and Navigation  

This milestone focused on **refining cross-filtering interactions** and **implementing a navigation sidebar** to enhance report usability.  

---

### **Cross-Filtering Adjustments**  
Power BI's default **cross-filtering and highlighting** were modified to ensure that only **relevant visuals interact with each other**, preventing unintended filtering.  

#### **1. Executive Summary Page**
- **Product Category bar chart** and **Top 10 Products table** **no longer filter card visuals or KPIs**.  

#### **2. Customer Detail Page**
- **Top 20 Customers table** no longer filters any other visuals.  
- **Total Customers by Product Category Donut Chart** no longer filters other visuals.  
- **Total Customers by Country Donut Chart** still filters **Total Customers by Product Category**.  
- **Customers Donut Chart** no longer affects the **Customers Line Graph**.  

#### **3. Product Detail Page**
- **Orders vs. Profitability Scatter Chart** no longer affects other visuals.  
- **Top 10 Products Table** no longer filters other visuals.  

---

### **Navigation Sidebar Implementation**  
A **custom navigation sidebar** was created to allow seamless navigation between report pages.  

#### **1. Button Setup**  
- **Four blank buttons** were added to the sidebar on the **Executive Summary Page**.  
- Each button was assigned a **custom icon** representing the corresponding report page.  
- The **white icon version** was used for the default button state.  
- The **cyan icon version** was used for the hover effect.  

#### **2. Button Actions**  
- **Page Navigation actions** were applied to each button:  

| **Button**            | **Destination**           |
|----------------------|--------------------------|
| 📊 **Executive Summary** | `Executive Summary` (Home) |
| 🏪 **Stores Map**        | `Stores Map` |
| 📦 **Product Detail**    | `Product Detail` |
| 👥 **Customer Detail**   | `Customer Detail` |

- Buttons were **grouped together** and **copied across all report pages** for consistency.  

---

### **Screenshots Included**  
- **Cross-filtering setup adjustments.**  
- **Navigation sidebar button configurations.**  
- **Final layout of the report with the sidebar.**  

This milestone **optimises the user experience** by ensuring correct filtering behavior and enabling quick, intuitive navigation between report pages.

