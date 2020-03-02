CREATE TABLE [dbo].[NASDAQ_Historical] (
    [Ticker] NVARCHAR (5) NULL,
    [Date]   DATE         NULL,
    [Open]   FLOAT (53)   NULL,
    [High]   FLOAT (53)   NULL,
    [Low]    FLOAT (53)   NULL,
    [Close]  FLOAT (53)   NULL,
    [Volume] FLOAT (53)   NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_NASDAQ_Historical_1]
    ON [dbo].[NASDAQ_Historical]([Date] ASC, [Ticker] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_NASDAQ_Historical]
    ON [dbo].[NASDAQ_Historical]([Ticker] ASC, [Date] ASC);

