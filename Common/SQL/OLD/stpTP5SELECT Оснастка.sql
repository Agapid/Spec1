
--ВЫБОРКА  ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpTP5SELECT')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpTP5SELECT as select 1')        

GO 
--stpTP1SELECT 1

	ALTER PROC stpTP5SELECT  @CompleteSetID INT, @ModuleID INT, @ProductNPID INT 

	AS

	/*
		автор: popovml
		система: 
		описание: Оснастка 
		

		возвращает:
				(0) - все прошло хорошо

	*/

	BEGIN
		SET NOCOUNT ON 
		
		SET @CompleteSetID  = ISNULL(@CompleteSetID,0)
		SET @ModuleID  = ISNULL(@ModuleID,0)
		SET @ProductNPID  = ISNULL(@ProductNPID,0)


		SELECT	T1.RDID,
				T1.CompleteSetID,	
				T1.ModuleID, 
				T1.ProductNPID, 
				T1.Note,
				T2.DeviceName,
				T2.StoringPlace

		FROM tblRefDeviceProdLink AS T1
					INNER JOIN tblRefDevices AS T2 ON T2.RDID=T1.RDID


  


		WHERE	@CompleteSetID <> 0 AND T1.CompleteSetID=@CompleteSetID
					OR
					@ModuleID <> 0 AND T1.ModuleID = @ModuleID
					OR
					@ProductNPID <> 0 AND T1.ProductNPID = @ProductNPID

	RETURN 0 

	END

GO

GRANT EXECUTE ON stpTP5SELECT TO rolManufacture34, rolTechDoc06

GO







