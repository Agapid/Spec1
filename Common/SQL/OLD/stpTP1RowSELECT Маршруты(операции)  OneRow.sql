
--ВЫБОРКА  ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpTP1RowSELECT')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpTP1RowSELECT as select 1')        

GO 
--stpTP1SELECT 1

	ALTER PROC [dbo].[stpTP1RowSELECT]   @RecordID INT

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
				dbo.fncGetUserFIO(A.Editor) AS EditorFIO
		FROM tblTechPaths as A
			INNER JOIN tblTechSOLinks as H ON H.TSOID = A.TSOID
			INNER JOIN tblTechSectors as I ON I.TSID = H.TSID
			INNER JOIN tblTechOperations as C ON C.OperID = H.OperID
			LEFT JOIN v_TPDocCurrentStatus AS STA ON STA.TPID=A.TPID
			LEFT JOIN (SELECT TPID, flgBasic FROM tblTechOperTime WHERE flgBasic =1  GROUP BY TPID, flgBasic) AS OT  ON OT.TPID=A.TPID
			LEFT JOIN (SELECT COUNT(*) AS MLCCount, TPID FROM tblTPMalocenka GROUP BY TPID) AS MLC ON MLC.TPID=A.TPID
			
		WHERE A.TPID=@RecordID

--SELECT * FROM tblTechPaths

	RETURN 0 

	END



GO

GRANT EXECUTE ON stpTP1RowSELECT TO rolManufacture34, rolTechDoc06

GO








