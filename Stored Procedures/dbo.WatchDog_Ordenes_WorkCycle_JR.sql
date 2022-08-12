SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

 CREATE Proc [dbo].[WatchDog_Ordenes_WorkCycle_JR] 
(

    @Umbralasignacion float = 10,
	@TempTableName varchar(255)='##WatchDogOrdenesWorkCycleJR',
	@WatchName varchar(255)='Expira',
	@ThresholdFieldName varchar(255) = '',
	@ColumnNamesOnly bit = 0,
	@ExecuteDirectly bit = 0,
    @FiltroNombre varchar(50) = '',
	@ColumnMode varchar (50) ='Selected'
)
						
As

Set NoCount On

--Reserved/Mandatory WatchDog Variables
Declare @SQL varchar(8000)
Declare @COLSQL varchar(4000)
--Reserved/Mandatory WatchDog Variables





	-- Initialize Temp Table
	

 
            create table #OrdenesWC (fechaproceso datetime , Orden integer, fechacompletada datetime, numtarifa integer, nom_tarifa varchar(20), compañia varchar(12),monto dec(8,2), Resultado varchar(30))
            
            create table #Todisplay (
             fechaproceso datetime 
			 ,Orden integer
			 ,fechacompletada datetime
			 ,numtarifa integer
			 ,nom_tarifa varchar(20)
			 ,compañia varchar(12)
			 ,monto dec(8,2)
			 ,Resultado varchar(30))


Begin
Insert into #OrdenesWC
--	select last_updatedate, ord_hdrnumber, ord_completiondate, tar_number,  tar_tarriffnumber, ord_company,  ord_totalcharge, 'PROCESADA'
 --from orderheader where last_updateby = 'ESTAT' and last_updatedate >= CONVERT(varchar, getdate(), 101) and ord_totalcharge > 0
 --union
select last_updatedate, ord_hdrnumber, ord_completiondate,  tar_number, tar_tarriffnumber, ord_company,  ord_totalcharge, 'NO PROCESADA'
from orderheader 
where ord_totalcharge = 0 
and ord_completiondate >= '2020-01-01' and ord_status = 'CMP' and ord_invoicestatus = 'AVL' and ord_completiondate < CONVERT(varchar, getdate(), 101)
and ord_hdrnumber not in (select ord_hdrnumber from invoiceheader where ivh_invoicestatus = 'XFR' and ord_hdrnumber in(select ord_hdrnumber from orderheader 
where ord_totalcharge = 0 
and ord_completiondate >= '2020-01-01' and ord_status = 'CMP' and ord_invoicestatus = 'AVL' and ord_completiondate < CONVERT(varchar, getdate(), 101)))




---Insertamos los datos en la tabla para desplejarlos
insert into #Todisplay 
	
	Select fechaproceso,Orden,fechacompletada,numtarifa,nom_tarifa,compañia,monto, Resultado
		from #OrdenesWC
           
--mostramos el resultado final de la tabla #todisplay

			select * 
			into 
			#TempResultsa
			from #Todisplay 

	--Commits the results to be used in the wrapper
	If @ColumnNamesOnly = 1 or @ExecuteDirectly = 1
	Begin
		Set @SQL = 'Select * from #TempResultsa'
	End
	Else
	Begin
		Set @COLSQL = ''
		Exec WatchDogColumnNames @WatchName=@WatchName,@ColumnMode=@ColumnMode,@SQLForWatchDog=1,@SELECTCOLSQL = @COLSQL OUTPUT
		Set @SQL = 'Select identity(int,1,1) as RowID ' + @COLSQL + ' into ' + @TempTableName + ' from #TempResultsa'
	End

	Exec (@SQL)
	Set NoCount Off


	

 end

GO
