CREATE TABLE [dbo].[USDA_Floriculture_Data] (
    [Program]         NVARCHAR (50)  NULL,
    [Year]            INT            NULL,
    [Period]          NVARCHAR (20)  NULL,
    [Geo Level]       NVARCHAR (20)  NULL,
    [State]           NVARCHAR (50)  NULL,
    [State ANSI]      INT            NULL,
    [Commodity]       NVARCHAR (MAX) NULL,
    [Data Item]       NVARCHAR (MAX) NULL,
    [Domain]          NVARCHAR (20)  NULL,
    [Domain Category] NVARCHAR (35)  NULL,
    [Value]           FLOAT (53)     NULL,
    [CV (%)]          NVARCHAR (15)  NULL
);

