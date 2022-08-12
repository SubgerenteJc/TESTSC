SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO

CREATE PROC [dbo].[d_settlement_sheet_summary_62](
	@report_type varchar(5),
	@payperiodstart datetime,
	@payperiodend datetime,
	@drv_yes varchar(3),
	@trc_yes varchar(3),
	@trl_yes varchar(3),
	@drv_id varchar(8),
	@trc_id varchar(8),
	@trl_id varchar(13),
	@drv_type1 varchar(6),
	@trc_type1 varchar(6),
	@trl_type1 varchar(6),
	@terminal varchar(8),
	@name varchar(64),
	@car_yes varchar(3),
	@car_id varchar(8),
	@car_type1 varchar(6),
	@hld_yes varchar(3),	
	@pyhnumber int,
	@relcol varchar(3),
	@relncol varchar(3),
	@workperiodstart datetime,
	@workperiodend datetime)
AS
/**
 * DESCRIPTION:
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
 * 11/02/2007.01 ? PTS40116 - JGUO ? convert old style outer join syntax to ansi outer join syntax.
 *
 **/

-- Create a temp table to hold the pay header and detail numbers
-- Create a temp table to hold the pay details
CREATE TABLE #temp_pd(
	sid			int identity not null,
	pyd_number		int not null,
	pyh_number		int not null,
	asgn_number		int null,
	asgn_type		varchar(6) not null,
	asgn_id			varchar(13) not null,
	ivd_number		int null,
	pyd_prorap		varchar(6) null, 
	pyd_payto		varchar(12) null, -- changed from 6 to 12 for PTS #5849, JET - 6/10/99
	pyt_itemcode		varchar(6) null, 
	pyd_description		varchar(75) null, --10
	pyr_ratecode		varchar(6) null, 
	pyd_quantity		float null,		--extension (BTC)
	pyd_rateunit		varchar(6) null,
	pyd_unit		varchar(6) null,
	pyd_pretax		char(1) null,
	pyd_status		varchar(6) null,
	pyh_payperiod		datetime null,
	lgh_startcity		int null,
	lgh_endcity		int null,
	pyd_minus		int null,	--20
	pyd_workperiod		datetime null,
	pyd_sequence		int null,
	pyd_rate		money null,		--rate (BTC)
	pyd_amount		money null,
	pyd_payrevenue		money null,		
	mov_number		int null,
	lgh_number		int null,
	ord_hdrnumber		int null,
	pyd_transdate		datetime null,
	payperiodstart		datetime null,	--30
	payperiodend		datetime null,
	pyd_loadstate		varchar(6) null,
	summary_code		varchar(6) null,
	name			varchar(64) null,
	terminal		varchar(6) null,
	type1			varchar(6) null,
	pyh_totalcomp		money null,
	pyh_totaldeduct		money null,
	pyh_totalreimbrs	money null,
	crd_cardnumber		char(20) null,	--40
	lgh_startdate		datetime null,
	std_balance		money null,
	itemsection		int null,
	ord_startdate		datetime null,
	ord_number		char(12) null,
	ref_number		varchar(30) null,
	stp_arrivaldate		datetime null,
	shipper_name		varchar(30) null,
	shipper_city		varchar(18) null,
	shipper_state		char(2) null,	--50
	consignee_name		varchar(30) null,
	consignee_city		varchar(18) null,
	consignee_state		char(2) null,
	cmd_name		varchar(60) null,
	pyd_billedweight	int null,		--billed weight (BTC)
	adjusted_billed_rate	money null,		--rate (BTC)
	cht_basis		varchar(6) null,
	cht_basisunit		varchar(6) null,
	cht_unit		varchar(6) null,
	cht_rateunit		varchar(6) null,	--60
	std_number		int null,
	stp_number		int null,
	unc_factor		float null,
	stp_mfh_sequence	int null,
	pyt_description		varchar(30) null,
	cht_itemcode		varchar(6) null,
	userlabelname		varchar(20) null,
	label_name		varchar(20) null,
	otherid			varchar(8) null,
	pyt_fee1		money null,	--70
	pyt_fee2		money null,
	start_city		varchar(18) null,
	start_state		char(2) null,
	end_city		varchar(18) null,
	end_state		char(2) null,
	lgh_count		int null,
	ref_number_tds		varchar(30) null,
	pyd_offsetpay_number	int null,
	pyd_credit_pay_flag	char(1) null,
	pyd_refnumtype		varchar(6) null,	--80
	pyd_refnum		varchar(30) null,
	pyh_issuedate		datetime null,
	pyt_basis		varchar(6) null,
	constructseq		int null,
	stp_seq_min		int null,
	stp_number_min		int null)

-- Create a temp table to the pay header and detail numbers
CREATE TABLE #temp_pay (
	pyd_number int not null,
	pyh_number int not null,
	pyd_status varchar(6) null,
	asgn_type1 varchar(6) null)

-- jyang pts13004
Declare @PeriodforYTD Varchar(3)

--Create a temp table for YTD balances
CREATE TABLE #ytdbal (asgn_type	varchar (6) not null,
	asgn_id			varchar (13) not null,
	ytdcomp			money null,
	ytddeduct		money null,
	ytdreimbrs		money null,
	pyh_payperiod		datetime null,
	pyh_issuedate		datetime null)

CREATE TABLE #temp_stop_info (
	sid		int identity not null,
	stp_number	int not null,
	stp_sequence	int null,
	stp_event	varchar(8) null,
	stp_city_nmstct	varchar(30) null,
	stp_arrivaldate	datetime null)

--vmj1+	PTS 17099	04/03/2003	The isnull below works if a row is returned which has
--a null value for that column, but NOT if no row is returned.  Pre-set the value, so a 
--no-row select below will leave that value untouched..
select	@PeriodForYtd = 'no'
--vmj1-

SELECT @PeriodforYTD = isnull(gi_string1,'no') 
FROM generalinfo
WHERE gi_name = 'UsePayperiodForYTD'

-- LOR PTS# 6404 elliminate trial and final settlement sheets - do just one
IF @hld_yes = 'Y' 
--IF @report_type = 'TRIAL'
BEGIN
	-- Get the driver pay header and detail numbers for held pay
	IF @drv_yes <> 'XXX'
		INSERT INTO #temp_pay
		SELECT pyd_number,
			pyh_number,
			pyd_status,
			@drv_type1
		FROM paydetail
		WHERE asgn_type = 'DRV'
			AND asgn_id = @drv_id
			AND pyh_number = 0 
			AND pyd_status = 'HLD'
			and pyd_workperiod between @workperiodstart and @workperiodend

	-- Get the tractor pay header and detail numbers for held pay
	IF @trc_yes <> 'XXX'
		INSERT INTO #temp_pay
		SELECT pyd_number,
			pyh_number,
			pyd_status,
			@trc_type1
		FROM paydetail
		WHERE asgn_type = 'TRC'
	  		AND asgn_id = @trc_id
			AND pyh_number = 0
			AND pyd_status = 'HLD'
			and pyd_workperiod between @workperiodstart and @workperiodend

	-- Get the carrier pay header and detail numbers for held pay
	IF @car_yes <> 'XXX'
		INSERT INTO #temp_pay
		SELECT pyd_number,
			pyh_number,
			pyd_status,
			@car_type1
		FROM paydetail
		WHERE asgn_type = 'CAR'
	  		AND asgn_id = @car_id
			AND pyh_number = 0
			AND pyd_status = 'HLD'
			and pyd_workperiod between @workperiodstart and @workperiodend

	-- Get the trailer pay header and detail numbers for held pay
	IF @trl_yes <> 'XXX'
		INSERT INTO #temp_pay
		SELECT pyd_number,
			pyh_number,
			pyd_status,
			@trl_type1
		FROM paydetail
		WHERE asgn_type = 'TRL'
	  		AND asgn_id = @trl_id
			AND pyh_number = 0
			AND pyd_status = 'HLD'
			and pyd_workperiod between @workperiodstart and @workperiodend
END

IF @relcol  = 'N' and @relncol = 'Y' 
BEGIN
	IF @drv_yes <> 'XXX'
		-- Get the driver pay header and detail numbers for pay released 
		-- to this payperiod, but not collected
		INSERT INTO #temp_pay
		SELECT pyd_number,
			pyh_number,
			pyd_status,
			@drv_type1
		FROM paydetail
		WHERE asgn_type = 'DRV'
	  	AND asgn_id = @drv_id
	  	AND pyh_payperiod BETWEEN @payperiodstart and @payperiodend
		AND pyh_number = 0

	-- Get the tractor pay header and detail numbers for pay released 
	-- to this payperiod, but not collected
	IF @trc_yes <> 'XXX'
		INSERT INTO #temp_pay
		SELECT pyd_number,
			pyh_number,
			pyd_status,
			@trc_type1
		FROM paydetail
		WHERE asgn_type = 'TRC'
	  	AND asgn_id = @trc_id
	  	AND pyh_payperiod BETWEEN @payperiodstart and @payperiodend
		AND pyh_number = 0

	-- Get the carrier pay header and detail numbers for pay released 
	-- to this payperiod, but not collected
	IF @car_yes <> 'XXX'
		INSERT INTO #temp_pay
		SELECT pyd_number,
			pyh_number,
			pyd_status,
			@car_type1
		FROM paydetail
		WHERE asgn_type = 'CAR'
	  	AND asgn_id = @car_id
	  	AND pyh_payperiod BETWEEN @payperiodstart and @payperiodend
		AND pyh_number = 0

	-- LOR  PTS# 5744 add trailer settlements
	-- Get the trailer pay header and detail numbers for pay released 
	-- to this payperiod, but not collected
	IF @trl_yes <> 'XXX'
		INSERT INTO #temp_pay
		SELECT pyd_number,
			pyh_number,
			pyd_status,
			@trl_type1
		FROM paydetail
		WHERE asgn_type = 'TRL'
	  		AND asgn_id = @trl_id
	  		AND pyh_payperiod BETWEEN @payperiodstart and @payperiodend
			AND pyh_number = 0
END

IF @relcol  = 'Y' and @relncol = 'N'
BEGIN
--IF @report_type = 'FINAL'
	-- Get the driver pay header and detail numbers for pay released to this payperiod
	-- and collected 
	IF @drv_yes <> 'XXX'
		INSERT INTO #temp_pay
		SELECT pd.pyd_number,
			pd.pyh_number,
			pd.pyd_status,
			@drv_type1
		FROM paydetail pd, payheader ph
		WHERE ph.asgn_type = 'DRV'
	  		AND ph.pyh_payperiod BETWEEN @payperiodstart and @payperiodend
	  		AND pd.pyh_number = ph.pyh_pyhnumber
	  		AND @drv_id = ph.asgn_id
			AND pyh_number = @pyhnumber

	-- Get the tractor pay header and detail numbers pay released to this payperiod
	-- and collected 
	IF @trc_yes <> 'XXX'
		INSERT INTO #temp_pay
		SELECT pd.pyd_number,
			pd.pyh_number,
			pd.pyd_status,
			@trc_type1
		FROM paydetail pd, payheader ph
		WHERE ph.asgn_type = 'TRC'
			AND ph.pyh_payperiod BETWEEN @payperiodstart and @payperiodend
			AND pd.pyh_number = ph.pyh_pyhnumber
			AND @trc_id = ph.asgn_id
			AND pyh_number = @pyhnumber

	-- Get the carrier pay header and detail numbers for pay released to this payperiod
	-- and collected 
	IF @car_yes <> 'XXX'
		INSERT INTO #temp_pay
		SELECT pd.pyd_number,
			pd.pyh_number,
			pd.pyd_status,

			@car_type1
		FROM paydetail pd, payheader ph
		WHERE ph.asgn_type = 'CAR'
			AND ph.pyh_payperiod BETWEEN @payperiodstart and @payperiodend
			AND pd.pyh_number = ph.pyh_pyhnumber
			AND @car_id = ph.asgn_id
			AND pyh_number = @pyhnumber

	-- Get the trailer pay header and detail numbers for pay released to this payperiod
	-- and collected 
	IF @trl_yes <> 'XXX'
		INSERT INTO #temp_pay
		SELECT pd.pyd_number,
			pd.pyh_number,
			pd.pyd_status,
			@trl_type1
		FROM paydetail pd, payheader ph
		WHERE ph.asgn_type = 'TRL'
		AND ph.pyh_payperiod BETWEEN @payperiodstart and @payperiodend
		AND pd.pyh_number = ph.pyh_pyhnumber
		AND @trl_id = ph.asgn_id
		AND pyh_number = @pyhnumber
END



-- Insert into the temp pay details table with the paydetail data per #temp_pay
INSERT INTO #temp_pd
SELECT pd.pyd_number,
	pd.pyh_number,
	pd.asgn_number,
	pd.asgn_type,
	pd.asgn_id,
	pd.ivd_number,
	pd.pyd_prorap,
	pd.pyd_payto,
	pd.pyt_itemcode,
	pd.pyd_description, 	--10
	pd.pyr_ratecode,
	pd.pyd_quantity,
	pd.pyd_rateunit, 
	pd.pyd_unit,
	pd.pyd_pretax,
	tp.pyd_status,
	pd.pyh_payperiod,
	pd.lgh_startcity,
	pd.lgh_endcity,
	pd.pyd_minus,		--20
	pd.pyd_workperiod,
	pd.pyd_sequence,
	pd.pyd_rate,
	ROUND(pd.pyd_amount, 2),
	pd.pyd_payrevenue,
	pd.mov_number,
	pd.lgh_number,
	pd.ord_hdrnumber,
	pd.pyd_transdate,
	@payperiodstart,	--30
	@payperiodend,
	pd.pyd_loadstate,
	pd.pyd_unit,
	@name,
	@terminal,
	tp.asgn_type1,
	0.0,
	0.0,
	0.0,
	null,			--40
	null,
	null,
	0,
	null,
	null,
	null,
	null,
	null,
	null,
	null,			--50
	null,
	null,
	null,
	null,
	pd.pyd_billedweight,
	0.0,
	null,
	null,
	null,
	null,			--60
	pd.std_number,
	null,
	1.0,
	null,
	null,
	pd.cht_itemcode,
	null,
	null,
	null,
	pd.pyt_fee1,		--70
	pd.pyt_fee2,
	null,
	null,
	null,
	null,
	0,
	null,
	pyd_offsetpay_number,
	pyd_credit_pay_flag,
	pyd_refnumtype,		--80
	pyd_refnum,
	(select pyh_issuedate from payheader where pyh_pyhnumber = pd.pyh_number) pyh_issuedate,
	null,	-- pyt_basis
	1,	-- constructseq
	null,	--stp_seq_min
	null	--stp_number_min

FROM paydetail pd, #temp_pay tp
WHERE pd.pyd_number = tp.pyd_number

--Update the temp pay details with legheader data
UPDATE #temp_pd
   SET lgh_startdate = (SELECT lgh_startdate 
			     FROM legheader lh
			    WHERE lh.lgh_number = #temp_pd.lgh_number)

-- Update the temp with number of legheaders for the move
-- actually, just find if there was another legheader on the move
UPDATE #temp_pd
   SET lgh_count = (SELECT COUNT(lgh_number) 
			 FROM legheader lh 
			WHERE lh.mov_number = #temp_pd.mov_number)

--Update the temp pay details with orderheader data
UPDATE #temp_pd
   SET ord_startdate = oh.ord_startdate,
	ord_number = oh.ord_number
  FROM #temp_pd tp, 
	orderheader oh
 WHERE tp.ord_hdrnumber = oh.ord_hdrnumber

--Update the temp, for split trips, set ord_number = ord_number + '/S'
UPDATE #temp_pd
   SET ord_number = left(ord_number + '/S',12)
 WHERE ord_hdrnumber > 0 
	AND lgh_count > 1 -- JET - 5/28/99 - PTS #5788, this was set to 0 and I changed it to 1


--JD #11490 09/24/01
UPDATE #temp_pd
SET    shipper_city = ct.cty_name,
	   shipper_state = ct.cty_state
  FROM #temp_pd tp, city ct, orderheader oh
 WHERE tp.ord_hdrnumber = oh.ord_hdrnumber
	AND oh.ord_origincity = ct.cty_code


UPDATE #temp_pd
SET    consignee_city = ct.cty_name,
	   consignee_state = ct.cty_state
  FROM #temp_pd tp, city ct, orderheader oh
 WHERE tp.ord_hdrnumber = oh.ord_hdrnumber
	AND oh.ord_destcity = ct.cty_code


UPDATE #temp_pd
   SET shipper_name = co.cmp_name 
  FROM #temp_pd tp, company co,orderheader oh
 WHERE tp.ord_hdrnumber = oh.ord_hdrnumber
	AND oh.ord_shipper = co.cmp_id

UPDATE #temp_pd
   SET consignee_name = co.cmp_name
  FROM #temp_pd tp, company co,orderheader oh
 WHERE tp.ord_hdrnumber = oh.ord_hdrnumber
	AND oh.ord_consignee = co.cmp_id


--Update the temp pay details with standingdeduction data
UPDATE #temp_pd
   SET std_balance = (SELECT std_balance 
			   FROM standingdeduction sd 
			  WHERE sd.std_number = #temp_pd.std_number)

--Update the temp pay details for summary code
UPDATE #temp_pd
   SET summary_code = 'OTHER'
 WHERE summary_code <> 'MIL'

--Update the temp pay details for load status
UPDATE #temp_pd
   SET pyd_loadstate = 'NA'
 WHERE pyd_loadstate IS NULL

-- JET - 5/14/99 - trying to reduce I/O by using a nested select
--Update the temp pay details with payheader data
UPDATE #temp_pd
SET crd_cardnumber = (SELECT ph.crd_cardnumber 
			      FROM payheader ph
			     WHERE ph.pyh_pyhnumber = #temp_pd.pyh_number)

--Need to get the stop of the 1st delivery and find the commodity and arrival date
--associated with it.
--Update the temp pay details table with stop data for the 1st unload stop
UPDATE #temp_pd
   SET stp_mfh_sequence = (SELECT MIN(stp_mfh_sequence)
				 FROM stops st
				WHERE st.mov_number = #temp_pd.mov_number 
				      AND stp_event IN ('DRL', 'LUL', 'DUL', 'PUL')) 
--  FROM #temp_pd tp

UPDATE #temp_pd
   SET stp_number = (SELECT MAX(stp_number) 
			  FROM stops st 
			 WHERE st.mov_number = #temp_pd.mov_number
				AND st.stp_mfh_sequence = #temp_pd.stp_mfh_sequence)

UPDATE #temp_pd
   SET stp_seq_min = (SELECT MIN(stp_mfh_sequence)
				 FROM stops st
				WHERE st.lgh_number = #temp_pd.lgh_number ) 


UPDATE #temp_pd
   SET stp_number_min = (select s1.stp_number from stops s1
				where s1.lgh_number = #temp_pd.lgh_number
				and s1.stp_mfh_sequence = #temp_pd.stp_seq_min)


UPDATE #temp_pd
   SET stp_arrivaldate = (select s1.stp_arrivaldate from stops s1
				where s1.stp_number = #temp_pd.stp_number_min)


-- Update for stop arrivaldate
UPDATE #temp_pd
   SET stp_arrivaldate = (SELECT stp_arrivaldate
				FROM stops st
			      WHERE st.stp_number = #temp_pd.stp_number)
where stp_arrivaldate is null

--Update the temp pay details with commodity data
UPDATE #temp_pd
   SET cmd_name = (SELECT MIN(cmd_name) 
			FROM freightdetail fd, 
			     commodity cd
		      WHERE fd.stp_number = #temp_pd.stp_number 
			     AND fd.cmd_code = cd.cmd_code)

--Need to get the bill-of-lading from the reference number table
--Update the temp pay details with reference number data
UPDATE #temp_pd
   SET ref_number = (SELECT MIN(ref_number) 
			  FROM referencenumber 
			 WHERE ref_tablekey = #temp_pd.ord_hdrnumber
				AND ref_table = 'orderheader'
				AND ref_type = 'SID')

-- Could this be written to reduce I/O, I'm not sure breaking it up will help
--Need to get revenue charge type data from the chargetype table
UPDATE #temp_pd
   SET cht_basis = ct.cht_basis,
	cht_basisunit = ct.cht_basisunit,
	cht_unit = ct.cht_unit,
	cht_rateunit = ct.cht_rateunit
  FROM #temp_pd tp, chargetype ct
 WHERE tp.cht_itemcode = ct.cht_itemcode

UPDATE #temp_pd 
   SET unc_factor = uc.unc_factor
  FROM #temp_pd tp, unitconversion uc
 WHERE uc.unc_from = tp.cht_basisunit
	AND uc.unc_to = tp.cht_rateunit
	AND uc.unc_convflag = 'R'

UPDATE #temp_pd
   SET adjusted_billed_rate = ROUND(pyd_payrevenue / pyd_billedweight / unc_factor, 2)
 WHERE pyd_billedweight > 0
	AND unc_factor > 0
	AND pyd_payrevenue > 0

--Insert into the temp YTD balances table the assets from the temp pay details table
INSERT INTO #ytdbal
     SELECT DISTINCT asgn_type, asgn_id, 0, 0, 0, pyh_payperiod, pyh_issuedate
	FROM #temp_pd

--Compute the YTD balances for each assets
--LOR	fixed null problem SR 7095
--JYang pts13004
if left(ltrim(@PeriodforYTD),1) = 'Y' begin
UPDATE #ytdbal
   SET	ytdcomp = ISNULL((SELECT SUM(ROUND(ph.pyh_totalcomp, 2))
			FROM payheader ph
		    	WHERE ph.asgn_id = yb.asgn_id
			   	AND ph.asgn_type = yb.asgn_type
			   	AND ph.pyh_payperiod >= '01/01/' + datename(yy, @payperiodend)
			   	AND ph.pyh_payperiod < @payperiodend
			   	AND ph.pyh_paystatus <> 'HLD'), 0),
     	ytddeduct = ISNULL((SELECT SUM(ROUND(ph.pyh_totaldeduct, 2))
		     	FROM payheader ph
		    	WHERE ph.asgn_id = yb.asgn_id
			  		AND ph.asgn_type = yb.asgn_type
			   	AND ph.pyh_payperiod >= '01/01/' + datename(yy, @payperiodend)
			  		AND ph.pyh_payperiod < @payperiodend
			   	AND ph.pyh_paystatus <> 'HLD'), 0),
    	ytdreimbrs = ISNULL((SELECT SUM(ROUND(ph.pyh_totalreimbrs, 2))
		     	FROM payheader ph
		    	WHERE ph.asgn_id = yb.asgn_id
			   	AND ph.asgn_type = yb.asgn_type
			   	AND ph.pyh_payperiod >= '01/01/' + datename(yy, @payperiodend)
			   	AND ph.pyh_payperiod < @payperiodend
			   	AND ph.pyh_paystatus <> 'HLD'), 0)
   FROM  #ytdbal yb
end else begin
UPDATE #ytdbal
	SET	ytdcomp = ISNULL((SELECT SUM(ROUND(ph.pyh_totalcomp, 2))
			FROM payheader ph
		   	WHERE ph.asgn_id = yb.asgn_id
			  	AND ph.asgn_type = yb.asgn_type
			  	AND isnull(ph.pyh_issuedate,ph.pyh_payperiod) >= '01/01/' + datename(yy, isnull(yb.pyh_issuedate,yb.pyh_payperiod))
			  	AND isnull(ph.pyh_issuedate,ph.pyh_payperiod) <= isnull(yb.pyh_issuedate,yb.pyh_payperiod)
			  	AND ph.pyh_paystatus <> 'HLD'), 0),
		ytddeduct = ISNULL((SELECT SUM(ROUND(ph.pyh_totaldeduct, 2))
		    	FROM payheader ph
		   	WHERE ph.asgn_id = yb.asgn_id
			 		AND ph.asgn_type = yb.asgn_type
			  	AND isnull(ph.pyh_issuedate,ph.pyh_payperiod) >= '01/01/' + datename(yy, isnull(yb.pyh_issuedate,yb.pyh_payperiod))
			  	AND isnull(ph.pyh_issuedate,ph.pyh_payperiod) <= isnull(yb.pyh_issuedate,yb.pyh_payperiod)
			  	AND ph.pyh_paystatus <> 'HLD'), 0),
		ytdreimbrs = ISNULL((SELECT SUM(ROUND(ph.pyh_totalreimbrs, 2))
		    	FROM payheader ph
		   	WHERE ph.asgn_id = yb.asgn_id
			  	AND ph.asgn_type = yb.asgn_type
			  	AND isnull(ph.pyh_issuedate,ph.pyh_payperiod) >= '01/01/' + datename(yy, isnull(yb.pyh_issuedate,yb.pyh_payperiod))
			  	AND isnull(ph.pyh_issuedate,ph.pyh_payperiod) <= isnull(yb.pyh_issuedate,yb.pyh_payperiod)
			  	AND ph.pyh_paystatus <> 'HLD'), 0)
   FROM  #ytdbal yb
END
 
UPDATE #ytdbal
   SET ytdcomp = ytdcomp + ISNULL((SELECT SUM(ROUND(tp.pyd_amount, 2))
				  FROM #temp_pd tp
				 WHERE tp.asgn_id = yb.asgn_id
					AND tp.asgn_type = yb.asgn_type
					AND tp.pyd_pretax = 'Y'
					AND tp.pyd_status <> 'HLD'
				   AND pyh_number = 0), 0)
   FROM  #ytdbal yb

UPDATE #ytdbal
   SET ytddeduct = ytddeduct + ISNULL((SELECT SUM(ROUND(tp.pyd_amount, 2)) 
				      FROM #temp_pd tp
				     WHERE tp.asgn_id = yb.asgn_id
					    AND tp.asgn_type = yb.asgn_type
					    AND tp.pyd_pretax = 'N'
					    AND tp.pyd_minus = -1
					    AND tp.pyd_status <> 'HLD'
					AND pyh_number = 0), 0)
   FROM  #ytdbal yb

UPDATE #ytdbal
   SET ytdreimbrs = ytdreimbrs + ISNULL((SELECT SUM(ROUND(tp.pyd_amount, 2))
					 FROM #temp_pd tp
					WHERE tp.asgn_id = yb.asgn_id
					      AND tp.asgn_type = yb.asgn_type
					      AND tp.pyd_pretax = 'N'
					      AND tp.pyd_minus = 1
					      AND tp.pyd_status <> 'HLD'
					 AND pyh_number = 0 ), 0)
   FROM  #ytdbal yb

UPDATE 	#temp_pd
  SET 	pyh_totalcomp = yb.ytdcomp,
		pyh_totaldeduct = yb.ytddeduct,
		pyh_totalreimbrs = yb.ytdreimbrs
  FROM 	#ytdbal yb
		,#temp_pd tp
  WHERE tp.asgn_type = yb.asgn_type
	AND tp.asgn_id = yb.asgn_id
	--vmj1+	Note that 2/2/1950 is a very unlikely date value which is used to compare NULL 
	--to NULL..
	and isnull(tp.pyh_issuedate, '1950-02-02') = isnull(yb.pyh_issuedate, '1950-02-02')
	and isnull(tp.pyh_payperiod, '1950-02-02') = isnull(yb.pyh_payperiod, '1950-02-02')
	--vmj1-

UPDATE #temp_pd
   SET itemsection = 2
 WHERE pyd_pretax = 'N'
	AND pyd_minus = 1

UPDATE #temp_pd
   SET itemsection = 3
 WHERE pyd_pretax = 'N'
	AND pyd_minus = -1

UPDATE #temp_pd
   SET itemsection = 4
 WHERE pyt_itemcode = 'MN+'
	OR pyt_itemcode = 'MN-'

--Update the temp pay details with labelfile data and drv alt id
UPDATE #temp_pd
   SET userlabelname = l.userlabelname,
	label_name = l.name,
	otherid = m.mpp_otherid
  FROM #temp_pd tp, labelfile l, manpowerprofile m
 WHERE m.mpp_id = tp.asgn_id 
	AND l.labeldefinition = 'DrvType1'
	AND m.mpp_type1 = l.abbr 

--Update the temp pay details with start/end city/state data - LOR PTS# 4457
UPDATE #temp_pd
   SET start_city = ct.cty_name, 
	start_state = ct.cty_state
  FROM #temp_pd tp, city ct
 WHERE ct.cty_code = tp.lgh_startcity

UPDATE #temp_pd
   SET end_city = ct.cty_name,
	end_state = ct.cty_state
  FROM #temp_pd tp, city ct
 WHERE ct.cty_code = tp.lgh_endcity

--Update the temp pay details with TDS ref# for CryOgenics - LOR PTS# 6837
UPDATE #temp_pd
   SET ref_number_tds = r.ref_number
  FROM #temp_pd tp, labelfile l, orderheader o, referencenumber r
 WHERE r.ref_table = 'orderheader' and
	r.ref_tablekey = tp.ord_hdrnumber and
	l.labeldefinition = 'ReferenceNumbers' and
	l.abbr = r.ref_type and
	r.ref_type = 'TRIP' and
	o.ord_hdrnumber = tp.ord_hdrnumber and
	r.ref_type = o.ord_reftype

-- PTS 29515 -- BL (start)
update #temp_pd
set pyt_basis = p.pyt_basis 
from #temp_pd tp, paytype p
where tp.pyt_itemcode = p.pyt_itemcode
-- PTS 29515 -- BL (end)

--JD 11605 delete fake routing paydetails
if exists (select * from generalinfo where gi_name = 'StlFindNextMTLeg' and gi_string1 = 'Y')
	delete #temp_pd from paydetail where #temp_pd.pyd_number = paydetail.pyd_number and paydetail.tar_tarriffnumber = '-1'

--vjh 32234 add logic to create rows for each stop on paydetails with flat rate
declare @v_sid int,
	@v_lgh_number int,
	@v_stop_count int,
	@v_stop_index int,
	@v_stop_identity_offset int

select @v_sid = max(sid)
from #temp_pd
where pyt_itemcode='FLAT'

while @v_sid is not null begin

	select @v_lgh_number = lgh_number from #temp_pd where sid = @v_sid
	insert #temp_stop_info (
		stp_number,
		stp_sequence,
		stp_event,
		stp_city_nmstct,
		stp_arrivaldate)
	select	stp_number,
		stp_mfh_sequence,
		stp_event,
		cty_nmstct,
		stp_arrivaldate
	from stops left join city on stp_city = cty_code
	where lgh_number = @v_lgh_number order by stp_mfh_sequence
	
	select @v_stop_identity_offset = min(sid) from #temp_stop_info
	select @v_stop_count = count(stp_number) from #temp_stop_info
	if @v_stop_count > 2 begin
		-- do the inserts here
		update #temp_pd 
		set pyd_description = (select a.stp_city_nmstct + ' to ' + b.stp_city_nmstct
			from #temp_stop_info a, #temp_stop_info b 
			where a.sid = @v_stop_identity_offset + @v_stop_count - 2
			and  b.sid = @v_stop_identity_offset + @v_stop_count -1),
		constructseq = @v_stop_count,
		stp_arrivaldate = (select stp_arrivaldate from #temp_stop_info where sid = @v_stop_count)
		where sid = @v_sid
		select @v_stop_index = @v_stop_count - 1

		while @v_stop_index > 1 begin

			insert #temp_pd (
				pyd_number,
				pyh_number,
				asgn_number,
				asgn_type,
				asgn_id,
				ivd_number,
				pyd_prorap,
				pyd_payto,
				pyt_itemcode,
				pyd_description,
				pyr_ratecode,
				pyd_quantity,
				pyd_rateunit,
				pyd_unit,
				pyd_pretax,
				pyd_status,
				pyh_payperiod,
				lgh_startcity,
				lgh_endcity,
				pyd_minus,
				pyd_workperiod,
				pyd_sequence,
				pyd_rate,
				pyd_amount,
				pyd_payrevenue,
				mov_number,
				lgh_number,
				ord_hdrnumber,
				pyd_transdate,
				payperiodstart,
				payperiodend,
				pyd_loadstate,
				summary_code,
				name,
				terminal,
				type1,
				pyh_totalcomp,
				pyh_totaldeduct,
				pyh_totalreimbrs,
				crd_cardnumber,
				lgh_startdate,
				std_balance,
				itemsection,
				ord_startdate,
				ord_number,
				ref_number,
				stp_arrivaldate,
				shipper_name,
				shipper_city,
				shipper_state,
				consignee_name,
				consignee_city,
				consignee_state,
				cmd_name,
				pyd_billedweight,
				adjusted_billed_rate,
				cht_basis,
				cht_basisunit,
				cht_unit,
				cht_rateunit,
				std_number,
				stp_number,
				unc_factor,
				stp_mfh_sequence,
				pyt_description,
				cht_itemcode,
				userlabelname,
				label_name,
				otherid,
				pyt_fee1,
				pyt_fee2,
				start_city,
				start_state,
				end_city,
				end_state,
				lgh_count,
				ref_number_tds,
				pyd_offsetpay_number,
				pyd_credit_pay_flag,
				pyd_refnumtype,
				pyd_refnum,
				pyh_issuedate,
				pyt_basis,
				constructseq,
				stp_seq_min
			)
			select 	pyd_number,
				pyh_number,
				asgn_number,
				asgn_type,
				asgn_id,
				ivd_number,
				pyd_prorap,
				pyd_payto,
				pyt_itemcode,
				(select a.stp_city_nmstct + ' to ' + b.stp_city_nmstct
					from #temp_stop_info a, #temp_stop_info b 
					where a.sid = @v_stop_identity_offset + @v_stop_index -2
					and  b.sid = @v_stop_identity_offset + @v_stop_index -1),
				pyr_ratecode,
				null, --pyd_quantity,
				null, --pyd_rateunit,
				pyd_unit,
				pyd_pretax,
				pyd_status,
				pyh_payperiod,
				lgh_startcity,
				lgh_endcity,
				pyd_minus,
				pyd_workperiod,
				pyd_sequence,
				null, --pyd_rate,
				null, --pyd_amount,
				null, --pyd_payrevenue,
				mov_number,
				lgh_number,
				ord_hdrnumber,
				pyd_transdate,
				payperiodstart,
				payperiodend,
				pyd_loadstate,
				summary_code,
				name,
				terminal,
				type1,
				pyh_totalcomp,
				pyh_totaldeduct,
				pyh_totalreimbrs,
				crd_cardnumber,
				lgh_startdate,
				std_balance,
				itemsection,
				ord_startdate,
				ord_number,
				ref_number,
				(select stp_arrivaldate from #temp_stop_info where sid = @v_stop_index),
				shipper_name,
				shipper_city,
				shipper_state,
				consignee_name,
				consignee_city,
				consignee_state,
				cmd_name,
				pyd_billedweight,
				adjusted_billed_rate,
				cht_basis,
				cht_basisunit,
				cht_unit,
				cht_rateunit,
				std_number,
				stp_number,
				unc_factor,
				stp_mfh_sequence,
				pyt_description,
				cht_itemcode,
				userlabelname,
				label_name,
				otherid,
				pyt_fee1,
				pyt_fee2,
				start_city,
				start_state,
				end_city,
				end_state,
				lgh_count,
				ref_number_tds,
				pyd_offsetpay_number,
				pyd_credit_pay_flag,
				pyd_refnumtype,
				pyd_refnum,
				pyh_issuedate,
				pyt_basis,
				@v_stop_index - 1,
				stp_seq_min
			from #temp_pd where sid = @v_sid
			select @v_stop_index = @v_stop_index - 1
		end
	end
	delete #temp_stop_info
	select @v_sid = max(sid)
	from #temp_pd
	where pyt_itemcode='FLAT'
	and sid < @v_sid
end


SELECT pyd_number, 
	pyh_number, 
	asgn_number, 
	tp.asgn_type, 
	tp.asgn_id, 
	ivd_number, 
	pyd_prorap, 
	pyd_payto,
	pyt_itemcode,
	pyd_description,
	pyr_ratecode, 
	pyd_quantity, 
	pyd_rateunit, 
	pyd_unit, 
	pyd_pretax, 
	pyd_status, 
	tp.pyh_payperiod, 
	lgh_startcity,
	lgh_endcity, 
	pyd_minus,
	pyd_workperiod,
	pyd_sequence,
	pyd_rate,
	round(pyd_amount, 2),
	pyd_payrevenue,
	mov_number,
	lgh_number,
	ord_hdrnumber,
	pyd_transdate,
	payperiodstart,
	payperiodend,
	pyd_loadstate,
	summary_code,
	name,
	terminal,
	type1,
	round(tp.pyh_totalcomp, 2),
	round(tp.pyh_totaldeduct, 2),
	round(tp.pyh_totalreimbrs, 2),
	ph.crd_cardnumber 'crd_cardnumber',
	lgh_startdate,
	std_balance,
	itemsection,
	ord_startdate,
	ord_number,
	ref_number,
	stp_arrivaldate,
	shipper_name,
	shipper_city,
	shipper_state,
	consignee_name,
	consignee_city,
	consignee_state,
	cmd_name,
	pyd_billedweight,
	adjusted_billed_rate,
	pyd_payrevenue,
	cht_basisunit,
	pyt_description,
	userlabelname,
	label_name,
	otherid,
	pyt_fee1,
	pyt_fee2,
	start_city,
	start_state,
	end_city,
	end_state, 
	ph.pyh_paystatus,
	ref_number_tds,
	pyd_offsetpay_number,
	pyd_credit_pay_flag,
	pyd_refnumtype,
	pyd_refnum,
	pyt_basis,
	constructseq
  FROM #temp_pd tp LEFT OUTER JOIN payheader ph ON tp.pyh_number = ph.pyh_pyhnumber

GO
GRANT EXECUTE ON  [dbo].[d_settlement_sheet_summary_62] TO [public]
GO
