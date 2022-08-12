SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   PROCEDURE [dbo].[TMT_BUILD_INSHOP_EXP_TABLE]
AS
DECLARE @CURR_EXP INTEGER
DECLARE @ORDERID INT
DECLARE @EXP_KEY INT
DECLARE @EXP_IDTYPE VARCHAR(12)
DECLARE @EXP_ID VARCHAR(13)
DECLARE @EXP_CODE VARCHAR(6)
DECLARE @EXP_EXPIRATIONDATE DATETIME
DECLARE @EXP_ROUTETO VARCHAR(8)
DECLARE @EXP_PRIORITY VARCHAR(6)
DECLARE @EXP_COMPLDATE DATETIME
DECLARE @EXP_COMPCODE VARCHAR(12)
DECLARE @EXP_CODEKEY  VARCHAR(12)
DECLARE @EXP_DESCRIPTION VARCHAR(100)
DECLARE @EXP_STATUS SMALLINT
DECLARE @EXP_OUTKEY INT
DECLARE @EXP_DAYSINSHOP INTEGER
DECLARE @EXP_PERCENT INTEGER
DECLARE @EXP_COMPLETED CHAR(1)

PRINT 'ADDING EXISTING INSHOP EXPIRATIONS'
-- HANDLE INSHOP EXPIRATIONS
SELECT	EXP_KEY,
EXP_ID,
EXP_IDTYPE,
EXP_EXPIRATIONDATE,
EXP_ROUTETO,
EXP_PRIORITY,
EXP_COMPLDATE,
EXP_MILESTOEXP,
EXP_DESCRIPTION,
EXP_COMPLETED
INTO #EXPIRATIONS from EXPIRATION WHERE EXP_CODE = 'INSHOP'

SELECT @CURR_EXP = MAX(EXP_KEY) FROM #EXPIRATIONS

WHILE @CURR_EXP IS NOT NULL
BEGIN
SELECT	@EXP_DESCRIPTION = EXP_DESCRIPTION,
@EXP_IDTYPE = EXP_IDTYPE,
@EXP_ID = EXP_ID,
@EXP_EXPIRATIONDATE = EXP_EXPIRATIONDATE,
@EXP_ROUTETO = EXP_ROUTETO,
@EXP_PRIORITY = EXP_PRIORITY,
@EXP_COMPLDATE = EXP_COMPLDATE,
@EXP_COMPCODE = NULL,
@EXP_CODEKEY = NULL,
@EXP_DESCRIPTION = EXP_DESCRIPTION,
@EXP_STATUS = 9,
@EXP_DAYSINSHOP = 10,
@EXP_PERCENT = 100,
@EXP_COMPLETED = EXP_COMPLETED
FROM #EXPIRATIONS WHERE EXP_KEY = @CURR_EXP

IF CHARINDEX ( ':' , @EXP_DESCRIPTION, 0) > 0 AND ISNUMERIC(RTRIM(SUBSTRING ( @EXP_DESCRIPTION , CHARINDEX ( ' ' , @EXP_DESCRIPTION, 0),  CHARINDEX ( ':' , @EXP_DESCRIPTION, 0)- CHARINDEX ( ' ' , @EXP_DESCRIPTION, 0)))) = 1
BEGIN
SELECT @ORDERID = convert(int, RTRIM(SUBSTRING ( @EXP_DESCRIPTION , CHARINDEX ( ' ' , @EXP_DESCRIPTION, 0),  CHARINDEX ( ':' , @EXP_DESCRIPTION, 0)- CHARINDEX ( ' ' , @EXP_DESCRIPTION, 0))))

IF (select count(0) from TMT_Expirations where EXP_ORDERID = @ORDERID and EXP_IDTYPE = @EXP_IDTYPE and EXP_ID = @EXP_ID and UPPER(EXP_CODE) = 'INSHOP') = 0
insert into TMT_Expirations (
EXP_KEY,
EXP_IDTYPE,
EXP_ID,
EXP_CODE,
EXP_EXPIRATIONDATE,
EXP_ROUTETO,
EXP_PRIORITY,
EXP_COMPLDATE,
EXP_COMPCODE,
EXP_CODEKEY,
EXP_MILESTOEXP,
EXP_DESCRIPTION,
EXP_STATUS,
EXP_OUTKEY,
EXP_DAYSINSHOP,
EXP_PERCENT,
EXP_ORDERID,
EXP_SECTION,
EXP_COMPLETED,
EXP_TRANSFER_STATUS)
Values (
@CURR_EXP,
@EXP_IDTYPE,
@EXP_ID,
'INSHOP',
@EXP_EXPIRATIONDATE,
@EXP_ROUTETO,
@EXP_PRIORITY,
@EXP_COMPLDATE,
@EXP_COMPCODE,
@EXP_CODEKEY,
0,
@EXP_DESCRIPTION,
@EXP_STATUS,
@CURR_EXP,
@EXP_DAYSINSHOP,
@EXP_PERCENT,
@ORDERID,
NULL,
@EXP_COMPLETED,
'RECIEVED')
END	-- : found in description.
SELECT @CURR_EXP = MAX(EXP_KEY) FROM #EXPIRATIONS WHERE EXP_KEY < @CURR_EXP
END

-- HANDLE OUT EXPIRATIONS
PRINT 'ADDING EXISTING OUT OF SERVICE EXPIRATIONS'
SELECT	EXP_KEY,
EXP_ID,
EXP_IDTYPE,
EXP_EXPIRATIONDATE,
EXP_ROUTETO,
EXP_PRIORITY,
EXP_COMPLDATE,
EXP_MILESTOEXP,
EXP_DESCRIPTION,
EXP_COMPLETED
INTO #OUTEXPIRATIONS from EXPIRATION WHERE EXP_CODE = 'OUT' AND EXP_IDTYPE IN ('TRC', 'TRL')

SELECT @CURR_EXP = MAX(EXP_KEY) FROM #OUTEXPIRATIONS

WHILE @CURR_EXP IS NOT NULL
BEGIN
SELECT	@EXP_DESCRIPTION = EXP_DESCRIPTION,
@EXP_IDTYPE = EXP_IDTYPE,
@EXP_ID = EXP_ID,
@EXP_EXPIRATIONDATE = EXP_EXPIRATIONDATE,
@EXP_ROUTETO = EXP_ROUTETO,
@EXP_PRIORITY = EXP_PRIORITY,
@EXP_COMPLDATE = EXP_COMPLDATE,
@EXP_COMPCODE = NULL,
@EXP_CODEKEY = NULL,
@EXP_DESCRIPTION = EXP_DESCRIPTION,
@EXP_STATUS = 9,
@EXP_DAYSINSHOP = 10,
@EXP_PERCENT = 100,
@EXP_COMPLETED = EXP_COMPLETED
FROM #OUTEXPIRATIONS WHERE EXP_KEY = @CURR_EXP

IF (select count(0) from TMT_Expirations where EXP_IDTYPE = @EXP_IDTYPE and EXP_ID = @EXP_ID and UPPER(EXP_CODE) = 'OUT') = 0
insert into TMT_Expirations (
EXP_KEY,
EXP_IDTYPE,
EXP_ID,
EXP_CODE,
EXP_EXPIRATIONDATE,
EXP_ROUTETO,
EXP_PRIORITY,
EXP_COMPLDATE,
EXP_COMPCODE,
EXP_CODEKEY,
EXP_MILESTOEXP,
EXP_DESCRIPTION,
EXP_STATUS,
EXP_OUTKEY,
EXP_DAYSINSHOP,
EXP_PERCENT,
EXP_ORDERID,
EXP_SECTION,
EXP_COMPLETED,
EXP_TRANSFER_STATUS)
Values (
@CURR_EXP,
@EXP_IDTYPE,
@EXP_ID,
'OUT',
@EXP_EXPIRATIONDATE,
@EXP_ROUTETO,
@EXP_PRIORITY,
@EXP_COMPLDATE,
@EXP_COMPCODE,
@EXP_CODEKEY,
0,
@EXP_DESCRIPTION,
@EXP_STATUS,
@CURR_EXP,
@EXP_DAYSINSHOP,
@EXP_PERCENT,
@ORDERID,
NULL,
@EXP_COMPLETED,
'RECIEVED')

SELECT @CURR_EXP = MAX(EXP_KEY) FROM #OUTEXPIRATIONS WHERE EXP_KEY < @CURR_EXP
END

DROP TABLE #EXPIRATIONS
DROP TABLE #OUTEXPIRATIONS

GO
GRANT EXECUTE ON  [dbo].[TMT_BUILD_INSHOP_EXP_TABLE] TO [public]
GO
