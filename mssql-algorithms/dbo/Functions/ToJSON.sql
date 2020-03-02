CREATE FUNCTION ToJSON
(
      @Hierarchy Hierarchy READONLY
)
 
/*
the function that takes a Hierarchy table and converts it to a JSON string
 
Author: Phil Factor
Revision: 1.5
date: 1 May 2014
why: Added a fix to add a name for a list.
example:
 
Declare @XMLSample XML
Select @XMLSample='
  <glossary><title>example glossary</title>
  <GlossDiv><title>S</title>
   <GlossList>
    <GlossEntry ID="SGML" SortAs="SGML">
     <GlossTerm>Standard Generalized Markup Language</GlossTerm>
     <Acronym>SGML</Acronym>
     <Abbrev>ISO 8879:1986</Abbrev>
     <GlossDef>
      <para>A meta-markup language, used to create markup languages such as DocBook.</para>
      <GlossSeeAlso OtherTerm="GML" />
      <GlossSeeAlso OtherTerm="XML" />
     </GlossDef>
     <GlossSee OtherTerm="markup" />
    </GlossEntry>
   </GlossList>
  </GlossDiv>
 </glossary>'
 
DECLARE @MyHierarchy Hierarchy -- to pass the hierarchy table around
insert into @MyHierarchy select * from dbo.ParseXML(@XMLSample)
SELECT dbo.ToJSON(@MyHierarchy)
 
       */
RETURNS NVARCHAR(MAX)--JSON documents are always unicode.
AS
BEGIN
  DECLARE
    @JSON NVARCHAR(MAX),
    @NewJSON NVARCHAR(MAX),
    @Where INT,
    @ANumber INT,
    @notNumber INT,
    @indent INT,
    @ii int,
    @CrLf CHAR(2)--just a simple utility to save typing!
     
  --firstly get the root token into place
  SELECT @CrLf=CHAR(13)+CHAR(10),--just CHAR(10) in UNIX
         @JSON = CASE ValueType WHEN 'array' THEN
         +COALESCE('{'+@CrLf+'  "'+NAME+'" : ','')+'['
         ELSE '{' END
            +@CrLf
            + case when ValueType='array' and NAME is not null then '  ' else '' end
            + '@Object'+CONVERT(VARCHAR(5),OBJECT_ID)
            +@CrLf+CASE ValueType WHEN 'array' THEN
            case when NAME is null then ']' else '  ]'+@CrLf+'}'+@CrLf end
                ELSE '}' END
  FROM @Hierarchy
    WHERE parent_id IS NULL AND valueType IN ('object','document','array') --get the root element
/* now we simply iterat from the root token growing each branch and leaf in each iteration. This won't be enormously quick, but it is simple to do. All values, or name/value pairs withing a structure can be created in one SQL Statement*/
  Select @ii=1000
  WHILE @ii>0
    begin
    SELECT @where= PATINDEX('%[^[a-zA-Z0-9]@Object%',@json)--find NEXT token
    if @where=0 BREAK
    /* this is slightly painful. we get the indent of the object we've found by looking backwards up the string */
    SET @indent=CHARINDEX(char(10)+char(13),Reverse(LEFT(@json,@where))+char(10)+char(13))-1
    SET @NotNumber= PATINDEX('%[^0-9]%', RIGHT(@json,LEN(@JSON+'|')-@Where-8)+' ')--find NEXT token
    SET @NewJSON=NULL --this contains the structure in its JSON form
    SELECT 
        @NewJSON=COALESCE(@NewJSON+','+@CrLf+SPACE(@indent),'')
        +case when parent.ValueType='array' then '' else COALESCE('"'+TheRow.NAME+'" : ','') end
        +CASE TheRow.valuetype
        WHEN 'array' THEN '  ['+@CrLf+SPACE(@indent+2)
           +'@Object'+CONVERT(VARCHAR(5),TheRow.[OBJECT_ID])+@CrLf+SPACE(@indent+2)+']'
        WHEN 'object' then '  {'+@CrLf+SPACE(@indent+2)
           +'@Object'+CONVERT(VARCHAR(5),TheRow.[OBJECT_ID])+@CrLf+SPACE(@indent+2)+'}'
        WHEN 'string' THEN '"'+dbo.JSONEscaped(TheRow.StringValue)+'"'
        ELSE TheRow.StringValue
       END
     FROM @Hierarchy TheRow
     inner join @hierarchy Parent
     on parent.element_ID=TheRow.parent_ID
      WHERE TheRow.parent_id= SUBSTRING(@JSON,@where+8, @Notnumber-1)
     /* basically, we just lookup the structure based on the ID that is appended to the @Object token. Simple eh? */
    --now we replace the token with the structure, maybe with more tokens in it.
    Select @JSON=STUFF (@JSON, @where+1, 8+@NotNumber-1, @NewJSON),@ii=@ii-1
    end
  return @JSON
end