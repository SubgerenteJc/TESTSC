CREATE TABLE [dbo].[tblQcEssT3020]
(
[SN] [int] NOT NULL IDENTITY(1, 1),
[qcUserIDCompany] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[equipUnitAddr] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[equipID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[eventKey] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[eventURL] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[eventTS_GMT] [datetime] NOT NULL,
[sentTS_GMT] [datetime] NOT NULL,
[equipSCAC] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[equipType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[equipMobileType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[equipAlias] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[equipDeviceID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[equipDeviceFirmwareVers] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[equipVIN] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[equipDivision] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[driverID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[eventTrigger] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[triggerData] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[eventType] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[speed] [int] NOT NULL,
[parkBrakeStatus] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[msgLocPosLat] [real] NOT NULL,
[msgLocPosLon] [real] NOT NULL,
[msgLocPosTS_GMT] [datetime] NOT NULL,
[incdntLocPosLat] [real] NOT NULL,
[incdntLocPosLon] [real] NOT NULL,
[incdntLocPosTS_GMT] [datetime] NOT NULL,
[evimsTripDataStartMonth] [int] NOT NULL,
[evimsTripDataStartDay] [int] NOT NULL,
[evimsTripDataStartYear] [int] NOT NULL,
[evimsTripDataStartHour] [int] NOT NULL,
[evimsTripDataStartMinute] [int] NOT NULL,
[evimsTripDataDistance] [real] NOT NULL,
[evimsTripDataMaxSpeed] [real] NOT NULL,
[evimsTripDataFollowPerc0_1] [real] NOT NULL,
[evimsTripDataFollowPerc1_2] [real] NOT NULL,
[evimsTripDataCoastingTime] [real] NOT NULL,
[evimsTripDataHB] [int] NOT NULL,
[updatedon] [datetime] NOT NULL,
[updatedby] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[rawXML] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblQcEssT3020] ADD CONSTRAINT [PK_tblQcEssT3020] PRIMARY KEY CLUSTERED ([SN]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tblQcEssT3020_Main] ON [dbo].[tblQcEssT3020] ([qcUserIDCompany], [equipUnitAddr], [equipID], [eventKey]) ON [PRIMARY]
GO