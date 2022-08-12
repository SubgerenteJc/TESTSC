CREATE TABLE [dbo].[ResNow_TractorCache_Final]
(
[tractor_key] [int] NOT NULL IDENTITY(1, 1),
[tractor_id] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[tractor_seatedstatus] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tractor_type1] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tractor_type2] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tractor_type3] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tractor_type4] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tractor_company] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tractor_division] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tractor_terminal] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tractor_fleet] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tractor_branch] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tractor_owner] [varchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[tractor_make] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[tractor_model] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[tractor_year] [int] NOT NULL,
[tractor_enginemake] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[tractor_enginemodel] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[tractor_fuelcapacity] [int] NOT NULL,
[tractor_grossweight] [int] NULL,
[tractor_axlecount] [smallint] NULL,
[tractor_tareweight] [float] NULL,
[tractor_tareweightuom] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tractor_originalcost] [float] NULL,
[tractor_licensestate] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[tractor_licensecountry] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[tractor_licensenumber] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[tractor_startdate] [datetime] NULL,
[tractor_dateacquired] [datetime] NULL,
[tractor_retiredate] [datetime] NULL,
[tractor_DateStart] [datetime] NULL,
[tractor_DateEnd] [datetime] NULL,
[tractor_active] [bit] NOT NULL CONSTRAINT [DF__ResNow_Tr__tract__14B23EE5] DEFAULT ((1)),
[tractor_Updated] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ResNow_TractorCache_Final] ADD CONSTRAINT [AutoPK_ResNow_TractorCache_Final_tractor_key] PRIMARY KEY CLUSTERED ([tractor_key]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_ResNow_TractorCache_Final_tractor_DateStart] ON [dbo].[ResNow_TractorCache_Final] ([tractor_DateStart]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_ResNow_TractorCache_Final_tractor_id] ON [dbo].[ResNow_TractorCache_Final] ([tractor_id], [tractor_DateStart], [tractor_DateEnd]) ON [PRIMARY]
GO
GRANT DELETE ON  [dbo].[ResNow_TractorCache_Final] TO [public]
GO
GRANT INSERT ON  [dbo].[ResNow_TractorCache_Final] TO [public]
GO
GRANT SELECT ON  [dbo].[ResNow_TractorCache_Final] TO [public]
GO
GRANT UPDATE ON  [dbo].[ResNow_TractorCache_Final] TO [public]
GO
