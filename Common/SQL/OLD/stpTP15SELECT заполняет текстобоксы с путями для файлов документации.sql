
--ВЫБОРКА  ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpTP15SELECT')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure [stpTP15SELECT] as select 1')        

GO 
--stpTP1SELECT 1
	--stpTP15SELECT 2584, 2
	ALTER PROC [dbo].[stpTP15SELECT]	@ProductTypeID INT,
										@ProductID INT
										--@DocType INT
										

	AS

	/*
		автор: popovml
		система: Технологические маршруты
		описание: заполняет текстобоксы с путями для файлов документации
		

		возвращает:
				(0) - все прошло хорошо

	*/

	BEGIN
		SET NOCOUNT ON 
		--1 Технологическая документация, 2 - Конструкторская документация 3 - Складская документация.
		
		DECLARE @DocPathTD VARCHAR(2000), @DocPathKD VARCHAR(2000), @DocPathSklad VARCHAR(2000) 
		SELECT @DocPathTD = '', @DocPathKD = '', @DocPathSklad = ''

		SELECT @DocPathTD = DocPath FROM tblTPProdOptions WHERE ProductTypeID=@ProductTypeID AND ProductID=@ProductID AND DocType=1
		SELECT @DocPathKD = DocPath FROM tblTPProdOptions WHERE ProductTypeID=@ProductTypeID AND ProductID=@ProductID AND DocType=2
		SELECT @DocPathSklad = DocPath FROM tblTPProdOptions WHERE ProductTypeID=@ProductTypeID AND ProductID=@ProductID AND DocType=3
		 
		

		SELECT	@DocPathTD AS DocPathTD, 
				@DocPathKD AS DocPathKD, 
				@DocPathSklad AS DocPathSklad
		--SELECT * FROM tblTPProdOptions
		
		
		--SELECT * FROM tblTPProdOptions
		
		
		
		
		


		

	

	END



GO
GRANT EXECUTE ON stpTP15SELECT TO rolManufacture34, rolTechDoc06, rolFactoryTP1
GO
