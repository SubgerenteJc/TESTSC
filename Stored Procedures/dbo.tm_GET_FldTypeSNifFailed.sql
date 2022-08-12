SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[tm_GET_FldTypeSNifFailed]
	@fldTypeSN int
	
	
AS

/**
 * 
 * NAME:
 * dbo.[tm_GET_FldTypeSNifFailed]
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
 * 001 - @fldTypeSN int
 * 
 *       
 *
 * REVISION HISTORY:
 * 06/08/12      - PTS 63352 SJ - Created Stored Procedure for Transaction Agent
 **/

/* [tm_GET_FldTypeSNifFailed]
 **************************************************************
*********************************************************************************/
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


SELECT TypeName  
FROM tblFldType(NoLock)  
WHERE SN = @fldTypeSN

GO
GRANT EXECUTE ON  [dbo].[tm_GET_FldTypeSNifFailed] TO [public]
GO
