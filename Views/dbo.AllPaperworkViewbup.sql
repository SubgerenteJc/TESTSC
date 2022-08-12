SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create	VIEW [dbo].[AllPaperworkViewbup] AS
SELECT	DISTINCT P.lgh_number AS LegNumber, P.ord_hdrnumber AS OrderNumber, P.abbr AS DocType, L.[name] AS DocTypeName
		,CASE WHEN P.pw_received = 'Y' THEN 'Yes' ELSE 'No' END AS [Received]
		,CASE WHEN BDT.bdt_inv_required = 'Y' THEN 'Yes' ELSE 'No' END AS [Required]
FROM	paperwork P INNER JOIN
		labelfile L ON P.abbr = L.abbr AND L.labeldefinition = 'paperwork' LEFT OUTER JOIN
		(
		SELECT	O.ord_hdrnumber, B.cmp_id, B.bdt_inv_required, B.bdt_doctype
		FROM	orderheader O  INNER JOIN
				BillDoctypes B ON O.ord_billto = B.cmp_id
		) BDT ON P.ord_hdrnumber = BDT.ord_hdrnumber AND P.abbr = BDT.bdt_doctype

GO
