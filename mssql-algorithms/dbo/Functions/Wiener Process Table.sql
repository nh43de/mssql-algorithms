

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[Wiener Process Table] (
    @T     FLOAT, -- "T is time length of all steps",
    @N     INT   -- N periods
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
    SELECT 0,
           @h,
           0,
           0;

    DECLARE @i INT;
    SET @i = 1;

    DECLARE @walk_sum FLOAT;
    SET @walk_sum = 0;

    WHILE @i <= @N
    BEGIN
        SELECT @walk_sum = @walk_sum + [dbo].[Box-MullerTransform](0, @h);
		
        INSERT INTO @rtn
        SELECT @i,
               @h,
               @i * @h,
               @walk_sum;

        SET @i = @i + 1;
    END;

    RETURN;
END;