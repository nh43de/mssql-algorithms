-- =============================================
-- Author:		Nathan Hollis
-- Create date: sometime in 2014-2015
-- Description:	Box-MullerTransform written in T-SQL
-- =============================================
CREATE FUNCTION [dbo].[Box-MullerTransform] 
(
	@mu float,
	@sigma float
)
RETURNS float
AS
BEGIN
	DECLARE @result float;


	DECLARE @haveSpare bit;
	SET @haveSpare = 0;

	DECLARE @rand1 float;
	DECLARE @rand2 float;
	
	if @haveSpare = 1 
	BEGIN
		set @haveSpare = 0;

		 set @result = (@sigma * sqrt(@rand1) * sin(@rand2)) + @mu;

		return @result;
	END

 
	set @haveSpare = 1;
 
	select @rand1 = rndResult from rndView;
	
	if @rand1 < 1e-100
	Begin 
		set @rand1 = 1.0e-100;
	END

	set @rand1 = -2. * log(@rand1);
	select @rand2 = (rndResult) * 2.0 * pi() from rndView;
 
	set @result = (@sigma * sqrt(@rand1) * cos(@rand2)) + @mu;

	return @result
	-- Return the result of the function
	

END