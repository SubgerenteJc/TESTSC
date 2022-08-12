SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO

CREATE PROC [dbo].[completion_invoicedetail_sp]	@p_ord_hdrnumber	int

AS

/**
 * 
 * NAME:
 * completion_invoicedetail_sp
 *
 * TYPE:
 * StoredProcedure
 *
 * DESCRIPTION:
 * 
 * RETURNS: NONE
 *
 * RESULT SETS: NONE
 *
 * PARAMETERS: NONE
 *
 * REVISION HISTORY:
 * 6/28/2006.01 ? PTS33397 - Dan Hudec ? Created Procedure
 *
 **/

IF EXISTS (select * from invoiceheader
		   where  ord_hdrnumber = @p_ord_hdrnumber)	
 BEGIN	
	SELECT	completion_invoicedetail.ivh_hdrnumber, 
			completion_invoicedetail.ivd_number, 
			completion_invoicedetail.stp_number, 
			completion_invoicedetail.ivd_description, 
			completion_invoicedetail.cht_itemcode, 
			completion_invoicedetail.ivd_quantity, 
			completion_invoicedetail.ivd_rate, 
			completion_invoicedetail.ivd_charge, 
			completion_invoicedetail.ivd_taxable1, 
			completion_invoicedetail.ivd_taxable2, 
			completion_invoicedetail.ivd_taxable3, 
			completion_invoicedetail.ivd_taxable4, 
			completion_invoicedetail.ivd_unit, 
			completion_invoicedetail.cur_code, 
			completion_invoicedetail.ivd_currencydate,
			completion_invoicedetail.ivd_glnum, 
			completion_invoicedetail.ord_hdrnumber, 
			completion_invoicedetail.ivd_type, 
			completion_invoicedetail.ivd_rateunit, 
			completion_invoicedetail.ivd_billto, 
			completion_invoicedetail.ivd_itemquantity, 
			completion_invoicedetail.ivd_subtotalptr, 
			completion_invoicedetail.ivd_allocatedrev, 
			completion_invoicedetail.ivd_sequence, 
			completion_invoicedetail.ivd_invoicestatus, 
			completion_invoicedetail.mfh_hdrnumber, 
			completion_invoicedetail.ivd_refnum, 
			completion_invoicedetail.cmd_code, 
			completion_invoicedetail.cmp_id, 
			completion_invoicedetail.ivd_distance, 
			completion_invoicedetail.ivd_distunit, 
			completion_invoicedetail.ivd_wgt, 
			completion_invoicedetail.ivd_wgtunit, 
			completion_invoicedetail.ivd_count, 
			completion_invoicedetail.ivd_countunit, 
			completion_invoicedetail.evt_number, 
			completion_invoicedetail.ivd_reftype, 
			completion_invoicedetail.ivd_volume, 
			completion_invoicedetail.ivd_volunit, 
			completion_invoicedetail.ivd_orig_cmpid, 
			completion_invoicedetail.ivd_payrevenue, 
			completion_invoicedetail.ivd_sign, 
			completion_invoicedetail.ivd_length, 
			completion_invoicedetail.ivd_lengthunit, 
			completion_invoicedetail.ivd_width, 
			completion_invoicedetail.ivd_widthunit, 
			completion_invoicedetail.ivd_height, 
			completion_invoicedetail.ivd_heightunit, 
			completion_invoicedetail.ivd_exportstatus, 
			completion_invoicedetail.cht_basisunit, 
			completion_invoicedetail.ivd_remark, 
			completion_invoicedetail.tar_number, 
			completion_invoicedetail.tar_tariffnumber, 
			completion_invoicedetail.tar_tariffitem, 
			completion_invoicedetail.ivd_fromord, 
			completion_invoicedetail.ivd_zipcode, 
			completion_invoicedetail.ivd_quantity_type, 
			completion_invoicedetail.cht_class, 
			completion_invoicedetail.ivd_mileagetable, 
			completion_invoicedetail.ivd_charge_type, 
			completion_invoicedetail.ivd_trl_rent, 
			completion_invoicedetail.ivd_trl_rent_start, 
			completion_invoicedetail.ivd_trl_rent_end, 
			completion_invoicedetail.ivd_rate_type, 
			completion_invoicedetail.cht_lh_min, 
			completion_invoicedetail.cht_lh_rev, 
			completion_invoicedetail.cht_lh_stl, 
			completion_invoicedetail.cht_lh_rpt, 
			completion_invoicedetail.cht_rollintolh, 
			completion_invoicedetail.cht_lh_prn, 
			completion_invoicedetail.fgt_number, 
			completion_invoicedetail.ivd_paylgh_number, 
			completion_invoicedetail.ivd_tariff_type, 
			completion_invoicedetail.ivd_taxid, 
			completion_invoicedetail.ivd_ordered_volume, 
			completion_invoicedetail.ivd_ordered_loadingmeters, 
			completion_invoicedetail.ivd_ordered_count,
			completion_invoicedetail.ivd_ordered_weight, 
			completion_invoicedetail.ivd_loadingmeters, 
			completion_invoicedetail.ivd_loadingmeters_unit,
			completion_invoicedetail.last_updateby, 
			completion_invoicedetail.last_updatedate, 
			completion_invoicedetail.ivd_revtype1, 
			completion_invoicedetail.ivd_hide, 
			completion_invoicedetail.ivd_baserate,  
			completion_invoicedetail.ivd_oradjustment, 
			completion_invoicedetail.ivd_cbadjustment, 
			completion_invoicedetail.ivd_fsc, 
			completion_invoicedetail.ivd_splitbillratetype, 
			completion_invoicedetail.ivd_rawcharge, 
			completion_invoicedetail.ivd_bolid, 
			completion_invoicedetail.ivd_shared_wgt,
			completion_invoicedetail.ivd_completion_odometer,
			completion_invoicedetail.ivd_completion_billable_flag,
			completion_invoicedetail.ivd_completion_payable_flag,
			completion_invoicedetail.ivd_completion_drv_id,
			completion_invoicedetail.ivd_completion_drv_name,
			completion_invoicedetail.cht_description,
			chargetype.cht_edit_completion_rate
	FROM	completion_invoicedetail, chargetype
	WHERE	completion_invoicedetail.ord_hdrnumber = @p_ord_hdrnumber
	  AND	completion_invoicedetail.cht_itemcode = chargetype.cht_itemcode
	  AND	chargetype.cht_primary <> 'Y'

	UNION

	SELECT	invoicedetail.ivh_hdrnumber, 
			invoicedetail.ivd_number, 
			invoicedetail.stp_number, 
			invoicedetail.ivd_description, 
			invoicedetail.cht_itemcode, 
			invoicedetail.ivd_quantity, 
			invoicedetail.ivd_rate, 
			invoicedetail.ivd_charge, 
			invoicedetail.ivd_taxable1, 
			invoicedetail.ivd_taxable2, 
			invoicedetail.ivd_taxable3, 
			invoicedetail.ivd_taxable4, 
			invoicedetail.ivd_unit, 
			invoicedetail.cur_code, 
			invoicedetail.ivd_currencydate,
			invoicedetail.ivd_glnum, 
			invoicedetail.ord_hdrnumber, 
			invoicedetail.ivd_type, 
			invoicedetail.ivd_rateunit, 
			invoicedetail.ivd_billto, 
			invoicedetail.ivd_itemquantity, 
			invoicedetail.ivd_subtotalptr, 
			invoicedetail.ivd_allocatedrev, 
			invoicedetail.ivd_sequence, 
			invoicedetail.ivd_invoicestatus, 
			invoicedetail.mfh_hdrnumber, 
			invoicedetail.ivd_refnum, 
			invoicedetail.cmd_code, 
			invoicedetail.cmp_id, 
			invoicedetail.ivd_distance, 
			invoicedetail.ivd_distunit, 
			invoicedetail.ivd_wgt, 
			invoicedetail.ivd_wgtunit, 
			invoicedetail.ivd_count, 
			invoicedetail.ivd_countunit, 
			invoicedetail.evt_number, 
			invoicedetail.ivd_reftype, 
			invoicedetail.ivd_volume, 
			invoicedetail.ivd_volunit, 
			invoicedetail.ivd_orig_cmpid, 
			invoicedetail.ivd_payrevenue, 
			invoicedetail.ivd_sign, 
			invoicedetail.ivd_length, 
			invoicedetail.ivd_lengthunit, 
			invoicedetail.ivd_width, 
			invoicedetail.ivd_widthunit, 
			invoicedetail.ivd_height, 
			invoicedetail.ivd_heightunit, 
			invoicedetail.ivd_exportstatus, 
			invoicedetail.cht_basisunit, 
			invoicedetail.ivd_remark, 
			invoicedetail.tar_number, 
			invoicedetail.tar_tariffnumber, 
			invoicedetail.tar_tariffitem, 
			invoicedetail.ivd_fromord, 
			invoicedetail.ivd_zipcode, 
			invoicedetail.ivd_quantity_type, 
			invoicedetail.cht_class, 
			invoicedetail.ivd_mileagetable, 
			invoicedetail.ivd_charge_type, 
			invoicedetail.ivd_trl_rent, 
			invoicedetail.ivd_trl_rent_start, 
			invoicedetail.ivd_trl_rent_end, 
			invoicedetail.ivd_rate_type, 
			invoicedetail.cht_lh_min, 
			invoicedetail.cht_lh_rev, 
			invoicedetail.cht_lh_stl, 
			invoicedetail.cht_lh_rpt, 
			invoicedetail.cht_rollintolh, 
			invoicedetail.cht_lh_prn, 
			invoicedetail.fgt_number, 
			invoicedetail.ivd_paylgh_number, 
			invoicedetail.ivd_tariff_type, 
			invoicedetail.ivd_taxid, 
			invoicedetail.ivd_ordered_volume, 
			invoicedetail.ivd_ordered_loadingmeters, 
			invoicedetail.ivd_ordered_count,
			invoicedetail.ivd_ordered_weight, 
			invoicedetail.ivd_loadingmeters, 
			invoicedetail.ivd_loadingmeters_unit,
			invoicedetail.last_updateby, 
			invoicedetail.last_updatedate, 
			invoicedetail.ivd_revtype1, 
			invoicedetail.ivd_hide, 
			invoicedetail.ivd_baserate,  
			invoicedetail.ivd_oradjustment, 
			invoicedetail.ivd_cbadjustment, 
			invoicedetail.ivd_fsc, 
			invoicedetail.ivd_splitbillratetype, 
			invoicedetail.ivd_rawcharge, 
			invoicedetail.ivd_bolid, 
			invoicedetail.ivd_shared_wgt,
			0,
			invoicedetail.ivd_billable_flag,
			'',
			'',
			'',
			'',
			chargetype.cht_edit_completion_rate
	FROM	invoicedetail, chargetype
	WHERE	invoicedetail.ord_hdrnumber = @p_ord_hdrnumber
	  AND	invoicedetail.cht_itemcode = chargetype.cht_itemcode
	  AND	chargetype.cht_primary <> 'Y'
 END
ELSE
 BEGIN
	SELECT	completion_invoicedetail.ivh_hdrnumber, 
			completion_invoicedetail.ivd_number, 
			completion_invoicedetail.stp_number, 
			completion_invoicedetail.ivd_description, 
			completion_invoicedetail.cht_itemcode, 
			completion_invoicedetail.ivd_quantity, 
			completion_invoicedetail.ivd_rate, 
			completion_invoicedetail.ivd_charge, 
			completion_invoicedetail.ivd_taxable1, 
			completion_invoicedetail.ivd_taxable2, 
			completion_invoicedetail.ivd_taxable3, 
			completion_invoicedetail.ivd_taxable4, 
			completion_invoicedetail.ivd_unit, 
			completion_invoicedetail.cur_code, 
			completion_invoicedetail.ivd_currencydate,
			completion_invoicedetail.ivd_glnum, 
			completion_invoicedetail.ord_hdrnumber, 
			completion_invoicedetail.ivd_type, 
			completion_invoicedetail.ivd_rateunit, 
			completion_invoicedetail.ivd_billto, 
			completion_invoicedetail.ivd_itemquantity, 
			completion_invoicedetail.ivd_subtotalptr, 
			completion_invoicedetail.ivd_allocatedrev, 
			completion_invoicedetail.ivd_sequence, 
			completion_invoicedetail.ivd_invoicestatus, 
			completion_invoicedetail.mfh_hdrnumber, 
			completion_invoicedetail.ivd_refnum, 
			completion_invoicedetail.cmd_code, 
			completion_invoicedetail.cmp_id, 
			completion_invoicedetail.ivd_distance, 
			completion_invoicedetail.ivd_distunit, 
			completion_invoicedetail.ivd_wgt, 
			completion_invoicedetail.ivd_wgtunit, 
			completion_invoicedetail.ivd_count, 
			completion_invoicedetail.ivd_countunit, 
			completion_invoicedetail.evt_number, 
			completion_invoicedetail.ivd_reftype, 
			completion_invoicedetail.ivd_volume, 
			completion_invoicedetail.ivd_volunit, 
			completion_invoicedetail.ivd_orig_cmpid, 
			completion_invoicedetail.ivd_payrevenue, 
			completion_invoicedetail.ivd_sign, 
			completion_invoicedetail.ivd_length, 
			completion_invoicedetail.ivd_lengthunit, 
			completion_invoicedetail.ivd_width, 
			completion_invoicedetail.ivd_widthunit, 
			completion_invoicedetail.ivd_height, 
			completion_invoicedetail.ivd_heightunit, 
			completion_invoicedetail.ivd_exportstatus, 
			completion_invoicedetail.cht_basisunit, 
			completion_invoicedetail.ivd_remark, 
			completion_invoicedetail.tar_number, 
			completion_invoicedetail.tar_tariffnumber, 
			completion_invoicedetail.tar_tariffitem, 
			completion_invoicedetail.ivd_fromord, 
			completion_invoicedetail.ivd_zipcode, 
			completion_invoicedetail.ivd_quantity_type, 
			completion_invoicedetail.cht_class, 
			completion_invoicedetail.ivd_mileagetable, 
			completion_invoicedetail.ivd_charge_type, 
			completion_invoicedetail.ivd_trl_rent, 
			completion_invoicedetail.ivd_trl_rent_start, 
			completion_invoicedetail.ivd_trl_rent_end, 
			completion_invoicedetail.ivd_rate_type, 
			completion_invoicedetail.cht_lh_min, 
			completion_invoicedetail.cht_lh_rev, 
			completion_invoicedetail.cht_lh_stl, 
			completion_invoicedetail.cht_lh_rpt, 
			completion_invoicedetail.cht_rollintolh, 
			completion_invoicedetail.cht_lh_prn, 
			completion_invoicedetail.fgt_number, 
			completion_invoicedetail.ivd_paylgh_number, 
			completion_invoicedetail.ivd_tariff_type, 
			completion_invoicedetail.ivd_taxid, 
			completion_invoicedetail.ivd_ordered_volume, 
			completion_invoicedetail.ivd_ordered_loadingmeters, 
			completion_invoicedetail.ivd_ordered_count,
			completion_invoicedetail.ivd_ordered_weight, 
			completion_invoicedetail.ivd_loadingmeters, 
			completion_invoicedetail.ivd_loadingmeters_unit,
			completion_invoicedetail.last_updateby, 
			completion_invoicedetail.last_updatedate, 
			completion_invoicedetail.ivd_revtype1, 
			completion_invoicedetail.ivd_hide, 
			completion_invoicedetail.ivd_baserate,  
			completion_invoicedetail.ivd_oradjustment, 
			completion_invoicedetail.ivd_cbadjustment, 
			completion_invoicedetail.ivd_fsc, 
			completion_invoicedetail.ivd_splitbillratetype, 
			completion_invoicedetail.ivd_rawcharge, 
			completion_invoicedetail.ivd_bolid, 
			completion_invoicedetail.ivd_shared_wgt,
			completion_invoicedetail.ivd_completion_odometer,
			completion_invoicedetail.ivd_completion_billable_flag,
			completion_invoicedetail.ivd_completion_payable_flag,
			completion_invoicedetail.ivd_completion_drv_id,
			completion_invoicedetail.ivd_completion_drv_name,
			completion_invoicedetail.cht_description,
			chargetype.cht_edit_completion_rate
	FROM	completion_invoicedetail, chargetype
	WHERE	completion_invoicedetail.ord_hdrnumber = @p_ord_hdrnumber
	  AND	completion_invoicedetail.cht_itemcode = chargetype.cht_itemcode
	  AND	chargetype.cht_primary <> 'Y'
 END

GO
GRANT EXECUTE ON  [dbo].[completion_invoicedetail_sp] TO [public]
GO