USE [ankura_dw]
GO

/****** Object:  View [dbo].[vwAR100]    Script Date: 7/12/2021 11:41:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Set statistics TIME, IO on




--CREATE VIEW [dbo].[vwAR100-1]
--AS
SELECT --top 10 
		[CustomerInvoiceID]		--[Customer_Invoice_Reference_ID]	
	  ,[ProjectCompanyName]
	  ,[ProjectCostCenterId]
      ,[ProjectDeptLevel4]
      ,[ProjectDeptLevel5]
      ,[CustomerName] 
	  ,[CustomerID]				--[Customer_ID] 
      ,[SeniorProjectManagerNameFL]
      ,[ProjectManagerNameFL]
	  ,I.[ProjectId]
      ,[ProjectName]
      ,[LOR_PM_DesigneeNameFL]
      ,[InvoiceNumber]			--[Invoice_Number]
      ,[InvoiceDate]
      ,[InvoiceAccountingDate]	--[AccountingDate]
      ,[AmountDue]				--[Amount_Due]	  
	  ,[InvoiceAmountWithSign]	--[Invoice_Amount]

	  , (select  isnull(sum([Payment_Amount]), 0)  
		FROM [ankura_dw].[dbo].[CustomerPayments] P 
		where P.Customer_Invoice_Reference_ID = I.CustomerInvoiceID) as [Total_Amount_Paid]

	  ,0 as Account_Amounts_USD  --TODO!!! need SQL to get this number
	  ,0 as Total_Writeoffs_USD  --TODO!!! need SQL to get this number

	  , (select  isnull(sum([Payment_Amount]), 0)  FROM [ankura_dw].[dbo].[CustomerPayments] P 
				where P.Customer_Invoice_Reference_ID = I.CustomerInvoiceID
					and [PaymentDate] >= DATEFROMPARTS(DATEPART(year, DATEADD(day,-1, CAST(GETDATE() AS DATE))), DATEPART(month, DATEADD(day,-1, CAST(GETDATE() AS DATE))), 1) 
				) as [Paid_MTD]

	  , (select  isnull(sum([Payment_Amount]), 0)  FROM [ankura_dw].[dbo].[CustomerPayments] P 
				where P.Customer_Invoice_Reference_ID = I.CustomerInvoiceID
					and [PaymentDate] >= DATEADD(day,-31, CAST(GETDATE() AS DATE)) -- last 30 days
				) as [Paid_Last30]

	  ,IIF(DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))>=0 and DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))<=30,[AmountDue],0) as Aging_0_30_Bucket_USD
	  ,IIF(DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))>=31 and DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))<=60,[AmountDue],0) as Aging_31_60_Bucket_USD
	  ,IIF(DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))>=61 and DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))<=90,[AmountDue],0) as Aging_61_90_Bucket_USD
	  ,IIF(DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))>=91 and DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))<=120,[AmountDue],0) as Aging_91_120_Bucket_USD
	  ,IIF(DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))>=121 and DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))<=180,[AmountDue],0) as Aging_121_180_Bucket_USD
	  ,IIF(DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))>=181 and DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))<=365,[AmountDue],0) as Aging_181_365_Bucket_USD
	  ,IIF(DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))>=366 and DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))<=720,[AmountDue],0) as Aging_366_720_Bucket_USD
	  ,IIF(DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))>=721, [AmountDue],0) as Aging_720_Plus_Bucket_USD

	  ,IIF(DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))>=0 and DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))<=30,[AmountDue],0) as Aging_0_30_Bucket_USD_InvoiceDate
	  ,IIF(DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))>=31 and DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))<=60,[AmountDue],0) as Aging_31_60_Bucket_USD_InvoiceDate
	  ,IIF(DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))>=61 and DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))<=90,[AmountDue],0) as Aging_61_90_Bucket_USD_InvoiceDate
	  ,IIF(DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))>=91 and DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))<=120,[AmountDue],0) as Aging_91_120_Bucket_USD_InvoiceDate
	  ,IIF(DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))>=121 and DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))<=180,[AmountDue],0) as Aging_121_180_Bucket_USD_InvoiceDate
	  ,IIF(DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))>=181 and DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))<=365,[AmountDue],0) as Aging_181_365_Bucket_USD_InvoiceDate
	  ,IIF(DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))>=366 and DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))<=720,[AmountDue],0) as Aging_366_720_Bucket_USD_InvoiceDate
	  ,IIF(DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE))>=721, [AmountDue],0) as Aging_720_Plus_Bucket_USD_InvoiceDate
	  --,IIF(DATEDIFF(day,[OverrideDueDate],CAST(GETDATE() AS DATE))>=0 and DATEDIFF(day,[OverrideDueDate],CAST(GETDATE() AS DATE))<=30,[AmountDue],0) as Aging_0_30_Bucket_USD_DueDate
	  --,IIF(DATEDIFF(day,[OverrideDueDate],CAST(GETDATE() AS DATE))>=31 and DATEDIFF(day,[OverrideDueDate],CAST(GETDATE() AS DATE))<=60,[AmountDue],0) as Aging_31_60_Bucket_USD_DueDate
	  --,IIF(DATEDIFF(day,[OverrideDueDate],CAST(GETDATE() AS DATE))>=61 and DATEDIFF(day,[OverrideDueDate],CAST(GETDATE() AS DATE))<=90,[AmountDue],0) as Aging_61_90_Bucket_USD_DueDate
	  --,IIF(DATEDIFF(day,[OverrideDueDate],CAST(GETDATE() AS DATE))>=91 and DATEDIFF(day,[OverrideDueDate],CAST(GETDATE() AS DATE))<=120,[AmountDue],0) as Aging_91_120_Bucket_USD_DueDate
	  --,IIF(DATEDIFF(day,[OverrideDueDate],CAST(GETDATE() AS DATE))>=121 and DATEDIFF(day,[OverrideDueDate],CAST(GETDATE() AS DATE))<=180,[AmountDue],0) as Aging_121_180_Bucket_USD_DueDate
	  --,IIF(DATEDIFF(day,[OverrideDueDate],CAST(GETDATE() AS DATE))>=181 and DATEDIFF(day,[OverrideDueDate],CAST(GETDATE() AS DATE))<=365,[AmountDue],0) as Aging_181_365_Bucket_USD_DueDate
	  --,IIF(DATEDIFF(day,[OverrideDueDate],CAST(GETDATE() AS DATE))>=366 and DATEDIFF(day,[OverrideDueDate],CAST(GETDATE() AS DATE))<=720,[AmountDue],0) as Aging_366_720_Bucket_USD_DueDate
	  --,IIF(DATEDIFF(day,[OverrideDueDate],CAST(GETDATE() AS DATE))>=721, [AmountDue],0) as Aging_720_Plus_Bucket_USD_DueDate

	  --,[OverrideDueDate] as Due_Date
	  --,DATEDIFF(day,[InvoiceDate],CAST(GETDATE() AS DATE)) as Aging_Days_Invoice_Date
	  --,DATEDIFF(day,[OverrideDueDate],CAST(GETDATE() AS DATE)) as Aging_Days_Due_Date

	  , (select CAST( max([PaymentDate]) AS DATE)  FROM [ankura_dw].[dbo].[CustomerPayments] P 
				where P.Customer_Invoice_Reference_ID = I.CustomerInvoiceID					
				) as [Most_Recent_Payment_Date]

      ,[ProjectBillerNameFL]
      ,[Project_Currency]
   --   ,[FD_Created_Date]
 --     ,[Worker]
  --    ,[Comment]
      ,[Retainer_Balance__USD]
 --     ,[Payment_Terms_ID]

  FROM [ankura_dw].[dbo].CustInvoiceSummaries I JOIN [Projects] P on I.[ProjectId] = P.[ProjectId]  
       where I.PaymentStatus in ('Unpaid','Partially Paid') and I.InvoiceStatus <> 'Canceled'      

	   --Document_Status is now InvoiceStatus
GO
/*
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwAR100'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwAR100'
GO

*/

