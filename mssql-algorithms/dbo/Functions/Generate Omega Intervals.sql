-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [Generate Omega Intervals] 
(	
	@n int
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT
		a.n,
		a.k,
		b.IntervalMin,
		b.IntervalMax
	FROM
		[Generate k](@n) a
	CROSS APPLY (
		SELECT * from [Omega Intervals](a.n, a.k)
	) b
)