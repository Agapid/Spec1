
--ВЫБОРКА  ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpTP2RowSELECT')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpTP2RowSELECT as select 1')        

GO 
--stpTP1SELECT 1

	ALTER PROC stpTP2RowSELECT @RecordID INT

	AS

	/*
		автор: popovml
		система: Технологические маршруты
		описание: Время операций
		

		возвращает:
				(0) - все прошло хорошо

	*/

	BEGIN
		SET NOCOUNT ON 



		SELECT	OT.TOTID AS RecordID,
				OT.TOTID,
				OT.TPID,
				OT.TSHID,
				PL.TPLID,
				PL.TPLName,

				OT.PreparTime,
				OT.BasicTime,
				OT.flgBasic,
				OT.Factor,
				OT.DateBAccount,
				OT.DateEdit,
				DATEDIFF(mm, OT.DateBAccount, OT.DateEdit) AS Diff,
				Remark

		FROM tblTechOperTime AS OT
			INNER JOIN tblTechStandardHour AS STH ON STH.TSHID = OT.TSHID
			INNER JOIN tblTechPlant AS PL ON PL.TPLID = STH.TPLID
		WHERE OT.TOTID=@RecordID





/*

параметры  @CompleteSetID INT, @ModuleID INT, @ProductNPID INT,  @TSOID INT

    	SET @CompleteSetID  = ISNULL(@CompleteSetID,0)
		SET @ModuleID  = ISNULL(@ModuleID,0)
		SET @ProductNPID  = ISNULL(@ProductNPID,0)
    
    
		SELECT D.TSHID, E.TPLName, C.TechSectorName, F.OperName, A.TSOID, A.CompleteSetID, A.ModuleID, A.ProductNPID--, A.*
			FROM tblTechPaths as A
				INNER JOIN tblTechSOLinks as B ON B.TSOID = A.TSOID
				INNER JOIN tblTechSectors as C ON C.TSID = B.TSID
				INNER JOIN tblTechStandardHour as D ON D.TSOID = A.TSOID
				INNER JOIN tblTechPlant as E ON E.TPLID = D.TPLID
				INNER JOIN tblTechOperations as F ON F.OperID = B.OperID
	    
		WHERE A.TSOID=@TSOID AND 
    
				@CompleteSetID <> 0 AND A.CompleteSetID=@CompleteSetID
				OR
				@ModuleID <> 0 AND A.ModuleID = @ModuleID
				OR
				@ProductNPID <> 0 AND A.ProductNPID = @ProductNPID
				
        ORDER BY E.TPLName

*/

	RETURN 0 

	END

GO

GRANT EXECUTE ON stpTP2RowSELECT TO rolManufacture34, rolTechDoc06

GO



