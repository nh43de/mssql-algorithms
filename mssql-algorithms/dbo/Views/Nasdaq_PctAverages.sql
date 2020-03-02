
CREATE VIEW Nasdaq_PctAverages AS 
WITH data AS (
SELECT 
        [Ticker] ,
        [Date] ,
        LEAD([Date]) OVER (PARTITION BY Ticker ORDER BY Date) "Next Open Date" ,
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
       data.[Date] "Day",
	   data.[Next Open Date] "Day+1",
	   
	   CAST(( data.[Next Open] - data.[Close] ) / data.[Close] * 100 AS DECIMAL(22,3)) "Overnight %",
	   CAST(( data.[Next Close] - data.[Close] ) / data.[Close] * 100 AS DECIMAL(22,3)) "Close-Close %",
	   CAST(( data.[Next Open] - data.[Open] ) / data.[Open] * 100 AS DECIMAL(22,3)) "Open-Open %",
	   CAST(( data.[Next Close] - data.[Open] ) / data.[Open] * 100 AS DECIMAL(22,3)) "Open-Close %"
FROM data WHERE data.[close] > 0.00 AND data.[Open] > 0.00
)
SELECT calcs.[Day] ,
        AVG(calcs.[Overnight %]) "Avg Overnight %",
        AVG(calcs.[Close-Close %]) "Avg Close-Close %",
        AVG(calcs.[Open-Open %]) "Avg Open-Open %",
        AVG(calcs.[Open-Close %]) "Avg Open-Close %"
--INTO Nasdaq_DailyPctAverages
FROM calcs
GROUP BY calcs.[Day]