-- =============================================
-- Author:		Nathan Hollis
-- Create date: 3/8/2015
-- Description:	Returns 1 if values are in omega table and 0 othewise
-- =============================================
CREATE FUNCTION [dbo].[Omega Table Lookup] 
(
	@omega float,
	@n int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE
		@Result int,
		@interval_min float,
		@interval_max float;

	SET @Result = 0;
	
	DECLARE interval_Cursor CURSOR FOR
	SELECT a.IntervalMin, a.IntervalMax
	FROM [Generate Omega Intervals](@n) a; 
	
	OPEN interval_cursor;

	FETCH NEXT FROM interval_Cursor
	INTO @interval_min, @interval_max;

	WHILE (@@FETCH_STATUS = 0 AND @Result != 1)
	BEGIN
		IF (@omega >= @interval_min AND @omega < @interval_max)
		BEGIN
			SET @Result = 1;
		END

		FETCH NEXT FROM interval_Cursor
		INTO @interval_min, @interval_max;
	END

	CLOSE interval_cursor;
	DEALLOCATE interval_cursor;

	-- Return the result of the function
	RETURN @Result
END