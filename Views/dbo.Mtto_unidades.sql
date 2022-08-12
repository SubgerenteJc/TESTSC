SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Mtto_unidades]
AS
SELECT     trc_number, trc_type1, trc_type2, trc_type3, trc_type4, trc_fleet, trc_division, trc_misc1, trc_misc2, trc_misc3, trc_misc4
FROM         dbo.tractorprofile
GO
DECLARE @xp tinyint
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DefaultView', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', NULL, NULL
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
         Configuration = "(H (1[50] 4[25] 3) )"
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
         Configuration = "(H (1[75] 4) )"
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
      ActivePaneConfig = 9
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tractorprofile"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 252
            End
            DisplayFlags = 280
            TopColumn = 155
         End
      End
   End
   Begin SQLPane = 
      PaneHidden = 
   End
   Begin DataPane = 
      PaneHidden = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
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
', 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Filter', NULL, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_OrderBy', NULL, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', NULL, NULL
GO
DECLARE @xp bit
SELECT @xp=0
EXEC sp_addextendedproperty N'MS_OrderByOn', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', NULL, NULL
GO
DECLARE @xp tinyint
SELECT @xp=0
EXEC sp_addextendedproperty N'MS_Orientation', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=10000
EXEC sp_addextendedproperty N'MS_TableMaxRecords', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', NULL, NULL
GO
DECLARE @xp bit
SELECT @xp=0
EXEC sp_addextendedproperty N'MS_ColumnHidden', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', 'COLUMN', N'trc_division'
GO
DECLARE @xp smallint
SELECT @xp=0
EXEC sp_addextendedproperty N'MS_ColumnOrder', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', 'COLUMN', N'trc_division'
GO
DECLARE @xp smallint
SELECT @xp=-1
EXEC sp_addextendedproperty N'MS_ColumnWidth', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', 'COLUMN', N'trc_division'
GO
DECLARE @xp bit
SELECT @xp=0
EXEC sp_addextendedproperty N'MS_ColumnHidden', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', 'COLUMN', N'trc_fleet'
GO
DECLARE @xp smallint
SELECT @xp=0
EXEC sp_addextendedproperty N'MS_ColumnOrder', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', 'COLUMN', N'trc_fleet'
GO
DECLARE @xp smallint
SELECT @xp=-1
EXEC sp_addextendedproperty N'MS_ColumnWidth', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', 'COLUMN', N'trc_fleet'
GO
DECLARE @xp bit
SELECT @xp=0
EXEC sp_addextendedproperty N'MS_ColumnHidden', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', 'COLUMN', N'trc_number'
GO
DECLARE @xp smallint
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_ColumnOrder', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', 'COLUMN', N'trc_number'
GO
DECLARE @xp smallint
SELECT @xp=-1
EXEC sp_addextendedproperty N'MS_ColumnWidth', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', 'COLUMN', N'trc_number'
GO
DECLARE @xp bit
SELECT @xp=0
EXEC sp_addextendedproperty N'MS_ColumnHidden', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', 'COLUMN', N'trc_type1'
GO
DECLARE @xp smallint
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_ColumnOrder', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', 'COLUMN', N'trc_type1'
GO
DECLARE @xp smallint
SELECT @xp=-1
EXEC sp_addextendedproperty N'MS_ColumnWidth', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', 'COLUMN', N'trc_type1'
GO
DECLARE @xp bit
SELECT @xp=0
EXEC sp_addextendedproperty N'MS_ColumnHidden', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', 'COLUMN', N'trc_type2'
GO
DECLARE @xp smallint
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_ColumnOrder', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', 'COLUMN', N'trc_type2'
GO
DECLARE @xp smallint
SELECT @xp=-1
EXEC sp_addextendedproperty N'MS_ColumnWidth', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', 'COLUMN', N'trc_type2'
GO
DECLARE @xp bit
SELECT @xp=0
EXEC sp_addextendedproperty N'MS_ColumnHidden', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', 'COLUMN', N'trc_type3'
GO
DECLARE @xp smallint
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_ColumnOrder', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', 'COLUMN', N'trc_type3'
GO
DECLARE @xp smallint
SELECT @xp=-1
EXEC sp_addextendedproperty N'MS_ColumnWidth', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', 'COLUMN', N'trc_type3'
GO
DECLARE @xp bit
SELECT @xp=0
EXEC sp_addextendedproperty N'MS_ColumnHidden', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', 'COLUMN', N'trc_type4'
GO
DECLARE @xp smallint
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_ColumnOrder', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', 'COLUMN', N'trc_type4'
GO
DECLARE @xp smallint
SELECT @xp=-1
EXEC sp_addextendedproperty N'MS_ColumnWidth', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Mtto_unidades', 'COLUMN', N'trc_type4'
GO
