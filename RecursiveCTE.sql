WITH CTE
AS
(
   SELECT CAST(A.Tag_Name as varchar(max)) as Tag_Name, A.Tag_ID, A.Parent_Tag_ID
   FROM Inventory.Tags_Dim A
   WHERE A.Parent_Tag_ID = 0
 
   UNION ALL
 
   SELECT CAST(CTE.Tag_Name as varchar(max)) + ' - ' +  CAST(A.Tag_Name as varchar(max)) Tag_Name, A.Tag_ID, A.Parent_Tag_ID
     FROM Inventory.Tags_Dim A 
    INNER JOIN CTE ON A.Parent_Tag_ID = CTE.Tag_ID
)

SELECT Tag_Name, Tag_ID, Parent_Tag_ID
FROM CTE
