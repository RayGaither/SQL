USE [ankura_dw]
GO

/****** Object:  View [dbo].[vwIncomeStatement]    Script Date: 7/14/2021 12:38:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vwIncomeStatement]
AS
SELECT        R.[Report Equivalent] AS Account, R.[Order], JL.AccountingDate, JL.LedgerCurrencyId, JL.Currency_Rate, SUM(JL.Debit_Amount) AS [Debit Amount], SUM(JL.Credit_Amount) AS [Credit Amount]
FROM            dbo.rptReportFormatTable AS R JOIN
                         dbo.vwAccountRelationshipsTall AS AR ON R.[Account Name] = AR.Parent
						 JOIN
                         dbo.JournalLines AS JL ON JL.LedgerAccountId = AR.LedgerAccountChild 
WHERE        (R.[Report Name] = 'Income Statement')
GROUP BY R.[Account Name], R.[Report Equivalent], R.[Report Name], R.[Order], JL.LedgerAccountId, JL.AccountingDate, JL.LedgerCurrencyId, JL.Currency_Rate
UNION
SELECT        R2.[Report Equivalent] AS Account, R2.[Order], null as AccountingDate, null as LedgerCurrencyId, null as Currency_Rate, null AS [Debit Amount], null AS [Credit Amount]
FROM            dbo.rptReportFormatTable R2 where R2.[Report Equivalent] =  ''
GO

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
         Begin Table = "R"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AR"
            Begin Extent = 
               Top = 6
               Left = 274
               Bottom = 136
               Right = 514
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JL"
            Begin Extent = 
               Top = 6
               Left = 552
               Bottom = 136
               Right = 833
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwIncomeStatement'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwIncomeStatement'
GO


