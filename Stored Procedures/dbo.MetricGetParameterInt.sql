SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[MetricGetParameterInt] 
(
	@ParmValue int OUTPUT,
	@DefaultValue int, 
	@Heading varchar(100),
	@SubHeading varchar(100),
	@ParmName varchar(100)
)
/* WITH ENCRYPTION */ -- Do not touch this line.  This gets uncommented in the build process if the file is to be encrypted.
AS
	SET NOCOUNT ON

	SELECT @ParmValue = NULL

	IF @ParmName IS NOT NULL  -- If ParmName is really not passed in...
	BEGIN
		SELECT @ParmValue = (SELECT CONVERT(int, ParmValue) 
							FROM MetricParameter WITH (NOLOCK)
							WHERE Heading = @Heading 
								AND SubHeading = @SubHeading
								AND ParmName = @ParmName)

		-- The next line handles the case where the parameter exists, but is a NULL value.
		IF EXISTS(SELECT * FROM MetricParameter WITH (NOLOCK) WHERE Heading = @Heading AND SubHeading = @SubHeading AND ParmName = @ParmName)
			RETURN
	END

	IF @Heading = 'Metric'	
	BEGIN
		SELECT @ParmValue = CONVERT(int, ParmValue) 
					FROM MetricParameter WITH (NOLOCK)
					WHERE Heading = @Heading 
						AND SubHeading IS NULL
						AND ParmName = @ParmName

			-- The next line handles the case where the parameter exists, but is a NULL value.
			IF EXISTS(SELECT * FROM MetricParameter WITH (NOLOCK) WHERE Heading = @Heading AND SubHeading IS NULL AND ParmName = @ParmName)
			RETURN
	END

	IF (@ParmValue IS NULL)
		SELECT @ParmValue = @DefaultValue

GO
GRANT EXECUTE ON  [dbo].[MetricGetParameterInt] TO [public]
GO
