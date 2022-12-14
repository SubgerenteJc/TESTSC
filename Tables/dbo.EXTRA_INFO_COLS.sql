CREATE TABLE [dbo].[EXTRA_INFO_COLS]
(
[COL_ID] [int] NOT NULL IDENTITY(1, 1),
[EXTRA_ID] [int] NOT NULL,
[TAB_ID] [int] NOT NULL,
[COL_NAME] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DISPLAY_ORDER] [int] NULL,
[EDITABLE] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MASK] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DDLB] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TABLE_NAME] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KEY_COL_NAME] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COL_DATA_FROM] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXTRA_WHERE] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MASK_TYPE] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[label] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FORMAT] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ord_field_num] [int] NULL,
[expression] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[err_msg] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MASTERFILE] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EXTRA_INFO_COLS] ADD CONSTRAINT [AutoPK_EXTRA_INFO_COLS] PRIMARY KEY CLUSTERED ([COL_ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [uk_extra_id_ord_field] ON [dbo].[EXTRA_INFO_COLS] ([EXTRA_ID], [ord_field_num]) ON [PRIMARY]
GO
GRANT DELETE ON  [dbo].[EXTRA_INFO_COLS] TO [public]
GO
GRANT INSERT ON  [dbo].[EXTRA_INFO_COLS] TO [public]
GO
GRANT REFERENCES ON  [dbo].[EXTRA_INFO_COLS] TO [public]
GO
GRANT SELECT ON  [dbo].[EXTRA_INFO_COLS] TO [public]
GO
GRANT UPDATE ON  [dbo].[EXTRA_INFO_COLS] TO [public]
GO
