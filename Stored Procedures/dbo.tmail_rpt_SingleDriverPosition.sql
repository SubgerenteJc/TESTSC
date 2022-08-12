SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[tmail_rpt_SingleDriverPosition]	@DispSysDriverID varchar(8),
							@IncludeRetired int

AS

SET NOCOUNT ON 

DECLARE @WorkDate datetime,
	@WorkDir varchar (3),
	@WorkMilesFrom float,
	@WorkIgnition char (1),
	@WorkCity varchar (16),
	@WorkLat int,
	@WorkLong int,
	@WorkState varchar (6),
	@WorkComment varchar (254),
	@Failed int

/***** CHANGE LOG
 * 05/01/03 MZ: TMWSuite based Single driver position 
 * 08/20/2012 - PTS60626 - APC - checkcall fields char to varchar
****************************************************************/

-- Create temp table to hold results
CREATE TABLE dbo.#Fleet (ckc_driver varchar(8),
			 ckc_date datetime,
			 ckc_milesfrom float,
			 ckc_directionfrom varchar(3),
			 ckc_vehicleignition char(1),
			 ckc_latseconds int,
			 ckc_longseconds int,
			 ckc_cityname varchar(16),
			 ckc_state varchar(6),
			 ckc_commentlarge varchar(254))

SELECT @Failed = 0
	
-- Get the last position report for this tractor
SELECT @WorkDate = ISNULL(MAX(ckc_date), '19500101')
FROM dbo.checkcall (NOLOCK)
WHERE ckc_asgnid = @DispSysDriverID
	AND ckc_asgntype = 'DRV'
	AND ckc_event = 'TRP'

IF (@WorkDate <> '19500101')
  BEGIN
	SELECT  @WorkDir = ISNULL(ckc_directionfrom, 'Z'),
		@WorkMilesFrom = ISNULL(ckc_milesfrom, 0),
		@WorkIgnition = ISNULL(ckc_vehicleignition, ''),
		@WorkCity = ISNULL(ckc_cityname, ''),
		@WorkLat = ISNULL(ckc_latseconds, 0),
		@WorkLong = ISNULL(ckc_longseconds, 0),
		@WorkState = ISNULL(ckc_state, ''),
		@WorkComment = ISNULL(ckc_commentlarge, '') 
	FROM dbo.checkcall (NOLOCK)
	WHERE ckc_asgnid = @DispSysDriverID
		AND ckc_asgntype = 'DRV'
		AND ckc_event = 'TRP'
		AND ckc_date = @WorkDate

	-- If the last position was no good, or was a fuel purchase record,
	-- keep trying to find a valid checkcall
	WHILE @WorkDir = 'Z' OR @WorkDir = 'BAD'
	  BEGIN
		SELECT @WorkDate = ISNULL(MAX(ckc_date),'19500101')
		FROM dbo.checkcall (NOLOCK)
		WHERE ckc_asgnid = @DispSysDriverId
			AND ckc_asgntype = 'DRV'
			AND ckc_event = 'TRP'
			AND ckc_date < @WorkDate

		IF @WorkDate <> '19500101'
		  BEGIN
			SELECT  @WorkDir = ISNULL(ckc_directionfrom, 'Z'),
				@WorkMilesFrom = ISNULL(ckc_milesfrom, 0),
				@WorkIgnition = ISNULL(ckc_vehicleignition, ''),
				@WorkCity = ISNULL(ckc_cityname, ''),
				@WorkLat = ISNULL(ckc_latseconds, 0),
				@WorkLong = ISNULL(ckc_longseconds, 0),
				@WorkState = ISNULL(ckc_state, ''),
				@WorkComment = ISNULL(ckc_commentlarge, '')
			FROM dbo.checkcall (NOLOCK)
			WHERE ckc_asgnid = @DispSysDriverId
				AND ckc_asgntype = 'DRV'
				AND ckc_event = 'TRP'
				AND ckc_date = @WorkDate
		  END
		ELSE
		  BEGIN
			-- Couldn't find a valid checkcall, so fail for this driver
			SELECT @Failed = 1	
			BREAK
		  END
	  END

	IF @Failed = 0
		-- Got a valid checkcall so add it to our temp table
		INSERT INTO dbo.#Fleet     (ckc_driver,
					ckc_date,
					ckc_milesfrom,
					ckc_directionfrom,
					ckc_vehicleignition,
					ckc_cityname,
					ckc_state,
					ckc_latseconds,
					ckc_longseconds,
					ckc_commentlarge)
		VALUES (@DispSysDriverId,
			@WorkDate,
			@WorkMilesFrom,
			@WorkDir,
			@WorkIgnition,
			@WorkCity,
			@WorkState,
			@WorkLat,
			@WorkLong,
			@WorkComment)
	ELSE	
		SELECT @Failed = 0	-- Reset failure flag

	IF @IncludeRetired = 0
		-- Delete any drivers that are retired if @IncludeRetired = 1
		DELETE dbo.#Fleet
		FROM dbo.#Fleet, dbo.manpowerprofile
		WHERE dbo.#Fleet.ckc_driver = dbo.manpowerprofile.mpp_id
			AND dbo.manpowerprofile.mpp_status = 'OUT'
  END

-- Pull all the results
SELECT  ckc_driver,
	CONVERT(VARCHAR(26), ckc_date) as ckc_date,
	ckc_milesfrom,
	ckc_directionfrom,
	ckc_vehicleignition,
	ckc_cityname,
	ckc_state,
	ckc_commentlarge,
	ckc_latseconds,
	ckc_longseconds
FROM dbo.#Fleet
GO
GRANT EXECUTE ON  [dbo].[tmail_rpt_SingleDriverPosition] TO [public]
GO
