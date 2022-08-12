SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- Part 2

CREATE PROCEDURE [dbo].[Metric_TractorDispo]
	(
		@Result decimal(20, 5) OUTPUT, 
		@ThisCount decimal(20, 5) OUTPUT, 
		@ThisTotal decimal(20, 5) OUTPUT, 
		@DateStart datetime, 
		@DateEnd datetime, 
		@UseMetricParms int, 
		@ShowDetail int,

	-- Additional / Optional Parameters
		@Numerator varchar(100) = 'Current',			-- Seated, Unseated, Working, Current, Total, OOSJ, OOSM, OOS
		@Denominator varchar(100) = 'Day',			-- Seated, Unseated, Working, Current, Total, Historical, Day
        @Mode varchar(100) = 'Normal',               -- Normal

	-- filtering parameters: includes
		@OnlyRevType1List varchar(255) ='',
		@OnlyRevType2List varchar(255) ='',
		@OnlyRevType3List varchar(255) ='',
		@OnlyRevType4List varchar(255) ='',
		@OnlyBillToList varchar(255) = '',
		@OnlyShipperList varchar(255) = '',
		@OnlyConsigneeList varchar(255) = '',
		@OnlyOrderedByList varchar(255) = '',

	-- filtering parameters: excludes
		@ExcludeRevType1List varchar(255) ='',
		@ExcludeRevType2List varchar(255) ='',
		@ExcludeRevType3List varchar(255) ='',
		@ExcludeRevType4List varchar(255) ='',
		@ExcludeBillToList varchar(255) = '',
		@ExcludeShipperList varchar(255) = '',
		@ExcludeConsigneeList varchar(255) = '',
		@ExcludeOrderedByList varchar(255) = '',

	-- parameters for Numerator Tractor Count ONLY
		@NumeratorOnlyTrcType1List varchar(255) = '',
		@NumeratorOnlyTrcType2List varchar(255) = '',
		@NumeratorOnlyTrcType3List varchar(255) = '',
		@NumeratorOnlyTrcType4List varchar(255) = '',
		@NumeratorOnlyTrcCompanyList varchar(255) = '',
		@NumeratorOnlyTrcDivisionList varchar(255) = '',
		@NumeratorOnlyTrcTerminalList varchar(255) = '',
		@NumeratorOnlyTrcFleetList varchar(255) = '',
		@NumeratorOnlyTrcBranchList varchar(255) = '',

		@NumeratorExcludeTrcType1List varchar(255) = '',
		@NumeratorExcludeTrcType2List varchar(255) = '',
		@NumeratorExcludeTrcType3List varchar(255) = '',
		@NumeratorExcludeTrcType4List varchar(255) = '',
		@NumeratorExcludeTrcCompanyList varchar(255) = '',
		@NumeratorExcludeTrcDivisionList varchar(255) = '',
		@NumeratorExcludeTrcTerminalList varchar(255) = '',
		@NumeratorExcludeTrcFleetList varchar(255) = '',
		@NumeratorExcludeTrcBranchList varchar(255) = '',

	-- parameters for Denominator Tractor Count ONLY
		@DenominatorOnlyTrcType1List varchar(255) = '',
		@DenominatorOnlyTrcType2List varchar(255) = '',
		@DenominatorOnlyTrcType3List varchar(255) = '',
		@DenominatorOnlyTrcType4List varchar(255) = '',
		@DenominatorOnlyTrcCompanyList varchar(255) = '',
		@DenominatorOnlyTrcDivisionList varchar(255) = '',
		@DenominatorOnlyTrcTerminalList varchar(255) = '',
		@DenominatorOnlyTrcFleetList varchar(255) = '',
		@DenominatorOnlyTrcBranchList varchar(255) = '',

		@DenominatorExcludeTrcType1List varchar(255) = '',
		@DenominatorExcludeTrcType2List varchar(255) = '',
		@DenominatorExcludeTrcType3List varchar(255) = '',
		@DenominatorExcludeTrcType4List varchar(255) = '',
		@DenominatorExcludeTrcCompanyList varchar(255) = '',
		@DenominatorExcludeTrcDivisionList varchar(255) = '',
		@DenominatorExcludeTrcTerminalList varchar(255) = '',
		@DenominatorExcludeTrcFleetList varchar(255) = '',
		@DenominatorExcludeTrcBranchList varchar(255) = '',

		@MetricCode varchar(500)= 'TractorCount'
	)
AS

	SET NOCOUNT ON

-- Don't touch the following line. It allows for choices in drill down
-- DETAILOPTIONS=1:No Disponibles,2:Disponibles

	SET @OnlyRevType1List= ',' + ISNULL(@OnlyRevType1List,'') + ','
	SET @OnlyRevType2List= ',' + ISNULL(@OnlyRevType2List,'') + ','
	SET @OnlyRevType3List= ',' + ISNULL(@OnlyRevType3List,'') + ','
	SET @OnlyRevType4List= ',' + ISNULL(@OnlyRevType4List,'') + ','

	Set @OnlyBillToList= ',' + ISNULL(@OnlyBillToList,'') + ','
	Set @OnlyShipperList= ',' + ISNULL(@OnlyShipperList,'') + ','
	Set @OnlyConsigneeList= ',' + ISNULL(@OnlyConsigneeList,'') + ','
	Set @OnlyOrderedByList= ',' + ISNULL(@OnlyOrderedByList,'') + ','

	SET @ExcludeRevType1List= ',' + ISNULL(@ExcludeRevType1List,'') + ','
	SET @ExcludeRevType2List= ',' + ISNULL(@ExcludeRevType2List,'') + ','
	SET @ExcludeRevType3List= ',' + ISNULL(@ExcludeRevType3List,'') + ','
	SET @ExcludeRevType4List= ',' + ISNULL(@ExcludeRevType4List,'') + ','

	Set @ExcludeBillToList= ',' + ISNULL(@ExcludeBillToList,'') + ','
	Set @ExcludeShipperList= ',' + ISNULL(@ExcludeShipperList,'') + ','
	Set @ExcludeConsigneeList= ',' + ISNULL(@ExcludeConsigneeList,'') + ','
	Set @ExcludeOrderedByList= ',' + ISNULL(@ExcludeOrderedByList,'') + ','

	Set @NumeratorOnlyTrcType1List= ',' + ISNULL(@NumeratorOnlyTrcType1List,'') + ','
	Set @NumeratorOnlyTrcType2List= ',' + ISNULL(@NumeratorOnlyTrcType2List,'') + ','
	Set @NumeratorOnlyTrcType3List= ',' + ISNULL(@NumeratorOnlyTrcType3List,'') + ','
	Set @NumeratorOnlyTrcType4List= ',' + ISNULL(@NumeratorOnlyTrcType4List,'') + ','
	Set @NumeratorOnlyTrcCompanyList= ',' + ISNULL(@NumeratorOnlyTrcCompanyList,'') + ','
	Set @NumeratorOnlyTrcDivisionList= ',' + ISNULL(@NumeratorOnlyTrcDivisionList,'') + ','
	Set @NumeratorOnlyTrcTerminalList= ',' + ISNULL(@NumeratorOnlyTrcTerminalList,'') + ','
	Set @NumeratorOnlyTrcFleetList= ',' + ISNULL(@NumeratorOnlyTrcFleetList,'') + ','
	Set @NumeratorOnlyTrcBranchList= ',' + ISNULL(@NumeratorOnlyTrcBranchList,'') + ','

	Set @NumeratorExcludeTrcType1List= ',' + ISNULL(@NumeratorExcludeTrcType1List,'') + ','
	Set @NumeratorExcludeTrcType2List= ',' + ISNULL(@NumeratorExcludeTrcType2List,'') + ','
	Set @NumeratorExcludeTrcType3List= ',' + ISNULL(@NumeratorExcludeTrcType3List,'') + ','
	Set @NumeratorExcludeTrcType4List= ',' + ISNULL(@NumeratorExcludeTrcType4List,'') + ','
	Set @NumeratorExcludeTrcCompanyList= ',' + ISNULL(@NumeratorExcludeTrcCompanyList,'') + ','
	Set @NumeratorExcludeTrcDivisionList= ',' + ISNULL(@NumeratorExcludeTrcDivisionList,'') + ','
	Set @NumeratorExcludeTrcTerminalList= ',' + ISNULL(@NumeratorExcludeTrcTerminalList,'') + ','
	Set @NumeratorExcludeTrcFleetList= ',' + ISNULL(@NumeratorExcludeTrcFleetList,'') + ','
	Set @NumeratorExcludeTrcBranchList= ',' + ISNULL(@NumeratorExcludeTrcBranchList,'') + ','

	Set @DenominatorOnlyTrcType1List= ',' + ISNULL(@DenominatorOnlyTrcType1List,'') + ','
	Set @DenominatorOnlyTrcType2List= ',' + ISNULL(@DenominatorOnlyTrcType2List,'') + ','
	Set @DenominatorOnlyTrcType3List= ',' + ISNULL(@DenominatorOnlyTrcType3List,'') + ','
	Set @DenominatorOnlyTrcType4List= ',' + ISNULL(@DenominatorOnlyTrcType4List,'') + ','
	Set @DenominatorOnlyTrcCompanyList= ',' + ISNULL(@DenominatorOnlyTrcCompanyList,'') + ','
	Set @DenominatorOnlyTrcDivisionList= ',' + ISNULL(@DenominatorOnlyTrcDivisionList,'') + ','
	Set @DenominatorOnlyTrcTerminalList= ',' + ISNULL(@DenominatorOnlyTrcTerminalList,'') + ','
	Set @DenominatorOnlyTrcFleetList= ',' + ISNULL(@DenominatorOnlyTrcFleetList,'') + ','
	Set @DenominatorOnlyTrcBranchList= ',' + ISNULL(@DenominatorOnlyTrcBranchList,'') + ','

	Set @DenominatorExcludeTrcType1List= ',' + ISNULL(@DenominatorExcludeTrcType1List,'') + ','
	Set @DenominatorExcludeTrcType2List= ',' + ISNULL(@DenominatorExcludeTrcType2List,'') + ','
	Set @DenominatorExcludeTrcType3List= ',' + ISNULL(@DenominatorExcludeTrcType3List,'') + ','
	Set @DenominatorExcludeTrcType4List= ',' + ISNULL(@DenominatorExcludeTrcType4List,'') + ','
	Set @DenominatorExcludeTrcCompanyList= ',' + ISNULL(@DenominatorExcludeTrcCompanyList,'') + ','
	Set @DenominatorExcludeTrcDivisionList= ',' + ISNULL(@DenominatorExcludeTrcDivisionList,'') + ','
	Set @DenominatorExcludeTrcTerminalList= ',' + ISNULL(@DenominatorExcludeTrcTerminalList,'') + ','
	Set @DenominatorExcludeTrcFleetList= ',' + ISNULL(@DenominatorExcludeTrcFleetList,'') + ','
	Set @DenominatorExcludeTrcBranchList= ',' + ISNULL(@DenominatorExcludeTrcBranchList,'') + ','

	Declare @NumeratorList Table (lgh_tractor varchar(12))
	Declare @DenominatorList Table (lgh_tractor varchar(12))


----------NUMERADOR CUENTA TRACTORES CURRENT----------------------------------------------------------------------------------------------------------------------------



			Insert into @NumeratorList (lgh_tractor)
			Select  substring(tractor,1,10)
			from dbo.fnc_TMWRN_TractorCount3 
					(
						@Numerator,@NumeratorOnlyTrcType1List,@NumeratorOnlyTrcType2List
						,@NumeratorOnlyTrcType3List,@NumeratorOnlyTrcType4List
						,@NumeratorOnlyTrcCompanyList,@NumeratorOnlyTrcDivisionList
						,@NumeratorOnlyTrcTerminalList,@NumeratorOnlyTrcFleetList,@NumeratorOnlyTrcBranchList
						,@NumeratorExcludeTrcType1List,@NumeratorExcludeTrcType2List
						,@NumeratorExcludeTrcType3List,@NumeratorExcludeTrcType4List
						,@NumeratorExcludeTrcCompanyList,@NumeratorExcludeTrcDivisionList
						,@NumeratorExcludeTrcTerminalList,@NumeratorExcludeTrcFleetList
						,@NumeratorExcludeTrcBranchList,@DateStart
					)
	


----------DENOMINADOR CUENTA TRACTORES TOTAL-----------------------------------------------------------------------------------------------------------------------------


			Insert into @DenominatorList (lgh_tractor)
			Select substring(Tractor,1,10)
			from dbo.fnc_TMWRN_TractorCount3 
				(
					@Denominator,@DenominatorOnlyTrcType1List,@DenominatorOnlyTrcType2List
					,@DenominatorOnlyTrcType3List,@DenominatorOnlyTrcType4List
					,@DenominatorOnlyTrcCompanyList,@DenominatorOnlyTrcDivisionList
					,@DenominatorOnlyTrcTerminalList,@DenominatorOnlyTrcFleetList,@DenominatorOnlyTrcBranchList
					,@DenominatorExcludeTrcType1List,@DenominatorExcludeTrcType2List
					,@DenominatorExcludeTrcType3List,@DenominatorExcludeTrcType4List
					,@DenominatorExcludeTrcCompanyList,@DenominatorExcludeTrcDivisionList
					,@DenominatorExcludeTrcTerminalList,@DenominatorExcludeTrcFleetList
					,@DenominatorExcludeTrcBranchList,@DateStart
				)
	


---------ASIGNACION DE LOS RESULTADOS A LAS VARIBLES TOTALES TRACTOR COUNT----------------------------------------------------------------------------------------------------------------------------

	-- set the Metric Numerator & Denominator values
	Set @ThisCount = (Select count(lgh_tractor) from @NumeratorList)
    
 
       

	Set @ThisTotal =
		Case When @Denominator = 'Day' then 
			CASE 
				WHEN CONVERT(VARCHAR(10), @DateStart, 121) = CONVERT(VARCHAR(10), @DateEnd, 121) THEN 1 
			ELSE 
				DATEDIFF(day, @DateStart, @DateEnd) 
			END
		Else
			(Select count(lgh_tractor) from @DenominatorList)
		End

	SELECT @Result = CASE ISNULL(@ThisTotal, 0) WHEN 0 THEN NULL ELSE @ThisCount / @ThisTotal END 

-----------------VISTA DETALLES DE LA METRICA TRACTOR COUNT-----------------------------------------------------------------------------------------------------------------------------------------

-----------------TRACTORES INACTIVOS----------------------------------------------------------------------------------------------------------------------------------------------------------------


  IF @ShowDetail = 1
		BEGIN
			Select
            Tractor = lgh_tractor,
            DiasInactivo = (select  datediff(d,exp_creatdate,getdate())  from expiration with (nolock)  where exp_id = lgh_tractor and exp_Completed = 'N' 
            and  exp_key = (select max(exp_key) from expiration with (nolock)  where exp_id = lgh_tractor and exp_Completed = 'N')),

            Flota = (select name from labelfile with (nolock)  where labelfile.labeldefinition = 'Fleet' and abbr = (select trc_fleet from tractorprofile with (nolock)  where tractorprofile.trc_number = lgh_tractor)),
            Division = (select trc_type4 from tractorprofile with (nolock)  where lgh_tractor = tractorprofile.trc_number),
            Operador = replace((select trc_driver from tractorprofile with (nolock)  where lgh_tractor = tractorprofile.trc_number),'UNKNOWN','SIN OP.'),
            Razon = ( select name from labelfile with (nolock)  where labeldefinition = 'TrcExp' and abbr = (select  exp_code from expiration with (nolock)  where exp_id = lgh_tractor and exp_Completed = 'N' 
            and  exp_key = (select max(exp_key) from expiration with (nolock) where exp_id = lgh_tractor and exp_Completed = 'N'))),
            ComentarioTMW = (select  exp_description from expiration with (nolock)  where exp_id = lgh_tractor and exp_Completed = 'N' 
            and  exp_key = (select max(exp_key) from expiration with (nolock) where exp_id = lgh_tractor and exp_Completed = 'N')),
            Ubicacion  = (select trc_gps_desc from tractorprofile with (nolock)  where lgh_tractor = tractorprofile.trc_number)

			From @DenominatorList where lgh_tractor not in (Select Tractor = lgh_tractor From @NumeratorList) 
            and (select name from labelfile with (nolock)  where labelfile.labeldefinition = 'Fleet' and abbr = (select trc_fleet from tractorprofile with (nolock)  where tractorprofile.trc_number = lgh_tractor)) <> '17'
            Order by   DiasInactivo desc
		END


-----------------TRACTORES TRABAJANDO----------------------------------------------------------------------------------------------------------------------------------------------------------------
  
	ELSE If @ShowDetail = 2
		BEGIN
			Select 
            Tractor = lgh_tractor, 
           -- Orden = isnull((select max(ord_number) from orderheader where ord_tractor = lgh_tractor and year(ord_startdate) = year(getdate())  and ord_number <'A' ),'Inactivo'),
            Flota = (select name from labelfile with (nolock)  where labelfile.labeldefinition = 'Fleet' and abbr = (select trc_fleet from tractorprofile with (nolock)  where tractorprofile.trc_number = lgh_tractor)),
            Division = (select trc_type4 from tractorprofile with (nolock)  where lgh_tractor = tractorprofile.trc_number),
            Operador = replace((select trc_driver from tractorprofile with (nolock) where lgh_tractor = tractorprofile.trc_number),'UNKNOWN','SIN OP.'),
            Ubicacion = (select trc_gps_desc from tractorprofile with (nolock)  where lgh_tractor = tractorprofile.trc_number)
			From @NumeratorList

            order by lgh_tractor desc
		END



	SET NOCOUNT OFF




-- Part 3

	/* NOTE: This SQL is used by MetricProcessing to automatically generate an new metric item in a category called NewItems.
	<METRIC-INSERT-SQL>

	EXEC MetricInitializeItem
		@sMetricCode = 'TractorCount',
		@nActive = 0,	-- 1=active, 0=inactive.
		@nSort = 112, 	-- Used to determine the sort order that updates should be run.
		@sFormatText = '',	-- Typically 'PCT' or blank ('').
		@nNumDigitsAfterDecimal = 0,
		@nPlusDeltaIsGood = 1,
		@nCumulative = 0,
		@sCaption = 'Tractor Count Metrics',
		@sCaptionFull = 'Tractor Count Metrics',
		@sProcedureName = 'Metric_TractorCount',
		@sCachedDetailYN = '',
		@nCacheRefreshAgeMaxMinutes = 0,
		@sShowDetailByDefaultYN = 'N', -- Typically 'N'
		@sRefreshHistoryYN = '',	-- Typically 'N'
		@sCategory = null

	</METRIC-INSERT-SQL>
	*/

GO
