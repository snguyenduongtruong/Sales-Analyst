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
<details>
  <summary>Click to expand expected results!</summary>
	
  ##### Expected Results:
(https://github.com/snguyenduongtruong/Sales-Analyst/blob/main/Q1.png)
</details>
</p>
<details>
  <summary>Click to expand answer!</summary>
	
  ##### Answer
  ```sql
SELECT
	[Sales Territory Country],
	SalesByCountry,
	SUM(SalesByCountry) OVER() TotalSales,
	ROUND(CAST(SalesByCountry AS FLOAT)/SUM(SalesByCountry) OVER() * 100, 2) AS PercentageOfTotal
FROM(
	SELECT 
		[Sales Territory Country],
		ROUND(SUM([Sales Amount]),2) AS SalesByCountry
	FROM dbo.[Internet Sales] LEFT JOIN dbo.[Sales Territory]
	ON dbo.[Internet Sales].SalesTerritoryKey = dbo.[Sales Territory].SalesTerritoryKey
	GROUP BY [Sales Territory Country]) t
ORDER BY SalesByCountry DESC
  ```
</details>
<br />


### 2. Find the total sales by each month in each year, and calculate the year-to-month cumulative total (accumulating from the first month to the current month within the same year)
<details>
  <summary>Click to expand expected results!</summary>
	
  ##### Expected Results:
(https://github.com/snguyenduongtruong/Sales-Analyst/blob/main/Q2.png)
</details>
</p>
<details>
  <summary>Click to expand answer!</summary>
	
  ##### Answer
  ```sql
SELECT
	[Year],
	[Month Name],
	SalesByMonth,
	SUM (SalesByMonth) OVER (PARTITION BY [Year] ORDER BY [Month]
								ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) YTMSales
FROM(
	SELECT
		[Year],
		[Month Number of Year] AS [Month],
		[Month Name],
		ROUND(SUM([Sales Amount]), 2) AS SalesByMonth
	FROM dbo.[Internet Sales] LEFT JOIN dbo.Date
	ON dbo.[Internet Sales].ShipDateKey = dbo.Date.DateKey
	GROUP BY [Year], [Month Number of Year], [Month Name]) t
ORDER BY [Year], [Month]
  ```
</details>
<br />

### 3. Find the total sales by each month in each year, by each quarter in each year, by each year and the overall total for all years





## **Benefits:**
- Focus on high-potential markets (including states, provinces, and cities within them).
- Encourage customers who share similar characteristics with those identified as major contributors to sales.
- Improve and develop products that generate high revenue.
