----Option 1
SELECT DISTINCT sysusers.name AS OwnerName, so.name--, 'SP' xtype
FROM syscomments sc
INNER JOIN sysobjects so ON sc.id=so.id
INNER JOIN sysusers ON so.uid = sysusers.uid
WHERE upper(sc.TEXT) LIKE '%SEARCH TERM%'
UNION
----Option 2
SELECT DISTINCT sysusers.name AS OwnerName, o.name--, o.xtype
FROM syscomments c
INNER JOIN sysobjects o ON c.id=o.id
INNER JOIN sysusers ON o.uid = sysusers.uid
WHERE c.TEXT LIKE '%SEARCH TERM%'