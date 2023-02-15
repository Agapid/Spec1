
--ВЫБОРКА  ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpTP2SELECT')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpTP2SELECT as select 1')        

GO 
--stpTP1SELECT 1

	ALTER PROC stpTP2SELECT  @TPID INT

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


--		SELECT B.TOTID AS RecordID, B.TOTID, A.TPID, B.TSHID, B.PreparTime, B.BasicTime, B.flgBasic, A.TSOID, B.Factor, B.DateBAccount, B.DateEdit, DATEDIFF(mm, B.DateBAccount, B.DateEdit) AS Diff
--		FROM tblTechPaths as A
--			INNER JOIN tblTechOperTime as B ON B.TPID = A.TPID
--			INNER JOIN tblTechStandardHour as D ON D.TSOID = A.TSOID
--			INNER JOIN tblTechPlant as E ON E.TPLID = D.TPLID
--
--
--		WHERE  A.TPID = @TPID




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
		WHERE OT.TPID=@TPID


	RETURN 0 

	END

GO

GRANT EXECUTE ON stpTP2SELECT TO rolManufacture34, rolTechDoc06

GO
--stpTP2RowSELECT 11314



--stpTP2SELECT 16232


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




