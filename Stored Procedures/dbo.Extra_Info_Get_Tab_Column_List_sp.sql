SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Extra_Info_Get_Tab_Column_List_sp](@Extra_ID INTEGER) AS
BEGIN
/* Returns a list of tabs and columns defined under a particular header
*/
SELECT	EXTRA_INFO_TAB.TAB_ID,
EXTRA_INFO_TAB.TAB_NAME,
EXTRA_INFO_COLS.COL_ID,
EXTRA_INFO_COLS.COL_NAME
FROM 	EXTRA_INFO_HEADER
JOIN EXTRA_INFO_TAB on EXTRA_INFO_HEADER.EXTRA_ID = EXTRA_INFO_TAB.EXTRA_ID
JOIN EXTRA_INFO_COLS on EXTRA_INFO_HEADER.EXTRA_ID = EXTRA_INFO_COLS.EXTRA_ID and EXTRA_INFO_TAB.TAB_ID = EXTRA_INFO_COLS.TAB_ID
WHERE	EXTRA_INFO_HEADER.EXTRA_ID = @Extra_ID
ORDER BY EXTRA_INFO_TAB.TAB_NAME, EXTRA_INFO_COLS.COL_NAME
END
GO
GRANT EXECUTE ON  [dbo].[Extra_Info_Get_Tab_Column_List_sp] TO [public]
GO
