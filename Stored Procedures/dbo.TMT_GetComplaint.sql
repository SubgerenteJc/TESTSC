SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* ------------------------
MB  05/07/2009 Expand String @SQL to 4000
MRH 05/19/2010 REVSISED TO USE TRANSMAN CONNECTION.
*/
create proc [dbo].[TMT_GetComplaint]
@CODE CHAR(12), @SHOPID CHAR(12)
as
IF (SELECT COUNT(0)
FROM COMMODITYCDMAP COMMODITYCDMAP
LEFT OUTER JOIN COMMODITYSHOP  ON COMMODITYSHOP.COMMODITYID = COMMODITYCDMAP.COMMODITYID
LEFT OUTER JOIN CMPONENT ON CMPONENT.CODE = COMMODITYCDMAP.CODE
WHERE
--(CMPONENT.CODEKEY ='0031')  AND
(CMPONENT.CODE =@CODE) AND
((COMMODITYSHOP.SHOPID IS NULL) OR
(COMMODITYSHOP.SHOPID =@SHOPID))) > 0
BEGIN
SELECT COMMODITYCDMAP.COMMODITYID COMPLTID, COMMODITYCODE.DESCRIP DESCRIP
FROM COMMODITYCDMAP COMMODITYCDMAP
LEFT OUTER JOIN COMMODITYSHOP  ON COMMODITYSHOP.COMMODITYID = COMMODITYCDMAP.COMMODITYID
LEFT OUTER JOIN CMPONENT ON CMPONENT.CODE = COMMODITYCDMAP.CODE
LEFT OUTER JOIN COMMODITYCODE ON COMMODITYCDMAP.COMMODITYID = COMMODITYCODE.COMMODITYID
WHERE
--(CMPONENT.CODEKEY ='0031')  AND
(CMPONENT.CODE =@CODE) AND
((COMMODITYSHOP.SHOPID IS NULL) OR
(COMMODITYSHOP.SHOPID =@SHOPID))
END
ELSE
SELECT COMPLTID, DESCRIP FROM VIEW_COMPLTID ORDER BY DESCRIP

GO
GRANT EXECUTE ON  [dbo].[TMT_GetComplaint] TO [public]
GO
