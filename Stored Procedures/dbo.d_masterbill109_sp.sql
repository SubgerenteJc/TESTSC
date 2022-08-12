SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO

CREATE PROC [dbo].[d_masterbill109_sp] (@reprintflag 	varchar(10),
                                @mbnumber    	int,
                                @billto      	varchar(8), 
	                        @revtype1    	varchar(6), 
                                @mbstatus 	varchar(6),
	                        @shipstart 	datetime,
                                @shipend 	datetime,
                                @billdate 	datetime,
                                @billstart	datetime,
                                @billend	datetime,
                                @revtype2	VARCHAR(6),
                                @revtype3	VARCHAR(6),
                                @revtype4	VARCHAR(6))
AS
/**
 * DESCRIPTION:
  Created to allow reprinting of masterbills
 * PARAMETERS:
 *
 * RETURNS:
 *	
 * RESULT SETS: 
 *
 * REFERENCES:
 *
 * REVISION HISTORY:
 * 12/17/2007.01 ? PTS39647 - MBR - Created.
 *
 **/

DECLARE @int0  int
SELECT @int0 = 0

SELECT @shipstart = convert(char(12),@shipstart,112)+'00:00:00'
SELECT @shipend   = convert(char(12),@shipend,112)+'23:59:59'
  

-- if printflag is set to REPRINT, retrieve an already printed mb by #
if UPPER(@reprintflag) = 'REPRINT' 
  BEGIN

    SELECT invoiceheader.ivh_invoicenumber,  
	   invoiceheader.ivh_hdrnumber, 
           invoiceheader.ivh_billto,   
           invoiceheader.ivh_totalcharge,   
           invoiceheader.ivh_originpoint,  
           invoiceheader.ivh_destpoint,   
           invoiceheader.ivh_origincity,   
           invoiceheader.ivh_destcity,   
           invoiceheader.ivh_shipdate,   
           invoiceheader.ivh_deliverydate,   
           invoiceheader.ivh_revtype1,
	   invoiceheader.ivh_mbnumber,
	   billto_name = cmp1.cmp_name,
-- dpete for LOR pts4785 provide for maitlto override of billto
	   billto_address = 
	      CASE
		  WHEN cmp1.cmp_mailto_name IS NULL THEN ISNULL(cmp1.cmp_address1,'')
		  WHEN (cmp1.cmp_mailto_name <= ' ') THEN ISNULL(cmp1.cmp_address1,'')
		  ELSE ISNULL(cmp1.cmp_mailto_address1,'')
	      END,
	   billto_address2 = 
	      CASE
		  WHEN cmp1.cmp_mailto_name IS NULL THEN ISNULL(cmp1.cmp_address2,'')
		  WHEN (cmp1.cmp_mailto_name <= ' ') THEN ISNULL(cmp1.cmp_address2,'')
		  ELSE ISNULL(cmp1.cmp_mailto_address2,'')
	      END,
	   billto_nmstct = 
	      CASE
		  WHEN cmp1.cmp_mailto_name IS NULL THEN 
		     ISNULL(SUBSTRING(cmp1.cty_nmstct,1,(CHARINDEX('/',cmp1.cty_nmstct))- 1),'')
		  WHEN (cmp1.cmp_mailto_name <= ' ') THEN 
		     ISNULL(SUBSTRING(cmp1.cty_nmstct,1,(CHARINDEX('/',cmp1.cty_nmstct))- 1),'')
		  ELSE ISNULL(SUBSTRING(cmp1.mailto_cty_nmstct,1,(CHARINDEX('/',cmp1.mailto_cty_nmstct)) - 1),'')
	      END,
	  billto_zip = 
	      CASE
		  WHEN cmp1.cmp_mailto_name IS NULL  THEN ISNULL(cmp1.cmp_zip ,'')  
		  WHEN (cmp1.cmp_mailto_name <= ' ') THEN ISNULL(cmp1.cmp_zip,'')
		  ELSE ISNULL(cmp1.cmp_mailto_zip,'')
	      END,
	  cty1.cty_nmstct   origin_nmstct,
	  cty1.cty_state    origin_state,
	  cty2.cty_nmstct   dest_nmstct,
	  cty2.cty_state    dest_state,
	  ivh_billdate      billdate,
	  ISNULL(ref.ref_number,'')   billoflading,
	  ISNULL(cmp1.cmp_mailto_name,'') cmp_mailto_name,
	  cmp1.cmp_altid  billto_altid 
-- stage results in a temp table so dup invoices can be cleared and
-- yet still show the rest of the info
into #Temp
    FROM 
	invoiceheader LEFT OUTER JOIN referencenumber ref ON (ref.ref_tablekey = invoiceheader.ord_hdrnumber and ref.ref_table = 'orderheader' and ref.ref_type ='BL#'), 
	company cmp1, 
	city cty1, 
	city cty2
   WHERE 
	( invoiceheader.ivh_mbnumber = @mbnumber ) 
	AND (cmp1.cmp_id = invoiceheader.ivh_billto) 
	AND (cty1.cty_code = invoiceheader.ivh_origincity) 
	AND (cty2.cty_code = invoiceheader.ivh_destcity)


-- Above allows dup invoices when there is more than one BL reference number
-- So, quick change to stage the results in a temp table and
-- then zero out the totalcharge on  any but the first BL
Update #Temp
	Set ivh_totalcharge=0
	from #temp
	where
		(	
			Select 
				count(*)
			From 
				#temp T1
			where 
				T1.ivh_hdrnumber=#temp.ivh_hdrnumber
		) > 1
		and
		#temp.billoflading <>
			(
				Select 
					min(t1.billoflading)
				From 
					#Temp T1	
				Where		
					T1.ivh_hdrnumber=#temp.ivh_hdrnumber
			)
Select * from #Temp				

 

  END

-- for master bills with 'RTP' status

IF UPPER(@reprintflag) <> 'REPRINT' 
BEGIN
   SELECT invoiceheader.ivh_invoicenumber,  
	  invoiceheader.ivh_hdrnumber, 
          invoiceheader.ivh_billto,   
          invoiceheader.ivh_totalcharge,   
          invoiceheader.ivh_originpoint,  
          invoiceheader.ivh_destpoint,   
          invoiceheader.ivh_origincity,   
          invoiceheader.ivh_destcity,   
          invoiceheader.ivh_shipdate,   
          invoiceheader.ivh_deliverydate,   
          invoiceheader.ivh_revtype1,
	  @mbnumber     ivh_mbnumber,
	  billto_name = cmp1.cmp_name,
 	  billto_address = 
	    CASE
		WHEN cmp1.cmp_mailto_name IS NULL THEN ISNULL(cmp1.cmp_address1,'')
		WHEN (cmp1.cmp_mailto_name <= ' ') THEN ISNULL(cmp1.cmp_address1,'')
		ELSE ISNULL(cmp1.cmp_mailto_address1,'')
	    END,
	  billto_address2 = 
	    CASE
		WHEN cmp1.cmp_mailto_name IS NULL THEN ISNULL(cmp1.cmp_address2,'')
		WHEN (cmp1.cmp_mailto_name <= ' ') THEN ISNULL(cmp1.cmp_address2,'')
		ELSE ISNULL(cmp1.cmp_mailto_address2,'')
	    END,
	  billto_nmstct = 
	    CASE
		WHEN cmp1.cmp_mailto_name IS NULL THEN 
		   ISNULL(SUBSTRING(cmp1.cty_nmstct,1,(CHARINDEX('/',cmp1.cty_nmstct))-1),'')
		WHEN (cmp1.cmp_mailto_name <= ' ') THEN 
		   ISNULL(SUBSTRING(cmp1.cty_nmstct,1,(CHARINDEX('/',cmp1.cty_nmstct))-1),'')
		ELSE ISNULL(SUBSTRING(cmp1.mailto_cty_nmstct,1,(CHARINDEX('/',cmp1.mailto_cty_nmstct)) -1),'')
	    END,
	 billto_zip = 
	    CASE
		WHEN cmp1.cmp_mailto_name IS NULL THEN ISNULL(cmp1.cmp_zip ,'')  
		WHEN (cmp1.cmp_mailto_name <= ' ') THEN ISNULL(cmp1.cmp_zip,'')
		ELSE ISNULL(cmp1.cmp_mailto_zip,'')
	    END,
	 cty1.cty_nmstct   origin_nmstct,
	 cty1.cty_state		origin_state,
	 cty2.cty_nmstct   dest_nmstct,
	 cty2.cty_state		dest_state,
	 @billdate	billdate,
	 ISNULL(ref.ref_number,'') billoflading,
	 ISNULL(cmp1.cmp_mailto_name,'') cmp_mailto_name,
	 cmp1.cmp_altid  billto_altid
-- stage results in a temp table so dup invoices can be cleared and
-- yet still show the rest of the info

    INTO #temp2
    FROM invoiceheader LEFT OUTER JOIN referencenumber ref ON (ref.ref_tablekey = invoiceheader.ord_hdrnumber and ref.ref_table = 'orderheader' and ref.ref_type ='BL#') 
	               JOIN company cmp1 ON invoiceheader.ivh_billto = cmp1.cmp_id
                       JOIN city cty1 ON invoiceheader.ivh_origincity = cty1.cty_code
                       JOIN city cty2 ON invoiceheader.ivh_destcity = cty2.cty_code 
   WHERE invoiceheader.ivh_billto = @billto AND
        (invoiceheader.ivh_mbnumber IS NULL OR invoiceheader.ivh_mbnumber = 0) AND 
         invoiceheader.ivh_shipdate BETWEEN @shipstart AND @shipend AND
         invoiceheader.ivh_billdate BETWEEN @billstart AND @billend AND
         invoiceheader.ivh_mbstatus = 'RTP' AND 
         @revtype1 in (invoiceheader.ivh_revtype1, 'UNK') AND
         @revtype2 in (invoiceheader.ivh_revtype2, 'UNK') AND
         @revtype3 in (invoiceheader.ivh_revtype3, 'UNK') AND
         @revtype4 IN (invoiceheader.ivh_revtype4, 'UNK')

-- Above allows dup invoices when there is more than one BL reference number
-- So, quick change to stage the results in a temp table and
-- then zero out the totalcharge on  any but the first BL

   UPDATE #Temp2
      SET ivh_totalcharge=0
     FROM #temp2
    WHERE (SELECT count(*)
	     FROM #temp2 T1
            WHERE T1.ivh_hdrnumber = #temp2.ivh_hdrnumber) > 1 AND
                  #temp2.billoflading <> (SELECT MIN(t1.billoflading)
				            FROM #Temp2 T1	
				           WHERE T1.ivh_hdrnumber = #temp2.ivh_hdrnumber)

   SELECT * 
     FROM #Temp2				
END

GO
GRANT EXECUTE ON  [dbo].[d_masterbill109_sp] TO [public]
GO
