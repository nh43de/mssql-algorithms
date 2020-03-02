

CREATE function [dbo].[Time Periods]
(
	@T float,
	@N int
) returns @rtn table
(
	n int,
	t float,
	h float
) 
AS
BEGIN
	DECLARE
		@i int,
		@h float
	;
	SET @i = 0;
	SET @h = @T / @N;

	WHILE @i <= @N 
	BEGIN
		INSERT INTO @rtn 
		SELECT
			@i,
			@i * @h,
			@h;

		SET @i = @i + 1;
	END

	RETURN
END