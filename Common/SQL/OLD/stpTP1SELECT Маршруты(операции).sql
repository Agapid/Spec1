
--ВЫБОРКА  ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpTP1SELECT')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpTP1SELECT as select 1')        

GO 
--stpTP1SELECT 1

ALTER PROC [dbo].[stpTP1SELECT]  @CompleteSetID INT, @ModuleID INT, @ProductNPID INT 

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
		
		SET @CompleteSetID  = ISNULL(@CompleteSetID,0)
		SET @ModuleID  = ISNULL(@ModuleID,0)
		SET @ProductNPID  = ISNULL(@ProductNPID,0)


		SELECT	CAST (1 AS BIT) AS Checked,
				A.TPID AS RecordID,
				A.TPID, 
				C.OperName,
				I.TechSectorName, 
				A.TSOID, 
				A.Note, 
				A.Priority, 
				A.CompleteSetID, 
				A.ModuleID, 
				A.ProductNPID, 
				A.DateBAccount,
				STA.StatusName AS DocStatusName,
				CAST (1 AS BIT) AS WillCopy,
				CASE WHEN OT.flgBasic=1 THEN 'Внесено' ELSE NULL END AS checkflgBasic,
				CASE WHEN (ISNULL(STA.ConfirmFunctionID,0)=0 OR STA.ConfirmFunctionID=10 OR STA.ConfirmFunctionID=11) THEN 1 ELSE 0 END AS EnableModify,
				CASE WHEN ISNULL(MLC.MLCCount,0)=0 THEN '' ELSE 'Внесено' END AS MLCStatusName,
				A.DateEdit AS opDateEdit,
				dbo.fncGetUserFIO(A.Editor) AS EditorFIO,
				H.OperID

		FROM tblTechPaths as A
			INNER JOIN tblTechSOLinks as H ON H.TSOID = A.TSOID
			INNER JOIN tblTechSectors as I ON I.TSID = H.TSID
			INNER JOIN tblTechOperations as C ON C.OperID = H.OperID
			LEFT JOIN v_TPDocCurrentStatus AS STA ON STA.TPID=A.TPID
			LEFT JOIN (SELECT TPID, flgBasic FROM tblTechOperTime WHERE flgBasic =1  GROUP BY TPID, flgBasic) AS OT  ON OT.TPID=A.TPID
			LEFT JOIN (SELECT COUNT(*) AS MLCCount, TPID FROM tblTPMalocenka GROUP BY TPID) AS MLC ON MLC.TPID=A.TPID

			
		WHERE	@CompleteSetID <> 0 AND A.CompleteSetID=@CompleteSetID
				OR
				@ModuleID <> 0 AND A.ModuleID = @ModuleID
				OR
				@ProductNPID <> 0 AND A.ProductNPID = @ProductNPID


/*

			INNER JOIN dbo.vwAccessPersonToProductsNotPieceByDomains AS APPNPD ON APPNPD.ProductNPID=ISNULL(A.ProductNPID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
			INNER JOIN dbo.vwAccessPersonToCompleteSetsByDomains AS APCSD ON APCSD.CompleteSetID=ISNULL(A.CompleteSetID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
			INNER JOIN dbo.vwAccessPersonToModulesByDomains AS APMD ON APMD.ModuleID=ISNULL(A.ModuleID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.              

*/
		ORDER BY A.Priority
--SELECT * FROM tblTPConfirmFunctions WHERE SystemType=3

	RETURN 0 

	END




GO

GRANT EXECUTE ON stpTP1SELECT TO rolManufacture34, rolTechDoc06

GO









--
--
--
----ВЫБОРКА  ДАННЫХ Begin
--	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpQualRemontCardRowSELECT')
--
--				 and objECTPROPERTY(id, N'IsProcedure') = 1))
--		   -- Создаем заглушку
--		   exec ('create procedure stpQualRemontCardRowSELECT as select 1')        
--
--GO 
--
----stpQualRemontCardRowSELECT 1
--	ALTER PROC stpQualRemontCardRowSELECT  @RecordID INT
--
--	AS
--
--	/*
--		автор: popovml
--		система: Управление качеством ПК. 
--		описание: полный просмотр одной карты
--		
--
--		возвращает:
--				(0) - все прошло хорошо
--
--	*/
--
--	BEGIN
--		SET NOCOUNT ON 
--
--
--		SELECT  DC.RemontCardID AS RecordID,
--				DC.RemontCardID,
--				
--					--TS.TechSectorName,
--				DC.PersonControllerID,
--					INF1.FIO AS PersonControllerFIO,
--					INF1.NativePodrName AS ControllerNativePodrName,
--				DC.ControllDate,
--				DC.RemontDate,
--				DC.PersonOperatorID,
--					INF2.FIO AS PersonOperatorFIO,
--					INF2.NativePodrName AS PersonOperatorNativePodrName,
--				DC.ModuleID,
--					MODU.ModuleName,
--				DC.DefectTypeID,
--					T2.Code + '  ' + T2.DefectTypeName AS HDefectTypeName,
--				DC.QtyChecked,
--				DC.Remark,
--				DC.IdenNumRemark,
--				DC.ActNum,
--				DC.Deleted,
--				DC.Creator,
--				DC.DateEdit,
--				DC.Editor,
--				DC.DateEdit,
--				DC.Deletor,
--				DC.DateDelete
--				
--		FROM dbo.tblQualRemontCard AS DC
--				--INNER JOIN tblTechSectors AS TS ON TS.TSID=DC.SectorRemontDetectID
--				INNER JOIN tblModules AS MODU ON MODU.ModuleID=DC.ModuleID AND MODU.flgView=0
--				LEFT JOIN tblSLRSTR AS INF1 ON DC.PersonControllerID=INF1.PeopleID AND INF1.YY=YEAR(GETDATE()) AND INF1.MM=MONTH(GETDATE())
--				LEFT JOIN tblSLRSTR AS INF2 ON DC.PersonOperatorID=INF2.PeopleID AND INF2.YY=YEAR(GETDATE()) AND INF2.MM=MONTH(GETDATE())
--				INNER JOIN tblQualDefectTypes AS T2 ON T2.DefectTypeID=DC.DefectTypeID AND T2.Deleted=0
--				
--		WHERE DC.RemontCardID = @RecordID AND DC.Deleted = 0 
--
--
--
--
--		RETURN 0 
--
--	END
--
--GO
--
--
--BEGIN
--	GRANT EXECUTE ON stpQualRemontCardRowSELECT TO rolQualFullControl
--END
--
--GO
--
--
--
--




