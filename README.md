# Data-Analytics-Power-BI-Report
Power BI Data Analytics Report for an international retailer. This project involves ETL, data modelling (star-schema), and creating a multi-page Power BI report with DAX-driven insights. Includes C-suite summaries, customer segmentation, product performance analysis, and a retail performance map.


## Milestone 2: Importing and Transforming Data
### Data Sources and Import Methods
**Orders Table:** Imported from an Azure SQL Database using the Database Credentials option.
**Products Table:** Loaded from a CSV file via Power BI’s Get Data feature.
**Stores Table:** Imported from an Azure Blob Storage container.
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
To enable time intelligence functions, time-based filtering and drill-downs in visualizations, a **Date Table** was created using the following **DAX formula**:

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



## Creating the Measures Table

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
