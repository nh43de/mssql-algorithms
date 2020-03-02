--SELECT * FROM dbo.NASDAQ_Historical WHERE Ticker = 'ANY' AND Date IN (
--'2014-07-25','2014-07-28')

;
CREATE VIEW [dbo].[Nasdaq_ChangePercentages] AS 

WITH data AS (
SELECT 
        [Ticker] ,
        [Date] ,
        LEAD([Date]) OVER (PARTITION BY Ticker ORDER BY Date) "Next Date" ,
        [High] ,
        [Low] ,
        [Open] ,
        [Close] ,
        LEAD([Open]) OVER (PARTITION BY Ticker ORDER BY Date) "Next Open" ,
        LEAD([Close]) OVER (PARTITION BY Ticker ORDER BY Date) "Next Close" ,
        [Volume]
FROM    [dbo].[NASDAQ_Historical]
--WHERE Ticker = 'MSFT'
), calcs AS ( 
SELECT 
	   data.Ticker ,
       data.[Date] ,
	   data.[Next Date] ,

       data.[Open] ,
       data.[Close] ,
       data.[Next Open] ,
       data.[Next Close] ,


	   ROUND(( data.[Next Open] - data.[Close] ),3) "Overnight $",
	   ROUND(( data.[Next Close] - data.[Close] ),3) "Close-Close $",
	   ROUND(( data.[Next Open] - data.[Open] ),3) "Open-Open $",
	   ROUND(( data.[Next Close] - data.[Open] ),3) "Open-Close $"
	
       
FROM data 
WHERE 
	data.[Close] > 0.40
	AND data.[Open] > 0.40
	AND data.[Next Open] IS NOT null
--AND CASE WHEN data.[Close] < 0.01 THEN 0 ELSE ( data.[Next Open] - data.[Close] ) / data.[Close] END > 0.05
),calcs2 AS (
	SELECT 
			c.*,
		
		   CAST(( c.[Next Open] - c.[Close] ) / c.[Close] * 100 AS DECIMAL(22,3)) "Overnight %",
		   CAST(( c.[Next Close] - c.[Close] ) / c.[Close] * 100 AS DECIMAL(22,3)) "Close-Close %",
		   CAST(( c.[Next Open] - c.[Open] ) / c.[Open] * 100 AS DECIMAL(22,3)) "Open-Open %",
		   CAST(( c.[Next Close] - c.[Open] ) / c.[Open] * 100 AS DECIMAL(22,3)) "Open-Close %",

		   ROUND((c.[Overnight $] + c.[Close-Close $] + c.[Open-Open $] + c.[Open-Close $]) / 4.,3) "Avg $"
	FROM calcs c
	WHERE DATEDIFF(DAY, c.[Date], c.[Next Date]) < 5
	AND 	c.[Close] > 0.40
	AND c.[Open] > 0.40
--ORDER BY [Avg %] DESC
)
SELECT *,
		ROUND((c.[Overnight %] + c.[Close-Close %] + c.[Open-Open %] + c.[Open-Close %]) / 4., 3) "Avg %"
FROM calcs2 c