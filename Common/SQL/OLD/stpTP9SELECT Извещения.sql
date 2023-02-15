
--ВЫБОРКА  ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpTP9SELECT')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpTP9SELECT as select 1')        

GO 
--stpTP1SELECT 1

	ALTER PROC stpTP9SELECT  @CompleteSetID INT, @ModuleID INT, @ProductNPID INT 

	AS

	/*
		автор: popovml
		система: Технологические маршруты.
		описание: Вкладка извещения. Просмотр.
		

		возвращает:
				(0) - все прошло хорошо

	*/

	BEGIN
		SET NOCOUNT ON 
		
		SET @CompleteSetID  = ISNULL(@CompleteSetID,0)
		SET @ModuleID  = ISNULL(@ModuleID,0)
		SET @ProductNPID  = ISNULL(@ProductNPID,0)





        SELECT A.TNID, 
				A.DateTN, 
				A.ProductID, 
				A.ProductNPID, 
				A.CompleteSetID, 
				A.ModuleID, 
                isnull(B.CompleteSetName, isnull(C.ModuleName, isnull(D.ProductName, E.ProductName))) as UnitName, 
				A.FALID, F.FirmName, 
				A.BufferWork, 
                G.Descript as DirectBufferWork, 
				A.Contents, A.Reason, 
				DirectBufferWork, 
				EntryTime
                
                
            FROM tblTechNotice as A
                LEFT JOIN tblCompleteSets as B ON B.CompleteSetID = A.CompleteSetID
                LEFT JOIN tblModules as C ON C.ModuleID = A.ModuleID
                LEFT JOIN tblProducts as D ON D.ProductID = A.ProductID
                LEFT JOIN tblProductNotPiece as E ON E.ProductNPID = A.ProductNPID
                INNER JOIN vw_Firms as F ON F.FALID = A.FALID
                LEFT JOIN tblDict as G ON G.Value = A.DirectBufferWork and G.Chapter = 'DirectBufferWork'
            WHERE A.flgConfirm = 1 and 
				(
					@CompleteSetID <> 0 AND A.CompleteSetID=@CompleteSetID
					OR
					@ModuleID <> 0 AND A.ModuleID = @ModuleID
					OR
					@ProductNPID <> 0 AND A.ProductNPID = @ProductNPID
				)









	RETURN 0 

	END

GO

GRANT EXECUTE ON stpTP9SELECT TO rolManufacture34, rolTechDoc06, rolFactoryTP1

GO





