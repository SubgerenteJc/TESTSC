SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[p_dump_useroptions] AS
BEGIN
	DBCC USEROPTIONS
END
GO
GRANT EXECUTE ON  [dbo].[p_dump_useroptions] TO [public]
GO
