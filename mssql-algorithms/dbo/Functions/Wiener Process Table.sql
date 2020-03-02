

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[Wiener Process Table] 
(
	@T float, -- "T is time length of all steps",
	@N int, -- N periods
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
		0,
		@h,
		0,
		0;

	DECLARE @i int;
	SET @i = 1;

	DECLARE @walk_sum float;
	SET @walk_sum = 0;

	WHILE @i <= @N BEGIN
		SELECT	
			@walk_sum = @walk_sum + 
				dbo.[Box-MullerTransform](@mu,@sigma)
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