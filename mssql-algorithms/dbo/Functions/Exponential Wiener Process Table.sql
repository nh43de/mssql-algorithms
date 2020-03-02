

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[Exponential Wiener Process Table] 
(
	@T float, -- "T is time length of all steps",
	@N int, -- N periods
	@start_value float, --start value of the walk sum
	@mu float, --mu is the drift or mean of the walk step
	@sigma float --sigma is the stddev of the walk step
)
RETURNS 
@rtn TABLE 
(
	n int,
	h float,
	t float,
	value float
)
AS
BEGIN
	DECLARE @h float; -- h is the step size
	SET @h = @T/@N;

	INSERT INTO @rtn
	SELECT 
		0, --step no.
		@h, --h (step)
		0, --t 
		@start_value; -- walk sum

	DECLARE @i int;
	SET @i = 1;

	DECLARE @walk_sum float;
	SET @walk_sum = @start_value;

	WHILE @i <= @N BEGIN
		SELECT	
			@walk_sum = @walk_sum * (1.0 + dbo.[Box-MullerTransform](@mu,@sigma))
		from rndView a;

		INSERT INTO @rtn
		SELECT
			@i,
			@h,
			@i * @h,
			@walk_sum;

		SET @i = @i + 1;
	END

	RETURN 
END