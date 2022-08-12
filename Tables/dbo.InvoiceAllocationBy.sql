CREATE TABLE [dbo].[InvoiceAllocationBy]
(
[InvoiceAllocationById] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InvoiceAllocationBy] ADD CONSTRAINT [PK_InvoiceAllocationBy] PRIMARY KEY CLUSTERED ([InvoiceAllocationById]) ON [PRIMARY]
GO
GRANT DELETE ON  [dbo].[InvoiceAllocationBy] TO [public]
GO
GRANT INSERT ON  [dbo].[InvoiceAllocationBy] TO [public]
GO
GRANT REFERENCES ON  [dbo].[InvoiceAllocationBy] TO [public]
GO
GRANT SELECT ON  [dbo].[InvoiceAllocationBy] TO [public]
GO
GRANT UPDATE ON  [dbo].[InvoiceAllocationBy] TO [public]
GO
