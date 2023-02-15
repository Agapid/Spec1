

--ВЫБОРКА  ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpTPListSELECT')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpTPListSELECT as select 1')        

GO 
--stpTPHeadersSELECT 1

		ALTER PROC [dbo].[stpTPListSELECT] @P INT = 0

	AS

	/*
		автор: popovml
		система: 
		описание: 
		

		возвращает:
				(0) - все прошло хорошо

	*/

	BEGIN
		SET NOCOUNT ON 


		--SELECT -1, -1, -1, 
		/*		
		ProductTypeID ProductTypeName
		------------- ----------------------------------------------------------------------------------------------------
		1             Модуль
		2             Комплект
		3             Несерийное изделие
		4             Элемент
		5             Изделие
		*/
--SELECT * FROM v_TPTPStatus

		CREATE TABLE #T (ProductTypeID INT, RecordID VARCHAR(11), CompleteSetID INT, ModuleID INT, ProductNPID INT, UnitName VARCHAR (100), Type VARCHAR (30), EnabledTP BIT, Diff INT, StatusName VARCHAR (30), 
						ConfirmFunctionID INT, ProductID INT , --DocPath VARCHAR (1000), 
						FirmName VARCHAR (1000))
					


		INSERT INTO #T (ProductTypeID, RecordID, CompleteSetID, ModuleID, ProductNPID, UnitName, Type, EnabledTP, Diff, StatusName,
						ConfirmFunctionID, 	ProductID, --DocPath, 
						FirmName)


		SELECT 0 AS ProductTypeID, CAST('TT'  AS VARCHAR(11)) AS RecordID, NULL AS CompleteSetID, NULL AS ModuleID, NULL AS ProductNPID, '  -=Выберите изделие=-  ' AS UnitName, NULL AS Type, 0 AS EnabledTP, 0 AS Diff, 'N/A' AS StatusName, 0 AS ConfirmFunctionID,
				0 AS ProductID, --'' AS DocPath, 
				'' AS FirmName
		UNION ALL

		--поле EnabledTP нужно для того, чтобы запретить редактировать строки с трудоемкостью
		SELECT 2 AS ProductTypeID, 'k' + CAST(T1.CompleteSetID AS VARCHAR(10)) AS RecordID, T1.CompleteSetID, null as ModuleID, null as ProductNPID, CompleteSetName as UnitName, 'Комплект' as Type, 
			   cast(case when is_member('rolManufacture34') = 1 or user_name() = 'dbo' then 1 else 0 end as bit) as EnabledTP,
				CASE WHEN tDiff.CompleteSetID IS NOT NULL THEN 1 ELSE 0 END AS Diff,
				ISNULL(ST.StatusName, 'нет') AS StatusName,
				ISNULL(ST.ConfirmFunctionID,0),
				T1.CompleteSetID AS ProductID,
				--OP.DocPath, 
				SUB.Description
			FROM tblCompleteSets AS T1 
				--LEFT JOIN tblTPProdOptions AS OP ON OP.ProductTypeID=2 AND OP.ProductID=T1.CompleteSetID
				LEFT JOIN v_TPCurrentStatus AS ST ON ST.ProductTypeID=2 AND ST.ProductID=T1.CompleteSetID
				INNER JOIN dbo.vwAccessPersonToCompleteSetsByDomains AS APCSD ON APCSD.CompleteSetID=T1.CompleteSetID -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
				LEFT JOIN 
    				(
    					SELECT DISTINCT A.CompleteSetID 
							FROM tblTechPaths as A
								INNER JOIN dbo.vwAccessPersonToProductsNotPieceByDomains AS APPNPD ON APPNPD.ProductNPID=ISNULL(A.ProductNPID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
								INNER JOIN dbo.vwAccessPersonToModulesByDomains AS APMD ON APMD.ModuleID=ISNULL(A.ModuleID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.              
    							INNER JOIN tblTechOperTime as B ON B.TPID = A.TPID AND B.flgBasic=1
    					WHERE DATEDIFF(mm, B.DateBAccount, B.DateEdit) >=6 
    				) AS tDiff ON tDiff.CompleteSetID=T1.CompleteSetID
				LEFT JOIN tblSubjects AS SUB ON SUB.SubjectID=T1.SubjectID
    		WHERE T1.[View] = 1
		UNION ALL
		SELECT 1 AS ProductTypeID, 'm' + CAST(T1.ModuleID AS VARCHAR(10)) AS RecordID, null as CompleteSetID, T1.ModuleID, null as ProductNPID, ModuleName as UnitName, 'Модуль' as Type, 
			   cast(case when is_member('rolManufacture34') = 1 or user_name() = 'dbo' then 1 else 0 end as bit) as EnabledTP,
				CASE WHEN tDiff.ModuleID IS NOT NULL THEN 1 ELSE 0 END AS Diff,
				ISNULL(ST.StatusName, 'нет') AS StatusName,
				ISNULL(ST.ConfirmFunctionID,0),
				T1.ModuleID AS ProductID,
				--OP.DocPath, 
				SUB.Description
			FROM tblModules T1 
				--LEFT JOIN tblTPProdOptions AS OP ON OP.ProductTypeID=1 AND OP.ProductID=T1.ModuleID
				LEFT JOIN v_TPCurrentStatus AS ST ON ST.ProductTypeID=1 AND ST.ProductID=T1.ModuleID
				INNER JOIN dbo.vwAccessPersonToModulesByDomains AS APMD ON APMD.ModuleID=T1.ModuleID -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
				LEFT JOIN 
    				(
    					SELECT DISTINCT A.ModuleID 
							FROM tblTechPaths as A
								INNER JOIN dbo.vwAccessPersonToProductsNotPieceByDomains AS APPNPD ON APPNPD.ProductNPID=ISNULL(A.ProductNPID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
								INNER JOIN dbo.vwAccessPersonToCompleteSetsByDomains AS APCSD ON APCSD.CompleteSetID=ISNULL(A.CompleteSetID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
    							INNER JOIN tblTechOperTime as B ON B.TPID = A.TPID AND B.flgBasic=1
    					WHERE DATEDIFF(mm, B.DateBAccount, B.DateEdit) >=6 
    				) AS tDiff ON tDiff.ModuleID=T1.ModuleID
				LEFT JOIN tblSubjects AS SUB ON SUB.SubjectID=T1.SubjectID
    		WHERE flgView = 0
		UNION ALL

		SELECT 3 AS ProductTypeID, 'p' + CAST(T1.ProductNPID AS VARCHAR(10)) AS RecordID, null as CompleteSetID, null as ModuleID, T1.ProductNPID, ProductName as UnitName, 'Несерийное изделие' as Type, 
			   cast(case when is_member('rolManufacture34') = 1 or user_name() = 'dbo' then 1 else 0 end as bit) as EnabledTP,
				CASE WHEN tDiff.ProductNPID IS NOT NULL THEN 1 ELSE 0 END AS Diff,
				ISNULL(ST.StatusName, 'нет') AS StatusName,
				ISNULL(ST.ConfirmFunctionID,0),
				T1.ProductNPID AS ProductID,
				--OP.DocPath,
				F.FirmName
			FROM tblProductNotPiece AS T1 
				--LEFT JOIN tblTPProdOptions AS OP ON OP.ProductTypeID=3 AND OP.ProductID=T1.ProductNPID
				LEFT JOIN v_TPCurrentStatus AS ST ON ST.ProductTypeID=3 AND ST.ProductID=T1.ProductNPID
				INNER JOIN dbo.vwAccessPersonToProductsNotPieceByDomains AS APPNPD ON APPNPD.ProductNPID=T1.ProductNPID -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
				LEFT JOIN 
    				(
    					SELECT DISTINCT A.ProductNPID 
							FROM tblTechPaths as A
								INNER JOIN dbo.vwAccessPersonToCompleteSetsByDomains AS APCSD ON APCSD.CompleteSetID=ISNULL(A.CompleteSetID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
								INNER JOIN dbo.vwAccessPersonToModulesByDomains AS APMD ON APMD.ModuleID=ISNULL(A.ModuleID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.              
    							INNER JOIN tblTechOperTime as B ON B.TPID = A.TPID AND B.flgBasic=1
    					WHERE DATEDIFF(mm, B.DateBAccount, B.DateEdit) >=6 
    				) AS tDiff  ON tDiff.ProductNPID=T1.ProductNPID
				LEFT JOIN vw_Firms AS F ON F.FALID=T1.FALID
			--WHERE T1.ProductNPID=5157
			
		
			SELECT ProductTypeID, RecordID, CompleteSetID, ModuleID, ProductNPID, UnitName, Type, EnabledTP, Diff, StatusName,
						ConfirmFunctionID, 
						CASE WHEN ProductTypeID<>0 AND (ConfirmFunctionID=0 OR ConfirmFunctionID=8 OR ConfirmFunctionID=12) THEN 1 ELSE 0 END AS EnableModify,
						CASE WHEN ProductTypeID<>0 THEN 1 ELSE 0 END AS EnableModify1,

						ProductID, --DocPath, 
						FirmName
					

			FROM #T 

			WHERE @P=0 OR (@P<>0 AND ConfirmFunctionID=5)

			ORDER BY UnitName

		RETURN 0 

	END

GO
GRANT EXECUTE ON stpTPListSELECT TO rolManufacture34, rolTechDoc06
GO








