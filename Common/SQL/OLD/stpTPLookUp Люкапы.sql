

	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpTPLookUp')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpTPLookUp as select 1')        

GO 


		ALTER PROC [dbo].[stpTPLookUp]  @LookUpID INT = 0,
							@CompleteSetID INT = NULL,
							@ModuleID INT = NULL,
							@ProductNPID INT = NULL, 
							@TSOID INT = NULL
	AS

	/*
		автор: popovml
		система: Технологические маршруты
		описание: люкапы
		stpTPLookUp 4

		возвращает:
				(0) - все прошло хорошо

	*/
--stpTPLookUp 0, 0, 553, 10
	BEGIN
		SET NOCOUNT ON 


		IF @LookUpID = 1
			BEGIN
			
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
						(
		    
						@CompleteSetID <> 0 AND A.CompleteSetID=@CompleteSetID
						OR
						@ModuleID <> 0 AND A.ModuleID = @ModuleID
						OR
						@ProductNPID <> 0 AND A.ProductNPID = @ProductNPID
						)
				ORDER BY E.TPLName
        
			END

		IF @LookUpID = 2
			BEGIN
				--DECLARE @CurUser INT
				--SET @CurUser = dbo.fncPurOrderCurUserID()
				--SELECT  @CurUser
				--SELECT * FROM tblTPConfirmFunctions
				
				SELECT -1 AS ConfirmFunctionID, 'ВЫБОР СТАТУСА МАРШРУТА' AS FunctionName, 'ВЫБЕРИТЕ СТАТУС МАРШРУТА' AS StatusName, -1 AS Priority
				
				UNION ALL
				
				
				SELECT T1.ConfirmFunctionID, T2.FunctionName, T2.StatusName, T2.Priority FROM tblTPConfirmFunctionsDetails AS T1
				
						INNER JOIN tblTPConfirmFunctions AS T2 ON T2.ConfirmFunctionID=T1.ConfirmFunctionID
				WHERE T2.SystemType=2 AND T1.PeopleID=dbo.fncCurrentUserID() ORDER BY T2.Priority
			


			--SELECT	T1.FunctionName, 
			--		T1.StatusName, 
			--		T2.ConfirmFunctionID,
			--		CASE WHEN T2.ConfirmFunctionID IS NULL THEN 0 ELSE 1 END AS IsEnabled
					
			--FROM tblTPConfirmFunctions AS T1
			--		LEFT JOIN 
			--				(SELECT ConfirmFunctionID FROM tblTPConfirmFunctionsDetails WHERE PeopleID=dbo.fncPurOrderCurUserID()) AS T2
			--				ON T2.ConfirmFunctionID=T1.ConfirmFunctionID							
							
				
			--			--LEFT JOIN tblTPConfirmFunctionsDetails AS T2 ON T2.ConfirmFunctionID=T1.ConfirmFunctionID
			--	WHERE T1.SystemType=2




			END

		
		IF @LookUpID = 3

			BEGIN
				SELECT T1.MLCItemID, 
					   T1.MLCItemName,
						T2.MLCSectionName,
						T3.MLCGroupName


				 FROM tblMLCItems AS T1 
						INNER JOIN tblMLCSections AS T2 ON T1.MLCSectionID=T2.MLCSectionID
						INNER JOIN tblMLCGroups AS T3 ON T3.MLCGroupID=T2.MLCGroupID
				ORDER BY T1.MLCItemName


			END




		IF @LookUpID = 4
			BEGIN

				SELECT -1 AS ConfirmFunctionID, 'ВЫБОР СТАТУСА ДОКУМЕНТАЦИИ' AS FunctionName, 'ВЫБЕРИТЕ СТАТУС ДОКУМЕНТАЦИИ' AS StatusName, -1 AS Priority
				
				UNION ALL

				SELECT T1.ConfirmFunctionID, T2.FunctionName, T2.StatusName, T2.Priority FROM tblTPConfirmFunctionsDetails AS T1
				
						INNER JOIN tblTPConfirmFunctions AS T2 ON T2.ConfirmFunctionID=T1.ConfirmFunctionID
				WHERE T2.SystemType=3 AND T1.PeopleID=dbo.fncCurrentUserID()
			
				ORDER BY T2.Priority

		

			END
			
			
		IF @LookUpID = 5
			BEGIN

				 SELECT MPT.MPTID, MPT.MPTID 
						FROM tblMagProductionTooling AS MPT
							INNER JOIN dbo.vwAccessPersonToCompleteSetsByDomains AS APCSD ON APCSD.CompleteSetID=ISNULL(MPT.CompleteSetID, -1) -- Добавил 03/2016 Денис всвязи с введением разграничений по территориям.
							INNER JOIN dbo.vwAccessPersonToModulesByDomains AS APMD ON APMD.ModuleID=ISNULL(MPT.ModuleID, -1) -- Добавил 03/2016 Денис всвязи с введением разграничений по территориям.
							INNER JOIN dbo.vwAccessPersonToProductsNotPieceByDomains AS APPNPD ON APPNPD.ProductNPID=ISNULL(MPT.ProductNPID, -1) -- Добавил 03/2016 Денис всвязи с введением разграничений по территориям.
						WHERE MPT.ProductNPID = @ProductNPID
						ORDER BY MPT.MPTID

			
			END
			
			
			
			

			

	RETURN 0 

	END

GO

