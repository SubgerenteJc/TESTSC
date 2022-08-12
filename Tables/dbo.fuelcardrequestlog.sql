CREATE TABLE [dbo].[fuelcardrequestlog]
(
[timestamp] [binary] (8) NULL,
[pyd_number] [int] NOT NULL,
[pyh_number] [int] NOT NULL,
[lgh_number] [int] NULL,
[asgn_number] [int] NULL,
[asgn_type] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[asgn_id] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ivd_number] [int] NULL,
[pyd_prorap] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_payto] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyt_itemcode] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mov_number] [int] NULL,
[pyd_description] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyr_ratecode] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_quantity] [float] NULL,
[pyd_rateunit] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_unit] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_rate] [money] NULL,
[pyd_amount] [money] NULL,
[pyd_pretax] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_glnum] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_currency] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_currencydate] [datetime] NULL,
[pyd_status] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_refnumtype] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_refnum] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyh_payperiod] [datetime] NULL,
[pyd_workperiod] [datetime] NULL,
[lgh_startpoint] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lgh_startcity] [int] NULL,
[lgh_endpoint] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lgh_endcity] [int] NULL,
[ivd_payrevenue] [money] NULL,
[pyd_revenueratio] [float] NULL,
[pyd_lessrevenue] [money] NULL,
[pyd_payrevenue] [money] NULL,
[pyd_transdate] [datetime] NULL,
[pyd_minus] [int] NULL,
[pyd_sequence] [int] NULL,
[std_number] [int] NULL,
[pyd_loadstate] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_xrefnumber] [int] NULL,
[ord_hdrnumber] [int] NULL,
[pyt_fee1] [money] NULL,
[pyt_fee2] [money] NULL,
[pyd_grossamount] [money] NULL,
[pyd_adj_flag] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_updatedby] [char] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[psd_id] [int] NULL,
[pyd_transferdate] [datetime] NULL,
[pyd_exportstatus] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_releasedby] [char] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cht_itemcode] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_billedweight] [int] NULL,
[tar_tarriffnumber] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[psd_batch_id] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_updsrc] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_updatedon] [datetime] NULL,
[pyd_offsetpay_number] [int] NULL,
[pyd_credit_pay_flag] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_ivh_hdrnumber] [int] NULL,
[psd_number] [int] NULL,
[pyd_ref_invoice] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_ref_invoicedate] [datetime] NULL,
[pyd_ignoreglreset] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_authcode] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_PostProcSource] [smallint] NULL,
[pyd_GPTrans] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cac_id] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ccc_id] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_hourlypaydate] [datetime] NULL,
[pyd_isdefault] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_mbtaxableamount] [money] NULL,
[pyd_nttaxableamount] [money] NULL,
[pyd_maxquantity_used] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_maxcharge_used] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_carinvnum] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_carinvdate] [datetime] NULL,
[std_number_adj] [int] NULL,
[pyd_vendortopay] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [df_fuelcardrequestlog_pyd_vendortopay] DEFAULT ('UNKNOWN'),
[pyd_vendorpay] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_remarks] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[stp_number] [int] NULL,
[stp_mfh_sequence] [int] NULL,
[pyd_perdiem_exceeded] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_carrierinvoice_aprv] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_carrierinvoice_rjct] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd__aprv_rjct_comment] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_payment_date] [datetime] NULL,
[pyd_payment_doc_number] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_paid_indicator] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_paid_amount] [money] NULL,
[pyd_expresscode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_createdby] [char] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_createdon] [datetime] NULL,
[stp_number_pacos] [int] NULL,
[pyd_gst_amount] [money] NULL,
[pyd_gst_flag] [int] NULL,
[pyd_mileagetable] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyt_otflag] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bill_override] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[not_billed_reason] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_ap_check_date] [datetime] NULL,
[pyd_ap_check_number] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_ap_check_amount] [decimal] (7, 2) NULL,
[pyd_ap_vendor_id] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_ap_updated_by] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_reg_time_qty] [float] NULL,
[pyd_advstdnum] [int] NULL,
[pyd_min_period] [datetime] NULL,
[crd_cardnumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_ap_voucher_nbr] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_workcycle_status] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_workcycle_description] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_thirdparty_split_percent] [float] NOT NULL,
[pyd_basis] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_basisunit] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_branch_override] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_billtype_changereason] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_branch] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_reg_time_pydnum] [int] NULL,
[pyd_delays] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_overlimit] [money] NULL,
[pyd_rate_factor] [float] NULL,
[pyd_orig_currency] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pyd_orig_amount] [money] NULL,
[pyd_cex_rate] [money] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[fuelcardrequestlog] ADD CONSTRAINT [PK_fuelcardrequestlog] PRIMARY KEY NONCLUSTERED ([pyd_number]) ON [PRIMARY]
GO
GRANT DELETE ON  [dbo].[fuelcardrequestlog] TO [public]
GO
GRANT INSERT ON  [dbo].[fuelcardrequestlog] TO [public]
GO
GRANT SELECT ON  [dbo].[fuelcardrequestlog] TO [public]
GO
GRANT UPDATE ON  [dbo].[fuelcardrequestlog] TO [public]
GO
