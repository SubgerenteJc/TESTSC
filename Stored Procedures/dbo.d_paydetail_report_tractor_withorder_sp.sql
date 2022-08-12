SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO

CREATE   PROC	[dbo].[d_paydetail_report_tractor_withorder_sp] (
				@tractor_id varchar(8), @tractor_type1 varchar(6), @tractor_type2 varchar(6), @tractor_type3 varchar(6), @tractor_type4 varchar(6), 
				@payment_status_array varchar(100), 
				@company varchar(6), @fleet varchar(6), @division varchar(6), @domicile varchar(6),
				@beg_work_date datetime, @end_work_date datetime, 
				@beg_pay_date datetime, @end_pay_date datetime, 
				@payment_type_array varchar(8000),
				@tractor_accounting_type varchar(6), @beg_transfer_date datetime, @end_transfer_date datetime,
				@beg_invoice_bill_date datetime, @end_invoice_bill_date datetime,
				@sch_date1 datetime, @sch_date2 datetime,
				@revtype1 varchar(6), @revtype2 varchar(6), @revtype3 varchar(6), @revtype4 varchar(6),
			@excl_revtype1 char(1), @excl_revtype2 char(1), @excl_revtype3 char(1), @excl_revtype4 char(1), 
			@resourcetypeonleg char(1))       
AS  

/**
 * DESCRIPTION:
 * Created to get tractor with order paydetail for settlement detail report
 *
 * PARAMETERS:
 *
 * RETURNS:
 *	
 * RESULT SETS: 
 *
 * REFERENCES:
 *
 * REVISION HISTORY:
 * 11/1/2007.01 ? PTS40115 - JGUO ? convert convert old style outer join syntax to ansi outer join syntax.
 * -- PTS 35274 11/2008 JSwindell RECODE:  Add Revtype1 -> 4 and excl_revtype1 -> 4
 * PTS 48237 - DJM - 6/15/2010 - Added 'resourcetypeonleg' parameter to allow the proc to look at the asset type
 *							on the leg instead of just the Asset Master (Driver and Tractor only)
**/

-- Set up incoming 'string' fields as arrays
--IF @payment_status_array IS NULL OR @payment_status_array = ''
--   SELECT @payment_status_array = 'UNK'
SELECT @payment_status_array = ',' + LTRIM(RTRIM(ISNULL(@payment_status_array, '')))  + ','

--IF @payment_type_array IS NULL OR @payment_type_array = ''
--   SELECT @payment_type_array = 'UNK'
SELECT @payment_type_array = ',' + LTRIM(RTRIM(ISNULL(@payment_type_array, '')))  + ','

-- Create temporary table    
CREATE TABLE #tractor_withorder_paydetail_temp  (
asgn_type varchar(6) Null, 
asgn_id varchar(8) Null, 
pyd_payto varchar(12) Null, 
pyt_itemcode varchar(6) Null, 
mov_number int Null, 
pyd_description varchar(75) Null, 
pyd_quantity float Null, 
pyd_rate money Null, 
pyd_amount money Null, 
pyd_glnum varchar(32) Null, 
pyd_pretax char(1) Null, 
pyd_status varchar(6) Null, 
pyd_refnumtype varchar(6) Null, 
pyd_refnum varchar(30) Null, 
pyh_payperiod datetime Null, 
pyd_workperiod datetime Null, 
lgh_startcity int Null, 
lgh_endcity int Null, 
start_city varchar(30) Null, 
end_city varchar(30) Null,
load_state varchar(6) Null,
legheader_enddate datetime Null,
tractor_name varchar(64) Null,
ord_number varchar(12) Null,
ivh_billdate datetime Null,
ivh_invoicenumber varchar(12) Null,
-- PTS 25416 -- BL (start)
pyh_number int null,
-- PTS 25416 -- BL (end)
-- PTS 31363 -- BL (start)
--ord_hdrnumber int null)
-- PTS 31363 -- BL (end)
-- PTS 35274 11/2008 JSwindell RECODE<<start>>
ord_hdrnumber int null,
ord_revtype1 varchar(6) NULL,
ord_revtype2 varchar(6) NULL,
ord_revtype3 varchar(6) NULL,
ord_revtype4 varchar(6) NULL,
-- PTS 35274 11/2008 JSwindell RECODE<<end>>
lgh_number	int	null)	-- PTS 48237 - DJM

-- Get paydetail info
INSERT INTO #tractor_withorder_paydetail_temp
SELECT  paydetail.asgn_type ,
           paydetail.asgn_id ,
           paydetail.pyd_payto ,
           paydetail.pyt_itemcode ,
           paydetail.mov_number ,
           paydetail.pyd_description ,
           paydetail.pyd_quantity ,
           paydetail.pyd_rate ,
           paydetail.pyd_amount ,
           paydetail.pyd_glnum ,
           paydetail.pyd_pretax ,
           paydetail.pyd_status ,
           paydetail.pyd_refnumtype ,
           paydetail.pyd_refnum ,
           paydetail.pyh_payperiod ,
           paydetail.pyd_workperiod ,
           paydetail.lgh_startcity ,
           paydetail.lgh_endcity ,
           sc.cty_nmstct ,
           ec.cty_nmstct ,
           paydetail.pyd_loadstate ,
           legheader.lgh_enddate ,
           tractorprofile.trc_owner +' ' + tractorprofile.trc_make name,
           ISNULL(orderheader.ord_number,  '') ord_number,
	-- PTS 19822 -- BL (start) 
--	ivh_billdate,
--	ivh_invoicenumber    
-- PTS 31363 -- BL (start)
-- 	(select max(ivh_billdate) from invoiceheader where ord_hdrnumber <> 0 and ord_hdrnumber = paydetail.ord_hdrnumber) ivh_billdate,
-- 	(select max(ivh_invoicenumber) from invoiceheader where ivh_billdate = 
-- 		(select max(ivh_billdate) from invoiceheader where ord_hdrnumber <> 0 and ord_hdrnumber = paydetail.ord_hdrnumber)) ivh_invoicenumber,
null ivh_billdate,
null ivh_invoicenumber, 
-- PTS 31363 -- BL (end)
	-- PTS 19822 -- BL (end) 
-- PTS 25416 -- BL (start)
paydetail.pyh_number,
-- PTS 25416 -- BL (end)
-- PTS 31363 -- BL (start)
paydetail.ord_hdrnumber,
-- PTS 31363 -- BL (end)
-- PTS 35274 11/2008 JSwindell RECODE<<start>>
	 orderheader.ord_revtype1,
	 orderheader.ord_revtype2,
	 orderheader.ord_revtype3,
	 orderheader.ord_revtype4,
-- PTS 35274 11/2008 JSwindell RECODE<<end>>
paydetail.lgh_number		-- PTS 48237

FROM  city sc  RIGHT OUTER JOIN  paydetail  ON  sc.cty_code  = paydetail.lgh_startcity   
				LEFT OUTER JOIN  city ec  ON  ec.cty_code  = paydetail.lgh_endcity   
				LEFT OUTER JOIN  orderheader  ON  paydetail.ord_hdrnumber  = orderheader.ord_hdrnumber   
				LEFT OUTER JOIN  legheader  ON  paydetail.lgh_number  = legheader.lgh_number ,
	 tractorprofile     
	-- PTS 19822 -- BL (start) 
	-- (COMMENT OUT CODE)
--  	(select *
--  	from invoiceheader d
--  	where (convert(varchar(28), ivh_billdate, 20) + ivh_invoicenumber) = 
--  	(select max(convert(varchar(28), ivh_billdate, 20) + ivh_invoicenumber)
--  	from invoiceheader e
--  	where e.ord_hdrnumber = d.ord_hdrnumber
--  	and e.ord_hdrnumber <> 0)) invoiceheader
--WHERE paydetail.ord_hdrnumber *= invoiceheader.ord_hdrnumber and
-- PTS 19822 -- BL (end) 
WHERE ( paydetail.asgn_id = tractorprofile.trc_number ) and          
(paydetail.asgn_type = 'TRC' and          
-- PTS 32226 -- BL (start)   (31363)
--( @tractor_id in ('UNKNOWN',  paydetail.asgn_id)) ) and          
( (@tractor_id = 'UNKNOWN' or @tractor_id =  paydetail.asgn_id)) ) and          
-- PTS 32226 -- BL (end)   (31363)
(@payment_type_array = ',,' OR CHARINDEX(',' + paydetail.pyt_itemcode + ',', @payment_type_array) > 0) AND
(paydetail.pyd_transdate between @beg_transfer_date and @end_transfer_date or ( paydetail.pyd_transdate is null) ) and          
(@payment_status_array = ',,' OR CHARINDEX(',' + paydetail.pyd_status + ',', @payment_status_array) > 0) AND
( paydetail.pyh_payperiod between @beg_pay_date and @end_pay_date ) and          
(paydetail.pyd_workperiod between @beg_work_date and @end_work_date or ( paydetail.pyd_workperiod is null) ) and          
( paydetail.asgn_id = tractorprofile.trc_number ) and          
-- PTS 32226 -- BL (start)   (31363)
--( @tractor_type1 in ('UNK',  tractorprofile.trc_type1) ) and          
--( @tractor_type2 in ('UNK',  tractorprofile.trc_type2) ) and          
--( @tractor_type3 in ('UNK',  tractorprofile.trc_type3) ) and          
--( @tractor_type4 in ('UNK',  tractorprofile.trc_type4) ) and          
--( @company in ('UNK',  tractorprofile.trc_company) ) and          
--( @fleet in ('UNK',  tractorprofile.trc_fleet) ) and          
--( @division in ('UNK',  tractorprofile.trc_division) ) and          
--( @domicile in ('UNK',  tractorprofile.trc_terminal) ) and          
--( @tractor_accounting_type in ('X',  tractorprofile.trc_actg_type) )   
--( (@tractor_type1 = 'UNK' or @tractor_type1 =  tractorprofile.trc_type1) ) and          
--( (@tractor_type2 = 'UNK' or @tractor_type2 =  tractorprofile.trc_type2) ) and          
--( (@tractor_type3 = 'UNK' or @tractor_type3 =  tractorprofile.trc_type3) ) and          
--( (@tractor_type4 = 'UNK' or @tractor_type4 =  tractorprofile.trc_type4) ) and          
( (@company = 'UNK' or @company =  tractorprofile.trc_company) ) and          
( (@fleet = 'UNK' or @fleet =  tractorprofile.trc_fleet) ) and          
( (@division = 'UNK' or @division =  tractorprofile.trc_division) ) and          
( (@domicile = 'UNK' or @domicile =  tractorprofile.trc_terminal) ) and          
( (@tractor_accounting_type = 'X' or @tractor_accounting_type =  tractorprofile.trc_actg_type) )   
-- PTS 32226 -- BL (end)   (31363)

-- PTS 25416 -- BL (start)
if CHARINDEX('XFR', @payment_status_array) > 0 or CHARINDEX('COL', @payment_status_array) > 0 
-- Get paydetail info
INSERT INTO #tractor_withorder_paydetail_temp
SELECT  paydetail.asgn_type ,
           paydetail.asgn_id ,
           paydetail.pyd_payto ,
           paydetail.pyt_itemcode ,
           paydetail.mov_number ,
           paydetail.pyd_description ,
           paydetail.pyd_quantity ,
           paydetail.pyd_rate ,
           paydetail.pyd_amount ,
           paydetail.pyd_glnum ,
           paydetail.pyd_pretax ,
           paydetail.pyd_status ,
           paydetail.pyd_refnumtype ,
           paydetail.pyd_refnum ,
           paydetail.pyh_payperiod ,
           paydetail.pyd_workperiod ,
           paydetail.lgh_startcity ,
           paydetail.lgh_endcity ,
           sc.cty_nmstct ,
           ec.cty_nmstct ,
           paydetail.pyd_loadstate ,
           legheader.lgh_enddate ,
           tractorprofile.trc_owner +' ' + tractorprofile.trc_make name,
           ISNULL(orderheader.ord_number,  '') ord_number,
	-- PTS 19822 -- BL (start) 
--	ivh_billdate,
--	ivh_invoicenumber    
-- PTS 31363 -- BL (start)
-- 	(select max(ivh_billdate) from invoiceheader where ord_hdrnumber <> 0 and ord_hdrnumber = paydetail.ord_hdrnumber) ivh_billdate,
-- 	(select max(ivh_invoicenumber) from invoiceheader where ivh_billdate = 
-- 		(select max(ivh_billdate) from invoiceheader where ord_hdrnumber <> 0 and ord_hdrnumber = paydetail.ord_hdrnumber)) ivh_invoicenumber,
null ivh_billdate,
null ivh_invoicenumber, 
-- PTS 31363 -- BL (end)
	-- PTS 19822 -- BL (end) 
paydetail.pyh_number,
-- PTS 31363 -- BL (start)
paydetail.ord_hdrnumber,
-- PTS 31363 -- BL (end)
-- PTS 35274 11/2008 JSwindell RECODE<<start>>
	 orderheader.ord_revtype1,
	 orderheader.ord_revtype2,
	 orderheader.ord_revtype3,
	 orderheader.ord_revtype4,
-- PTS 35274 11/2008 JSwindell RECODE<<end>>
paydetail.lgh_number		-- PTS 48237

FROM city sc  RIGHT OUTER JOIN  paydetail  ON  sc.cty_code  = paydetail.lgh_startcity   
			LEFT OUTER JOIN  city ec  ON  ec.cty_code  = paydetail.lgh_endcity   
			LEFT OUTER JOIN  orderheader  ON  paydetail.ord_hdrnumber  = orderheader.ord_hdrnumber   
			LEFT OUTER JOIN  legheader  ON  paydetail.lgh_number  = legheader.lgh_number ,
	 tractorprofile,
	 payheader ph     
	-- PTS 19822 -- BL (start) 
	-- (COMMENT OUT CODE)
--  	(select *
--  	from invoiceheader d
--  	where (convert(varchar(28), ivh_billdate, 20) + ivh_invoicenumber) = 
--  	(select max(convert(varchar(28), ivh_billdate, 20) + ivh_invoicenumber)
--  	from invoiceheader e
--  	where e.ord_hdrnumber = d.ord_hdrnumber
--  	and e.ord_hdrnumber <> 0)) invoiceheader
--WHERE paydetail.ord_hdrnumber *= invoiceheader.ord_hdrnumber and
-- PTS 19822 -- BL (end) 
WHERE ( paydetail.asgn_id = tractorprofile.trc_number ) and          
	(paydetail.asgn_type = 'TRC' and          
	-- PTS 32226 -- BL (start)   (31363)
	--( @tractor_id in ('UNKNOWN',  paydetail.asgn_id)) ) and          
	( (@tractor_id = 'UNKNOWN' or @tractor_id =  paydetail.asgn_id)) ) and          
	-- PTS 32226 -- BL (end)   (31363)
	(@payment_type_array = ',,' OR CHARINDEX(',' + paydetail.pyt_itemcode + ',', @payment_type_array) > 0) AND
	(paydetail.pyd_transdate between @beg_transfer_date and @end_transfer_date or ( paydetail.pyd_transdate is null) ) and          
	--(@payment_status_array = ',,' OR CHARINDEX(',' + paydetail.pyd_status + ',', @payment_status_array) > 0) AND
	( paydetail.pyh_payperiod between @beg_pay_date and @end_pay_date ) and          
	(paydetail.pyd_workperiod between @beg_work_date and @end_work_date or ( paydetail.pyd_workperiod is null) ) and          
	( paydetail.asgn_id = tractorprofile.trc_number ) and          
	-- PTS 32226 -- BL (start)   (31363)
	--( @tractor_type1 in ('UNK',  tractorprofile.trc_type1) ) and          
	--( @tractor_type2 in ('UNK',  tractorprofile.trc_type2) ) and          
	--( @tractor_type3 in ('UNK',  tractorprofile.trc_type3) ) and          
	--( @tractor_type4 in ('UNK',  tractorprofile.trc_type4) ) and          
	--( @company in ('UNK',  tractorprofile.trc_company) ) and          
	--( @fleet in ('UNK',  tractorprofile.trc_fleet) ) and          
	--( @division in ('UNK',  tractorprofile.trc_division) ) and          
	--( @domicile in ('UNK',  tractorprofile.trc_terminal) ) and          
	--( @tractor_accounting_type in ('X',  tractorprofile.trc_actg_type) )   
	--( (@tractor_type1 = 'UNK' or @tractor_type1 =  tractorprofile.trc_type1) ) and          
	--( (@tractor_type2 = 'UNK' or @tractor_type2 =  tractorprofile.trc_type2) ) and          
	--( (@tractor_type3 = 'UNK' or @tractor_type3 =  tractorprofile.trc_type3) ) and          
	--( (@tractor_type4 = 'UNK' or @tractor_type4 =  tractorprofile.trc_type4) ) and          
	( (@company = 'UNK' or @company =  tractorprofile.trc_company) ) and          
	( (@fleet = 'UNK' or @fleet =  tractorprofile.trc_fleet) ) and          
	( (@division = 'UNK' or @division =  tractorprofile.trc_division) ) and          
	( (@domicile = 'UNK' or @domicile =  tractorprofile.trc_terminal) ) and          
	( (@tractor_accounting_type = 'X' or @tractor_accounting_type =  tractorprofile.trc_actg_type) )   
	-- PTS 32226 -- BL (end)   (31363)
		and paydetail.pyh_number = ph.pyh_pyhnumber 
		and (CHARINDEX(',' + ph.pyh_paystatus + ',', ',XFR,COL,') > 0)
		and paydetail.pyh_number not in 
			(select distinct pyh_number
			from #tractor_withorder_paydetail_temp)
	-- PTS 25416 -- BL (end)

-- PTS 31363 -- BL (start)
-- Update billdate and invoicenumber rather than set it during the insert
update 	#tractor_withorder_paydetail_temp
set 	ivh_billdate = (SELECT 	max(ivh_billdate)
						from 	invoiceheader
						where	#tractor_withorder_paydetail_temp.ord_hdrnumber = invoiceheader.ord_hdrnumber)
where	#tractor_withorder_paydetail_temp.ord_hdrnumber > 0

update 	#tractor_withorder_paydetail_temp
set		ivh_invoicenumber = (select max(ivh_invoicenumber) 
							from 	invoiceheader 
							where 	ivh_billdate = #tractor_withorder_paydetail_temp.ivh_billdate)
where 	#tractor_withorder_paydetail_temp.ord_hdrnumber > 0
-- PTS 31363 -- BL (end)

-- See if user entered in an Invoice bill_date range
if @beg_invoice_bill_date > convert(datetime, '1950-01-01 00:00') OR 
      @end_invoice_bill_date < convert(datetime, '2049-12-31 23:59') 
Begin
	-- Remove paydetails that do NOT fit in given invoice bill_date range
	Delete from #tractor_withorder_paydetail_temp  
	where ivh_billdate is NULL 
	or ivh_billdate > @end_invoice_bill_date 
	or ivh_billdate < @beg_invoice_bill_date 
end	

--LOR	PTS# 32588
if @sch_date1 > convert(datetime, '1950-01-01 00:00') OR 
      @sch_date2 < convert(datetime, '2049-12-31 23:59') 
	Delete from #tractor_withorder_paydetail_temp
	where #tractor_withorder_paydetail_temp.ord_hdrnumber > 0 and 
		#tractor_withorder_paydetail_temp.ord_hdrnumber in (select ord_hdrnumber 
						from stops
						where stp_sequence = 1 and
							(stp_schdtearliest > @sch_date2  or 
							stp_schdtearliest < @sch_date1))	
-- LOR

-- PTS 35274 11/2008 JSwindell RECODE<<start>>
	--	LOR	PTS# 35274
	IF isNull(@revtype1,'UNK') <> 'UNK'
		Begin
			If @excl_revtype1 = 'Y'
				DELETE FROM #tractor_withorder_paydetail_temp WHERE isNull(#tractor_withorder_paydetail_temp.ord_revtype1,'UNK') = @revtype1
			Else
				DELETE FROM #tractor_withorder_paydetail_temp WHERE isNull(#tractor_withorder_paydetail_temp.ord_revtype1,'UNK') <> @revtype1
		End
	IF isNull(@revtype2,'UNK') <> 'UNK'
		Begin
			If @excl_revtype2 = 'Y'
				DELETE FROM #tractor_withorder_paydetail_temp WHERE isNull(#tractor_withorder_paydetail_temp.ord_revtype2,'UNK') = @revtype2
			Else
				DELETE FROM #tractor_withorder_paydetail_temp WHERE isNull(#tractor_withorder_paydetail_temp.ord_revtype2,'UNK') <> @revtype2
		End
	IF isNull(@revtype3,'UNK') <> 'UNK'
		Begin
			If @excl_revtype3 = 'Y'
				DELETE FROM #tractor_withorder_paydetail_temp WHERE isNull(#tractor_withorder_paydetail_temp.ord_revtype3,'UNK') = @revtype3
			Else
				DELETE FROM #tractor_withorder_paydetail_temp WHERE isNull(#tractor_withorder_paydetail_temp.ord_revtype3,'UNK') <> @revtype3
		End
	IF isNull(@revtype4,'UNK') <> 'UNK'
		Begin
			If @excl_revtype4 = 'Y'
				DELETE FROM #tractor_withorder_paydetail_temp WHERE isNull(#tractor_withorder_paydetail_temp.ord_revtype4,'UNK') = @revtype4
			Else
				DELETE FROM #tractor_withorder_paydetail_temp WHERE isNull(#tractor_withorder_paydetail_temp.ord_revtype4,'UNK') <> @revtype4
		End
	--	LOR
-- PTS 35274 11/2008 JSwindell RECODE<<end>>

-- PTS 48237 - DJM - Remove rows that don't match the correct Tractor Types.
if @resourcetypeonleg = 'Y'
	Begin
		IF @tractor_type1 <> 'UNK'
			delete #tractor_withorder_paydetail_temp from legheader l where asgn_type = 'DRV' and l.lgh_number = #tractor_withorder_paydetail_temp.lgh_number and isNull(#tractor_withorder_paydetail_temp.lgh_number,0) > 0 and l.trc_type1 <> @tractor_type1

		IF @tractor_type2 <> 'UNK'
			delete #tractor_withorder_paydetail_temp from legheader l where asgn_type = 'DRV' and l.lgh_number = #tractor_withorder_paydetail_temp.lgh_number and isNull(#tractor_withorder_paydetail_temp.lgh_number,0) > 0 and l.trc_type2 <> @tractor_type2

		IF @tractor_type3 <> 'UNK'
			delete #tractor_withorder_paydetail_temp from legheader l where asgn_type = 'DRV' and l.lgh_number = #tractor_withorder_paydetail_temp.lgh_number and isNull(#tractor_withorder_paydetail_temp.lgh_number,0) > 0 and l.trc_type3 <> @tractor_type3
		
		IF @tractor_type4 <> 'UNK'
			delete #tractor_withorder_paydetail_temp from legheader l where asgn_type = 'DRV' and l.lgh_number = #tractor_withorder_paydetail_temp.lgh_number and isNull(#tractor_withorder_paydetail_temp.lgh_number,0) > 0 and l.trc_type4 <> @tractor_type4
	end
else
	Begin
		IF @tractor_type1 <> 'UNK'
			delete #tractor_withorder_paydetail_temp from tractorprofile tp where asgn_type = 'TRC' and asgn_id = tp.trc_number and trc_type1 <> @tractor_type1

		IF @tractor_type2 <> 'UNK'
			delete #tractor_withorder_paydetail_temp from tractorprofile tp where asgn_type = 'TRC' and asgn_id = tp.trc_number and trc_type2 <> @tractor_type2

		IF @tractor_type3 <> 'UNK'
			delete #tractor_withorder_paydetail_temp from tractorprofile tp where asgn_type = 'TRC' and asgn_id = tp.trc_number and trc_type3 <> @tractor_type3
		
		IF @tractor_type4 <> 'UNK'
			delete #tractor_withorder_paydetail_temp from tractorprofile tp where asgn_type = 'TRC' and asgn_id = tp.trc_number and trc_type4 <> @tractor_type4

	End
	

-------  VERIFY THE SELECT !!!!!!!!!!!!!!!!!!!!!! 

--SELECT 
--asgn_type , 
--asgn_id , 
--pyd_payto , 
--pyt_itemcode , 
--mov_number , 
--pyd_description , 
--pyd_quantity , 
--pyd_rate , 
--pyd_amount , 
--pyd_glnum , 
--pyd_pretax , 
--pyd_status , 
--pyd_refnumtype , 
--pyd_refnum , 
--pyh_payperiod , 
--pyd_workperiod , 
--lgh_startcity , 
--lgh_endcity , 
--start_city , 
--end_city ,
--load_state ,
--legheader_enddate ,
--tractor_name ,
--ord_number ,
--ivh_billdate ,
--ivh_invoicenumber ,
--pyh_number,
--ord_hdrnumber
--from #tractor_withorder_paydetail_temp  



-- Send result set back 
SELECT * from #tractor_withorder_paydetail_temp  
DROP TABLE #tractor_withorder_paydetail_temp  
  
GO
GRANT EXECUTE ON  [dbo].[d_paydetail_report_tractor_withorder_sp] TO [public]
GO
