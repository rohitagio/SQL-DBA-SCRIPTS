USE [DBAMaint]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[P_UPDATESTATISTICS]') AND type IN (N'U'))
DROP PROCEDURE [dbo].[P_UPDATESTATISTICS]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[P_UPDATESTATISTICS]
	-- Add the parameters for the stored procedure here

AS

BEGIN

SET NOCOUNT ON

DECLARE @DB_TABLE TABLE (DB NVARCHAR(100)) 
DECLARE @DB AS NVARCHAR(100)
DECLARE @COUNTER INT 
DECLARE @COMMAND AS NVARCHAR(500)

INSERT INTO @DB_TABLE (DB)
SELECT [NAME] FROM SYS.DATABASES WHERE name NOT IN ('master','model','msdb','tempdb')
--SELECT * FROM @DB_TABLE AS [@DB_TABLE]

SET @COUNTER = (SELECT COUNT(*) FROM @DB_TABLE)
--SELECT @COUNTER AS [@COUNTER]

SET @DB = (SELECT TOP 1 DB FROM @DB_TABLE)
--SELECT @DB

WHILE @COUNTER > 0
BEGIN
	SET @COMMAND = 'USE ['+RTRIM(@DB)+'] EXEC sp_updatestats'
	--PRINT @COMMAND
	EXEC (@COMMAND)
DELETE FROM @DB_TABLE WHERE DB = @DB
SET @DB = (SELECT TOP 1 DB FROM @DB_TABLE)

	SET @COUNTER = @COUNTER - 1
END



END



GO

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
