USE YourEDW
GO

SELECT 
SCHEMA_NAME(t.schema_id) AS [Schema],
t.name AS [Table Name],
c.name AS [Column Name],
CASE
WHEN ty.name = 'char' OR ty.name = 'nvarchar' THEN CONCAT(ty.name,'(',ty.max_length,')')
WHEN ty.name = 'numeric' THEN CONCAT(ty.name,'(',ty.precision,',',ty.scale,')')
ELSE ty.name
END AS [Data Type]
FROM sys.tables AS t
JOIN sys.columns c 
ON t.OBJECT_ID = c.OBJECT_ID
JOIN sys.types ty 
ON c.user_type_id = ty.user_type_id
LEFT OUTER JOIN sys.index_columns ic 
ON ic.object_id = c.object_id 
AND ic.column_id = c.column_id
LEFT OUTER JOIN sys.indexes i 
ON ic.object_id = i.object_id 
AND ic.index_id = i.index_id
WHERE 1 = 1
--AND c.name LIKE '%YourColumnName%'
ORDER BY [Table Name], [Column Name]