-- =============================================
-- Author:		Nathan Hollis
-- Create date: 3/8/2015
-- Description:	Returns a scaled random walk
-- =============================================
CREATE FUNCTION [dbo].[Scaled Random Walk]
(
	@T float, -- "T is time length of all steps",
	@N int -- N periods
)
RETURNS float
AS
BEGIN
	DECLARE @h float ;
	SET @h = @T/@N;


	DECLARE @i int;
	SET @i = 1;

	DECLARE @walk_sum float;
	SET @walk_sum = 0;
	WHILE @i <= @N BEGIN
		select 
			@walk_sum = @walk_sum + 
			CASE ROUND(a.rndResult,0)
				WHEN 0 THEN -1
				WHEN 1 THEN 1
			END
		from rndView a;

		SET @i = @i + 1;
	END

	DECLARE @rtn float;
	SET @rtn = SQRT(@h)*@walk_sum;

	RETURN @rtn;
END