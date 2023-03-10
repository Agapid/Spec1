
	ALTER PROC [dbo].[stpTP13DetailsSELECT]  @ProductTypeID INT, @ProductID INT

	AS

	/*
		автор: popovml
		система: Технологические маршруты 
		описание: просмотр детализации Паспорта запуска
		

		возвращает:
				(0) - все прошло хорошо

	*/


	BEGIN
		SET NOCOUNT ON 

		SELECT  T1.PassDetailsID AS RecordID,
				T1.PassDetailsID,
				T1.LaunchPassID,
				T1.PZOperID,
					T3.PZOperName,
				T1.DefectTypeID,
					T2.Code + '  ' + T2.DefectTypeName AS DefectTypeName,
				
				T1.Remark AS RemarkDet

		FROM tblQualPMLaunchPassDetails AS T1 
				INNER JOIN tblQualDefectTypes AS T2 ON T2.DefectTypeID=T1.DefectTypeID AND T2.Deleted=0
				INNER JOIN tblQualPZOper AS T3 ON T3.PZOperID=T1.PZOperID AND T3.Deleted=0
				INNER JOIN tblQualPMLaunchPass AS PASS ON PASS.LaunchPassID=T1.LaunchPassID AND T1.Deleted=0 AND PASS.ProductTypeID=@ProductTypeID AND PASS.ProductID= @ProductID

		WHERE  T1.Deleted=0

    
	END

GO

GRANT EXECUTE ON stpTP13DetailsSELECT TO rolFactoryTP1, rolManufacture34,  rolTechDoc06

GO
