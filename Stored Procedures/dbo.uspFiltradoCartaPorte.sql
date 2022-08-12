SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[uspFiltradoCartaPorte]
@segmento varchar(100)
as
begin

if @segmento=''
    SELECT top 50 Folio,Fecha,oh.ord_billto,Serie,UUID,Pdf_xml_descarga,Pdf_descargaFactura, replace(xlm_descargaFactura,'}','') as xlm_descargaFactura
    FROM VISTA_Carta_Porte as vista 
		INNER JOIN legheader as lg ON vista.Folio = lg.lgh_number 
		INNER JOIN orderheader as oh ON lg.ord_hdrnumber = oh.ord_hdrnumber
		ORDER BY Fecha DESC
else 
    SELECT Folio,Fecha,oh.ord_billto,Serie,UUID,Pdf_xml_descarga,Pdf_descargaFactura, replace(xlm_descargaFactura,'}','') as xlm_descargaFactura
    FROM VISTA_Carta_Porte as vista 
		INNER JOIN legheader as lg ON vista.Folio = lg.lgh_number 
		INNER JOIN orderheader as oh ON lg.ord_hdrnumber = oh.ord_hdrnumber
	WHERE 
		 oh.ord_billto like '%'+@segmento+'%' or 
		 vista.Folio like '%'+@segmento+'%' or
		 vista.UUID like '%'+@segmento+'%'
	ORDER BY Fecha DESC
	--select Folio,Serie,UUID,Pdf_xml_descarga,Pdf_descargaFactura, replace(xlm_descargaFactura,'}','') as xlm_descargaFactura
	--from VISTA_Carta_Porte
	--where Folio like '%'+@segmento+'%' or UUID like '%'+@segmento+'%'
end
GO
