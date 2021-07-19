select * 
from sys.objects 
where (type = 'U' or type = 'P') 
  and modify_date > dateadd(m, -3, getdate()) 
  order by modify_date desc