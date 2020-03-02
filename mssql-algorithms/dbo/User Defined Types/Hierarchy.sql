CREATE TYPE [dbo].[Hierarchy] AS TABLE (
    [element_id]  INT             NOT NULL,
    [sequenceNo]  INT             NULL,
    [parent_ID]   INT             NULL,
    [Object_ID]   INT             NULL,
    [NAME]        NVARCHAR (2000) NULL,
    [StringValue] NVARCHAR (MAX)  NOT NULL,
    [ValueType]   VARCHAR (10)    NOT NULL,
    PRIMARY KEY CLUSTERED ([element_id] ASC));

