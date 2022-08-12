SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[tm_GET_SNCodebytblFldType]
	@SN int
	
	
	
	
AS

/**
 * 
 * NAME:
 * dbo.[tm_GET_SNCodebytblFldType]
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
 * 001 - @SN int
 * 
 * 
 *    
 *
 * REVISION HISTORY:
 * 05/14/12      - PTS 60785 SJ - Created Stored Procedure for Email Agent
 **/

/* [tm_GET_SNCodebytblFldType]
 **************************************************************
*********************************************************************************/
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT Code 
FROM dbo.tblFldType 
WHERE SN = @SN

GO
GRANT EXECUTE ON  [dbo].[tm_GET_SNCodebytblFldType] TO [public]
GO
