USE [Budget]
GO
/****** Object:  StoredProcedure [dbo].[stpCompleteSetsStatusSELECT]    Script Date: 12/05/2022 15:07:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


	ALTER PROC [dbo].[stpCompleteSetsStatusSELECT]  @CompleteSetID INT

	AS

	/*
		автор: popovml
		система:  
		описание: 
		

		возвращает:
				(0) - все прошло хорошо

	*/

	BEGIN
		SET NOCOUNT ON 

		DECLARE @StatusInfoText VARCHAR(250),	@StatusInfoValue INT
		
		
		
		IF EXISTS(SELECT * FROM tblCompleteSetsStatus WHERE CompleteSetID=@CompleteSetID)
			BEGIN
				SELECT @StatusInfoText='НА РЕДАКТИРОВАНИИ', @StatusInfoValue=1
			END
		ELSE
			BEGIN
				SELECT @StatusInfoText='В ПРОИЗВОДСТВЕ', @StatusInfoValue=0
			END
						
		SELECT @StatusInfoText AS StatusInfoText, @StatusInfoValue AS StatusInfoValue
		
		

	END

