-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	Also known as geometric brownian motion
-- =============================================
CREATE FUNCTION [dbo].[Exponential Wiener Process Table] (
    @T           FLOAT, -- "T is time length of all steps",
    @N           INT,   -- N periods
    @start_value FLOAT, --start value of the walk sum
    @mu          FLOAT, --mu is the drift or mean of the walk step
    @sigma       FLOAT  --sigma is the stddev of the walk step
)
RETURNS @rtn TABLE (
    [n]     INT,
    [h]     FLOAT,
    [t]     FLOAT,
    [value] FLOAT
)
AS
BEGIN
    DECLARE @h FLOAT; -- h is the step size
    SET @h = @T / @N;

    INSERT INTO @rtn
    SELECT 0,            --step no.
           @h,           --h (step)
           0,            --t 
           @start_value; -- walk sum

    DECLARE @i INT;
    SET @i = 1;

    DECLARE @walk_sum FLOAT;
    SET @walk_sum = @start_value;

    WHILE @i <= @N
    BEGIN
        SELECT @walk_sum = @walk_sum * EXP((@mu - POWER(@sigma, 2) / 2.0) * @h + @sigma * SQRT(@h) * [dbo].[Box-MullerTransform](0, 1))
        FROM [dbo].[rndView] AS [rv];

        INSERT INTO @rtn
        SELECT @i,
               @h,
               @i * @h,
               @walk_sum;

        SET @i = @i + 1;
    END;

    RETURN;
END;


GO

