


/*

	From p.199 in "Mathematics for Finance" Capinsky

*/

CREATE function [dbo].[Omega Table]
(
	@T float,
	@N int
) returns table
AS RETURN
(
	with x as(
		select a.n, a.t, b.k from [Time Periods](@T, @N) a
		CROSS APPLY (select * from [Generate k](a.n)) b
	)
	select
		x.n,
		x.k,
		x.t,
		b.IntervalMin,
		b.IntervalMax
	from x 
		CROSS APPLY
		(
			select * from [Omega Intervals](x.n, x.k)
		) b
	--order by x.t, x.n, x.k
)