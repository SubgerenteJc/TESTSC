SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[CarrierHubAssignedLoadsView]
as
select 'TMWWF_CarrierHub_ASSIGNED' AS 'TMWWF_CarrierHub_ASSIGNED',
	leg.lgh_number,  
	leg.ord_hdrnumber,
	(select abbr from labelfile where leg.lgh_204status = name and labeldefinition = 'Lgh204Status') as 'Edi204Status',
	leg.lgh_204date 'Edi204Date', 
	rtrim((select ord_number from orderheader where ord_hdrnumber = leg.ord_hdrnumber))+ case when isnull(lgh_split_flag,'N') = 'N' then '' else '-' + lgh_split_flag end ord_number, 
	lgh_startdate 'Start Date', 
	lgh_enddate 'End Date', 
	leg.lgh_outstatus 'DispStatus',
	lgh_miles 'Mileage',
	startcompany.cmp_id 'PickupId',
	startcompany.cmp_name  'PickupName',
	startcity.cty_name 'PickupCity',
	lgh_startstate 'PickupState',
	LegStartStop.stp_arrivaldate 'PickupArrival',
	LegStartStop.stp_departuredate 'PickupDeparture', 
	endcompany.cmp_id 'ConsigneeId',
	endcompany.cmp_name 'ConsigneeName',
	endcity.cty_name 'ConsigneeCity',
	endcompany.cmp_state 'ConsigneeState',
	LegFinalStop.stp_arrivaldate 'DropArrival',
	LegFinalStop.stp_departuredate 'DropDeparture', 
	(select count(distinct ord_hdrnumber) from stops where stops.lgh_number = leg.lgh_number and ord_hdrnumber <> 0 ) 'OrdCnt',
	(select count(*) from stops where stops.lgh_number = leg.lgh_number and stp_type = 'PUP') 'PupCnt',
    (select count(*) from stops where stops.lgh_number = leg.lgh_number and stp_type = 'DRP') 'DrpCnt',
	ord.ord_totalvolume 'TotalVol',
	ord.ord_totalweight 'TotalWeight',
	lgh_primary_trailer 'Trailer',
	lgh_carrier 'Carrier', --This is required by the business objects.
	
	dbo.tmw_legstopslate_fn(leg.lgh_number) 'Late Stops'
	from legheader_active as leg join city as startcity on lgh_startcty_nmstct = startcity.cty_nmstct
					  join orderheader ord on leg.ord_hdrnumber = ord.ord_hdrnumber
					  join company as startcompany on cmp_id_start = startcompany.cmp_id
					  join company as endcompany on endcompany.cmp_id  = leg.cmp_id_end
					  join city as endcity on endcity.cty_code = leg.lgh_endcity
					  join stops as LegStartStop on LegStartStop.stp_number = leg.stp_number_start
					  join stops as LegFinalStop on LegFinalStop.stp_number = leg.stp_number_end
					  join trailerprofile on trailerprofile.trl_id = leg.lgh_primary_trailer
GO
GRANT DELETE ON  [dbo].[CarrierHubAssignedLoadsView] TO [public]
GO
GRANT INSERT ON  [dbo].[CarrierHubAssignedLoadsView] TO [public]
GO
GRANT SELECT ON  [dbo].[CarrierHubAssignedLoadsView] TO [public]
GO
GRANT UPDATE ON  [dbo].[CarrierHubAssignedLoadsView] TO [public]
GO
