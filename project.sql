USE SalesAnalystDB
GO

/* Find the total sales of each country and the overall total, 
-- and calculate the percentage compared to the overall total. */
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


	
/* Find the total sales by each month in each year, 
-- and calculate the year-to-month cumulative total (accumulating from the first month to the current month within the same year).*/
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


	
/* Find the total sales by each month in each year, by each quarter in each year, by each year and the overall total for all years. */
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

	
	
/* Find the total sales by each month within each quarter of each year, 
-- and calculate the quarter-to-month cumulative total (accumulating from the first month to the current month within each quarter of each year). */
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


	
/* Find the total sales for each month of each year, and find the sales of the same month in the previous year. 
-- Then calculate the increase (or decrease) in value compared to last year, as well as the percentage increase (or decrease) */
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


	
/* Calculate the year-to-month cumulative sales (accumulating from the first month to the current month within the year), 
-- and calculate the year-to-month sales for the same month last year. */
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


	
/* Find the total sales for each month of each year, then calculate the 2-month rolling total including the current month and the previous month. */
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


	
/* Find the total sales for each month of each year, 
-- then calculate the rolling average of the current month and the two previous months, and also calculate the average sales of all months. */
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


	
/* Find the total sales by state and by country. */
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


	
/* Find the total sales by product and rank them. */
SELECT
	[English Product Name],
	ROUND(SUM([Sales Amount]), 2) AS SalesByProduct,
	RANK() OVER(ORDER BY SUM([Sales Amount]) DESC) Rank_SalesByProduct
FROM dbo.[Internet Sales] LEFT JOIN dbo.Product
ON dbo.[Internet Sales].ProductKey = dbo.Product.ProductKey
GROUP BY [English Product Name]


	
/* Analyze each customer's loyalty by calculating the number of orders and the average number of days between orders, 
-- then rank them in descending order by order count and in ascending order by average order interval. */
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


	
/* Analyze each customer's potential by calculating their number of orders and total sales, then rank them in order of order count and total sales. */
SELECT
	CustomerKey,
	COUNT(*) NumOrders,
	ROUND(SUM([Sales Amount]), 2) SalesByCustomer,
	DENSE_RANK() OVER(ORDER BY SUM([Sales Amount]) DESC, COUNT(*) DESC) [Rank]
FROM dbo.[Internet Sales] LEFT JOIN dbo.Date
ON dbo.[Internet Sales].ShipDateKey = dbo.Date.DateKey
GROUP BY CustomerKey


