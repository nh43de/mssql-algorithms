﻿
	 CREATE VIEW [dbo].[rndView]
AS
SELECT ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT)) / 2147483647. rndResult