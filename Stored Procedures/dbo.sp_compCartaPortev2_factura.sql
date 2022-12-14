SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
Autor: Juan Ramon Lopez
Fecha: 5 Mayo 2022 10:217 hrs
Version 2.0


Stored Proc que arma la cadena para formar el txt
de uan carta porte desarrolado con base al layout  Carta porte de Tralix

Recibe como parametro el numero de de legheader
dado que en una orden segmentado son varios los recursos involucrados.


Sentencia de prueba


[sp_compCartaPortev2_factura] 'A1313730'

*/

CREATE proc [dbo].[sp_compCartaPortev2_factura]  @invoiceNumber varchar(20)

as
declare @lgh_hdrnumber varchar(20),
@ord_hdrnumber int,
@num_factura int
select @num_factura = cast(@invoiceNumber as int)

select @ord_hdrnumber = ord_hdrnumber from invoiceheader where ivh_hdrnumber = @num_factura

-- obtengo el segmento que se encuentra con estatus STD

select @lgh_hdrnumber = isnull(min(lgh_number),0) from legheader where ord_hdrnumber = @ord_hdrnumber 

if @lgh_hdrnumber = 0 return
declare @li_num_mov integer,
@numrenglon integer,
@cantidadConceptos integer,
@totalconceptos money
--@numeroInvoice integer
declare  @matpeligroso  integer

-- select para saber si tiene mat peligroso
select @matpeligroso = count(cat.cat_peligroso)
from commodity as com, cat_mercancia_sat_jr as cat where 
com.cmd_code = cat.cat_cmd_code and
com.cmd_code in (
select cmd_code from invoicedetail where cht_itemcode = 'DEL' and ivh_hdrnumber = @num_factura)
and cat.cat_peligroso = '0,1'





select @numrenglon = 1

--select @numeroInvoice = SUBSTRING(@invoiceNumber,2,7) 

create table #conceptosfactura2(TT2_cht_itemcode varchar(6), TT2_cht_description varchar(30), 
TT2_ivd_description varchar(60),TT2_ivd_charge money,TT2_ivd_taxable1 char(1), TT2_ivd_taxable2 char(1), TT2_ivd_number int,
TT2_remark varchar(254),TT2_cantidad float, TT2_rate money,TT2_unidadSat varchar(50),TT2_consecutivo int identity)

	insert into #conceptosfactura2(TT2_cht_itemcode, TT2_cht_description , TT2_ivd_description ,TT2_ivd_charge 
	,TT2_ivd_taxable1, TT2_ivd_taxable2 , TT2_ivd_number , TT2_remark, TT2_cantidad, TT2_rate, TT2_UnidadSat )

	select invd.cht_itemcode, cht_description, invd.ivd_description,invd.ivd_charge,
	invd.ivd_taxable1, invd.ivd_taxable2 , invd.ivd_number, cht_remark,	invd.ivd_quantity, invd.ivd_rate, cwt.UnidadSat
	from invoicedetail invd,  chargetype cht,catWhenThen cwt
	where invd.cht_itemcode = cht.cht_itemcode
	and cwt.cWhen = cht_description
	and invd.ivh_hdrnumber = @num_factura and cht.cht_itemcode not in ('LHF','DEL','VIAJE','PESO')
	order by invd.ivd_number
	-- suma el iva total de c/u de los conceptos
	DECLARE @montoconcepto money, @taxiva char(1), @taxretencion char(1), @totaliva money, @totalretencion money
	set @totaliva =0
	set @totalretencion = 0
	set @totalconceptos = 0
	DECLARE MY_CURSOR CURSOR 
	  LOCAL STATIC READ_ONLY FORWARD_ONLY
	FOR 
	SELECT TT2_ivd_charge ,TT2_ivd_taxable1, TT2_ivd_taxable2 
	FROM #conceptosfactura2
	Where TT2_cht_itemcode not in ('GST','PST')

	OPEN MY_CURSOR
	FETCH NEXT FROM MY_CURSOR INTO @montoconcepto,@taxiva,@taxretencion
	WHILE @@FETCH_STATUS = 0
	BEGIN 
		--Do something with Id here
		if @taxiva = 'Y' 
			set @totaliva = @totaliva + @montoconcepto *.16
		if @taxretencion = 'Y'
			set @totalretencion = @totalretencion + @montoconcepto * .04
		set @totalconceptos = @totalconceptos + @montoconcepto
		FETCH NEXT FROM MY_CURSOR INTO @montoconcepto,@taxiva,@taxretencion
	END
	CLOSE MY_CURSOR
	DEALLOCATE MY_CURSOR

-- obtiene la suma de los conceptos contables
--redondea a 2 decimales el iva

select @totaliva = Round(@totaliva,2,1)
-- obtengo la cantidad de conceptos

select  @cantidadConceptos = count(*) from #conceptosfactura2

Select


--SECION HEADER (1:1)

    '01'                                                                                                             --1 Tipo de Registro   (R)
																		       +'|'+ 
    'TDRZP' + cast(invoiceheader.ivh_hdrnumber  as varchar(20))                                                             --2 ID comrpobante  (R)
																	           +'|'+     
    'TDRZP'                                                                                                          --3 Serie (R)     
																	           +'|'+     
    cast(invoiceheader.ivh_hdrnumber  as varchar(20))                                                                       --4 Folio Num  (R)
																	           +'|'+     
	isnull(replace(format(GETDATE(),'yyyy/MM/dd HH:mm:ss'),'|',''),'')                                               --5 Fecha formato 24hrs (R)     
																	           +'|'+     
																		      
    cast(convert(decimal (10,2),isnull(invoiceheader.ivh_charge,0)+@totalconceptos) as varchar(20))			                     --6 Subtotal (R) 

	                                                                           +'|'+    
    --cast(convert(decimal (10,2),isnull((orderheader.ord_totalcharge)*.16,0)) as varchar(20)) 						     --7 Total imp trasladado
	cast(convert(decimal (10,2),isnull(round(((invoiceheader.ivh_charge)*.16)+@totaliva,2,1) ,0)) as varchar(20))
																		       +'|'+    
    cast(convert(decimal (10,2),isnull((invoiceheader.ivh_charge)*.04,0)) as varchar(20)) 							  --8 Total imp retenido
                                                                               +'|'+   
	''																										     	 --9 Descuentos																		     
																		       +'|'+     
   cast(convert(decimal (10,2),isnull((invoiceheader.ivh_charge)+@totalconceptos,0))+ convert(decimal (10,2)
   ,isnull(round(((invoiceheader.ivh_charge)*.16)+@totaliva,2,1),0)) - convert(decimal (10,2),
   isnull((invoiceheader.ivh_charge)*.04,0)) as varchar(20))                                                        --10 Total
																		
																		+'|'+     
    REPLACE(REPLACE(dbo.NumeroEnLetra(ROUND((abs(convert(decimal (10,2),isnull((invoiceheader.ivh_charge+@totalconceptos),0))+ 
	convert(decimal (10,2),isnull(  round((invoiceheader.ivh_charge)*.16,2,1),0  )+@totaliva) - 
	convert(decimal (10,2),isnull((invoiceheader.ivh_charge)*.04,0)))), 0, 1))	 + 
	(CASE isnull(invoiceheader.ivh_currency,'M.N') WHEN 'MX$' THEN ' PESOS' ELSE ' DOLARES' END) + ' ' +
	CAST((((ROUND((abs(convert(decimal (10,2),isnull((invoiceheader.ivh_charge+@totalconceptos),0))+ 
	convert(decimal (10,2),isnull( round((invoiceheader.ivh_charge)*.16,2,1),0    )+@totaliva) - 
	convert(decimal (10,2),isnull((invoiceheader.ivh_charge)*.04,0)))), 2)))) - (ROUND((abs(isnull(convert(decimal (10,2),isnull((invoiceheader.ivh_charge+@totalconceptos),0))+ 
	convert(decimal (10,2),isnull( round((invoiceheader.ivh_charge)*.16,2,1),0)+@totaliva) - convert(decimal (10,2),
   isnull((invoiceheader.ivh_charge)*.04,0)),0))), 0, 1)) AS varchar) 
    + ' /100 ' + (CASE isnull(orderheader.ord_currency,'M.N') WHEN 'MX$' THEN 'M.N.' ELSE 'DLS' END), '0.', ''), '	', '')		 
	                                                                                                                 --11 Total con letra	
	    																       +'|'+     
    isnull(replace(billcmp.cmp_misc3,'|',''), '99')                                                         	     --12 Forma de Pago
																		       +'|'+     
    
	rtrim
                             (
							 isnull(
							 (SELECT             replace(PYMTRMID,'|','')
                                 FROM            [172.24.16.113].TDR.DBO.RM00101
                                 WHERE        custnmbr = orderheader.ord_billto)
								,    (SELECT      replace(PYMTRMID,'|','')
                                 FROM            [172.24.16.113].CNVOY.DBO.RM00101
                                 WHERE        custnmbr = orderheader.ord_billto)       
								 )
								 )     																			     --13 Condiciones de pago
															                   +'|'+     
    'PPD'                                							                                                 --14 Metodo de Pago
																		       +'|'+     
    (CASE invoiceheader.ivh_currency WHEN 'MX$' THEN 'MXN' ELSE 'USD' END)											 --15 Moneda
																	           +'|'+     
    (CASE 
		  WHEN (invoiceheader.ivh_currency = 'UNK') THEN '1' 
		  WHEN (invoiceheader.ivh_currency = 'MX$') THEN '1' 
		  WHEN (invoiceheader.ivh_currency = 'US$') THEN
                             (SELECT        cast(round(cex_rate, 2) AS varchar(20))
                               FROM            currency_exchange(nolock)
                               WHERE        cex_date =
                                                             (SELECT        max(cex_Date)
                                                               FROM            currency_exchange(nolock))) WHEN invoiceheader.ivh_currency = 'USDOLLAR' THEN
                             (SELECT        cast(round(cex_rate, 2) AS varchar(20))
                               FROM            currency_exchange(nolock)
                               WHERE        cex_date =
                                                             (SELECT        max(cex_Date)  FROM            currency_exchange(nolock))) 
															   
	END)	                                                                                                         --16 Tipo de Cambio
																		       +'|'+     
    'I'																										     	 --17 Tipo de Comprobante
																		       +'|'+     
    '76240'																										     --18 Lugar Expedicion   
																		       +'|'+     
    isnull(replace(billcmp.cmp_misc6,'|',''), 'G03')															     --20 Tipo gasto
																		       +'|'+     
    ''																										     	 --21 Etiqueta Documento

																		       +'|'+     
  
                                                                               + '\n' +

--SECION RECEPTOR (1:1)

    '02'                                                                                                              --1 Tipo de Registro   (R)
																		       +'|'+ 
    isnull((select replace(cmp_id,'|','') from company where cmp_id = invoiceheader.ivh_billto),'')                     --2 ID Cliente  (R)
																	           +'|'+     
    isnull((select replace(replace(cmp_taxid,'|',''),'-','') from company where cmp_id = invoiceheader.ivh_billto),'')  --3 RFC (R)     
																	           +'|'+     
    isnull((select replace(cmp_name,'|','') from company where cmp_id = invoiceheader.ivh_billto),'')                   --4 Nombre Receptor (R)
																	           +'|'+   
    'MEX'                                                                                                                --5 Pais  
																	           +'|'+  
	isnull((select replace(cmp_address1,'|','') from company where cmp_id = invoiceheader.ivh_billto),'')               --6 Calle (R)     
																	           +'|'+   
    ''                                                                                                                --7 Num Exterior
																	           +'|'+       
																		      
    isnull((select replace(cmp_misc1,'|','') from company where cmp_id = invoiceheader.ivh_billto),'')                  --8 Numero Interior  (R)   
	                                                                           +'|'+   
    isnull((select replace(cmp_address2,'|','') from company where cmp_id = invoiceheader.ivh_billto),'')               --9 Colonia (R)  																			     
																		       +'|'+  
	''                                                                                                                --10 Localidad
																		       +'|'+  
    isnull((select replace(isnull(cmp_address1,'') + isnull(cmp_address2,''),'|','') 
	from company where cmp_id = invoiceheader.ivh_billto),'')                                                           --11 Direccion (R)  	 
                                                                               +'|'+     
    isnull((select replace((select stc_state_desc from  statecountry
	 where stc_State_c = cmp_state),'|','') from company where cmp_id = invoiceheader.ivh_billto),'')                  --13 Municiipio Delegacion (R)  
																		       +'|'+     
    rtrim(isnull((select replace((select stc_state_alt from statecountry where stc_state_c = cmp_state),'|','') 
	from company where cmp_id = invoiceheader.ivh_billto),'')  )                                                       --14 Estado (R)  
	                                                                           +'|'+  
																			   
    isnull((select replace(cmp_zip  ,'|','') from company where cmp_id = invoiceheader.ivh_billto),'')                 --15 CP (R)     
																		       +'|'+                        
	''                                                                                                               --16 Pais de Residencia Fiscal
                                                                               +'|'+   
	''                                                                                                               --17 Num de residencia fiscal                                
																		       +'|'+   
	''                                                                                                               --18 Correo electronio para envio
                                                                               +'|'+   

                                                                               + '\n' +

----SECCION 04 (1:1)

    '04'                                                                                                             --1 Tipo de Registro   (R)
																		       +'|'+ 
    '1'                                                                                                              --2 Consecutivo  (R)
																	           +'|'+     
    ----'78101800'                                                                                                       --3 Clave producto o servicio SAT  (R)     original jr
	isnull((select replace(cmp_last_call_note,'|','') from company where cmp_id = invoiceheader.ivh_billto),'78101800')
																	           +'|'+    
    'Viaje-FLETE'                                                                                                    --4 Num Identifacion Descripcion (R)   
																	           +'|'+     
    '1'                                                                                                              --5 Cantidad  (R)     
																	           +'|'+  
    --'E54'                                                                                                            --6 Actividad  (R)     original jr
	isnull((select replace(cmp_wgtunits,'|','') from company where cmp_id = invoiceheader.ivh_billto),'E54')
																	           +'|'+   

    'Servicio'                                                                                                           --7 Id Producto (R) --	'Viaje'
																	           +'|'+
    --  'Servicio de Mercancia Correspondiente al ejercicio 2021'
	isnull((select replace(cmp_street_name,'|','') from company where cmp_id = invoiceheader.ivh_billto),'Viaje (Tarifa Fija)')
    --'Viaje (Tarifa Fija)'                                                       --8 Descripcion (R)    
	
																	           +'|'+     
    cast(convert(decimal (10,2),isnull(invoiceheader.ivh_charge,0)) as varchar(20))                               --9 Valor unitario  (R)     
																	           +'|'+  
    cast(convert(decimal (10,2),isnull(invoiceheader.ivh_charge,0)) as varchar(20))                               --10 Importe  (R)     
																	           +'|'+   
    ''                                                                                                               --11 DEscuento (O) 
																	           +'|'+   
                                                                               + '\n' +

----SECCION 041 Impuesto trasladado (1:1)

    '041'                                                                                                           --1 Tipo de Registro   (R)
																		       +'|'+ 
    '1'                                                                                                             --2 Consecutivo Concepto de 04-2  (R)
																	           +'|'+     
    '002'                                                                                                           --3 Cod Impuesto  (R)     
																	           +'|'+    
    'Tasa'                                                                                                          --4 Tipo (R)   
																	           +'|'+     
    '0.160000'                                                                                                      --5 % Impuesto (R)     
																	           +'|'+     
    cast(convert(decimal (10,2),isnull(round((invoiceheader.ivh_charge*.16),2,1),0)) as varchar(20))                          --6 Monto Impuesto  (R)     
																	           +'|'+  
    cast(convert(decimal (10,2),isnull(invoiceheader.ivh_charge,0)) as varchar(20))                              --7 Base para Impuesto  (R)     
																	           +'|'+   
                                                                               + '\n' +

----SECCION 041 Impuesto retenido (1:1)

    '042'                                                                                                           --1 Tipo de Registro   (R)
																		       +'|'+ 
    '1'                                                                                                             --2 Consecutivi concepto de 04-2  (R)
																	           +'|'+     
    '002'                                                                                                           --3 Cod Impuesto  (R)     
																	           +'|'+    
    'Tasa'                                                                                                          --4 Tipo (R)   
																	           +'|'+     
    '0.040000'                                                                                                      --5 % Impuesto (R)     
																	           +'|'+     
    cast(convert(decimal (10,2),isnull(invoiceheader.ivh_charge*.04,0)) as varchar(20))                          --6 Monto Impuesto  (R)     
																	           +'|'+  
    cast(convert(decimal (10,2),isnull(invoiceheader.ivh_charge,0)) as varchar(20))                              --7 Base para Impuesto  (R)     
																	           +'|'+   
                                                                               + '\n' 
																			   
-- JR inicio se agregan los conceptos de la factura
+
 CASE when @cantidadConceptos = '0' then
 ''
 else
	replace( (STUFF(( 
	
	select
	
	'04'                                                                                        
																				+'|'+ 
	cast(TT2_consecutivo+1 as varchar(10))
																				+'|'+
        isnull(replace(TT2_remark,'|',''),'')                       
																				+'|'+
          
	''

																				+'|'+
	casT(isnull(cast(TT2_cantidad as decimal(8,2)),'0')  as varchar(20))	          
																				+'|'+
	'E54'
																				+'|'+
   isnull(replace(TT2_UnidadSat,'|',''),'')                                        
																				+'|'+
	isnull(replace(TT2_cht_description,'|',''),'')                                        
																		        +'|'+ 
	casT(isnull(cast(TT2_rate as decimal(8,4)),'0')  as varchar(20))	          
																				+'|'+ 
	casT(isnull(cast(TT2_ivd_charge as decimal(8,2)),'0')  as varchar(20))	                                                                                                    
																		        +'|'+ 
	''
	 +'|'+ 
	'??????'							+						 --Wildcard para despues remplazar por salto de linea

	
	case when TT2_ivd_taxable1 = 'N'  then '' Else
	'041'
																				+'|'+
    cast(TT2_consecutivo+1 as varchar(10))
																				+'|'+
	'002'                                                                         --3 Cod Impuesto  (R)     
																	           +'|'+    
	'Tasa'
																				+'|'+
	'0.160000'
																				+'|'+
	casT(isnull(cast(round((TT2_ivd_charge * 0.1600),2,1) as decimal(8,2)),'0')  as varchar(20))	
																				+'|'+
	casT(isnull(cast(TT2_ivd_charge as decimal(8,2)),'0')  as varchar(20))	
	end
																				+'|'+
	--'??????'							+					 --Wildcard para despues remplazar por salto de linea
	
	case when TT2_ivd_taxable2 = 'N'  then '' Else
	'042'
																				+'|'+
	cast(TT2_consecutivo+1 as varchar(10))
																				+'|'+
	'Tasa'
																				+'|'+
	'0.040000'
																				+'|'+
	casT(isnull(cast(TT2_ivd_charge * 0.04 as decimal(8,2)),'0')  as varchar(20))	
																				+'|'+
	casT(isnull(cast(TT2_ivd_charge as decimal(8,2)),'0')  as varchar(20))	
	end
	+
	--'|'+
	'??????'
	from #conceptosfactura2
	where TT2_cht_itemcode  not in ('GST', 'PST')
	order by TT2_ivd_number
	FOR XML PATH('')),1,0,'')
	),'??????' ,'\n' )
	end--case
-- fin de los conceptos de la factura jr
+


----SECCION 06 Impuesto trasladado (1:1)

    '06'                                                                                                            --1 Tipo de Registro   (R)
																	           +'|'+     
    '002'                                                                                                           --2 Cod Impuesto  (R)     
																	           +'|'+    
    'Tasa'                                                                                                          --3 Tipo (R)   
																	           +'|'+     
    '0.160000'                                                                                                      --4 % Impuesto (R)     
																	           +'|'+     
      cast(convert(decimal (10,2),isnull(round((invoiceheader.ivh_charge*.16),2,1)+@totaliva,0)) as varchar(20))            --5 Monto Impuesto  (R)     
																	           +'|'+   
                                                                               + '\n' +
----SECCION 07 Impuesto Retenido (1:1)

    '07'                                                                                                            --1 Tipo de Registro   (R)
																	           +'|'+     
    '002'                                                                                                           --2 Cod Impuesto  (R)     
																	           +'|'+     
    '0.040000'                                                                                                      --3 % Impuesto (R)     
																	           +'|'+     
     cast(convert(decimal (10,2),isnull((invoiceheader.ivh_charge*.04),0)) as varchar(20))                          --4 Monto Impuesto  (R)     
																	           +'|'+   
                                                                               + '\n' +
----SECCION ORDEN
	'08'
																				+'|'+
	'NumViaje'
																				+'|'+
   CAST(invoiceheader.ord_hdrnumber as varchar(20))											-- num de orden
																				+'|'+
																				+ '\n' +


----SECCION CARTA PORTE GENERAL(1:1)

    'CP2_GEN'                                                                                                        --1 Tipo de Registro   (R)
																		       +'|'+ 
    '2.0'                                                                                                            --2 Version  (R)
																	           +'|'+     
    'No'                                                                                                             --3 Transporte Internacional  (R)     
																	           +'|'+   
																			     
	''	                                                                       +'|'+                                 --4 Entrada o Salida de Mercancia al pais  (O)

	''	                                                                       +'|'+                                 --5 Pais Origen / Destino
					                                                                                                 
	''	                                                                       +'|'+ 								 --6 Via de Entrada/salida  (O)  ---> catCartaPorte:c_CveTransporte
					                                                                                                
	
    (select cast(sum (case when stp_lgh_mileage = 0 then 0.01  when stp_lgh_mileage IS NULL  
   then 0.01 when stp_lgh_mileage =  '-1' then 0.01 else convert(decimal(10,2),stp_lgh_mileage) end)   as varchar(20))                                                                                                               
	from stops 
	where stops.ord_hdrnumber = orderheader.ord_hdrnumber
	and stp_type = 'DRP'
	and stp_event in (select abbr from eventcodetable where ect_billable = 'Y'))
																   
	                                                                           +'|'+ 								 --7 Total Distancia Recorrida  (O)
                                                                             
																			   + '\n' +

----SECCION CARTA PORTE UBICACI??N (1:N)  
----STUFF RECURSIVO DEDE LA TABLA DE STOPS
replace( (STUFF(( 

	select 

	'CP2_UBQ'                                                                                                          --1 Tipo de Registro
																	            +'|'+ 
    isnull(replace(stops.cmp_id+CAST( stp_sequence  as varchar(3)),'|',''),'')                                         --2 Consecutivo Ubicaci??n
																	            +'|'+ 
    case when stp_type = 'PUP' then 'Origen'  
	     when stp_type = 'DRP' then 'Destino'
		                       else 'Destino'   end                                                                    --3 Tipo Ubicaci??n
	
																	            +'|'+ 		
   case when ( select COUNT(*) from stops
	left join freightdetail f on stops.stp_number = f.stp_number
	where stp_type = 'DRP' and stops.ord_hdrnumber = orderheader.ord_hdrnumber
	and stp_event in (select abbr from eventcodetable where ect_billable = 'Y')) <=2 then '' else																													
	case when  stp_type = 'PUP' then 'OR'+ CAST(stp_sequence as varchar(3)) + RIGHT(rtrim(CAST(stp_number as char(10))),5) else
	'DE'+CAST(stp_sequence as varchar(3))+ RIGHT(rtrim(CAST(stp_number as char(10))),5) end    
	end                                                                                                                --4 ID ubicaci??n SAT
																	            +'|'+ 
	 case 
   when len((select replace(replace(isnull(cmp_taxid,''),'|',''),'-','') 
   from company where company.cmp_id = stops.cmp_id)) >= 12
   then (select replace(replace(isnull(cmp_taxid,''),'|',''),'-','') 
   from company where company.cmp_id = stops.cmp_id)
   else   isnull((select replace(replace(cmp_taxid,'|',''),'-','')  
   from company where cmp_id = invoiceheader.ivh_billto),'') end                                                          --5 RFC Remitente /destinatario
																	            +'|'+ 
    isnull((select replace(isnull(replace(cmp_name,'??',''),''),'|','') 
	from company where company.cmp_id = stops.cmp_id),'')                                                               --6 Nombre remitente/ destinatario
																	            +'|'+ 
	''				                                                                                                	--7 Num Registro Trib remitente/destinatario
																	            +'|'+ 
	''		                                                                                                            --8 Residencia Fisica remitente/destinatario
																	            +'|'+
	''																												    --9 Numero de Estacion
																	            +'|'+
	''																													--10 Nombre Estacion
																	            +'|'+
	''																													--11 Navegacion Traf maritimo
																	            +'|'+ 
	isnull(replace(format(stops.stp_arrivaldate,'yyyy-MM-ddThh:mm:ss'),'|',''),'')                                      --12 Fecha Hora salida/llegada
																	            +'|'+ 
	''                                                                                                                  --13 Tipo Estacion/Solo Ferreo
																	            +'|'+ 
     case when stp_type = 'PUP' then '' else
	 case when (CAST( case when stp_lgh_mileage = 0 then 0.00  when stp_lgh_mileage IS NULL 
	 then 0.01 when stp_lgh_mileage =  '-1' then 0.01 else convert(decimal(10,2),stp_lgh_mileage)
	  end  as varchar(20)) = '0.00') then '0.01'else   
	  CAST( case when stp_lgh_mileage = 0 then 0.00  when stp_lgh_mileage IS NULL 
	 then 0.01 when stp_lgh_mileage =  '-1' then 0.01 else convert(decimal(10,2),stp_lgh_mileage)
	  end  as varchar(20))   end   end                                                                                   --14 Distancia Recorrida
																	            +'|'+ 
	'??????'                                                                                                               --Wildcard para despues remplazar por salto de linea
	from stops 
	left join company on company.cmp_id = stops.cmp_id
	where stops.ord_hdrnumber = orderheader.ord_hdrnumber
	and stp_type <> 'NONE'
	and stp_event in (select abbr from eventcodetable where ect_billable = 'Y')
	order by stp_sequence
	FOR XML PATH('')),1,0,'')
	),'??????' , '\n' )

	                                                                              +

--SECCION CARTA PORTE UBICACI??N DOMICILIO (0:1)
----STUFF RECURSIVO DEDE LA TABLA DE STOPS
	replace( (STUFF(( 

	select 
	'CP2_UBQ_DOM'                                                                                                     --1 Tipo de Registro
																				+'|'+ 
	isnull(replace(stops.cmp_id+CAST( stp_sequence  as varchar(3)),'|',''),'')                                        --2 Identificador de la ubicaci??n
																				+'|'+ 
	rtrim(isnull(replace(cmp_address1,'|',''),''))                                                                    --3 Calle
																	            +'|'+ 
     ''                                                                                                               --4 N??mero Exterior
																	            +'|'+ 
     ''                                                                                                               --5 N??mero Interior
																	            +'|'+ 
    (select max(c_colonia) from SATColoniasCAT where c_codigopostal = rtrim(isnull(replace(cmp_zip,'|',''),'')))      --6 Colonia
																	            +'|'+ 
    
    isnull((select localidad from satcpcat where cp = cmp_zip),'')                                                    --7 Localidad
																	            +'|'+ 
    cast(isnull(round(cast(cmp_latseconds as float)/3600,2),0.0) as varchar(20)) +','
	+ cast(isnull(round(cast(cmp_longseconds as float)/3600,2)*-1,0.0) as varchar(20))                                --8 Referencia
		
																	            +'|'+ 
    
	isnull((select municipio from satcpcat where cp = cmp_zip),'')                                                    --9 Municipio / Delegaci??n
																	            +'|'+ 
    isnull((select estado from satcpcat where cp = cmp_zip),'')                                                      --10 Estado -->   conforme con la especificaci??n ISO 3166-2
																	            +'|'+ 
    isnull(replace(cmp_country,'|',''),'')                                                                            --11 Pa??s  --> especificaci??n ISO 3166-1
																	            +'|'+ 
                                                                                                                      --12 Codigo Postal
    isnull(replace(cmp_zip,'|',''),'')
																	            +'|'+ 
    (select rtrim(isnull(replace(cmp_address1,'|',''),'')) +',' + rtrim(isnull(replace(cmp_address2,'|',''),'')) +
	rtrim(isnull(replace(cmp_address3,'|',''),'')) +',' + 
	rtrim(isnull(replace(cty_nmstct,'|',''),'')) + ','+rtrim(isnull(replace(cmp_country,'|',''),''))+',' + 
	'(Cp:'+rtrim(isnull(replace(cmp_zip,'|',''),'')) + ' ' +
	'Mun:'+ isnull((select municipio from satcpcat where cp = cmp_zip),'') + ' ' +                                                   
    'Edo:' + isnull((select estado from satcpcat where cp = cmp_zip),'')+')'  
	from company where company.cmp_id = stops.cmp_id)      
																		        +'|'+ 
	'??????'                                                                                                             --Wildcard para despues remplazar por salto de linea
	from stops 
	left join company on company.cmp_id = stops.cmp_id
	where stops.ord_hdrnumber = orderheader.ord_hdrnumber
	and stp_event in (select abbr from eventcodetable where ect_billable = 'Y')
	and stp_type <> 'NONE'
	order by stp_sequence
	FOR XML PATH('')),1,0,'')
	),'??????' , '\n' )




	
								
                                                                                 +

--SECCION MERCANC??AS (1:1)

    'CP2_MER'                                                                                                                                                  --1 Tipo de Registro
																	        +'|'+      
 -- cast( cast(
 --   (select case when SUM(fgt_weight) <= 0 then 0.01 else SUM(fgt_weight)  end 
	--from freightdetail where stp_number in  (select stp_number from stops where stp_type  ='PUP'  
	--and stops.ord_hdrnumber = orderheader.ord_hdrnumber))  																										--2 Peso Bruto Total original jr
	--as decimal(10,2))
	--as varchar(20))
	 cast( cast(
    (select case when SUM(ivd_wgt) <= 0 then 0.01 else SUM(ivd_wgt)  end 
	from invoicedetail where ivh_hdrnumber = @num_factura and cht_itemcode = 'DEL' and ivd_wgt > 0 )  																										--2 Peso Bruto Total original jr
	as decimal(10,2))
	as varchar(20))
																	        +'|'+ 
     
	case isnull((select max(ivd_wgtunit) from invoicedetail where ivh_hdrnumber = @num_factura and cht_itemcode = 'DEL' and ivd_wgt > 0 ),0) when'TON' then 'L86'     
	 when 'KGM' then 'KGM' when 'LBS' then 'LBR'else 'L86' end  
  --   case isnull((select (MAX(stp_weightunit)) from stops where stops.ord_hdrnumber = orderheader.ord_hdrnumber),0) when'TON' then 'L86'     
	 --when 'KGM' then 'KGM' when 'LBS' then 'LBR'else 'L86' end                                                                                                 --3 Unidad de Peso  --> catCartaPorte:c_ClaveUnidadPeso
																	        +'|'+ 

 --cast(cast(
	--(select case when SUM(fgt_weight) <= 0 then 0.01 else SUM(fgt_weight)  end 
	--from freightdetail where stp_number in  (select stp_number from stops where stp_type  ='PUP'  and stops.ord_hdrnumber = orderheader.ord_hdrnumber)) --original jr
	--as decimal(10,2))
	--as varchar(20))  
	cast(cast(
	(select sum(ivd_wgt) from invoicedetail where ivh_hdrnumber = @num_factura and cht_itemcode = 'DEL' and ivd_wgt > 0)
	as decimal(10,2))
	as varchar(20))  
		
   

     --4 Peso Neto Total

																	        +'|'+ 
	--cast(isnull((select COUNT( cmd_code ) from freightdetail where cmd_code <> 'UNKNOWN' and stp_number in
	--(select stp_number from stops where stops.ord_hdrnumber = orderheader.ord_hdrnumber 	and stp_type = 'PUP'
	--	and stp_event in (select abbr from eventcodetable where ect_billable = 'Y'))),0)    as varchar(5))
		cast((select count(*) from invoicedetail where ivh_hdrnumber = @num_factura and cht_itemcode = 'DEL' and ivd_wgt > 0) as varchar(5)) --5 Numero Total de Mercanc??as
																	        +'|'+ 
     ''                                                                                                                                                       --6 Cargo por Tasaci??n
																	        +'|'+  
                                                                             + '\n'   



--SECCION MERCANC??A (1:N)
                                                                                 +
    replace( (STUFF(( 

	--select distinct
	select 
'CP2_MER_MER'                                                                                                                                                                  --1 Tipo de Registro
																				+'|'+ 
	replace(isnull(f.cmd_code,''),'|','')                                                                                                                                         --2 Consecutivo de la Mercancia
																				+'|'+
	replace(isnull(f.cmd_code,''),'|','')                                                                                                                                         --3 Bienes Transportados  ---> catCartaPorte:c_ClaveProdServCP
																		        +'|'+ 
     ''                                                                                                                                                                           --4 Clave Producto Cat??logo STCC   ---> catCartaPorte:c_ClaveProdSTCC cuando es ferroviario (O)
																		        +'|'+ 
    isnull(replace(f.ivd_description,'|',''),'NA')                                                                                                                                 --5 Descripci??n
																		        +'|'+ 
   cast( isnull((f.ivd_count),'0.01') as varchar(20)) 
																											--6 Cantidad
																	            +'|'+ 
    replace(isnull(f.ivd_countunit,''),'|','')                                                                                                                                     --7 Clave Unidad
																	            +'|'+ 
    replace(isnull(f.ivd_countunit,''),'|','')                                                                                                                                     --8 Unidad
																	            +'|'+ 
    cast(replace(isnull(f.ivd_volume,0),0,'') as varchar(10))                                                                                                                      --9 Dimensiones
	 																            +'|'+ 
    case when  (select replace(isnull(cmd_class,''),'|','') from commodity where commodity.cmd_code =  f.cmd_code) 
	= 'MPeligro' then 'S??' else '' end																										                                       --10 Material Peligroso   --> si o no
																	            +'|'+ 
    case when  (select replace(isnull(cmd_class,''),'|','') from commodity where commodity.cmd_code =  f.cmd_code) 
	= 'MPeligro' then  isnull((select replace(isnull(replace(cmd_haz_class,'|',''),''),'UNK','')   from commodity where cmd_code = f.cmd_code) ,'')   else '' end	               --11 Clave Tipo Material Peligroso  ---> catCartaPorte:c_MaterialPeligroso  NOM-002-SCT/2011
																	            +'|'+ 
      case when  (select replace(isnull(cmd_class,''),'|','') from commodity where commodity.cmd_code =  f.cmd_code) 
	= 'MPeligro' then
	 isnull((select replace(isnull(replace(cmd_haz_subclass,'!',''),''),'UNK','')   from commodity where cmd_code = f.cmd_code) ,'')  else '' end                                  --12 Embalaje --->   catCartaPorte:c_TipoEmbalaje
																	            +'|'+ 
       case when  (select replace(isnull(cmd_class,''),'|','') from commodity where commodity.cmd_code =  f.cmd_code) 
	= 'MPeligro' then
	 isnull((select isnull(replace(left([Descripci??n],90),'|',''),'') FROM [TMWSuite].[dbo].[SATTipoEmbalajeCAT]  where [Clave de designaci??n] =
	  (select isnull(replace(cmd_haz_subclass,'!',''),'')   from commodity where cmd_code = f.cmd_code)),'')    else '' end                                                       --13 Descripci??n del Embalaje -- solo si se trata de material peligroso
																	            +'|'+ 
   
   case when isnull(ivd_wgt,0) <= 0     then '0.01' 
	             when  isnull(ivd_wgt,0) IS NULL  then '0.01' else ( cast(cast(isnull(ivd_wgt,0) as decimal(8,2)) as varchar(20))   ) end   
                                                                                                                                                                                  --14 Peso en kilogramos
																	            +'|'+ 
     ''                                                                                                                                                                            --15 Valor Mercanc??a (O)
																	            +'|'+ 
     ''                                                                                                                                                                            --16 Moneda  --> catCFDI:c_Moneda (O)
																	            +'|'+ 
     ''                                                                                                                                                                            --17 Fracci??n Arancelaria    ---> catComExt:c_FraccionArancelaria /opc (O)
																	            +'|'+ 
     ''                                                                                                                                                                            --18 UUID Comercio Exterior (O)
																		        +'|'+ 
	'??????'                                                                                                                                                                         --Wildcard para despues remplazar por salto de linea
	from invoicedetail f where ivh_hdrnumber = @num_factura and cht_itemcode = 'DEL' and ivd_wgt > 0
	FOR XML PATH('')),1,0,'')
	),'??????' , '\n' )
						



--SECCION CANTIDAD TRANSPORTA (0:N)
----STUFF RECURSIVO DEDE LA TABLA DE STOPS

 
                                                                                 +
   case when ( select COUNT(*) from stops
	left join freightdetail f on stops.stp_number = f.stp_number
	where stp_type = 'DRP' and  stops.ord_hdrnumber = orderheader.ord_hdrnumber
	and stp_event in (select abbr from eventcodetable where ect_billable = 'Y')) <=2 then ''
	else


 	replace( (STUFF(( 
	--select distinct
	select 
	'CP2_MER_MER_CAN'                                                                                                                                                             --1 Tipo de Registro
																				+'|'+ 
	isnull(replace(f.cmd_code,'|',''),'')                                                                                                                                         --2 Consecutivo de la mercancia
																				+'|'+
	casT(isnull(cast(f.fgt_count as int),'0')  as varchar(20))                                                                                                                    --3 Cantidad
																		        +'|'+ 
    (select 'OR' +  isnull(CAST(max(stp_sequence) as varchar(3)) + RIGHT(rtrim(CAST(max(x.stp_number) as char(10))),5),'9999')  from stops x
	where x.stp_type = 'PUP' and x.ord_hdrnumber = orderheader.ord_hdrnumber and x.stp_sequence < y.stp_sequence   )                                                               --4 Id Origen
																				+'|'+ 
	 'DE'+ CAST(stp_sequence as varchar(3)) + RIGHT(rtrim(CAST(y.stp_number as char(10))),5)                                                                                      --5 Id Destino
																				+'|'+ 
	''                                                                                                                                                                            --6 Clave Transporte   --> catCartaPorte:c_CveTransporte
																		        +'|'+ 
	'??????'                                                                                                                                                                         --Wildcard para despues remplazar por salto de linea
	from stops y
	left join freightdetail f on y.stp_number = f.stp_number
	where y.ord_hdrnumber = orderheader.ord_hdrnumber
	and y.stp_event in (select abbr from eventcodetable where ect_billable = 'Y')
	and y.stp_type = 'DRP'
	FOR XML PATH('')),1,0,'')
	),'??????' ,'\n' )

	end
						

/*
						                                                          +					
--SECCION DETALLE MERCANC??A (1:1)

----STUFF RECURSIVO DEDE LA TABLA DE STOPS


 	replace( (STUFF(( 

	select distinct
	'CP2_MER_MER_DET'                                                            --1 Tipo de Registro
																				+'|'+ 
	replace(f.cmd_code,'|','')                                                  --2 Consecutivo de la mercancia
																				+'|'+
	replace(isnull(f.fgt_weightunit,''),'|','')                                 --3 Unidad Peso
																		        +'|'+ 
	replace(isnull(f.fgt_weight,''),'|','')                                     --4 Peso Bruto
																				+'|'+ 
	replace(isnull(f.fgt_weight,''),'|','')                                     --5 Peso Neto 
																				+'|'+ 
	'0.01'                                                                      --6 Peso Tara
																		        +'|'+ 
	casT(isnull(cast(f.fgt_count as int),'0')  as varchar(20))                  --7 Numero Piezas
																		        +'|'+ 
	'??????'                                                                       --Wildcard para despues remplazar por salto de linea
    from stops
	left join freightdetail f on stops.stp_number = f.stp_number
	where stops.ord_hdrnumber = orderheader.ord_hdrnumber
	and stp_event in (select abbr from eventcodetable where ect_billable = 'Y')
	-- order by stp_sequence
	FOR XML PATH('')),1,0,'')
	),'??????' ,CHAR(10))

*/
	


--SECCION AUTOTRANSPORTE FEDERAL (1:1)
																			 +   
    'CP2_AUT'                                                                  --1 Tipo de Registro
																	        +'|'+ 
     case when  trl2.trl_number  <> 'UNKNOWN' then  'TPAF19'
	      when  (select cmd_class from commodity
		  where commodity.cmd_code =  invoiceheader.ivh_order_cmd_code)  = 'MPeligro'   then 'TPAF03' 
	   else 'TPAF01' end                                                    --2 Permiso SCT ---> catCartaPorte:c_TipoPermiso, TPAF01 carga general, TPAF19  expreso doble articulado
																	        +'|'+ 
     '2242TTR15062011021002407'                                              --3 N??mero Permiso SCT
																	        +'|'+ 
                                                                            + '\n' +

--SECCION IDENTIFICACI??N VEHICULAR (0:1)
   
    'CP2_VEH'                                                                --1 Tipo de Registro	
																	        +'|'+ 	 
		case when tractorprofile.trc_type1 = 'THORT' 
	then 'C2R' + cast(replace(isnull(trc_axles,3),0,3) as varchar(3))  
	else 'T' + cast(replace(isnull(trc_axles,3),0,3) as varchar(3)) +

		case when trl2.trl_number = 'UNKNOWN' then  'S' +
		cast( replace(isnull(trl1.trl_axles,2),0,2)  as varchar(3))  
	
		else  
		'S' +
		--cast(isnull(replace(dolly.trl_axles,0,2),2) as varchar(3)) + 'R' + JR No lo trae la factura
		cast(isnull(replace(2,0,2),2) as varchar(3)) + 'R' + -- se deja fijo el valor de los ejes en el dolly
		cast(isnull(replace(trl1.trl_axles,0,2),2) + isnull(trl2.trl_axles,2) as varchar(3))
		end
	end                                                                     --2 catCartaPorte:c_ConfigAutotransporte
																	        +'|'+ 
     isnull(REPLACE(trc_licnum,'|',''),'')                                  --3 Placa
																	        +'|'+ 
     isnull(REPLACE(trc_year,  '|',''),'')                                  --4 A??o Modelo
																	        +'|'+ 
	 isnull(REPLACE(trc_number,'|',''),'')                                  --4.5 Unidad jr
																	        +'|'+
																			+ '\n' +
--SECCION SEGUROS (1:1)

   'CP2_SEG'                                                                --1 Tipo de Registro	
																	        +'|'+
	'HDI seguros'															--2 Aseguradora responsabildiad civi
	 																        +'|'+
	'2264019'																--3  Num Poliza Aseguradora responsabildiad civi																			 	 
	 																        +'|'+
	--'ABA Seguros'																		--4  Aseguradora Medio Ambiental
case @matpeligroso when 0 then
	''
	else
	--isnull((select replace(cmp_volunits,'MPELIG','ABA Seguros') from company where cmp_id = orderheader.ord_billto),'') --4  Aseguradora Medio Ambiental
	'ABA Seguros'
	end
		 																    +'|'+
--	'TH 41001285'																		--5  Poliza Aseguradora Medio Ambiental
	case @matpeligroso when 0 then
	''
	else
	--isnull((select replace(cmp_volunits,'MPELIG','TH 41001285') from company where cmp_id = orderheader.ord_billto),'') 		--5  Poliza Aseguradora Medio Ambiental
	'TH 41001285'
	end
			 																+'|'+
	isnull((select cmp_misc4 from company where cmp_id = 
	orderheader.ord_billto),'')  										    --6  Aseguradora Carga
			 																+'|'+
	isnull((select cmp_misc5 from company where cmp_id = 
	orderheader.ord_billto),'')                                             --7  Poliza Carga
			 																+'|'+
	''  																	--8  Prima seguro
				 														    +'|'+
	+ '\n' +																			
--SECCION REMOLQUE (0:2) --REMOLQUE 1
   
    'CP2_REM'                                                               --1 Tipo de Registro
																	        +'|'+ 
	CASE WHEN TRL1.TRL_TYPE3 = 'TOL' THEN
	 isnull(REPLACE((select param1 from labelfile
	 where labeldefinition = trl1.trl_type1) ,'|',''),'CTR029')
	ELSE
     isnull(REPLACE((select param1 from labelfile
	 where labeldefinition = trl1.trl_type1) ,'|',''),'CTR002')             --2 Subtipo de Remolque   ---> catCartaPorte:c_SubTipoRem
	 END
																	        +'|'+                                              
     isnull(REPLACE(trl1.trl_licnum,'|',''),'')                              --3 Placa
																	        +'|'+ 
	 isnull(REPLACE(trl1.trl_number,'|',''),'')                              --3.5 Remolque 1 jr																	
																	        +'|'+ 
																		    + '\n' +
--SECCION REMOLQUE (0:2) --REMOLQUE 2
    
	case when trl2.trl_number <> 'UNKNOWN' then 

    ('CP2_REM'                                                               --1 Tipo de Registro
																	        +'|'+ 
	CASE WHEN TRL2.TRL_TYPE3 = 'TOL' THEN
			isnull(REPLACE((select param1 from labelfile 
			where labeldefinition = trl2.trl_type1) ,'|',''),'CTR029')
		ELSE
			isnull(REPLACE((select param1 from labelfile 
			where labeldefinition = trl2.trl_type1) ,'|',''),'CTR002')              --2 Subtipo de Remolque   ---> catCartaPorte:c_SubTipoRem
		END
																	        +'|'+                                              
     isnull(REPLACE(trl2.trl_licnum,'|',''),'')                              --3 Placa
																	        +'|'+ 
	 isnull(REPLACE(trl2.trl_number,'|',''),'')                              --3.5 Remolque 2 jr																	
																	        +'|'+ 
																		    +  '\n' )

	else ''
	end
	+''+



/********************INICIA POSIBLEMENTE NO REQUERIDOS*******************************

--SECCION TRANSPORTE MAR??TIMO (1:N)
   
    'CP_TRA_MAR'                                 --1 Tipo de Registro
																	        +'|'+ 
     ''                                          --2 Permiso SCT  --> catCartaPorte:c_TipoPermiso
																	        +'|'+ 
     ''                                          --3 N??mero de Permiso SCT
																	        +'|'+ 
     ''                                          --4 Nombre Aseguradora
																	        +'|'+ 
     ''                                          --5 N??mero de P??liza
																	        +'|'+ 
     ''                                          --6 Tipo de Embarcaci??n  --> catCartaPorte:c_ConfigMaritima
																	        +'|'+ 
     ''                                          --7 Matricula
																	        +'|'+ 
     ''                                          --8 Numero de IMO
																	        +'|'+ 
     ''                                          --9 A??o Construcci??n Embarcaci??n
																	        +'|'+ 
     ''                                          --10 Nombre Embarcaci??n
																	        +'|'+ 
     ''                                          --11 Nacionalidad Embarcaci??n  --> catCFDI:c_Pais
																	        +'|'+ 
     ''                                          --12 Unidades de Arqueo Bruto
																	        +'|'+ 
     ''                                          --13 Tipo de Carga  --> catCartaPorte:c_ClaveTipoCarga
																	        +'|'+ 
     ''                                          --14 N??mero de Certiicado ITC
																	        +'|'+ 
     ''                                          --15 Eslora
																	        +'|'+ 
     ''                                          --16 Manga
																	        +'|'+ 
     ''                                          --17 Calado
																	        +'|'+ 
     ''                                          --18 L??nea Naviera
																	        +'|'+ 
     ''                                          --19 Agente Naviero
																	        +'|'+ 
     ''                                          --20 N??mero de Autorizaci??n Agente Naviero --> catCartaPorte:c_NumAutorizacionNaviero
																	        +'|'+ 
     ''                                          --21 N??mero de Viaje
																	        +'|'+ 
     ''                                          --22 Conocimiento de Embarque
																	        +'|'+ 
																		    + '\n' +

--SECCION TRANSPORTE MAR??TIMO CONTENEDOR (1:N)
   
    'CP_TRA_MAR_CNT'                              --1 Tipo de Registro
																	        +'|'+ 
     ''                                           --2 N??mero de Contenedor
																	        +'|'+ 
     ''                                           --3 Tipo de Contenedor  --> catCartaPorte:c_ContenedorMaritimo
																	        +'|'+ 
     ''                                           --4 N??mero de Precinto
																	        +'|'+ 
                                                                            + '\n' +
--SECCION TRANSPORTE AEREO (1:N)
   
    'CP_TRA_AER'                                 --1 Tipo de Registro
																	        +'|'+ 
     ''                                           --2 Tipo Permiso SCT  --> catCartaPorte:c_TipoPermiso
																	        +'|'+ 
     ''                                           --3 N??mero de Permiso SCT
																	        +'|'+ 
     ''                                           --4 Matricula Aeronave
																	        +'|'+ 
     ''                                           --5 Nombre Aseguradora
																	        +'|'+ 
     ''                                           --6 N??mero de P??liza de Seguro
																	        +'|'+ 
     ''                                           --7 N??mero de Guia
																	        +'|'+ 
     ''                                           --8 Lugar Contrato
																	        +'|'+ 
     ''                                           --9 RFC Transportista
																	        +'|'+ 
     ''                                           --10 C??digo Transporista --> catCartaPorte:c_CodigoTransporteAereo
																	        +'|'+ 
     ''                                           --11 N??mero de Registro de Identificaci??n Tributaria Transportista
																	        +'|'+ 
     ''                                           --12 Residencia Fiscal Transportista
																	        +'|'+ 
     ''                                           --13 Nombre Transportista
																	        +'|'+ 
     ''                                           --14 RFC Embarcador
																	        +'|'+ 
     ''                                           --15 N??mero de Registro de Identificaci??n Tributaria Embarcador
																	        +'|'+ 
     ''                                           --16 Residencia Fiscal Embarcador
																	        +'|'+ 
     ''                                           --17 Nombre Embarcador
																	        +'|'+ 
																		    + '\n' +

--SECCION TRANSPORTE FERROVIARIO (0:1)
   
    'CP_TRA_FER'                                 --1 Tipo de Registro
																	        +'|'+ 
     ''                                           --2 Tipo de Servicio  --> catCartaPorte:c_TipoDeServicio
																	        +'|'+ 
     ''                                           --3 Nombre Aseguradora
																	        +'|'+ 
     ''                                           --4 N??mero de Poliza Seguro
																	        +'|'+ 
     ''                                           --5 Concesionario  --> tdCFDI:t_RFC_PM
																	        +'|'+ 
																		    + '\n' +
																			
--SECCION DERECHOS DE PASO (0:N)
   
    'CP_TRA_FER_DER'                              --1 Tipo de Registro
																	        +'|'+ 
     ''                                           --2 Tipo de Derecho de Paso --> catCartaPorte:c_DerechosDePaso
																	        +'|'+ 
     ''                                           --3 Kilometraje Pagado
																	        +'|'+ 
																		    + '\n' +

--SECCION CARRO FERROVIARIO (1:N)
   
    'CP_TRA_FER_CAR'                              --1 Tipo de Registro  
																	        +'|'+ 
     ''                                           --2 Identificador ??nico Carro
																	        +'|'+ 
     ''                                           --3 Tipo de Carro -->  catCartaPorte:c_TipoCarro
																	        +'|'+ 
     ''                                           --4 Matricula Carro
																	        +'|'+ 
     ''                                           --5 Guia Carro
																	        +'|'+ 
     ''                                           --6 Toneladas Netas Carro
																	        +'|'+ 
																		    + '\n' +

--SECCION CONTENEDORES CARROS FERROVIARIO (0:N)
   
    'CP_TRA_FER_CAR_CNT'                           --1 Tipo de Registro  
																	        +'|'+ 
     ''                                            --2 Identificador ??nico Carro
																	        +'|'+ 
     ''                                            --3 Tipo de Contenedor --> catCartaPorte:c_Contenedor
																	        +'|'+ 
     ''                                            --4 Peso Contenedor Vacio
																	        +'|'+ 
     ''                                            --5 Peso Neto Mercanc??a
																	        +'|'+ 
															                + '\n' +

--********************TERMINA POSIBLEMENTE NO REQUERIDOS**********************************/

--SECCION  FIGURA TRANSPORTE (0:N)
   
    'CP2_TIP_FIG'                                                           --1 Tipo de Registro
																	        +'|'+ 
	 isnull(REPLACE(invoiceheader.ivh_ref_number,'|',''),'')						--2 Consecutivo tipo figura transporte -- se ocupo para la referencia JR
																	        +'|'+ 
     '01'                                                                   --3 Tipo de Figura ---> catCartaPorte:c_CveTransporte 01-Autotransporte Federal
																	        +'|'+ 
     isnull(REPLACE(mpp_misc3,'|',''),'')							        --4 RFC Figura transporte--> tdCFDI:t_RFC_PF
																	        +'|'+ 	 
	 isnull(REPLACE(mpp_licensenumber,'|',''),'')							--5 N??mero de Licencia
																	        +'|'+ 		 
	 isnull(REPLACE(mpp_lastfirst,'|',''),'')								--6 Nombre Figura
	 																	    +'|'+
     ''																		--7 N??mero de Registro de Identificaci??n Tributaria Operador, dejar en blanco
																	        +'|'+
     '' 																	--8 Residencia Fiscal Operador Pais catalogo c_pais  ISO 3166-1
	     													            + '\n' +


/*

--SECCION PARTE (0:N)
   
    'CP2_TIP_FIG_PAR'                                                       --1 Tipo de Registro
																	        +'|'+ 
	 isnull(REPLACE(mpp_id,'|',''),'')										--2 Consecutivo tipo figura transporte
																	        +'|'+ 
     'PT03'							                                        --3 PArte Transporte catCartaPorte:c_ParteTransporte
																	        +'|'+ 	 
																            + '\n' +
*/
--SECCION DOMICILIO (0:N)
   
    'CP2_TIP_FIG_DOM'                                                       --1 Tipo de Registro
																	        +'|'+
	 isnull(REPLACE(mpp_id,'|',''),'')	                                    --2 Consecutivo tipo figura transporte
																	        +'|'+
    'Avenida Mexico'
	-- isnull(REPLACE(mpp_address1,'|',''),'')							    --3 Calle  (R)
																	        +'|'+
     '10'		                                                            --4 N??mero Exterior (O)
																	        +'|'+
     ''																		--5 N??mero Interior (O)
																	        +'|'+
     '0282'																	--6 Colonia (O)
																	        +'|'+
     ''																		--7 Localidad (O)
																	        +'|'+
     ''																		--8 Referencia (O)
																	        +'|'+ 
	+'011'                                                   				--9 Municipio (O)
																	        +'|'+
     'QUE'															        --10 Estado (R)
																	        +'|'+
     'MEX'																	--11 Pa??s (R) --> ISO 3166-1
																	        +'|'+
     '76247'
	 --isnull(REPLACE(mpp_zip,'|',''),'')									--12 Codigo Postal (R)
																	        +'|'




--OBTECION DE DATOS DE LA TABLA LEGHEADER
from invoiceheader
left join manpowerprofile      on invoiceheader.ivh_driver           = manpowerprofile.mpp_id
left join orderheader          on invoiceheader.ord_hdrnumber         = orderheader.ord_hdrnumber
left join tractorprofile       on invoiceheader.ivh_tractor           = tractorprofile.trc_number
left join trailerprofile trl1  on invoiceheader.ivh_trailer   = trl1.trl_id
left join trailerprofile trl2  on invoiceheader.ivh_trailer2       = trl2.trl_id
--left join trailerprofile dolly on invoiceheader.ivh_dolly             = dolly.trl_number
left join company billcmp      on orderheader.ord_billto          = billcmp.cmp_id
--CLAUSULA WHERE EL numero de invoice SEA IGUAL AL PARAMETRO DEL SP
where ivh_hdrnumber = @num_factura
GO
