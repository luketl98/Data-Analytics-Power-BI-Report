# Data-Analytics-Power-BI-Report
Power BI Data Analytics Report for an international retailer. This project involves ETL, data modelling (star-schema), and creating a multi-page Power BI report with DAX-driven insights. Includes C-suite summaries, customer segmentation, product performance analysis, and a retail performance map.


Milestone 2: Importing and Transforming Data
Data Sources and Import Methods
Orders Table: Imported from an Azure SQL Database using the Database Credentials option.
Products Table: Loaded from a CSV file via Power BI’s Get Data feature.
Stores Table: Imported from an Azure Blob Storage container.
Customers Table: Combined multiple CSV files using the Folder data connector.
Transformations Performed
Orders Table:

Removed sensitive data (Card Number column).
Split Order Date and Shipping Date into separate Date and Time columns.
Filtered out null values in the Order Date column.
Renamed columns to align with Power BI naming conventions.
Products Table:

Removed duplicate values in the Product Code column.
Renamed columns for consistency.
Stores Table:

Standardised region names using Replace Values.
Renamed columns for consistency.
Customers Table:

Combined First Name and Last Name into a Full Name column.
Removed unnecessary columns.
Renamed columns to match Power BI naming conventions.
This milestone ensures a structured, well-prepared dataset ready for data modelling and analysis in subsequent stages.
