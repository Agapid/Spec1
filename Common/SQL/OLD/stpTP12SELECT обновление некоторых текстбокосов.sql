
--ВЫБОРКА  ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpTP12SELECT')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpTP12SELECT as select 1')        

GO 
--stpTP1SELECT 1

	ALTER PROC [dbo].[stpTP12SELECT]	@ProductTypeID INT,
										@ProductID INT
										

	AS

	/*
		автор: popovml
		система: Технологические маршруты
		описание: обновление некоторых текстбоксов
		

		возвращает:
				(0) - все прошло хорошо

	*/

	BEGIN
		SET NOCOUNT ON 

		DECLARE @DocPath VARCHAR(500), @StatusName VARCHAR(500), @ConfirmFunctionID INT
		SELECT @DocPath = '', @StatusName='', @ConfirmFunctionID=0

		

		SELECT @DocPath=DocPath FROM tblTPProdOptions WHERE ProductTypeID=@ProductTypeID AND ProductID=@ProductID

		SELECT @StatusName=StatusName, @ConfirmFunctionID=ConfirmFunctionID FROM v_TPCurrentStatus WHERE ProductTypeID=@ProductTypeID AND ProductID=@ProductID
		
		SELECT @DocPath AS DocPath, @StatusName AS StatusName, @ConfirmFunctionID AS ConfirmFunctionID,
				CASE WHEN @ProductTypeID<>0 AND (@ConfirmFunctionID=0 OR @ConfirmFunctionID=8 OR @ConfirmFunctionID=12) THEN 1 ELSE 0 END AS EnableModify,
				CASE WHEN @ProductTypeID<>0 THEN 1 ELSE 0 END AS EnableModify1


	RETURN 0 

	END



GO

GRANT EXECUTE ON stpTP12SELECT TO rolManufacture34, rolTechDoc06, rolFactoryTP1

GO
