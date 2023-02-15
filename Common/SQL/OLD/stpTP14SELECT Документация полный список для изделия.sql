
--ВЫБОРКА  ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpTP14SELECT')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpTP14SELECT as select 1')        

GO 


	ALTER PROC stpTP14SELECT  @CompleteSetID INT, @ModuleID INT, @ProductNPID INT 

	AS

	/*
		автор: popovml
		система: Технологические маршруты
		описание: Получение списка всей документации для выбранного изделия
		

		возвращает:
				(0) - все прошло хорошо

	*/


	BEGIN
		SET NOCOUNT ON 
		
		
		
		SET @CompleteSetID  = ISNULL(@CompleteSetID,0)
		SET @ModuleID  = ISNULL(@ModuleID,0)
		SET @ProductNPID  = ISNULL(@ProductNPID,0)


		SELECT	CAST (1 AS BIT) AS Checked,
				B.TPDID AS RecordID,
				A.TPID, 
				C.DTName, 
				B.[FileName], 
				B.DateRec, 
				B.flgArchive, 
				B.DateEdit, 
				C.flgOpen, 
				B.Note,
				B.Editor, 
				B.DateEdit, 
				B.Editor + '(' + ISNULL(LGN.Surname,'') + ')' AS Surname
				

		FROM tblTechPaths as A
			INNER JOIN Files.dbo.tblTechPathDoc as B ON B.TPID = A.TPID and B.flgArchive = 0
			INNER JOIN tblTechDocTypes as C ON C.TDTID = B.TDTID
			LEFT JOIN tblUserLogins AS LGN ON LGN.Login=B.Editor AND LGN.flgArchive=0
			
			
			
		WHERE	@CompleteSetID <> 0 AND A.CompleteSetID=@CompleteSetID
				OR
				@ModuleID <> 0 AND A.ModuleID = @ModuleID
				OR
				@ProductNPID <> 0 AND A.ProductNPID = @ProductNPID
		
		

		
	RETURN 0 

	END

GO

GRANT EXECUTE ON stpTP14SELECT TO rolManufacture34, rolTechDoc06

GO








