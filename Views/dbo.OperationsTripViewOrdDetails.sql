SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
         
CREATE view [dbo].[OperationsTripViewOrdDetails]  
as       
select rtrim(oh.ord_number) as OrderNumber,   
	 oh.ord_status as DispStatus,
	 oh.ord_hdrnumber As OrderHeaderNumber,     
	 oh.ord_startdate as StartDate, 
	 ISNULL(oh.ord_originpoint, '') as OriginId, 
	 ISNULL(fc.cmp_name, '') as OriginName, 
	 fcy.cty_nmstct as OriginCity, 
	 fcy.cty_state as OriginState, 
	 fcy.cty_zip as OriginZip,       
	 oh.ord_completiondate as EndDate, 
	 ISNULL(lc.cmp_id, '') as FinalId, 
	 ISNULL(lc.cmp_name, '') as FinalName, 
	 lcy.cty_nmstct as FinalCity, 
	 lcy.cty_state as FinalState, 
	 lcy.cty_zip As FinalZip,     
	 (select sum(stp_lgh_mileage) from stops (nolock) where stops.mov_number = oh.mov_number) as Mileage, 
	 oh.ord_totalweight as Weight, 
	 oh.ord_totalcharge as Revenue,       
	 (select count(*) from stops where stops.ord_hdrnumber = oh.ord_hdrnumber) StopCount, 
	 oh.ord_driver1 as Driver1, 
	 (select MAX(mpp_lastname + ', ' + mpp_firstname) from manpowerprofile where mpp_id = oh.ord_driver1) Driver1Name, 
	 oh.ord_tractor as Tractor, 
	 oh.ord_trailer as Trailer1,       
	 oh.ord_carrier as Carrier, 
	 oh.ord_driver2 as Driver2, 
	 (select MAX(mpp_lastname + ', ' + mpp_firstname) from manpowerprofile where mpp_id = oh.ord_driver2) Driver2Name, 
	 oh.ord_trailer2 as Trailer2, 
	 oh.trl_type1 TrailerType,       
	 (select top 1 f.cmd_code from freightdetail f join stops s on f.stp_number = s.stp_number where s.ord_hdrnumber = oh.ord_hdrnumber) CmdCode, 
	 (select top 1 f.fgt_description from freightdetail f join stops s on f.stp_number = s.stp_number where s.ord_hdrnumber = oh.ord_hdrnumber) CmdDescription, 
	 (select top 1 f.fgt_count from freightdetail f join stops s on f.stp_number = s.stp_number where s.ord_hdrnumber = oh.ord_hdrnumber) CmdCount, 
	 oh.ord_revtype1 as RevType1, 
	 (select top 1 userlabelname from labelfile where labeldefinition = 'RevType1') as RevType1Name, 
	 oh.ord_revtype2 as RevType2, 
	 (select top 1 userlabelname from labelfile where labeldefinition = 'RevType2') as RevType2Name, 
	 oh.ord_revtype3 as RevType3, 
	 (select top 1 userlabelname from labelfile where labeldefinition = 'RevType3') as RevType3Name, 
	 oh.ord_revtype4 as RevType4, 
	 (select top 1 userlabelname from labelfile where labeldefinition = 'RevType4') as RevType4Name,  
	 ord_booked_revtype1 as BookingTerminal, 
	 'UNKNOWN' as ExecutingTerminal, 
	 'UNKNOWN' RouteId,       
	 0 as lgh_number,
	 'UNKNOWN' as TotalMailStatus, 
	 'UNKNOWN' as TotalMailStatusName, 
	 'UNP' as InStatus,       
	 oh.ord_bookedby as BookedBy, 
	 oh.ord_billto as BillTo, 
	 oh.ord_customer as OrderBy, 
	 oh.ord_refnum as RefNum,       
	 pc.cmp_id as PickupId, 
	 pc.cmp_name as PickupName, 
	 pc.cty_nmstct as PickupCity, 
	 pc.cmp_state as PickupState, 
	 pc.cmp_zip as PickupZip, 
	 pc.cmp_region1 as PickupRegion1,   
	 pc.cmp_region2 as PickupRegion2, 
	 pc.cmp_region3 as PickupRegion3,
	 pc.cmp_region4 as PickupRegion4,     
	 cc.cmp_id as ConsigneeId, 
	 cc.cmp_name as ConsigneeName, 
	 cc.cty_nmstct as ConsigneeCity, 
	 cc.cmp_zip as ConsigneeZip, 
	 cc.cmp_state as ConsigneeState, 
	 cc.cmp_region1 as ConsigneeRegion1,   
	 cc.cmp_region2 as ConsigneeRegion2, 
	 cc.cmp_region3 as ConsigneeRegion3, 
	 cc.cmp_region4 as ConsigneeRegion4,       
	 'UNK'as LghType1, 
	 (select top 1 [name] from labelfile (nolock) where labeldefinition = 'LghType1' and abbr = 'UNK') as LghType1Name, 
	 'UNK' as LghType2, 
	 (select top 1 [name] from labelfile (nolock) where labeldefinition = 'LghType2' and abbr = 'UNK') as LghType2Name,  
	 'UNKNOWN' as TeamLeader, 
	 'UNKNOWN' As TeamLeaderName,       
	 oh.ord_status as OrderStatus, 
	 (select top 1 [name] from labelfile (nolock) where labeldefinition = 'DispStatus' and abbr = oh.ord_status) as OrderStatusName, 
	 oh.mov_number as mov_number, 
	 '' as EtaStatus, 
	 '' as EtaComment, 
	 oh.ord_priority as 'Priority'  
 from orderheader oh left outer join company pc on oh.ord_shipper = pc.cmp_id   
    left outer join company cc on oh.ord_consignee = cc.cmp_id 
                           join company fc on (oh.ord_originpoint = fc.cmp_id)      
                           join city fcy on (oh.ord_origincity= fcy.cty_code)      
                           join company lc on (oh.ord_destpoint = lc.cmp_id)      
                           join city lcy on (oh.ord_destcity = lcy.cty_code)  
WHERE oh.ord_status <> 'CMP'
GO
