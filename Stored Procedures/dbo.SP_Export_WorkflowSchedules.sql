SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_Export_WorkflowSchedules]
@WorkflowName varchar(50)
AS
BEGIN
DECLARE @SQL VARCHAR(1000) DECLARE @WORKFLOW_TEMPLATEID INT

SELECT @WORKFLOW_TEMPLATEID = WORKFLOW_TEMPLATE_ID FROM [WorkFlow_Template] WHERE Workflow_Template_Name = @WorkflowName
SELECT * FROM WorkFlow_Schedule WHERE WorkFlow_Template_id = @WORKFLOW_TEMPLATEID
	
END

GO
GRANT EXECUTE ON  [dbo].[SP_Export_WorkflowSchedules] TO [public]
GO
