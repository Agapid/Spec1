USE [Budget]
GO
/****** Object:  StoredProcedure [dbo].[stpBackupOldSpecification]    Script Date: 12/26/2022 00:26:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- stpBackupOldSpecification 8
-- Предназначена для создания бекапа спецификации.
ALTER PROCEDURE [dbo].[stpBackupOldSpecification]
	@CompleteSetID int -- ID комплекта, для которого нужно сохранить спецификацию.

AS
	SET NOCOUNT ON

	BEGIN TRANSACTION


	-- Удаляем из таблицы с бекапами спецификаций, бекап спецификации данного комплекта, если он там есть.
	DELETE FROM dbo.tblSpecificationsOld WHERE CompleteSetID=@CompleteSetID
	IF @@ERROR<>0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 1
	END
	
	-- Сохраняем спецификацию комплекта в таблице с бекапами комплектов.
	INSERT INTO dbo.tblSpecificationsOld 
			(CompleteSetID, ComponentID, Quantity)
		SELECT CompleteSetID, ComponentID, Quantity
			FROM dbo.tblSpecifications 
			WHERE CompleteSetID=@CompleteSetID
	IF @@ERROR<>0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 2
	END


	COMMIT TRANSACTION
	
	RETURN 0