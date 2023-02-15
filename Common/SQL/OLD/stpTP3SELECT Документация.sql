
--ВЫБОРКА  ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpTP3SELECT')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpTP3SELECT as select 1')        

GO 
--stpTP3SELECT 100

	ALTER PROC stpTP3SELECT  @TPID INT

	AS

	/*
		автор: popovml
		система: Технологические маршруты
		описание: Документация
		

		возвращает:
				(0) - все прошло хорошо

	*/


	BEGIN
		SET NOCOUNT ON 
		
		--Действующая документация
		SELECT B.TPDID AS RecordID, 'Действующая'AS DocType, A.TPID, B.TPDID, C.DTName, B.[FileName], B.DateRec, B.flgArchive, B.DateEdit, C.flgOpen, B.Note,
				B.Editor, B.DateEdit, B.Editor + '(' + ISNULL(LGN.Surname,'') + ')' AS Surname
		FROM tblTechPaths as A
			INNER JOIN Files.dbo.tblTechPathDoc as B ON B.TPID = A.TPID and B.flgArchive = 0
			INNER JOIN tblTechDocTypes as C ON C.TDTID = B.TDTID
			LEFT JOIN tblUserLogins AS LGN ON LGN.Login=B.Editor AND LGN.flgArchive=0
		WHERE A.TPID=@TPID
		--ORDER BY B.[FileName], B.DateRec
		UNION ALL
		--архив
		SELECT B.TPDID AS RecordID, 'Архив'AS DocType, A.TPID, B.TPDID, C.DTName, B.[FileName], B.DateRec, B.flgArchive, B.DateEdit, C.flgOpen, B.Note,
				B.Editor, B.DateEdit,  B.Editor + '(' + ISNULL(LGN.Surname,'') + ')' AS Surname
		FROM tblTechPaths as A
			INNER JOIN Files.dbo.tblTechPathDoc as B ON B.TPID = A.TPID and B.flgArchive = 1
			INNER JOIN tblTechDocTypes as C ON C.TDTID = B.TDTID
			LEFT JOIN tblUserLogins AS LGN ON LGN.Login=B.Editor AND LGN.flgArchive=0
		WHERE A.TPID=@TPID	
		ORDER BY B.DateRec
/*
		--ORDER BY B.[FileName], B.DateRec
		UNION ALL
		--конструкторская
		SELECT 'Конструкторская'AS DocType, A.TPID, D.TDTID, D.DTName, C.[FileName], C.DateRec, C.DateEdit, D.flgOpen, C.Note
		FROM tblTechPaths as A
			INNER JOIN tblTechPathLinkDD as B ON B.TPID = A.TPID
			INNER JOIN Files.dbo.tblDesignerDoc as C ON C.DDID = B.DDID and C.flgArchive = 0
			INNER JOIN tblTechDocTypes as D ON D.TDTID = C.TDTID
		WHERE A.TPID=@TPID
		
		--SELECT * FROM tblTechDocTypes
*/
	RETURN 0 

	END

GO

GRANT EXECUTE ON stpTP3SELECT TO rolManufacture34, rolTechDoc06

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




