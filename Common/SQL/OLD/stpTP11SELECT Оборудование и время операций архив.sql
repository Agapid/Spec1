
--ВЫБОРКА  ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpTP11SELECT')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpTP11SELECT as select 1')        

GO 
--stpTP1SELECT 1

	ALTER PROC stpTP11SELECT  @TPID INT

	AS

	/*
		автор: popovml
		система: Технологические маршруты
		описание: Время операций архив
		

		возвращает:
				(0) - все прошло хорошо

	*/

	BEGIN
		SET NOCOUNT ON 


--SELECT * FROM tblTechOperTimeArchive

		DECLARE @Origin INT
		SELECT @Origin = MIN(TOTAID) FROM tblTechOperTimeArchive WHERE TPID=@TPID 

		SELECT	OT.TOTAID AS RecordID,
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
				OT.Remark,
				OT.DateRec,
				UL.Surname
				
				
--SELECT (replace(replace(replace(Creator,'ATLAS\',''),'TITAN\',''),'SATURN\','')) FROM tblTechOperTimeArchive


		FROM tblTechOperTimeArchive AS OT
			INNER JOIN tblTechStandardHour AS STH ON STH.TSHID = OT.TSHID
			INNER JOIN tblTechPlant AS PL ON PL.TPLID = STH.TPLID
			LEFT JOIN tblUserLogins AS UL ON (replace(replace(replace(OT.Creator,'ATLAS\',''),'TITAN\',''),'SATURN\',''))=UL.Login
		WHERE OT.TPID=@TPID --AND OT.TOTAID <> @Origin
		ORDER BY OT.TOTAID DESC

	RETURN 0 

	END

GO

GRANT EXECUTE ON stpTP11SELECT TO rolManufacture34, rolTechDoc06, rolFactoryTP1

GO
