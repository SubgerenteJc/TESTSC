SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
 CREATE FUNCTION [dbo].[UDF_DRV_9_fn] (@p_mpp_id varchar(8), @Label_or_Data char(1))	returns varchar(255) AS begin declare @return varchar(255) if @Label_or_Data = 'L' select @return = 'UDF_DRV_9' else select @return = '' return @return end
GO
GRANT EXECUTE ON  [dbo].[UDF_DRV_9_fn] TO [public]
GO
