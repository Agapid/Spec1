
--ВЫБОРКА  ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpTP4SELECT')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpTP4SELECT as select 1')        

GO 
--stpTP4SELECT 0, 0, 47

	ALTER PROC stpTP4SELECT  @CompleteSetID INT, @ModuleID INT, @ProductNPID INT 

	AS

	/*
		автор: popovml
		система: 
		описание: Трафареты 
		

		возвращает:
				(0) - все прошло хорошо

	*/

	BEGIN
		SET NOCOUNT ON 
		
		SET @CompleteSetID  = ISNULL(@CompleteSetID,0)
		SET @ModuleID  = ISNULL(@ModuleID,0)
		SET @ProductNPID  = ISNULL(@ProductNPID,0)


		SELECT	A.MaskID, 
				A.MaskName, 
				A.ProductNPID, 
				A.FirmID, 
					FINESER.FirmName AS Zakazchik, 
				A.FALID, 
					IZG.FirmName AS Izgotovitel,

				A.MaskStatus,
					Dict1.Descript AS MaskStatusName,
				CAST (A.Cost AS NUMERIC(14,2)) AS Cost,

				A.DateSupply,


				A.MMID, 
					Mater.MaskMaterialName,
				A.MaskQuanSides, 
					Dict2.Descript AS MaskQuanSidesName,


				A.MSID, 
					SIZ.MaskSizeName,

				A.MaskMaterialThickness, 
					Dict3.Descript AS MaskMaterialThicknessName,

				CAST (A.QuanAperture AS INT) AS QuanAperture, 
				 
				A.KeepingCell, 
				 
				A.Note, 

				

				
				Multiplication, 
				DateMaskOrder
		INTO #T
		FROM tblMaskRef as A
			INNER JOIN tblProductNotPiece as B ON B.ProductNPID = A.ProductNPID
			INNER JOIN vw_Firms as IZG ON IZG.FALID = A.FALID
			INNER JOIN vw_Firms as FINESER ON FINESER.FALID = B.FALID   --фирма заказчик (для несерийной прод)
			LEFT JOIN tblDict AS Dict1 ON Dict1.Chapter='MaskStatus' AND Dict1.Value=A.MaskStatus
			LEFT JOIN tblMaskMaterialRef AS Mater ON Mater.MMID=A.MMID
			LEFT JOIN tblDict AS Dict2 ON Dict2.Chapter='MaskQuanSides' AND Dict2.Value=A.MaskQuanSides
			LEFT JOIN tblMaskSizeRef AS SIZ ON SIZ.MSID=A.MSID
			LEFT JOIN tblDict AS Dict3 ON Dict3.Chapter='MaskMaterialThickness' AND Dict3.Value=A.MaskMaterialThickness


  


	WHERE	@CompleteSetID <> 0 AND A.CompleteSetID=@CompleteSetID
				OR
				@ModuleID <> 0 AND A.ModuleID = @ModuleID
				OR
				@ProductNPID <> 0 AND A.ProductNPID = @ProductNPID




	SELECT CAST ('Название'  AS VARCHAR(100)) AS F1, CAST (MaskName AS VARCHAR(100)) AS F2 FROM #T 
	UNION ALL
	SELECT CAST ('Статус' AS VARCHAR(100)) , CAST (MaskStatusName AS VARCHAR(100)) FROM #T 
	UNION ALL
	SELECT CAST ('Дата получения' AS VARCHAR(100)) , CAST (DateSupply AS VARCHAR(100)) FROM #T 
	UNION ALL
	SELECT CAST ('Материал' AS VARCHAR(100)) , CAST (MaskMaterialName AS VARCHAR(100)) FROM #T 
	UNION ALL
	SELECT CAST ('Кол-во сторон' AS VARCHAR(100)) , CAST (MaskQuanSidesName AS VARCHAR(100)) FROM #T 
	UNION ALL
	SELECT CAST ('Примечание' AS VARCHAR(100)) , CAST (Note AS VARCHAR(100)) FROM #T 
	UNION ALL
	SELECT CAST ('Фирма' AS VARCHAR(100)) , CAST (Zakazchik AS VARCHAR(100)) FROM #T 
	UNION ALL
	SELECT CAST ('Стоимость' AS VARCHAR(100)) , CAST (Cost AS VARCHAR(100)) FROM #T 
	UNION ALL
	SELECT CAST ('Ячейка' AS VARCHAR(100)) , CAST (KeepingCell AS VARCHAR(100)) FROM #T 
	UNION ALL
	SELECT CAST ('Размер' AS VARCHAR(100)) , CAST (MaskSizeName AS VARCHAR(100)) FROM #T 
	UNION ALL
	SELECT CAST ('Кол-во апертур' AS VARCHAR(100)) , CAST (QuanAperture AS VARCHAR(100)) FROM #T 
	UNION ALL
	SELECT CAST ('Изготовитель' AS VARCHAR(100)) , CAST (Izgotovitel AS VARCHAR(100)) FROM #T 
	UNION ALL
	SELECT CAST ('Дата заказа' AS VARCHAR(100)) , CAST (DateMaskOrder AS VARCHAR(100)) FROM #T 
	UNION ALL
	SELECT CAST ('Толщина' AS VARCHAR(100)) , CAST (MaskMaterialThicknessName AS VARCHAR(100)) FROM #T 
	UNION ALL
	SELECT CAST ('Мультипликация' AS VARCHAR(100)) , CAST (Multiplication AS VARCHAR(100)) FROM #T 


	RETURN 0 

	END

GO

GRANT EXECUTE ON stpTP4SELECT TO rolManufacture34, rolTechDoc06

GO






