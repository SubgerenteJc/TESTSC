SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
----------------------------------
--- TMT AMS from TMWSYSTEMSl
--- CHANGED 11/14/2014 MH - Added GI setting to default accounting type.
--- CHANGED 04/04/2011 MH
--- CHANGED 12/21/2009 MH
--- Changed 05/18/2006 MB
----------------------------------
CREATE PROCEDURE [dbo].[TMT_ADDUNIT]
@UNIT_IDTYPE CHAR(12)
,@UNIT_ID VARCHAR(8)
,@UNIT_HUB INT = NULL
,@ERRORCODE INT OUTPUT -- ADDED MB
AS
DECLARE @ACCOUNTINGTYPE CHAR(1)

SELECT @ACCOUNTINGTYPE = left(isnull(gi_string4,'A'),1) from generalinfo where gi_name = 'ShopLinkOptions'
IF @ACCOUNTINGTYPE = ''
SELECT @ACCOUNTINGTYPE =  'A'

SET @ERRORCODE = 0

IF @UNIT_IDTYPE = 'TRACTOR'
BEGIN
SELECT  @UNIT_IDTYPE = 'TRC'
END
ELSE
IF @UNIT_IDTYPE = 'TRAILER'
BEGIN
SELECT @UNIT_IDTYPE = 'TRL'
END

--IF @UNIT_IDTYPE <> 'TRC' OR @UNIT_IDTYPE <> 'TRL' BEGIN
IF @UNIT_IDTYPE NOT IN ( 'TRC', 'TRL' )
BEGIN
IF EXISTS ( SELECT  [CODE]
FROM    [dbo].[TMTUNITTYPE]
WHERE   [CODE] = @UNIT_IDTYPE )
BEGIN

SELECT @UNIT_IDTYPE = [TMWDESIGNATION]
FROM   [dbo].[TMTUNITTYPE]
WHERE  [CODE] = @UNIT_IDTYPE
END
ELSE
BEGIN
SELECT @ERRORCODE = -1
GOTO ERROR_EXIT
END
END

--SELECT @UNIT_IDTYPE

IF @UNIT_IDTYPE = 'TRC'
BEGIN
IF NOT EXISTS ( SELECT  [TRC_NUMBER]
FROM    [dbo].[TRACTORPROFILE]
WHERE   [TRC_NUMBER] = @UNIT_ID )
BEGIN
INSERT INTO [dbo].[TRACTORPROFILE]
( [TRC_NUMBER]
,[TRC_OWNER]
,[TRC_CURRENTHUB]
,[trc_actg_type]
)
VALUES ( @UNIT_ID
,'UNKNOWN'
,@UNIT_HUB
,@ACCOUNTINGTYPE
)
END
END
ELSE
IF @UNIT_IDTYPE = 'TRL'
BEGIN
--  SELECT [TRL_NUMBER] FROM [dbo].[TRAILERPROFILE] WHERE [TRL_NUMBER] = @UNIT_ID
-- IF NOT EXISTS(SELECT [TRL_NUMBER] FROM [dbo].[TRAILERPROFILE] WHERE [TRL_NUMBER] = @UNIT_ID and isnull(trl_ilt, 'N') = 'N')
IF NOT EXISTS ( SELECT [TRL_NUMBER]
FROM   [dbo].[TRAILERPROFILE]
WHERE  [TRL_ID] = @UNIT_ID
AND ISNULL(trl_ilt, 'N') = 'N' )
BEGIN
INSERT  INTO [dbo].[TRAILERPROFILE]
( [TRL_ID]
,[TRL_NUMBER]
,[TRL_OWNER]
,[TRL_CURRENTHUB]
,trl_ilt
)
VALUES  ( @UNIT_ID
,@UNIT_ID
,'UNKNOWN'
,@UNIT_HUB
,'N'
)
END
END


GOTO NO_ERROR_EXIT

ERROR_EXIT:
--SELECT @ERRORCODE OUT MB
NO_ERROR_EXIT:
GO
GRANT EXECUTE ON  [dbo].[TMT_ADDUNIT] TO [public]
GO
