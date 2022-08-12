CREATE TABLE [dbo].[TASK_LINK_ENTITY_TABLE]
(
[TASK_LINK_ENTITY_TABLE_ID] [int] NOT NULL,
[TABLE_NAME] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ACTIVE_FLAG] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[COLUMN_EXPRESSION] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DISPLAY_NAME] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TASK_LINK_ENTITY_TABLE] ADD CONSTRAINT [PK__TASK_LINK_ENTITY__7A1555B3] PRIMARY KEY CLUSTERED ([TASK_LINK_ENTITY_TABLE_ID]) ON [PRIMARY]
GO
GRANT DELETE ON  [dbo].[TASK_LINK_ENTITY_TABLE] TO [public]
GO
GRANT INSERT ON  [dbo].[TASK_LINK_ENTITY_TABLE] TO [public]
GO
GRANT REFERENCES ON  [dbo].[TASK_LINK_ENTITY_TABLE] TO [public]
GO
GRANT SELECT ON  [dbo].[TASK_LINK_ENTITY_TABLE] TO [public]
GO
GRANT UPDATE ON  [dbo].[TASK_LINK_ENTITY_TABLE] TO [public]
GO
