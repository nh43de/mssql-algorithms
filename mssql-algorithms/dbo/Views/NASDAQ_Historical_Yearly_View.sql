create view NASDAQ_Historical_Yearly_View as
with minmaxDates as (
	select
		a.Ticker,
		year(a.[Date]) "Year",
		min(a.[Date]) "Min Date",
		max(a.[Date]) "Max Date"
	from NASDAQ_Historical a
	group by 
		a.Ticker,
		year(a.[Date])
)
select 
	dates.Ticker,
	dates.[Year],
	dates.[Min Date] "Period Start Date",
	dates.[Max Date] "Period End Date"
	,a.[Open] "Period Open"
	,b.[Close] "Period Close"
from minmaxDates dates
	LEFT JOIN NASDAQ_Historical a	
		on dates.[Min Date] = a.[Date]
		and dates.Ticker = a.Ticker
	LEFT JOIN NASDAQ_Historical b
		on dates.[Max Date] = b.[Date]
		and dates.Ticker = b.Ticker
--order by dates.Ticker, dates.[Year]