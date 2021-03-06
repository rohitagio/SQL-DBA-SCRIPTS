/**************************************************************************
** CREATED BY:   Bulent Gucuk
** CREATED DATE: 2019.02.26
** CREATED FOR:  Starting the jobs after maintenance
** NOTES:	The script depends on the DBA database and table named dbo.JobsRunning
**			When executed it will start all the jobs at the step they were stopped
**			before the maintenance
***************************************************************************/
USE msdb;
GO
DECLARE @RowId SMALLINT = 1
	, @MaxRowId SMALLINT
	, @job_name SYSNAME
	, @step_name SYSNAME;

SELECT	@MaxRowId = RowId
FROM	DBA.DBO.JobsRunning;

WHILE @RowId <= @MaxRowId
	BEGIN
		SELECT	@job_name = job_name
			, @step_name  = step_name
		FROM	DBA.dbo.JobsRunning
		WHERE	RowId = @RowId;

		EXEC msdb.dbo.sp_start_job
			@job_name = @job_name,
			@step_name = @step_name;

		SELECT @RowId = @RowId + 1;
	END
