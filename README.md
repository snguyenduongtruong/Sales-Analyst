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
![Q1](https://github.com/snguyenduongtruong/Sales-Analyst/blob/main/Q1.png)
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
![Q2](https://github.com/snguyenduongtruong/Sales-Analyst/blob/main/Q2.png)
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
<details>
  <summary>Click to expand expected results!</summary>
	
  ##### Expected Results:
![Q3](https://github.com/snguyenduongtruong/Sales-Analyst/blob/main/Q3.png)
</details>
</p>
<details>
  <summary>Click to expand answer!</summary>
	
  ##### Answer
  ```sql
SELECT
	[Year],
	[Quarter],
	[Month Name],
	SalesByMonth,
	SUM (SalesByMonth) OVER (PARTITION BY [Year], [Quarter]) AS SalesByQuarter,
	SUM (SalesByMonth) OVER (PARTITION BY [Year]) AS SalesByYear,
	SUM (SalesByMonth) OVER () AS TotalSales
FROM(
	SELECT
		[Year],
		[Quarter],
		[Month Name],
		[Month Number of Year] AS [Month],
		ROUND(SUM([Sales Amount]), 2) AS SalesByMonth
	FROM dbo.[Internet Sales] LEFT JOIN dbo.Date
	ON dbo.[Internet Sales].ShipDateKey = dbo.Date.DateKey
	GROUP BY [Year], [Quarter], [Month Name], [Month Number of Year]) t
ORDER BY [Year], [Quarter], [Month]
  ```
</details>
<br />

### 4. Find the total sales by each month within each quarter of each year, and calculate the quarter-to-month cumulative total (accumulating from the first month to the current month within each quarter of each year)
<details>
  <summary>Click to expand expected results!</summary>
	
  ##### Expected Results:
![Q4](https://github.com/snguyenduongtruong/Sales-Analyst/blob/main/Q4.png)
</details>
</p>
<details>
  <summary>Click to expand answer!</summary>
	
  ##### Answer
  ```sql
SELECT
	[Year],
	[Quarter],
	[Month Name],
	SalesByMonth,
	SUM([SalesByMonth]) OVER (PARTITION BY [Year],[Quarter] ORDER BY [Month]
	                              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS QTMSales
FROM(
	SELECT
		[Year],
		[Quarter],
		[Month Name],
		[Month Number of Year] AS [Month],
		ROUND(SUM([Sales Amount]), 2) AS SalesByMonth
	FROM dbo.[Internet Sales] LEFT JOIN dbo.Date
	ON dbo.[Internet Sales].ShipDateKey = dbo.Date.DateKey
	GROUP BY [Year], [Quarter], [Month Name], [Month Number of Year]) t
ORDER BY [Year], [Quarter], [Month]
  ```
</details>
<br />

### 5. Find the total sales for each month of each year, and find the sales of the same month in the previous year, then calculate the increase (or decrease) in value compared to last year, as well as the percentage increase (or decrease)
<details>
  <summary>Click to expand expected results!</summary>
	
  ##### Expected Results:
![Q5](https://github.com/snguyenduongtruong/Sales-Analyst/blob/main/Q5.png)
</details>
</p>
<details>
  <summary>Click to expand answer!</summary>
	
  ##### Answer
  ```sql
SELECT
	[Year],
	[Month Name],
	CurrentMonthSales,
	PreviousYearByMonthSales,
	ROUND(CurrentMonthSales - PreviousYearByMonthSales, 2) AS MoM_Change,
	CONCAT(ROUND(CAST(CurrentMonthSales - PreviousYearByMonthSales AS FLOAT) * 100/ PreviousYearByMonthSales, 2), '%') AS MoM_Perc
FROM(
	SELECT
		[Year],
		[Month Name],
		[Month],
		SalesByMonth AS CurrentMonthSales,
		LAG(SalesByMonth) OVER (PARTITION BY [Month Name] ORDER BY [Year]) AS PreviousYearByMonthSales
	FROM(
		SELECT
			[Year],
			[Month Name],
			[Month Number of Year] AS [Month],
			ROUND(SUM([Sales Amount]), 2) AS SalesByMonth
		FROM dbo.[Internet Sales] LEFT JOIN dbo.[Date]
		ON dbo.[Internet Sales].ShipDateKey = dbo.Date.DateKey
		GROUP BY [Year], [Month Name], [Month Number of Year]) t) t
ORDER BY [Year], [Month]
  ```
</details>
<br />

### 6. Calculate the year-to-month cumulative sales (accumulating from the first month to the current month within the year), and calculate the year-to-month sales for the same month last year
<details>
  <summary>Click to expand expected results!</summary>
	
  ##### Expected Results:
![Q6](https://github.com/snguyenduongtruong/Sales-Analyst/blob/main/Q6.png)
</details>
</p>
<details>
  <summary>Click to expand answer!</summary>
	
  ##### Answer
  ```sql
SELECT
	[Year],
	[Month Name],
	CurrentYTMSales,
	LAG(CurrentYTMSales) OVER (PARTITION BY [Month] ORDER BY [Year]) PreviousYTMSales
FROM(
	SELECT
		[Year],
		[Month Name],
		[Month],
		SalesByMonth,
		SUM(SalesByMonth) OVER (PARTITION BY [Year] ORDER BY [Month]
								 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CurrentYTMSales
	FROM(
		SELECT
			[Year],
			[Month Name],
			[Month Number of Year] AS [Month],
			ROUND(SUM([Sales Amount]), 2) AS SalesByMonth
		FROM dbo.[Internet Sales] LEFT JOIN dbo.Date
		ON dbo.[Internet Sales].ShipDateKey = dbo.Date.DateKey
		GROUP BY [Year], [Month Name], [Month Number of Year]) t) t
ORDER BY [Year], [Month]
  ```
</details>
<br />

### 7. Find the total sales for each month of each year, then calculate the 2-month rolling total including the current month and the previous month.
<details>
  <summary>Click to expand expected results!</summary>
	
  ##### Expected Results:
![Q7](https://github.com/snguyenduongtruong/Sales-Analyst/blob/main/Q7.png)
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
	SUM(SalesByMonth) OVER (ORDER BY [Year], [Month] 
	                          ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS RollingTotalSalesBy2Month
FROM(
	SELECT
		[Year],
		[Month Name],
		[Month Number of Year] AS [Month],
		ROUND(SUM([Sales Amount]), 2) AS SalesByMonth
	FROM dbo.[Internet Sales] LEFT JOIN dbo.Date
	ON dbo.[Internet Sales].ShipDateKey = dbo.[Date].DateKey
	GROUP BY [Year], [Month Number of Year], [Month Name]) t
ORDER BY [Year], [Month]
  ```
</details>
<br />

### 8. Find the total sales for each month of each year, then calculate the rolling average of the current month and the two previous months, and also calculate the average sales of all months.
<details>
  <summary>Click to expand expected results!</summary>
	
  ##### Expected Results:
![Q8](https://github.com/snguyenduongtruong/Sales-Analyst/blob/main/Q8.png)
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
	ROUND(RollingAVGSalesBy3Month, 2) RollingAVGSalesBy3Month,
	ROUND(AVGSalesByMonth, 2) AVGSalesByMonth
FROM(
	SELECT
		[Year],
		[Month],
		[Month Name],
		SalesByMonth,
		AVG(SalesByMonth) OVER (ORDER BY [Year], [Month] 
								  ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS RollingAVGSalesBy3Month,
		AVG(SalesByMonth) OVER() AVGSalesByMonth
	FROM(
		SELECT
			[Year],
			[Month Name],
			[Month Number of Year] AS [Month],
			ROUND(SUM([Sales Amount]), 2) AS SalesByMonth
		FROM dbo.[Internet Sales] LEFT JOIN dbo.Date
		ON dbo.[Internet Sales].ShipDateKey = dbo.[Date].DateKey
		GROUP BY [Year], [Month Number of Year], [Month Name]) t) t
ORDER BY [Year], [Month]
  ```
</details>
<br />

### 9. Find the total sales by state and by country.
<details>
  <summary>Click to expand expected results!</summary>
	
  ##### Expected Results:
![Q9](https://github.com/snguyenduongtruong/Sales-Analyst/blob/main/Q9.png)
</details>
</p>
<details>
  <summary>Click to expand answer!</summary>
	
  ##### Answer
  ```sql
SELECT
	Country,
	State,
	SalesByState,
	SUM(SalesByState) OVER(PARTITION BY Country) SalesByCountry
FROM(
	SELECT
		Country,
		State,
		ROUND(SUM([Sales Amount]), 2) AS SalesByState
	FROM dbo.[Internet Sales] 
	LEFT JOIN (
		SELECT
			GeographyKey,
			CustomerKey
		FROM dbo.Customer
		GROUP BY GeographyKey, CustomerKey ) cus
	ON cus.CustomerKey = dbo.[Internet Sales].CustomerKey
	LEFT JOIN (
		SELECT
			Country,
			State,
			GeographyKey
		FROM dbo.Geography
		GROUP BY Country, State, GeographyKey ) geo
	ON cus.GeographyKey = geo.GeographyKey
	GROUP BY Country, State) t
ORDER BY Country
  ```
</details>
<br />

### 10. Find the total sales by product and rank them
<details>
  <summary>Click to expand expected results!</summary>
	
  ##### Expected Results:
![Q10](https://github.com/snguyenduongtruong/Sales-Analyst/blob/main/Q10.png)
</details>
</p>
<details>
  <summary>Click to expand answer!</summary>
	
  ##### Answer
  ```sql
SELECT
	[English Product Name],
	ROUND(SUM([Sales Amount]), 2) AS SalesByProduct,
	RANK() OVER(ORDER BY SUM([Sales Amount]) DESC) Rank_SalesByProduct
FROM dbo.[Internet Sales] LEFT JOIN dbo.Product
ON dbo.[Internet Sales].ProductKey = dbo.Product.ProductKey
GROUP BY [English Product Name]
  ```
</details>
<br />

### 11. Analyze each customer's loyalty by calculating the number of orders and the average number of days between orders, then rank them in descending order by order count and in ascending order by average order interval
<details>
  <summary>Click to expand expected results!</summary>
	
  ##### Expected Results:
![Q11](https://github.com/snguyenduongtruong/Sales-Analyst/blob/main/Q11.png)
</details>
</p>
<details>
  <summary>Click to expand answer!</summary>
	
  ##### Answer
  ```sql
SELECT
	CustomerKey,
	NumOrders,
	AVG_DayUntilNextOrder,
	[Rank]
FROM(
	SELECT
		CustomerKey,
		AVG(DayUntilNextOrder) AVG_DayUntilNextOrder,
		COUNT(*) NumOrders,
		DENSE_RANK() OVER (ORDER BY COUNT(*) DESC, AVG(DayUntilNextOrder) ASC) [Rank]
	FROM(
		SELECT
			CustomerKey,
			Date ShipDate,
			LEAD(Date) OVER (PARTITION BY CustomerKey ORDER BY Date) NextShip,
			DATEDIFF (day, Date, LEAD(Date) OVER (PARTITION BY CustomerKey ORDER BY Date)) DayUntilNextOrder
		FROM dbo.[Internet Sales] LEFT JOIN dbo.Date
		ON dbo.[Internet Sales].ShipDateKey = dbo.Date.DateKey) t
	GROUP BY CustomerKey) t
WHERE AVG_DayUntilNextOrder IS NOT NULL
ORDER BY [Rank]
  ```
</details>
<br />

### 12. Analyze each customer's potential by calculating their number of orders and total sales, then rank them in order of order count and total sales
<details>
  <summary>Click to expand expected results!</summary>
	
  ##### Expected Results:
![Q12](https://github.com/snguyenduongtruong/Sales-Analyst/blob/main/Q12.png)
</details>
</p>
<details>
  <summary>Click to expand answer!</summary>
	
  ##### Answer
  ```sql
SELECT
	CustomerKey,
	COUNT(*) NumOrders,
	ROUND(SUM([Sales Amount]), 2) SalesByCustomer,
	DENSE_RANK() OVER(ORDER BY SUM([Sales Amount]) DESC, COUNT(*) DESC) [Rank]
FROM dbo.[Internet Sales] LEFT JOIN dbo.Date
ON dbo.[Internet Sales].ShipDateKey = dbo.Date.DateKey
GROUP BY CustomerKey
  ```
</details>
<br />


## **Benefits:**
- Focus on high-potential markets (including states, provinces, and cities within them).
- Encourage customers who share similar characteristics with those identified as major contributors to sales.
- Improve and develop products that generate high revenue.
