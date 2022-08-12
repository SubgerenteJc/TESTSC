SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[tmail_routesync_updateBlobRecord_Omnitracs] 
	@lrs_id INT,
	@DateTimeSent SMALLDATETIME = NULL,
	@ResponseCode INT = NULL,
	@ErrorText VARCHAR(500) = NULL,
	@ErrorDateTime SMALLDATETIME = NULL,
	@OmnitracsKey VARCHAR(50) = NULL,	--PTS71605
	@Status INT = NULL					--PTS71605
AS
-- =============================================================================
--	Stored Proc:	dbo.tmail_routesync_updateBlobRecord_Omnitracs
--	Author     :	Rob Scott
--	Create date:	2013.10.28  - PTS 71605
--	Description:	Updates RouteSync record with provided values
--
--	Change Log:
--	2013.10.28	-PTS71605	RRS	Created
--
--		
--	Returns:
--  ROWCOUNT including number of affected records
--
-- =============================================================================

	BEGIN
		SET NOCOUNT OFF

		UPDATE dbo.lgh_routesync 
		SET lrs_date_sent		= ISNULL(@DateTimeSent, lrs_date_sent),
			lrs_response_code	= ISNULL(@ResponseCode, lrs_response_code),
			lrs_error_text		= ISNULL(@ErrorText, lrs_error_text),
			lrs_error_date		= ISNULL(@ErrorDateTime, lrs_error_date),
			lrs_omnitracs_key	= ISNULL(@OmnitracsKey, lrs_omnitracs_key),	--PTS71605
			lrs_status			= ISNULL(lrs_status,0) | ISNULL(@Status,0)	--PTS71605
		WHERE lrs_id = @lrs_id 

		RETURN @@ROWCOUNT
	END
GO
GRANT EXECUTE ON  [dbo].[tmail_routesync_updateBlobRecord_Omnitracs] TO [public]
GO
