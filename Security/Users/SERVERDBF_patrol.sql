IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'SERVERDBF\patrol')
CREATE LOGIN [SERVERDBF\patrol] FROM WINDOWS
GO
CREATE USER [SERVERDBF\patrol] FOR LOGIN [SERVERDBF\patrol] WITH DEFAULT_SCHEMA=[SERVERDBF\patrol]
GO