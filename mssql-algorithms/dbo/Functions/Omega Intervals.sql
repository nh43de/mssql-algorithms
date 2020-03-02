


/*

	K^w_N(t)= { U - if w in [k/2^n, k+1/2^(n+1)] for even k, D otherwise }

*/

CREATE function [dbo].[Omega Intervals]
(
	@n int,
	@k int
) returns @rtn table
(
	n int,
	k int,
	IntervalMin float,
	IntervalMax float
) 
AS
BEGIN
	IF (@k / 2. != @k / 2) 
	BEGIN
		DECLARE @adsf int;
		SET @adsf = CAST('K must be multiple of two' as int);
	END


	insert into @rtn
	select
			@n,
			@k,
			CAST(@k as float) / POWER(2.0, @n),
			(CAST(@k as float) + 1.0) / POWER(2.0, @n);

	RETURN
END