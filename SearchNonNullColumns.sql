SELECT *
FROM information_schema.columns
WHERE table_name = 'TABLE_NAME' 
AND is_nullable = 'NO'
