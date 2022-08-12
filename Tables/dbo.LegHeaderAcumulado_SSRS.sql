CREATE TABLE [dbo].[LegHeaderAcumulado_SSRS]
(
[ord_hdrnumber] [int] NULL,
[lgh_tractor] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lgh_primary_trailer] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mov_number] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lgh_number] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoadedMlsMove] [float] NULL,
[MTMlsMove] [float] NULL,
[TotMlsMove] [float] NULL,
[LoadedMlsLegHeader] [float] NULL,
[MTMlsLegHeader] [float] NULL,
[TotMlsLegHeader] [float] NULL,
[TotLHChargeForMove] [float] NULL,
[AccChargeMove] [float] NULL,
[AllChargesMove] [float] NULL,
[PercentLghMlsOfMoveMls] [float] NULL,
[AllocatedLHChargeForLgh] [float] NULL,
[AllocatedAcclChargeForLgh] [float] NULL,
[AllocatedTotlChargesForLgh] [float] NULL,
[RevPerMileAllCharges] [float] NULL,
[RevPerMileLHCharge] [float] NULL,
[AllocRevMinusPay] [float] NULL,
[AllocRevMinusPayPerTrvlMile] [float] NULL,
[mpp_teamleader] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
