SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vista_pnfs]
AS
SELECT     [Order Number], [Invoice Status], [Order Status], DrvType3, Tractor, [Reference Number], CASE WHEN Currency = 'US$' THEN [Total Revenue] *
                          (SELECT     cex_rate
                            FROM          currency_exchange
                            WHERE      (DAY(cex_date) =
                                                       (SELECT     fechamax = MAX(DAY(cex_date))
                                                         FROM          currency_exchange
                                                         WHERE      (MONTH(cex_date) = MONTH(GETDATE())) AND (YEAR(cex_date) = YEAR(GETDATE())))) AND (YEAR(cex_date) 
                                                   = YEAR(GETDATE())) AND (MONTH(cex_date) = MONTH(GETDATE()))) ELSE [Total Revenue] END AS [Total Revenue], 
                      [Total Revenue] AS original, Currency, [RevType2 Name], [RevType4 Name], [PaperWork Received Date], [Delivery Date], DATEDIFF([day], 
                      [Delivery Date], GETDATE()) AS DIFdias, ROUND(DATEDIFF([day], [Delivery Date], GETDATE()), - 1) AS diastranssup, CASE WHEN (DATEDIFF([day], 
                      [Delivery Date], GETDATE()) - ROUND(DATEDIFF([day], [Delivery Date], GETDATE()), - 1)) > 0 THEN ROUND(DATEDIFF([day], [Delivery Date], GETDATE()), 
                      - 1) + 10 ELSE ROUND(DATEDIFF([day], [Delivery Date], GETDATE()), - 1) END AS dd, [Bill To ID], [Driver Name]
FROM         dbo.vTTSTMW_OrderandInvoiceInformation
WHERE     ([Order Status] = 'CMP') AND ([Invoice Status] IN ('AVL', 'HLD', 'RTP', 'HLA'))
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
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
         Configuration = "(H (1[50] 2[25] 3) )"
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
         Configuration = "(H (1 [56] 4 [18] 2))"
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
         Begin Table = "vTTSTMW_OrderandInvoiceInformation"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 327
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
      RowHeights = 220
      Begin ColumnWidths = 19
         Width = 284
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
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
', 'SCHEMA', N'dbo', 'VIEW', N'vista_pnfs', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vista_pnfs', NULL, NULL
GO
