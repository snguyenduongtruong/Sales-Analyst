# **Sales Analysis in Power BI and SQL**


## **Data Modeling**
![Data Model](https://github.com/snguyenduongtruong/Sales-Analyst/blob/main/data_model.png)

## **Key Features:**
📌 Sale Analyst: extract and visualize for analyzing the sales insights based on customers, countries, and products.

## **Built with:**
- Power BI Desktop
- Microsoft SQL Server

## **Key Insights from Dashboard:**
### Sale by Country
![Sales by Country](https://github.com/snguyenduongtruong/Sales-Analyst/blob/main/sales_by_country.png)
- Sales revenue is spread out and fairly evenly distributed across the three regions: North America, Oceania, and Europe.
- At the country level, total sales in the U.S. and Australia account for the highest proportions (each contributing over 30%).
- Overall sales have increased over time, with profit growing rapidly from late 2022 to early 2023.
### Sales by Customer
![Sales by Customer](https://github.com/snguyenduongtruong/Sales-Analyst/blob/main/sales_by_customer.png)
- Overall, customers without children contribute the highest proportion of total sales. However, when looking at individual customers, the biggest spenders (in terms of both sales and number of orders) are mostly those with children (ranging from 1 to 4).
- The majority of these high-spending customers are from France.
- At the state level, the states with the highest total sales are New South Wales (Australia), England (UK), and Washington (USA), with each state accounting for more than 10% of total sales across all regions.
### Sales by Product
![Sales by Product](https://github.com/snguyenduongtruong/Sales-Analyst/blob/main/sales_by_product.png)
- The highest total sales and profit come from the bike category, with subcategories such as road bikes and mountain bikes accounting for the largest shares.

## **Question I Wanted to Answer by SQL:**
### 1. Find the total sales of each country and the overall total, and calculate the percentage compared to the overall total
<strong>1.  Create Database, Tables and Relations.</strong>  
Using the CSV files located in `source_data/csv_data`, create your new SQL database and tables with the properly formatted data.

* Add a numeric, auto-incrementing Primary Key to every table.
* In the `countries` table, add the column `created_on` with the current date.
* Create a one-to-one and one-to-many relationship with the countries table as the parent table.

<strong>2.  List Regions and Country Count</strong>  
List all of the regions and the total number of countries in each region.  Order by country count in descending order and capitalize the region name.

<details>
  <summary>Click to expand expected results!</summary>

  ##### Expected Results:

region   |country_count|
---------|-------------|
Africa   |           59|
Americas |           57|
Asia     |           50|
Europe   |           48|
Oceania  |           26|
Antartica|            1|

</details>
</p>

<details>
  <summary>Click to expand answer!</summary>
### 2. Find the total sales by each month in each year, and calculate the year-to-month cumulative total (accumulating from the first month to the current month within the same year)
### 3. Find the total sales by each month in each year, by each quarter in each year, by each year and the overall total for all years
## **Benefits:**
- Focus on high-potential markets (including states, provinces, and cities within them).
- Encourage customers who share similar characteristics with those identified as major contributors to sales.
- Improve and develop products that generate high revenue.
