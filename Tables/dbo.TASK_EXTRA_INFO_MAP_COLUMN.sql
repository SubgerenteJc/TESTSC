CREATE TABLE [dbo].[TASK_EXTRA_INFO_MAP_COLUMN]
(
[TASK_EXTRA_INFO_MAP_COLUMN_ID] [int] NOT NULL IDENTITY(1, 1),
[TASK_LINK_ENTITY_TABLE_ID] [int] NOT NULL,
[COLUMN_EXPRESSION] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ACTIVE_FLAG] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TASK_COLUMN_POSITION] [int] NULL,
[DISPLAY_COLUMN_NAME] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TASK_EXTRA_INFO_MAP_COLUMN] ADD CONSTRAINT [PK__TASK_EXTRA_INFO___745C7C5D] PRIMARY KEY CLUSTERED ([TASK_EXTRA_INFO_MAP_COLUMN_ID]) ON [PRIMARY]
GO
GRANT DELETE ON  [dbo].[TASK_EXTRA_INFO_MAP_COLUMN] TO [public]
GO
GRANT INSERT ON  [dbo].[TASK_EXTRA_INFO_MAP_COLUMN] TO [public]
GO
GRANT REFERENCES ON  [dbo].[TASK_EXTRA_INFO_MAP_COLUMN] TO [public]
GO
GRANT SELECT ON  [dbo].[TASK_EXTRA_INFO_MAP_COLUMN] TO [public]
GO
GRANT UPDATE ON  [dbo].[TASK_EXTRA_INFO_MAP_COLUMN] TO [public]
GO