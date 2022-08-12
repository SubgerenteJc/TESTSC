SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

-- WatchDogProcessing 'TrailerCommodity' ,1

CREATE PROC [dbo].[WatchDog_TrailerCommodity]           
	(
		@MinThreshold FLOAT = 0, -- not used
		@MinsBack INT=-20,	     -- not used	
		@TempTableName VARCHAR(255) = '##WatchDogGlobalTrailerCommodity',
		@WatchName VARCHAR(255)='WatchTrailerCommodity',
		@ThresholdFieldName VARCHAR(255) = null,
		@ColumnNamesOnly bit = 0,
		@ExecuteDirectly bit = 0,
		@ColumnMode VARCHAR(50) = 'Selected',
		@CompanyIDList VARCHAR(255)='',
		@TrailerLoadStatus VARCHAR(15)='', --MT,LD,UNK
		@TrlType1 VARCHAR(255)='',
		@TrlType2 VARCHAR(255)='',
		@TrlType3 VARCHAR(255)='',
		@TrlType4 VARCHAR(255)='',
		@TrlFleet VARCHAR(255)='',
		@TrlDivision VARCHAR(255)='',
		@TrlCompany VARCHAR(255)='',
		@TrlTerminal VARCHAR(255)='',
		@TeamLeader VARCHAR(255)='',
		@OnlyTrlOwner VARCHAR(255)=''
 	)
						
AS
	
	SET NOCOUNT ON
	
	/***************************************************************
	Procedure Name:    WatchDog_TrailerCommodity
	Author/CreateDate: David Wilks / 3-31-2006
	Purpose: 	   	Provides a list of trailers in the company yard
					along with a loaded status and last commodity
	Revision History:	
	****************************************************************/
	
	--Reserved/Mandatory WatchDog Variables
	Declare @SQL VARCHAR(8000)
	Declare @COLSQL VARCHAR(4000)
	--Reserved/Mandatory WatchDog Variables
	
	--Standard Parameter Initialization
	SET @TrlType1= ',' + ISNULL(@TrlType1,'') + ','
	SET @TrlType2= ',' + ISNULL(@TrlType2,'') + ','
	SET @TrlType3= ',' + ISNULL(@TrlType3,'') + ','
	SET @TrlType4= ',' + ISNULL(@TrlType4,'') + ','
	
	SET @TrlTerminal = ',' + ISNULL(@TrlTerminal,'') + ','
	SET @TrlCompany = ',' + ISNULL(@TrlCompany,'') + ','
	SET @TrlFleet = ',' + ISNULL(@TrlFleet,'') + ','
	SET @TrlDivision = ',' + ISNULL(@TrlDivision,'') + ','
	SET @TeamLeader = ',' + ISNULL(@TeamLeader,'') + ','
	SET @OnlyTrlOwner = ',' + ISNULL(@OnlyTrlOwner,'') + ','
	SET @CompanyIDLIst = ',' + ISNULL(@CompanyIDLIst,'') + ','
	SET @TrailerLoadStatus = ',' + ISNULL(@TrailerLoadStatus,'') + ','

	
	/****************************************************************************
		Create temp table #TempResults where the following conditions are met:
		The last assignment is the assignment of type 'TRL' with the maximum
		end date.
	
	*****************************************************************************/
	SELECT  
		trl_number AS [Trailer ID],
		trl_status AS [Trailer Status],
		LegHeader.mov_number AS Movement,
	    lgh_driver1 AS [Driver],
		mpp_teamleader as [Team Leader],
	    lgh_tractor AS [Tractor ID],
		
	    'Origin Company' = 	(
								SELECT TOP 1 Company.cmp_name 
								FROM Company (NOLOCK)
								WHERE legheader.cmp_id_start = Company.cmp_id
							), 
		'Origin City State' =	(
									SELECT City.cty_name + ', '+ City.cty_state 
									FROM City (NOLOCK)
									WHERE legheader.lgh_startcity = City.cty_code
								),
	    lgh_startdate AS 'Segment Start Date',
		lgh_enddate AS 'Segment End Date',
		'Trailer Start Event' = (
				SELECT TOP 1 stp_event 
				FROM stops (NOLOCK)
				WHERE stops.lgh_number = legheader.lgh_number 
					AND stp_arrivaldate = (
						SELECT MIN(stp_arrivaldate)
						FROM stops (NOLOCK)
						WHERE stops.lgh_number = legheader.lgh_number 
							AND stops.trl_id = trl_number
					)ORDER BY stp_number
			),
		'Trailer End Event' = (
				SELECT TOP 1 stp_event 
				FROM stops (NOLOCK)
				WHERE stops.lgh_number = legheader.lgh_number 
					AND stp_arrivaldate = (
						SELECT MAX(stp_arrivaldate)
						FROM stops (NOLOCK)
						WHERE stops.lgh_number = legheader.lgh_number 
							AND stops.trl_id = trl_number
					) ORDER BY stp_number desc
			),
		'Trailer Origin City State' = (
				SELECT TOP 1 cty_name + ', ' + cty_state
				FROM stops (NOLOCK), city (NOLOCK)
				WHERE stops.stp_city = city.cty_code
					AND stops.lgh_number = legheader.lgh_number 
					AND stp_arrivaldate = (
						SELECT MIN(stp_arrivaldate)
						FROM stops (NOLOCK) ,event (NOLOCK) 
						WHERE stops.lgh_number = legheader.lgh_number 
							And
						      event.stp_number = stops.stp_number
							  And
							  evt_sequence = 1
							  And
							  (evt_trailer1 = trl_number Or evt_trailer2 = trl_number) 
							  and stp_status = 'DNE'
					)ORDER BY stp_number
			),
		'Trailer City State' = (
				SELECT cty_name + ', ' + cty_state
				FROM event (NOLOCK), stops (NOLOCK), city (NOLOCK)
				WHERE evt_number = E.evt_number
					And event.stp_number = stops.stp_number
					AND stops.stp_city = city.cty_code
					
			),
		'Trailer Region' = (
				SELECT stp_region1
				FROM event (NOLOCK), stops (NOLOCK)
				WHERE evt_number = E.evt_number
					And event.stp_number = stops.stp_number
			),
		'Trailer Company' = (
				SELECT stops.cmp_name
				FROM event (NOLOCK), stops (NOLOCK), city (NOLOCK)
				WHERE evt_number = E.evt_number
					And event.stp_number = stops.stp_number
					AND stops.stp_city = city.cty_code		
			),
		'Trailer Company ID' = (
				SELECT stops.cmp_id
				FROM event (NOLOCK), stops (NOLOCK), city (NOLOCK)
				WHERE evt_number = E.evt_number
					And event.stp_number = stops.stp_number
					AND stops.stp_city = city.cty_code		

					
			),
		'Trailer Loaded Status' = dbo.fnc_TMWRN_TrailerLoadedStatus(trl_number, default),
		'Last Trailer Commodity' = dbo.fnc_TMWRN_TrailerCommodityList(trl_number, default, Assetassignment.mov_number, default),
	    Asgn_enddate AS 'Assignment End Date',
		trl_type1 as [TrlType1],
		trl_type2 as [TrlType2],
		trl_type3 as [TrlType3],
		trl_type4 as [TrlType4],
		trl_fleet as [TrlFleet],
		trl_terminal as [TrlTerminal],
	    'Destination Company' =	ISNULL((
									select cmp_name 
									from stops (NOLOCK)
									where stp_number in	(	select top 1 stp_number
															from stops (NOLOCK) 
															where stops.lgh_number = legheader.lgh_number
															--and stp_status = 'DNE' 
															order by stp_arrivaldate desc
														)
								),'UNKNOWN'),
		
		
	    'Destination City State' = 	ISNULL((
										select city.cty_name + ', '+ City.cty_state 
										from stops (NOLOCK), city (NOLOCK) 
										where stp_number in	(	select top 1 stp_number
																from stops (NOLOCK)  
																where stops.lgh_number = legheader.lgh_number
																--	and stp_status = 'DNE' 
																order by stp_arrivaldate desc
															)
											AND city.cty_code = stops.stp_city
									),'UNKNOWN')

	INTO #TempResults
	FROM 
		(
		SELECT 
			trl_number, 
			trl_status,
	      	'MaxAsgnNumber'= (
								SELECT MAX(asgn_number) 
								FROM assetassignment a (NOLOCK)
								WHERE trl_number=asgn_id
									AND asgn_type = 'TRL'
									AND asgn_enddate = (
															SELECT MAX(b.asgn_enddate) 
															FROM assetassignment b (NOLOCK) 
															WHERE (b.asgn_type = 'TRL'
																	AND a.asgn_id = b.asgn_id)
														)
	
							)
		FROM TrailerProfile (NOLOCK)
		WHERE trl_number<>'UNKNOWN'	
			AND trl_retiredate > GETDATE() 
			AND (@TrlType1 =',,' OR CHARINDEX(',' + trl_type1 + ',', @TrlType1) >0)
	        AND (@TrlType2 =',,' OR CHARINDEX(',' + trl_type2 + ',', @TrlType2) >0)
	        AND (@TrlType3 =',,' OR CHARINDEX(',' + trl_type3 + ',', @TrlType3) >0)
	        AND (@TrlType4 =',,' OR CHARINDEX(',' + trl_type4 + ',', @TrlType4) >0)
			AND (@TrlTerminal =',,' OR CHARINDEX(',' + trl_terminal + ',', @TrlTerminal) >0)
	        AND (@TrlFleet =',,' OR CHARINDEX(',' + trl_fleet + ',', @TrlFleet) >0)
	        AND (@TrlCompany =',,' OR CHARINDEX(',' + trl_company + ',', @TrlCompany) >0)
	        AND (@TrlDivision =',,' OR CHARINDEX(',' + trl_division + ',', @TrlDivision) >0) 
	        AND (@OnlyTrlOwner =',,' OR CHARINDEX(',' + trl_owner + ',', @OnlyTrlOwner) >0)
			AND ISNULL(dbo.fnc_TMWRN_TotalTractorExpirations(GETDATE(),GETDATE(),trl_number,'OUT'),0) <= 0
	
		) AS TempInactivity 
		LEFT JOIN Assetassignment (NOLOCK) ON TempInactivity.MaxAsgnNumber =Assetassignment.Asgn_number
	    LEFT JOIN LegHeader (NOLOCK) ON Assetassignment.lgh_number = LegHeader.lgh_number
		LEFT Join Event E (NOLOCK) ON Assetassignment.last_evt_number = E.evt_number 	 
	WHERE  (@TeamLeader =',,' OR CHARINDEX(',' + mpp_teamleader + ',', @TeamLeader) >0)
	
		
	IF @CompanyIDLIst <>',,'
		DELETE from #TempResults WHERE (CHARINDEX(',' + [Trailer Company ID] + ',', @CompanyIDLIst) =0)

--select * from #TempResults Where [Trailer Company] <> [Destination Company] 

	IF @TrailerLoadStatus <>',,'
		DELETE from #TempResults WHERE (CHARINDEX(',' + [Trailer Loaded Status] + ',', @TrailerLoadStatus) =0)

	
	--Commits the results to be used in the wrapper
	IF @ColumnNamesOnly = 1 OR @ExecuteDirectly = 1
	BEGIN
		SET @SQL = 'SELECT * FROM #TempResults'
	END
	ELSE
	BEGIN
		SET @COLSQL = ''
		EXEC WatchDogColumnNames @WatchName=@WatchName,@ColumnMode=@ColumnMode,@SQLForWatchDog=1,@SELECTCOLSQL = @COLSQL OUTPUT
		SET @SQL = 'SELECT identity(INT,1,1) AS RowID ' + @COLSQL + ' INTO ' + @TempTableName + ' FROM #TempResults'
	END
	
	EXEC (@SQL)
	
	SET NOCOUNT OFF
	
GO
GRANT EXECUTE ON  [dbo].[WatchDog_TrailerCommodity] TO [public]
GO
