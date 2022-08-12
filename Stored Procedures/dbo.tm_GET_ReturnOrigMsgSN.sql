SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[tm_GET_ReturnOrigMsgSN]
	@MsgSN int
AS

/**
 * 
 * NAME:
 * dbo.[tm_GET_ReturnOrigMsgSN]
 *
 * TYPE:
 * StoredProcedure 
 *
 * DESCRIPTION:
 * Pulls PropSN, FldType and TypeName value base on a EntryType and PropSN
 *  
 * RETURNS:
 * none.
 *
 * RESULT SETS: 
 * PropSN, FldType and TypeName fields
 *
 * PARAMETERS:
 * 001 - @MsgSN int
 *       
 *
 * REVISION HISTORY:
 * 06/08/12      - PTS 63352 SJ - Created Stored Procedure for Transaction Agent
 **/

/* [tm_GET_ReturnOrigMsgSN]
 **************************************************************
*********************************************************************************/
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT OrigMsgSN 
FROM tblMessages(NoLock) 
WHERE SN = @MsgSN


GO
GRANT EXECUTE ON  [dbo].[tm_GET_ReturnOrigMsgSN] TO [public]
GO
