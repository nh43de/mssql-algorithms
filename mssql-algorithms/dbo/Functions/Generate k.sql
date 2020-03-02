

CREATE function [dbo].[Generate k]
(
	@n int
) returns @rtn table
(
	n int,
	k int
) 
AS
BEGIN
	DECLARE
		@i int
	;
	SET @i = 0;

	/*bounds on k --- >   k/2^n >= 0 and (k+1)/2^n <= 1
				  --- >   (k+1) <= 2^n
				  --- >   k <= 2^n - 1
	since k even  --- >   k <= 2^n - 2 
				  --- >   k: [0, 2^n - 1) 
	since k even  --- >   k = 0, 2, ..., 2^n - 2
	*/
	WHILE @i <= (power(2, @n) - 1)
	BEGIN
		INSERT INTO @rtn 
		SELECT
			@n,
			@i

		SET @i = @i + 2;
	END

	RETURN
END