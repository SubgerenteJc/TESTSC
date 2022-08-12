SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[Metric_DeudaOperadores] (
	--PARAMETROS ESTANDAR PARA EL CALCULO DE LA METRICA
	@Result decimal(20, 5) OUTPUT, 
	@ThisCount decimal(20, 5) OUTPUT, 
	@ThisTotal decimal(20, 5) OUTPUT, 
	@DateStart datetime, 
	@DateEnd datetime, 
	@UseMetricParms int, 
	@ShowDetail int

	--PARAMETROS PROPIOS DE LA METRICA
   -- @Modo  varchar(20)  = 'RESUELTOS'                     --RESUELTOS,MONTOARREGLO
     
    --  @noproyecto varchar(255) = ''
       

)
AS
	SET NOCOUNT ON  

-- Don't touch the following line. It allows for choices in drill down
-- DETAILOPTIONS=1:Concepto,2:Operador,3:Proyecto,4:Detalle



	--INICIALIZACION DE PARAMETROS PROPIOS DE LA METRICA.
      --Set  @Soloalmacenlista = ',' + ISNULL(@Soloalmacenlista,'') + ','
	--Set @DIVISION= ',' + ISNULL(@DIVISION,'') + ','
	--Set @NOPROYECTO= ',' + ISNULL(@NOPROYECTO,'') + ','


	-- Creación de la tabla temporal

	CREATE TABLE #DeudaOp(Concepto varchar(255), Descripcion varchar(900), Fecha datetime, Operador varchar(600), Flota varchar(200),
    Balance float )
	     
	--Cargamos la tabla temporal con los datos de la consulta de la tabla de litigios

      INSERT INTO #DeudaOp
        
		
		SELECT 

   
    --Asignar valores al numerador y al denominador

    SELECT @ThisCount = (Select sum(Balance) from #DeudaOp  )
 
    SELECT @ThisTotal = CASE  WHEN CONVERT(VARCHAR(10), @DateStart, 121) = CONVERT(VARCHAR(10), @DateEnd, 121) THEN 1  ELSE DATEDIFF(day, @DateStart, @DateEnd) END
    
    --Calculo del valor final de la metrica, resultado 


	SELECT @Result = CASE ISNULL(@ThisTotal, 0) WHEN 0 THEN NULL ELSE @ThisCount / @ThisTotal END

--Vista de resultados detalle

	IF (@ShowDetail=1)  --a nivel del concepto

	BEGIN
		Select 
        Concepto = (select sdm_description    FROM stdmaster  where concepto =  sdm_itemcode),
        Cantidad = '$' + dbo.fnc_TMWRN_FormatNumbers(sum(balance),2)
        from #DeudaOp
        group by Concepto
        order by cast(sum(balance) as int) desc 
	END

 IF (@ShowDetail=2)  --a nivel del operador

	BEGIN
		Select 
        Operador,
        Cantidad = '$' + dbo.fnc_TMWRN_FormatNumbers(sum(balance),2)
        from #DeudaOp
        group by Operador
        order by cast(sum(balance) as int) desc 
	END


 IF (@ShowDetail=3)  --a nivel de Flota

		BEGIN
		Select 
        Flota,
        Cantidad = '$' + dbo.fnc_TMWRN_FormatNumbers(sum(balance),2)
        from #DeudaOp
        group by Flota
        order by cast(sum(balance) as int) desc 
	END




 IF (@ShowDetail=4)  --a nivel de detalle

	BEGIN
		Select 
        Concepto = (select sdm_description    FROM stdmaster  where concepto =  sdm_itemcode),
        Descripcion,
        Fecha,
        Operador,
        Flota,
        Balance = '$' + dbo.fnc_TMWRN_FormatNumbers((balance),2)
        from #DeudaOp
        order by flota, fecha DESC
        
	END

GO