CREATE TYPE [dbo].[UtOrd] AS TABLE
(
[ord_hdrnumber] [int] NOT NULL,
[ord_number] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ord_status] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ord_invoicestatus] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ord_billto] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ord_bookdate] [datetime] NULL,
[ord_availabledate] [datetime] NULL,
[ord_invoice_effectivedate] [datetime] NULL,
[tar_number] [int] NULL,
[ord_rateby] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ord_complete_stamp] [datetime] NULL,
[ord_consignee] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ord_company] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ord_shipper] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ord_carrier] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ord_trailer] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ord_tractor] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ord_edistate] [tinyint] NULL,
[ord_originpoint] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ord_destpoint] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ord_startdate] [datetime] NULL,
[ord_charge] [money] NULL,
[ord_accessorial_chrg] [money] NULL,
[ord_priority] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ord_remark] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ord_totalpieces] [decimal] (10, 2) NULL,
[ord_totalweight] [decimal] (12, 4) NULL,
[ord_totalvolume] [money] NULL,
[ord_currency] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ord_quantity] [decimal] (12, 4) NULL,
[ord_completiondate] [datetime] NULL,
[mov_number] [int] NULL,
[cht_itemcode] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED ([ord_hdrnumber])
)
GO
GRANT EXECUTE ON TYPE:: [dbo].[UtOrd] TO [public]
GO
