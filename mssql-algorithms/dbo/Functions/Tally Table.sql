-- =============================================
-- Author:		Nathan Hollis
-- Create date: 3/8/2015
-- Description:	
-- =============================================
CREATE FUNCTION [Tally Table] 
(	
	@NumberOfRows int
)
RETURNS TABLE 
AS
RETURN 
(
	with
	t0 as (select 0 d union all select 0), --2^1 = 2
	t1 as (select a.d from t0 a cross join t0 b), --(2^1)^2 = 2^(1*2) = 4
	t2 as (select a.d from t1 a cross join t1 b), --(2^2)^2 = 2^(2*2) = 16
	t3 as (select a.d from t2 a cross join t2 b), --2^(3*2) = 256
	t4 as (select a.d from t3 a cross join t3 b), --2^(4*2) = 65,536
	t5 as (select a.d from t4 a cross join t4 b) --2^(5*2) = 4,294,967,296
	select top (@NumberOfRows) ROW_NUMBER() over (order by (select 1)) "Number" from t5
)