USE [ankura_dw]
GO

/****** Object:  View [dbo].[vwAR100]    Script Date: 7/12/2021 3:43:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








--CREATE VIEW [dbo].[vwAR100]
--AS
SELECT [Customer_Invoice_Reference_ID]
	  ,[ProjectCompanyName]
	  ,[ProjectCostCenterId]
      ,[ProjectDeptLevel4]
      ,[ProjectDeptLevel5]
      ,[CustomerName] 
	  ,[Customer_ID] 
      ,[SeniorProjectManagerNameFL]
      ,[ProjectManagerNameFL]
	  ,I.[ProjectId]
      ,[ProjectName]
      ,[LOR_PM_DesigneeNameFL]
      ,[Invoice_Number]
      ,CIS.[InvoiceDate]
      ,CIS.[InvoiceAccountingDate] as [AccountingDate]
      ,CIS.[AmountDueInUSD2] as Amount_Due	    
	  ,CIS.[CustomerInvoiceTotalAmountInUSD] as Invoice_Amount 

	  ,CIS.[TotalPaymentsExcludingWriteoffsInUSD] as [Total_Amount_Paid] 

	  ,0 as Account_Amounts_USD  --TODO!!! need SQL to get this number
	  ,CIS.[TotalWriteoffAmountApprovedandNotCanceledUSD] as Total_Writeoffs_USD 

	  , (select  isnull(sum([Payment_Amount]), 0)  FROM [ankura_dw].[dbo].[CustomerPayments] P 
				where P.Customer_Invoice_Reference_ID = I.Customer_Invoice_Reference_ID
					and [PaymentDate] >= DATEFROMPARTS(DATEPART(year, DATEADD(day,-1, CAST(GETDATE() AS DATE))), DATEPART(month, DATEADD(day,-1, CAST(GETDATE() AS DATE))), 1) 
				) as [Paid_MTD]

	  , (select  isnull(sum([Payment_Amount]), 0)  FROM [ankura_dw].[dbo].[CustomerPayments] P 
				where P.Customer_Invoice_Reference_ID = I.Customer_Invoice_Reference_ID
					and [PaymentDate] >= DATEADD(day,-31, CAST(GETDATE() AS DATE)) -- last 30 days
				) as [Paid_Last30]

	  ,IIF(DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))>=0 and DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))<=30,CIS.[AmountDueInUSD2],0) as Aging_0_30_Bucket_USD
	  ,IIF(DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))>=31 and DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))<=60,CIS.[AmountDueInUSD2],0) as Aging_31_60_Bucket_USD
	  ,IIF(DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))>=61 and DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))<=90,CIS.[AmountDueInUSD2],0) as Aging_61_90_Bucket_USD
	  ,IIF(DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))>=91 and DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))<=120,CIS.[AmountDueInUSD2],0) as Aging_91_120_Bucket_USD
	  ,IIF(DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))>=121 and DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))<=180,CIS.[AmountDueInUSD2],0) as Aging_121_180_Bucket_USD
	  ,IIF(DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))>=181 and DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))<=365,CIS.[AmountDueInUSD2],0) as Aging_181_365_Bucket_USD
	  ,IIF(DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))>=366 and DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))<=720,CIS.[AmountDueInUSD2],0) as Aging_366_720_Bucket_USD
	  ,IIF(DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))>=721, CIS.[AmountDueInUSD2],0) as Aging_720_Plus_Bucket_USD
	  ,IIF(DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))>=0 and DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))<=30,CIS.[AmountDueInUSD2],0) as Aging_0_30_Bucket_USD_InvoiceDate
	  ,IIF(DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))>=31 and DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))<=60,CIS.[AmountDueInUSD2],0) as Aging_31_60_Bucket_USD_InvoiceDate
	  ,IIF(DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))>=61 and DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))<=90,CIS.[AmountDueInUSD2],0) as Aging_61_90_Bucket_USD_InvoiceDate
	  ,IIF(DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))>=91 and DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))<=120,CIS.[AmountDueInUSD2],0) as Aging_91_120_Bucket_USD_InvoiceDate
	  ,IIF(DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))>=121 and DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))<=180,CIS.[AmountDueInUSD2],0) as Aging_121_180_Bucket_USD_InvoiceDate
	  ,IIF(DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))>=181 and DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))<=365,CIS.[AmountDueInUSD2],0) as Aging_181_365_Bucket_USD_InvoiceDate
	  ,IIF(DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))>=366 and DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))<=720,CIS.[AmountDueInUSD2],0) as Aging_366_720_Bucket_USD_InvoiceDate
	  ,IIF(DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE))>=721, CIS.[AmountDueInUSD2],0) as Aging_720_Plus_Bucket_USD_InvoiceDate
	  ,IIF(DATEDIFF(day,CIS.[DueDate],CAST(GETDATE() AS DATE))>=0 and DATEDIFF(day,CIS.[DueDate],CAST(GETDATE() AS DATE))<=30,CIS.[AmountDueInUSD2],0) as Aging_0_30_Bucket_USD_DueDate
	  ,IIF(DATEDIFF(day,CIS.[DueDate],CAST(GETDATE() AS DATE))>=31 and DATEDIFF(day,CIS.[DueDate],CAST(GETDATE() AS DATE))<=60,CIS.[AmountDueInUSD2],0) as Aging_31_60_Bucket_USD_DueDate
	  ,IIF(DATEDIFF(day,CIS.[DueDate],CAST(GETDATE() AS DATE))>=61 and DATEDIFF(day,CIS.[DueDate],CAST(GETDATE() AS DATE))<=90,CIS.[AmountDueInUSD2],0) as Aging_61_90_Bucket_USD_DueDate
	  ,IIF(DATEDIFF(day,CIS.[DueDate],CAST(GETDATE() AS DATE))>=91 and DATEDIFF(day,CIS.[DueDate],CAST(GETDATE() AS DATE))<=120,CIS.[AmountDueInUSD2],0) as Aging_91_120_Bucket_USD_DueDate
	  ,IIF(DATEDIFF(day,CIS.[DueDate],CAST(GETDATE() AS DATE))>=121 and DATEDIFF(day,CIS.[DueDate],CAST(GETDATE() AS DATE))<=180,CIS.[AmountDueInUSD2],0) as Aging_121_180_Bucket_USD_DueDate
	  ,IIF(DATEDIFF(day,CIS.[DueDate],CAST(GETDATE() AS DATE))>=181 and DATEDIFF(day,CIS.[DueDate],CAST(GETDATE() AS DATE))<=365,CIS.[AmountDueInUSD2],0) as Aging_181_365_Bucket_USD_DueDate
	  ,IIF(DATEDIFF(day,CIS.[DueDate],CAST(GETDATE() AS DATE))>=366 and DATEDIFF(day,CIS.[DueDate],CAST(GETDATE() AS DATE))<=720,CIS.[AmountDueInUSD2],0) as Aging_366_720_Bucket_USD_DueDate
	  ,IIF(DATEDIFF(day,CIS.[DueDate],CAST(GETDATE() AS DATE))>=721, CIS.[AmountDueInUSD2],0) as Aging_720_Plus_Bucket_USD_DueDate

	  ,CIS.[DueDate] as Due_Date
	  ,DATEDIFF(day,CIS.[InvoiceDate],CAST(GETDATE() AS DATE)) as Aging_Days_Invoice_Date
	  ,DATEDIFF(day,CIS.[DueDate],CAST(GETDATE() AS DATE)) as Aging_Days_Due_Date

	  , (select CAST( max([PaymentDate]) AS DATE)  FROM [ankura_dw].[dbo].[CustomerPayments] P 
				where P.Customer_Invoice_Reference_ID = I.Customer_Invoice_Reference_ID					
				) as [Most_Recent_Payment_Date]

      ,[ProjectBillerNameFL]
      ,[Project_Currency]
      ,[FD_Created_Date]
      ,[Worker]
      ,[Comment]
      ,[Retainer_Balance__USD]
      ,[Payment_Terms_ID]

  FROM 
  
  [ankura_dw].[dbo].[CustInvoiceSummaries] CIS join (SELECT [DataSourceId], max([LastUpdateTimestamp]) as Max_LastUpdateTimestamp
  FROM [ankura_dw].[dbo].[CustInvoiceSummaries] group by [DataSourceId]) MCIS --This is just to assure there this only one record
  on CIS.[DataSourceId] = MCIS.[DataSourceId] and Max_LastUpdateTimestamp = LastUpdateTimestamp
  join [ankura_dw].[dbo].[CustomerInvoices] I on CIS.[CustomerInvoiceID] = I.[Invoice_Number]
  join (SELECT [Customer_Invoice_Reference_WID], max([LoadedDate]) as max_LoadedDate
  FROM [ankura_dw].[dbo].[CustomerInvoices] group by [Customer_Invoice_Reference_WID]) M  --This is just to assure there this only one record
  on I.[Customer_Invoice_Reference_WID] = M.[Customer_Invoice_Reference_WID] and max_LoadedDate = I.LoadedDate
  join [ankura_dw].[dbo].[Projects] P on I.[ProjectId] = P.[ProjectId]  
 
 where I.Payment_Status in ('Unpaid','Partially Paid') and I.Document_Status <> 'Canceled'      
  and ProjectStatusCode in ('Active', 'Active - AR/Revenue/GL Use Only')
  and CIS.[AmountDue] <> 0
GO

--EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
--Begin DesignProperties = 
--   Begin PaneConfigurations = 
--      Begin PaneConfiguration = 0
--         NumPanes = 4
--         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
--      End
--      Begin PaneConfiguration = 1
--         NumPanes = 3
--         Configuration = "(H (1 [50] 4 [25] 3))"
--      End
--      Begin PaneConfiguration = 2
--         NumPanes = 3
--         Configuration = "(H (1 [50] 2 [25] 3))"
--      End
--      Begin PaneConfiguration = 3
--         NumPanes = 3
--         Configuration = "(H (4 [30] 2 [40] 3))"
--      End
--      Begin PaneConfiguration = 4
--         NumPanes = 2
--         Configuration = "(H (1 [56] 3))"
--      End
--      Begin PaneConfiguration = 5
--         NumPanes = 2
--         Configuration = "(H (2 [66] 3))"
--      End
--      Begin PaneConfiguration = 6
--         NumPanes = 2
--         Configuration = "(H (4 [50] 3))"
--      End
--      Begin PaneConfiguration = 7
--         NumPanes = 1
--         Configuration = "(V (3))"
--      End
--      Begin PaneConfiguration = 8
--         NumPanes = 3
--         Configuration = "(H (1[56] 4[18] 2) )"
--      End
--      Begin PaneConfiguration = 9
--         NumPanes = 2
--         Configuration = "(H (1 [75] 4))"
--      End
--      Begin PaneConfiguration = 10
--         NumPanes = 2
--         Configuration = "(H (1[66] 2) )"
--      End
--      Begin PaneConfiguration = 11
--         NumPanes = 2
--         Configuration = "(H (4 [60] 2))"
--      End
--      Begin PaneConfiguration = 12
--         NumPanes = 1
--         Configuration = "(H (1) )"
--      End
--      Begin PaneConfiguration = 13
--         NumPanes = 1
--         Configuration = "(V (4))"
--      End
--      Begin PaneConfiguration = 14
--         NumPanes = 1
--         Configuration = "(V (2))"
--      End
--      ActivePaneConfig = 0
--   End
--   Begin DiagramPane = 
--      Begin Origin = 
--         Top = 0
--         Left = 0
--      End
--      Begin Tables = 
--      End
--   End
--   Begin SQLPane = 
--   End
--   Begin DataPane = 
--      Begin ParameterDefaults = ""
--      End
--   End
--   Begin CriteriaPane = 
--      Begin ColumnWidths = 11
--         Column = 1440
--         Alias = 900
--         Table = 1170
--         Output = 720
--         Append = 1400
--         NewValue = 1170
--         SortType = 1350
--         SortOrder = 1410
--         GroupBy = 1350
--         Filter = 1350
--         Or = 1350
--         Or = 1350
--         Or = 1350
--      End
--   End
--End
--' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwAR100'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwAR100'
--GO


