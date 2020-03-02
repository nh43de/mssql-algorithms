CREATE TABLE [dbo].[NASDAQ_Historical_Yearly] (
    [Ticker]            NVARCHAR (5) NULL,
    [Year]              INT          NULL,
    [Period Start Date] DATE         NULL,
    [Period End Date]   DATE         NULL,
    [Period Open]       FLOAT (53)   NULL,
    [Period Close]      FLOAT (53)   NULL
);

