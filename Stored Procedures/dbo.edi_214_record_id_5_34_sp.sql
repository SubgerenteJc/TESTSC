SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
pts10311 make v3.4 work in PS v2001, 2002 (manual 214)
*/
CREATE PROCEDURE [dbo].[edi_214_record_id_5_34_sp] 
		@invoice_number varchar( 12 ),
	@trpid varchar(20),
	@docid varchar(30)
AS

declare @emptystring varchar(79)
select @emptystring=' '

INSERT edi_214 (data_col,trp_id,doc_id)
SELECT 
data_col = '5' +				-- Record ID
'34' +						-- Record Version
@emptystring +	replicate(' ',4-datalength(@emptystring)) +	-- scac
@emptystring +	replicate(' ',15-datalength(@emptystring)) +	-- city
@emptystring +	replicate(' ',9-datalength(@emptystring)) +	-- splc
@emptystring +	replicate(' ',15-datalength(@emptystring)) +	-- invoicenumber
replicate('0',6-datalength(@emptystring)) + @emptystring,	-- billingdate
trp_id=@trpid, doc_id = @docid







GO
GRANT EXECUTE ON  [dbo].[edi_214_record_id_5_34_sp] TO [public]
GO
