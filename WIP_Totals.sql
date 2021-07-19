select sum(CC_Amount_Due_in_USD) as TotalWIP
from ankura_dw.dbo.ProjectTransactions
--where ProjectId = 'DV-B01254.01'
where CompanyId = 'USD010'
 and CustomerBillingStatus not in ('Billed', 'Unbillable', 'Do Not Bill')



 --37,521,587.8300
 --90,314,024.49
