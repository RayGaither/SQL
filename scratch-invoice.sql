--CI-035688

select top 100 *
from [dbo].[CustomerPayments] p
join [dbo].[CustomerInvoices] as A on A.[Customer_Invoice_Reference_ID] =  P.[Customer_Invoice_Reference_ID]
and P.[Customer_Payment_for_Invoices_Reference_ID] 


select *
from [dbo].[CustomerPayments] p
where [Customer_Invoice_Reference_ID] like '%035688'
or  [Customer_Invoice_Reference_ID]  like '%4378%'

select  *
from [dbo].[CustomerInvoices]
where [Customer_Invoice_Reference_ID] like '%43785'




select top  10 *
from [dbo].[CustInvoiceSummaries]
where [CustomerInvoiceDocument] like '%035688'