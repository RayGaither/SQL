Select *, COLUMN_NAME,DATA_TYPE from INFORMATION_SCHEMA.COLUMNS
--where TABLE_NAME='[dbo].[vwAR100]'



select a.name View_name,b.name column_name
from sys.all_objects a,sys.all_columns b
where a.object_id=b.object_id
and a.type='V'
and a.name = 'vwAR100'