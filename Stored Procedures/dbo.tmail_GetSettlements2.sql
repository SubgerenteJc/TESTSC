SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[tmail_GetSettlements2]   @sPayPeriod varchar(25),
					    @AssignId varchar(13),
					    @AssignType varchar(6),
					    @Collected varchar(6),
					    @PayStatus varchar(6),
                                            @sMoveNumber varchar(20)

AS

/*****************************************************************
*   05/20/03 MZ: Created 
*   08/16/04 jgf: Sodrel 22135 enhancements:
*                 Allow restrict by Move#, ANY payperiod, ANY Collected status, 
*                 ANY Status (including HLD).  Add Net Pay.
*   New input parm: sMoveNumber.
*   Original RETURNs: MoveNumber (rep), GrossPay, TotalDeductiONs, TotalExpenses, 
*                     DescriptiON (rep), Rate (rep), RateUnit (rep), Quantity (rep), 
*                     Amount (rep), PayPeriod.
*   Changes: MoveNumber (rep) changed to PayDetMoveNumber (rep).
*   New RETURNs added: MoveNumber, TotalQuantity, Order# (rep), RevType1 (rep), 
*                      RevType2 (rep), RevType3 (rep), RevType4 (rep), NetPay.
*   Notes: The Order# and RevTypes will of course be from the paydetail.ord_hdrnumber.
*          If loads are cONsolidated, this will be the lowest Order ON that Move, not 
*          necessarily the exact Order# for that stop. 
*****************************************************************/
SET NOCOUNT ON 

/*
DECLARE @TotalComp mONey,
        @TotalDed mONey,
        @TotalReimburs mONey,
        @TotalAdjust mONey,
        @PayPeriod datetime,
        @pyh_number int,
        @TotalQuantity int,
        @MoveNumber int,
        @PayStatusRestrict varchar(6),
        @PayStatusExclude varchar(6),
        @PayHdrNumberRestrict int,
        @PayHdrNumberExclude int,
        @MoveNumberRestrict int,
        @PayPeriodExclude datetime,
        @NetPay mONey,
        @FakeDate datetime,
        @AnyDate datetime,
        @NeverDate datetime

SET @Collected = UPPER(LEFT(ISNULL(@Collected, ''), 1))
SET @FakeDate = CONVERT(datetime, '19500101')
SET @AnyDate = CONVERT(datetime, '18010101')
SET @NeverDate = CONVERT(datetime, '20491231')

-- ValidatiON
-- If Collected is not supplied (or invalid), default to Y
IF ISNULL(@Collected, '') NOT IN ('N', 'F', 'A', '0') -- 'A' = ANY, also could be 'Y', 'T', '1', or '-', but all will be treated as 'Y'.
  SET @Collected = 'Y'

IF @Collected = 'Y'
  BEGIN
    SET @PayHdrNumberRestrict = NULL
    SET @PayHdrNumberExclude = 0
  END
ELSE IF @Collected IN ('N', 'F', '0')
  BEGIN
    SET @PayHdrNumberRestrict = 0
    SET @PayHdrNumberExclude = NULL
  END
ELSE -- A = ANY
  BEGIN
    SET @PayHdrNumberRestrict = NULL
    SET @PayHdrNumberExclude = NULL
  END

-- if PayStatus is not supplied, default to any but HLD.  ANY = ANY.
SET @PayStatus = ISNULL(@PayStatus,'')
IF @PayStatus NOT IN ('', 'ANY','COL','PND','PRN','REL','XFR')
  BEGIN
    IF (SELECT COUNT(pyh_paystatus) 
    FROM payheader (NOLOCK)
    WHERE pyh_paystatus = @PayStatus) < 1
      BEGIN
	RAISERROR ('Invalid pay status (%s).',16,1,@PayStatus)
	RETURN 1	
      END
  END
IF @PayStatus = ''            -- = any but HLD
  BEGIN
    SET @PayStatusRestrict = NULL
    SET @PayStatusExclude = 'HLD'
  END
ELSE IF @PayStatus = 'ANY'    -- = ANY
  BEGIN
    SET @PayStatusRestrict = NULL
    SET @PayStatusExclude = NULL
  END
ELSE                          -- = specified status
  BEGIN
    SET @PayStatusRestrict = @PayStatus
    SET @PayStatusExclude = NULL
  END

-- AssignID
IF (ISNULL(@AssignId,'') = '') 
  BEGIN
	RAISERROR ('No assignment id supplied.',16,1)
	RETURN 1	
  END

-- if PayPeriod is not supplied defalt to latest payperiod. '18010101' = ANY.
IF (ISNULL(@sPayPeriod, '') = '') 
  BEGIN
    SET @PayPeriod = @FakeDate
    SET @PayPeriodExclude = @NeverDate
  END
ELSE IF (ISDATE(@sPayPeriod)= 1)
  BEGIN
    SET @PayPeriod = CONVERT(datetime, @sPayPeriod)
    SET @PayPeriodExclude = @NeverDate
  END
ELSE
  BEGIN
    RAISERROR ('Pay period is an invalid date.',16,1)
    RETURN 1	
  END	

IF @PayPeriod = @AnyDate -- ANY
  BEGIN
    SET @PayPeriod = NULL
    SET @PayPeriodExclude = NULL
  END

-- if Assign Type is not supplied default to to DRV
IF (ISNULL(@AssignType,'') = '') 
  SET @AssignType = 'DRV'

-- START OF MAIN PROCESSING --------------------------------------------------------------------
-- Init
SET @pyh_number = 0
SET @MoveNumber = -1
SET @sMoveNumber = ISNULL(@sMoveNumber, '')
IF ISNUMERIC(@sMoveNumber) <> 0
	SET @MoveNumber = CONVERT(int, @sMoveNumber)

IF ISNULL(@MoveNumber, -1) < 1
  SET @MoveNumberRestrict = NULL
ELSE
  SET @MoveNumberRestrict = @MoveNumber

IF (@PayPeriod = @FakeDate)
  -- We dON't have a pay period so find latest pay period for this assign id 
  IF @PayHdrNumberExclude = 0 -- must have payheader
    SELECT @PayPeriod = ISNULL(MAX(payheader.pyh_payperiod), @FakeDate)
    FROM payheader (NOLOCK)
    LEFT JOIN paydetail (NOLOCK) ON pyh_pyhnumber = pyh_number 
    WHERE payheader.asgn_type = @AssignType AND payheader.asgn_id = @AssignId  
      AND payheader.pyh_paystatus = ISNULL(@PayStatusRestrict, payheader.pyh_paystatus)
      AND payheader.pyh_paystatus <> ISNULL(@PayStatusExclude, 'arglebargle')
      AND payheader.pyh_pyhnumber = ISNULL(@PayHdrNumberRestrict, payheader.pyh_pyhnumber)
      AND payheader.pyh_pyhnumber <> ISNULL(@PayHdrNumberExclude, -1234567890)
      AND paydetail.mov_number = ISNULL(@MoveNumberRestrict, paydetail.mov_number)
  ELSE -- no payheader required
    SELECT @PayPeriod = ISNULL(MAX(pyh_payperiod), @FakeDate)
    FROM paydetail(NOLOCK)
    WHERE asgn_type = @AssignType AND asgn_id = @AssignId  
      AND pyd_status = ISNULL(@PayStatusRestrict, pyd_status)
      AND pyd_status <> ISNULL(@PayStatusExclude, 'arglebargle')
      AND pyh_number = ISNULL(@PayHdrNumberRestrict, pyh_number)
      AND pyh_number <> ISNULL(@PayHdrNumberExclude, -1234567890)
      AND mov_number = ISNULL(@MoveNumberRestrict, mov_number)
      AND pyh_payperiod <> ISNULL(@PayPeriodExclude, @FakeDate)

IF (@PayPeriod = @FakeDate)
  BEGIN
    RAISERROR ('There are no collected pay periods for asgn_id: %s asgn_type: %s pay status: %s .',16,1, @AssignId, @AssignType, @PayStatus)
    RETURN 1	
  END

-- OK, now we have a payperiod if we need ONe, let's get the header, if needed
IF @PayHdrNumberExclude = 0 -- must have payheader
  BEGIN
    SELECT @pyh_number = ISNULL(pyh_pyhnumber,0)
    FROM payheader (NOLOCK) 
    LEFT JOIN paydetail (NOLOCK) ON pyh_pyhnumber = pyh_number 
    WHERE payheader.asgn_type = @AssignType AND payheader.asgn_id = @AssignId  
      AND payheader.pyh_paystatus = ISNULL(@PayStatusRestrict, payheader.pyh_paystatus)
      AND payheader.pyh_paystatus <> ISNULL(@PayStatusExclude, 'arglebargle')
      AND payheader.pyh_pyhnumber = ISNULL(@PayHdrNumberRestrict, payheader.pyh_pyhnumber)
      AND payheader.pyh_pyhnumber <> ISNULL(@PayHdrNumberExclude, -1234567890)
      AND paydetail.mov_number = ISNULL(@MoveNumberRestrict, paydetail.mov_number)
      AND payheader.pyh_payperiod = ISNULL(@PayPeriod, payheader.pyh_payperiod)
      AND payheader.pyh_payperiod <> ISNULL(@PayPeriodExclude, @FakeDate)

    IF NOT EXISTS  (SELECT pyh_totalcomp 
                    FROM payheader (NOLOCK) 
                      LEFT JOIN paydetail (NOLOCK) ON payheader.pyh_pyhnumber = paydetail.pyh_number
                    WHERE payheader.pyh_pyhnumber = @pyh_number
                      AND paydetail.pyd_amount <> 0)
      BEGIN
        SET @sPayPeriod = CONVERT (varchar(20), @PayPeriod,101)
        RAISERROR ('There are no collected paydetails for asgn_id: %s asgn_type: %s pay period: %s, status: %s.',16,1, @AssignId, @AssignType, @sPayPeriod, @PayStatus)
        RETURN 1	
      END

    -- Now total the Quantity for this payheader
    SELECT @TotalQuantity = ISNULL(SUM(pyd_quantity),0)
    FROM payheader (NOLOCK) 
    LEFT JOIN paydetail (NOLOCK) ON payheader.pyh_pyhnumber = paydetail.pyh_number
    WHERE payheader.pyh_pyhnumber = @pyh_number
      AND paydetail.pyd_amount <> 0

    -- Now total the NetPay for this payheader
    SELECT @NetPay = ISNULL(pyh_totalcomp,0) + ISNULL(pyh_totaldeduct,0) + ISNULL(pyh_totalreimbrs,0)
    FROM payheader (NOLOCK) 
    WHERE payheader.pyh_pyhnumber = @pyh_number

    -- OK, RETURN all the data for this payheader
    SELECT  paydetail.mov_number MoveNumber,
      @MoveNumber LookupMove,
      ISNULL(payheader.pyh_totalcomp,0) GrossPay,
      ISNULL(payheader.pyh_totaldeduct,0) TotalDeductiONs,
      ISNULL(payheader.pyh_totalreimbrs,0) TotalExpenses,
      CASE ISNULL(paydetail.pyd_descriptiON,'')
        WHEN '' then paytype.pyt_descriptiON	
        ELSE paydetail.pyd_descriptiON 
      END DescriptiON,	
      paydetail.pyd_rate Rate, 
      paydetail.pyd_rateunit RateUnit,
      paydetail.pyd_quantity Quantity,
      paydetail.pyd_amount Amount,
      @PayPeriod PayPeriod,
      @TotalQuantity TotalQuantity,
      orderheader.ord_number OrderNumber,
      r1.name RevType1,
      r2.name RevType2,
      r3.name RevType3,
      r4.name RevType4,
      @NetPay NetPay
    FROM payheader (NOLOCK)
    LEFT JOIN paydetail (NOLOCK)ON payheader.pyh_pyhnumber = paydetail.pyh_number
	LEFT OUTER JOIN paytype (NOLOCK) ON paydetail.pyt_itemcode = paytype.pyt_itemcode
    LEFT OUTER JOIN orderheader (NOLOCK) ON paydetail.ord_hdrnumber = orderheader.ord_hdrnumber
    LEFT OUTER JOIN labelfile r1 (NOLOCK) ON orderheader.ord_revtype1 = r1.abbr and r1.labeldefinitiON = 'RevType1'
    LEFT OUTER JOIN labelfile r2 (NOLOCK) ON orderheader.ord_revtype2 = r2.abbr and r2.labeldefinitiON = 'RevType2'
    LEFT OUTER JOIN labelfile r3 (NOLOCK) ON orderheader.ord_revtype3 = r3.abbr and r3.labeldefinitiON = 'RevType3'
    LEFT OUTER JOIN labelfile r4 (NOLOCK) ON orderheader.ord_revtype4 = r4.abbr and r4.labeldefinitiON = 'RevType4'
    WHERE payheader.pyh_pyhnumber = @pyh_number
      AND paydetail.pyd_amount <> 0
    ORDER BY paydetail.mov_number, paydetail.pyd_sequence
  END

ELSE 
  -- no payheader required, get the details
  BEGIN
    -- Total CompensatiON
    SELECT @TotalComp = ISNULL(SUM(pyd_amount),0)
    FROM paydetail (NOLOCK)
    WHERE asgn_id = @AssignId AND asgn_type = @AssignType
      AND pyd_status = ISNULL(@PayStatusRestrict, pyd_status)
      AND pyd_status <> ISNULL(@PayStatusExclude, 'arglebargle')
      AND pyh_number = ISNULL(@PayHdrNumberRestrict, pyh_number)
      AND pyh_number <> ISNULL(@PayHdrNumberExclude, -1234567890)
      AND mov_number = ISNULL(@MoveNumberRestrict, mov_number)
      AND pyh_payperiod <> ISNULL(@PayPeriodExclude, @FakeDate)
      AND pyh_payperiod = ISNULL(@PayPeriod, pyh_payperiod)
      AND pyd_pretax = 'Y'

    -- Total DeductiONs
    SELECT @TotalDed = ISNULL(SUM(pyd_amount),0)
    FROM paydetail 
    WHERE asgn_id = @AssignId AND asgn_type = @AssignType
      AND pyd_status = ISNULL(@PayStatusRestrict, pyd_status)
      AND pyd_status <> ISNULL(@PayStatusExclude, 'arglebargle')
      AND pyh_number = ISNULL(@PayHdrNumberRestrict, pyh_number)
      AND pyh_number <> ISNULL(@PayHdrNumberExclude, -1234567890)
      AND mov_number = ISNULL(@MoveNumberRestrict, mov_number)
      AND pyh_payperiod <> ISNULL(@PayPeriodExclude, @FakeDate)
      AND pyh_payperiod = ISNULL(@PayPeriod, pyh_payperiod)
      AND pyd_pretax = 'N' 
      AND pyd_minus = -1

    -- Total Expenses
    SELECT @TotalReimburs = ISNULL(SUM(pyd_amount),0)
    FROM paydetail (NOLOCK)
    WHERE asgn_id = @AssignId AND asgn_type = @AssignType
      AND pyd_status = ISNULL(@PayStatusRestrict, pyd_status)
      AND pyd_status <> ISNULL(@PayStatusExclude, 'arglebargle')
      AND pyh_number = ISNULL(@PayHdrNumberRestrict, pyh_number)
      AND pyh_number <> ISNULL(@PayHdrNumberExclude, -1234567890)
      AND mov_number = ISNULL(@MoveNumberRestrict, mov_number)
      AND pyh_payperiod <> ISNULL(@PayPeriodExclude, @FakeDate)
      AND pyh_payperiod = ISNULL(@PayPeriod, pyh_payperiod)
      AND pyd_pretax = 'N' 
      AND pyd_minus = 1

    -- Net Pay
    SET @NetPay = @TotalComp + @TotalDed + @TotalReimburs

    -- Total Quantity
    SELECT @TotalQuantity = ISNULL(SUM(pyd_quantity),0)
    FROM paydetail (NOLOCK)
    WHERE asgn_id = @AssignId AND asgn_type = @AssignType
      AND pyd_status = ISNULL(@PayStatusRestrict, pyd_status)
      AND pyd_status <> ISNULL(@PayStatusExclude, 'arglebargle')
      AND pyh_number = ISNULL(@PayHdrNumberRestrict, pyh_number)
      AND pyh_number <> ISNULL(@PayHdrNumberExclude, -1234567890)
      AND mov_number = ISNULL(@MoveNumberRestrict, mov_number)
      AND pyh_payperiod <> ISNULL(@PayPeriodExclude, @FakeDate)
      AND pyh_payperiod = ISNULL(@PayPeriod, pyh_payperiod)
      AND pyd_pretax = 'Y' 
      AND pyd_minus = 1
	 
    -- Set RETURN values for details
    SELECT  paydetail.mov_number MoveNumber,
            @MoveNumber LookupMove,
            @TotalComp GrossPay,
            @TotalDed TotalDeductiONs,
            @TotalReimburs TotalExpenses,
            CASE ISNULL(pyd_descriptiON,'')
              WHEN '' then pyt_descriptiON	
              ELSE pyd_descriptiON 
            END DescriptiON,	
            pyd_rate Rate, 
            pyd_rateunit RateUnit,
            pyd_quantity Quantity,
            pyd_amount Amount,
            @PayPeriod PayPeriod,
            @TotalQuantity TotalQuantity,
            orderheader.ord_number OrderNumber,
            r1.name RevType1,
            r2.name RevType2,
            r3.name RevType3,
            r4.name RevType4,
            @NetPay NetPay
    FROM paydetail (NOLOCK)
    LEFT OUTER JOIN paytype (NOLOCK) ON paydetail.pyt_itemcode = paytype.pyt_itemcode
    LEFT OUTER JOIN orderheader (NOLOCK) ON paydetail.ord_hdrnumber = orderheader.ord_hdrnumber
    LEFT OUTER JOIN labelfile r1 (NOLOCK) ON orderheader.ord_revtype1 = r1.abbr and r1.labeldefinitiON = 'RevType1'
    LEFT OUTER JOIN labelfile r2 (NOLOCK) ON orderheader.ord_revtype2 = r2.abbr and r2.labeldefinitiON = 'RevType2'
    LEFT OUTER JOIN labelfile r3 (NOLOCK) ON orderheader.ord_revtype3 = r3.abbr and r3.labeldefinitiON = 'RevType3'
    LEFT OUTER JOIN labelfile r4 (NOLOCK) ON orderheader.ord_revtype4 = r4.abbr and r4.labeldefinitiON = 'RevType4'
    WHERE asgn_id = @AssignId AND asgn_type = @AssignType
      AND pyd_status = ISNULL(@PayStatusRestrict, pyd_status)
      AND pyd_status <> ISNULL(@PayStatusExclude, 'arglebargle')
      AND pyh_number = ISNULL(@PayHdrNumberRestrict, pyh_number)
      AND pyh_number <> ISNULL(@PayHdrNumberExclude, -1234567890)
      AND paydetail.mov_number = ISNULL(@MoveNumberRestrict, paydetail.mov_number)
      AND pyh_payperiod <> ISNULL(@PayPeriodExclude, @FakeDate)
      AND pyh_payperiod = ISNULL(@PayPeriod, pyh_payperiod)
      AND paydetail.pyd_amount <> 0
    ORDER BY paydetail.mov_number, pyd_sequence
  END
*/

EXEC dbo.tmail_GetSettlements3 @SPayPeriod, @AssignID, @AssignType, @Collected, @PayStatus, @sMoveNumber 

GO
GRANT EXECUTE ON  [dbo].[tmail_GetSettlements2] TO [public]
GO
