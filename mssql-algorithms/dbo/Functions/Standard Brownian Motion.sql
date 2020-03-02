-- =============================================
-- Author:		Nathan Hollis
-- Create date: 3/8/2015
-- Description:	Returns a scaled random walk
-- =============================================
CREATE FUNCTION [dbo].[Standard Brownian Motion]
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
		SELECT	
			@walk_sum = @walk_sum + 
				dbo.[Box-MullerTransform](0,@h)
		from rndView a;

		SET @i = @i + 1;
	END

	RETURN @walk_sum;
END