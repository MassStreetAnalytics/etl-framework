-- =============================================
-- Author: Bob Wakefield
-- Create date: 20Oct20
-- Description: These are the stored procedures that SSIS uses to log activity. 
-- Note that they do not conform to the naming convention for stored procedures.
-- Directions for use:Simply run the script.
-- =============================================

USE [SSISManagement]
GO

DROP PROCEDURE IF EXISTS [dbo].[LogPackageStart]
DROP PROCEDURE IF EXISTS [dbo].[LogPackageEnd]
DROP PROCEDURE IF EXISTS [dbo].[LogPackageError]
DROP PROCEDURE IF EXISTS [dbo].[LogTaskPreExecute]
DROP PROCEDURE IF EXISTS [dbo].[LogTaskPostExecute]
DROP PROCEDURE IF EXISTS [dbo].[LogVariableValueChanged]
GO

CREATE PROCEDURE [dbo].[LogPackageStart]
(    @BatchLogID int
    ,@PackageName varchar(255) 
    ,@ExecutionInstanceID uniqueidentifier 
    ,@MachineName varchar(64) 
    ,@UserName varchar(64) 
    ,@StartDateTime datetime 
    ,@PackageVersionGUID uniqueidentifier 
    ,@VersionMajor int 
    ,@VersionMinor int 
    ,@VersionBuild int 
    ,@VersionComment varchar(1000) 
    ,@PackageGUID uniqueidentifier 
    ,@CreationDate datetime 
    ,@CreatedBy varchar(255) 
)

AS
BEGIN
SET NOCOUNT ON

DECLARE @PackageID int
,@PackageVersionID int 
,@PackageLogID int
,@EndBatchAudit bit

/* Initialize Variables */
SELECT @EndBatchAudit = 0

/* Get Package Metadata ID */
IF NOT EXISTS (SELECT 1 FROM dbo.Package WHERE PackageGUID = @PackageGUID AND PackageName = @PackageName)
Begin
    INSERT INTO dbo.Package (PackageGUID, PackageName, CreationDate, CreatedBy)
        VALUES (@PackageGUID, @PackageName, @CreationDate, @CreatedBy)
End

SELECT @PackageID = PackageID
    FROM dbo.Package 
    WHERE PackageGUID = @PackageGUID
    AND PackageName = @PackageName

/* Get Package Version MetaData ID */
IF NOT EXISTS (SELECT 1 FROM dbo.PackageVersion WHERE PackageVersionGUID = @PackageVersionGUID)
Begin
    INSERT INTO dbo.PackageVersion (PackageID, PackageVersionGUID, VersionMajor, VersionMinor, VersionBuild, VersionComment)
        VALUES (@PackageID, @PackageVersionGUID, @VersionMajor, @VersionMinor, @VersionBuild, @VersionComment)
End
SELECT @PackageVersionID = PackageVersionID
    FROM dbo.PackageVersion 
    WHERE PackageVersionGUID = @PackageVersionGUID

/* Get BatchLogID */
IF ISNULL(@BatchLogID,0) = 0
Begin
    INSERT INTO dbo.BatchLog (StartDateTime, [Status])
        VALUES (@StartDateTime, 'R')
    SELECT @BatchLogID = SCOPE_IDENTITY()
    SELECT @EndBatchAudit = 1
End

/* Create PackageLog Record */
INSERT INTO dbo.PackageLog (BatchLogID, PackageVersionID, ExecutionInstanceID, MachineName, UserName, StartDateTime, [Status])
    VALUES(@BatchLogID, @PackageVersionID, @ExecutionInstanceID, @MachineName, @UserName, @StartDateTime, 'R')

SELECT @PackageLogID = SCOPE_IDENTITY()

SELECT @BatchLogID as BatchLogID, @PackageLogID as PackageLogID, @EndBatchAudit as EndBatchAudit

END
GO

CREATE PROCEDURE [dbo].[LogPackageEnd]
(    @PackageLogID int
    ,@BatchLogID int
    ,@EndBatchAudit bit
)

AS
BEGIN
    SET NOCOUNT ON
    UPDATE dbo.PackageLog
        SET Status = 'S'
        , EndDateTime = getdate()
        WHERE PackageLogID = @PackageLogID

    IF @EndBatchAudit = 1
    Begin
        UPDATE dbo.BatchLog
        SET Status = 'S'
        , EndDateTime = getdate()
        WHERE BatchLogID = @BatchLogID
    End
END
GO

CREATE PROCEDURE [dbo].[LogPackageError]
(    @PackageLogID int
    ,@BatchLogID int
    ,@SourceName varchar(64)
    ,@SourceID uniqueidentifier
    ,@ErrorCode int
    ,@ErrorDescription varchar(2000)
    ,@EndBatchAudit bit
)

AS
BEGIN
    SET NOCOUNT ON
    INSERT INTO dbo.PackageErrorLog (PackageLogID, SourceName, SourceID, ErrorCode, ErrorDescription, LogDateTime)
    VALUES (@PackageLogID, @SourceName, @SourceID, @ErrorCode, @ErrorDescription, getdate())

    UPDATE dbo.PackageLog
        SET Status = 'F'
        WHERE PackageLogID = @PackageLogID

    IF @EndBatchAudit = 1
    Begin
    UPDATE dbo.BatchLog
        SET Status = 'F'
        , EndDateTime = getdate()
        WHERE BatchLogID = @BatchLogID
    End
END
GO

CREATE PROCEDURE [dbo].[LogTaskPreExecute]
(    @PackageLogID int
    ,@SourceName varchar(64)
    ,@SourceID uniqueidentifier
    ,@PackageID uniqueidentifier
)

AS
BEGIN
    SET NOCOUNT ON
    IF @PackageID <> @SourceID
        AND @SourceName <> 'SQL LogPackageStart'
        AND @SourceName <> 'SQL LogPackageEnd'
        INSERT INTO dbo.PackageTaskLog (PackageLogID, SourceName, SourceID, StartDateTime)
        VALUES (@PackageLogID, @SourceName, @SourceID, getdate())
END
GO

CREATE PROCEDURE [dbo].[LogTaskPostExecute]
(    @PackageLogID int
    ,@SourceID uniqueidentifier
    ,@PackageID uniqueidentifier
)

AS
BEGIN
    SET NOCOUNT ON
    IF @PackageID <> @SourceID
        UPDATE dbo.PackageTaskLog 
            SET EndDateTime = getdate()
            WHERE PackageLogID = @PackageLogID AND SourceID = @SourceID
                AND EndDateTime is null
END
GO

CREATE PROCEDURE [dbo].[LogVariableValueChanged]
(    @PackageLogID	int
    ,@VariableName		varchar(255)
    ,@VariableValue		varchar(max)
)
AS
BEGIN
SET NOCOUNT ON
INSERT INTO dbo.PackageVariableLog(PackageLogID, VariableName, VariableValue, LogDateTime)
VALUES (@PackageLogID, @VariableName, @VariableValue, getdate())
END
GO
