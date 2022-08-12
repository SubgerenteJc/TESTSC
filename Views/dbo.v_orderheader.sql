SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/****** Object:  View dbo.v_orderheader    Script Date: 6/1/99 11:54:02 AM ******/
/****** Object:  View dbo.v_orderheader    Script Date: 12/10/97 1:56:59 PM ******/
/****** Object:  View dbo.v_orderheader    Script Date: 4/17/97 3:25:46 PM ******/
CREATE VIEW [dbo].[v_orderheader]  
    ( ord_company,   
      ord_number,   
      ord_customer,   
      ord_bookdate,   
      ord_bookedby,   
      ord_status,   
      ord_originpoint,   
      ord_destpoint,   
      ord_invoicestatus,   
      ord_origincity,   
      ord_destcity,   
      ord_originstate,   
      ord_deststate,   
      ord_originregion1,   
      ord_destregion1,   
      ord_supplier,   
      ord_billto,   
      ord_startdate,   
      ord_completiondate,   
      ord_revtype1,   
      ord_revtype2,   
      ord_revtype3,   
      ord_revtype4,   
      ord_totalweight,   
      ord_totalpieces,   
      ord_totalmiles,   
      ord_totalcharge,   
      ord_currency,   
      ord_currencydate,   
      ord_totalvolume,   
      ord_hdrnumber,   
      ord_refnum,   
      ord_invoicewhole,   
      ord_remark,   
      ord_shipper,   
      ord_consignee,   
      ord_pu_at,   
      ord_dr_at,   
      ord_originregion2,   
      ord_originregion3,   
      ord_originregion4,   
      ord_destregion2,   
      ord_destregion3,   
      ord_destregion4,   
      mfh_hdrnumber,   
      ord_priority,   
      mov_number,   
      tar_tarriffnumber,   
      tar_number,   
      tar_tariffitem,   
      ord_contact,   
      ord_showshipper,   
      ord_showcons,   
      ord_subcompany,   
      ord_lowtemp,   
      ord_hitemp,   
      ord_quantity,   
      ord_rate,   
      ord_charge,   
      ord_rateunit,   
      ord_unit,   
      trl_type1,   
      ord_driver1,   
      ord_driver2,   
      ord_tractor,   
      ord_trailer,   
      ord_length,   
      ord_width,   
      ord_height,   
      ord_lengthunit,   
      ord_widthunit,   
      ord_heightunit,   
      ord_reftype,   
      cmd_code,   
      ord_description,   
      ord_terms,   
      cht_itemcode,   
      ord_origin_earliestdate,   
      ord_origin_latestdate,   
      ord_odmetermiles,   
      ord_stopcount,   
      ord_dest_earliestdate,   
      ord_dest_latestdate,   
      ref_sid,   
      ref_pickup,   
      ord_cmdvalue,   
      ord_accessorial_chrg,   
      ord_availabledate,   
      ord_miscqty ) AS   
  SELECT orderheader.ord_company,   
         orderheader.ord_number,   
         orderheader.ord_customer,   
         orderheader.ord_bookdate,   
         orderheader.ord_bookedby,   
         orderheader.ord_status,   
         orderheader.ord_originpoint,   
         orderheader.ord_destpoint,   
         orderheader.ord_invoicestatus,   
         orderheader.ord_origincity,   
         orderheader.ord_destcity,   
         orderheader.ord_originstate,   
         orderheader.ord_deststate,   
         orderheader.ord_originregion1,   
         orderheader.ord_destregion1,   
         orderheader.ord_supplier,   
         orderheader.ord_billto,   
         orderheader.ord_startdate,   
         orderheader.ord_completiondate,   
         orderheader.ord_revtype1,   
         orderheader.ord_revtype2,   
         orderheader.ord_revtype3,   
         orderheader.ord_revtype4,   
         orderheader.ord_totalweight,   
         orderheader.ord_totalpieces,   
         orderheader.ord_totalmiles,   
         orderheader.ord_totalcharge,   
         orderheader.ord_currency,   
         orderheader.ord_currencydate,   
         orderheader.ord_totalvolume,   
         orderheader.ord_hdrnumber,   
         orderheader.ord_refnum,   
         orderheader.ord_invoicewhole,   
         orderheader.ord_remark,   
         orderheader.ord_shipper,   
         orderheader.ord_consignee,   
         orderheader.ord_pu_at,   
         orderheader.ord_dr_at,   
         orderheader.ord_originregion2,   
         orderheader.ord_originregion3,   
         orderheader.ord_originregion4,   
         orderheader.ord_destregion2,   
         orderheader.ord_destregion3,   
         orderheader.ord_destregion4,   
         orderheader.mfh_hdrnumber,   
         orderheader.ord_priority,   
         orderheader.mov_number,   
         orderheader.tar_tarriffnumber,   
         orderheader.tar_number,   
         orderheader.tar_tariffitem,   
         orderheader.ord_contact,   
         orderheader.ord_showshipper,   
         orderheader.ord_showcons,   
         orderheader.ord_subcompany,   
         orderheader.ord_lowtemp,   
         orderheader.ord_hitemp,   
         orderheader.ord_quantity,   
         orderheader.ord_rate,   
         orderheader.ord_charge,   
         orderheader.ord_rateunit,   
         orderheader.ord_unit,   
         orderheader.trl_type1,   
         orderheader.ord_driver1,   
         orderheader.ord_driver2,   
         orderheader.ord_tractor,   
         orderheader.ord_trailer,   
         orderheader.ord_length,   
         orderheader.ord_width,   
         orderheader.ord_height,   
         orderheader.ord_lengthunit,   
         orderheader.ord_widthunit,   
         orderheader.ord_heightunit,   
         orderheader.ord_reftype,   
         orderheader.cmd_code,   
         orderheader.ord_description,   
         orderheader.ord_terms,   
         orderheader.cht_itemcode,   
         orderheader.ord_origin_earliestdate,   
         orderheader.ord_origin_latestdate,   
         orderheader.ord_odmetermiles,   
         orderheader.ord_stopcount,   
         orderheader.ord_dest_earliestdate,   
         orderheader.ord_dest_latestdate,   
         orderheader.ref_sid,   
         orderheader.ref_pickup,   
         orderheader.ord_cmdvalue,   
         orderheader.ord_accessorial_chrg,   
         orderheader.ord_availabledate,   
         orderheader.ord_miscqty  
    FROM orderheader   



GO
GRANT DELETE ON  [dbo].[v_orderheader] TO [public]
GO
GRANT INSERT ON  [dbo].[v_orderheader] TO [public]
GO
GRANT REFERENCES ON  [dbo].[v_orderheader] TO [public]
GO
GRANT SELECT ON  [dbo].[v_orderheader] TO [public]
GO
GRANT UPDATE ON  [dbo].[v_orderheader] TO [public]
GO
