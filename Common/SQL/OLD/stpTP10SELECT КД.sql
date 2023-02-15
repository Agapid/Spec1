
--ВЫБОРКА  ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpTP10SELECT')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpTP10SELECT as select 1')        

GO 
--stpTP1SELECT 1

	ALTER PROC stpTP10SELECT  @CompleteSetID INT, @ModuleID INT-- , @ProductNPID INT 

	AS

	/*
		автор: popovml
		система: Технологические маршруты.
		описание: Вкладка КД. Просмотр.
		

		возвращает:
				(0) - все прошло хорошо

	*/

	BEGIN
		SET NOCOUNT ON 
		
		SET @CompleteSetID  = ISNULL(@CompleteSetID,0)
		SET @ModuleID  = ISNULL(@ModuleID,0)
		--SET @ProductNPID  = ISNULL(@ProductNPID,0)





      SELECT	A.DDID,
				B.DTName,
				A.ProductID,
				A.ModuleID,
				A.CompleteSetID,
				A.[FileName],
				A.Note,
				A.flgArchive,
				CASE WHEN A.flgArchive=1 THEN 'Архив' ELSE NULL END AS Archive,

				A.DateRec,
				A.DateEdit,
				B.flgOpen
      FROM Files.dbo.tblDesignerDoc AS A
      INNER JOIN tblTechDocTypes AS B ON B.TDTID = A.TDTID
      WHERE --A.flgArchive = 1
				(
					@CompleteSetID <> 0 AND A.CompleteSetID=@CompleteSetID
					OR
					@ModuleID <> 0 AND A.ModuleID = @ModuleID
--					OR
--					@ProductNPID <> 0 AND A.ProductNPID = @ProductNPID
				)









	RETURN 0 

	END

GO

GRANT EXECUTE ON stpTP10SELECT TO rolManufacture34, rolTechDoc06, rolFactoryTP1

GO





