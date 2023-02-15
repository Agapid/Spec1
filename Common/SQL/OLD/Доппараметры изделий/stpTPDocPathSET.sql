ALTER PROC [dbo].[stpTPDocPathSET]
							@ProductTypeID INT,
							@ProductID INT,
							@DocType INT,  --1 Технологическая документация, 2 - Конструкторская документация 3 - Складская документация.
							@DocPath VARCHAR(1000)
							
							
AS


BEGIN

	IF NOT EXISTS(SELECT * FROM tblTPProdOptions WHERE ProductTypeID=@ProductTypeID AND ProductID=@ProductID AND DocType=@DocType)
		BEGIN
			INSERT INTO tblTPProdOptions(ProductTypeID, ProductID, DocType, DocPath, Creator, DateCreate, Editor,  DateEdit)
				VALUES (@ProductTypeID, @ProductID, @DocType, @DocPath, (suser_sname()), (getdate()), (suser_sname()),  (getdate()))
		END
	ELSE
		BEGIN
			UPDATE tblTPProdOptions SET DocPath=@DocPath WHERE ProductTypeID=@ProductTypeID AND ProductID=@ProductID AND DocType=@DocType
		END



	

END							
							
GO
			
GRANT EXECUTE ON stpTPDocPathSET TO rolManufacture34, rolTechDoc06, rolFactoryTP1
GO

--SELECT * FROM tblTPProdOptions
--UPDATE tblTPProdOptions SET DocType=2

--DELETE FROM tblTPProdOptions WHERE TPProdOptionID<3