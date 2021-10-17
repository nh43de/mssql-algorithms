

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[Wiener Process With Drift and Variance] (
    @T     FLOAT, -- "T is time length of all steps",
    @N     INT,   -- N periods
    @mu    FLOAT, --mu is the drift or mean of the walk step
    @sigma FLOAT  --sigma is the stddev of the walk step
)
RETURNS TABLE
AS
    RETURN SELECT [wpt].[n],
                  [wpt].[h],
                  [wpt].[t],
                  [value] = @mu * [wpt].[t] + @sigma * [wpt].[value]
           FROM [dbo].[Wiener Process Table](@T, @N) AS [wpt];
