CREATE TABLE [dbo].[Pagina]
(
[IIDPAGINA] [int] NOT NULL IDENTITY(1, 1),
[MENSAJE] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CONTRALADOR] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACCION] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BHABILITADO] [int] NULL
) ON [PRIMARY]
GO
