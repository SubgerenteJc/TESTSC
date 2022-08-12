SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[tmail_QhosUpdateLogDriverLogsRec]	
		@mpp_id					VARCHAR(8),		--
		@log_date				DATETIME,		--
		@total_miles			INT,			--
		@log					CHAR(96),		--
		@off_duty_hrs			FLOAT,			--
		@sleeper_berth_hrs		FLOAT,			--
		@driving_hrs			FLOAT,			--
		@on_duty_hrs			FLOAT,			--
		@processed_flag			CHAR(1),		--
		@rule_reset_indc		CHAR(1),		--
		@rule_reset_date		DATETIME,		--
		@rule_est_reset_date	DATETIME,		--
		@eleven_hr_rule			FLOAT,			--
		@fourteen_hr_rule		FLOAT,			--
		@sixty_seventy_hr_rule	FLOAT,			--
		@last_avail_hrs_recalc	DATETIME,		--
		@skip_trigger			BIT = 0			--
AS

-- =============================================================================
-- Stored Proc: tmail_QhosUpdateLogDriverLogsRec
-- Author     :	Sensabaugh, Virgil
-- Create date: 2014.04.25
-- Description:
--      This procedure will update a record in the log_driverlogs table using 
--      data received from Omnitracs Hours of Service web interface.
--      
--      Outputs:
--      ------------------------------------------------------------------------
--      None										--
--
--      Input parameters:
--      ------------------------------------------------------------------------
--		@mpp_id					VARCHAR(8),		--
--		@log_date				DATETIME,		--
--		@total_miles			INT,			--
--		@log					CHAR(96),		--
--		@off_duty_hrs			FLOAT,			--
--		@sleeper_berth_hrs		FLOAT,			--
--		@driving_hrs			FLOAT,			--
--		@on_duty_hrs			FLOAT,			--
--		@processed_flag			CHAR(1),		--
--		@rule_reset_indc		CHAR(1),		--
--		@rule_reset_date		DATETIME,		--
--		@rule_est_reset_date	DATETIME,		--
--		@eleven_hr_rule			FLOAT,			--
--		@fourteen_hr_rule		FLOAT,			--
--		@sixty_seventy_hr_rule	FLOAT,			--
--		@last_avail_hrs_recalc	DATETIME		--
--		@skip_trigger			BIT				--
--
-- =============================================================================
--
-- Revisions:
-- 04/10/2015 - Abdullah Binghunaiem - PTS 71086: Added extra columns which were
--		were created as part of PTS 70026
-- 04/10/2015 - Abdullah Binghunaiem - PTS 71086: Updated the date comparison to
--		account only for dates, not dates and times. 
-- 09/29/2015 - Abdullah Binghunaiem - PTS 94581: Added a skip-trigger flag
-- 10/13/2015 - Abdullah Binghunaiem - PTS 95651: Added an execute statement to update the
--				manpowerprofile.
--

-- Check for nulls
IF 
	@mpp_id = NULL 
BEGIN
	RAISERROR (N'mpp_id cannot be NULL.',10, 1)
END

IF
	@log_date = NULL
BEGIN
	RAISERROR (N'log_date cannot be NULL.',10, 1)
END

IF
	@total_miles = NULL
BEGIN
	RAISERROR (N'total_miles cannot be NULL.',10, 1)
END

IF
	@off_duty_hrs = NULL
BEGIN
	RAISERROR (N'off_duty_hrs cannot be NULL.',10, 1)
END

IF
	@sleeper_berth_hrs = NULL
BEGIN
	RAISERROR (N'sleeper_berth_hrs cannot be NULL.',10, 1)
END

IF
	@driving_hrs = NULL
BEGIN
	RAISERROR (N'driving_hrs cannot be NULL.',10, 1)
END

IF
	@on_duty_hrs = NULL
BEGIN
	RAISERROR (N'on_duty_hrs cannot be NULL.',10, 1)
END

BEGIN	
	--------------------------------------------------------------------------------
	UPDATE dbo.log_driverlogs SET
		total_miles = @total_miles,
		[log] = @log,
		off_duty_hrs = @off_duty_hrs,
		sleeper_berth_hrs = @sleeper_berth_hrs,
		driving_hrs = @driving_hrs,
		on_duty_hrs = @on_duty_hrs,
		processed_flag = @processed_flag,
		rule_reset_indc = @rule_reset_indc,
		rule_reset_date = @rule_reset_date,
		rule_est_reset_date = @rule_est_reset_date,
		eleven_hr_rule = @eleven_hr_rule,
		fourteen_hr_rule = @fourteen_hr_rule,
		sixty_seventy_hr_rule = @sixty_seventy_hr_rule,
		last_avail_hrs_recalc = @last_avail_hrs_recalc,
		skip_trigger = @skip_trigger
	WHERE 
		mpp_id = @mpp_id
		AND
		CAST(log_date AS DATE) = CAST(@log_date AS DATE)
END	

-- PTS 95651 10.13.15 AB Starts
EXEC update_loghours @mpp_id
-- PTS 95651 10.13.15 AB Ends
GO
GRANT EXECUTE ON  [dbo].[tmail_QhosUpdateLogDriverLogsRec] TO [public]
GO
