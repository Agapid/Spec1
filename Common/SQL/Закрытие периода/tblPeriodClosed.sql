

--DROP TABLE [tblPeriodClosed]



--CREATE TABLE [dbo].[tblPeriodClosed] (
--        PeriodClosedID [int] IDENTITY (1, 1) NOT NULL  PRIMARY KEY CLUSTERED,
--		YY INT NOT NULL,
--		MM INT NOT NULL,
--		RBID INT NOT NULL,
--		SystemID INT NOT NULL,
--		PeriodState INT NOT NULL DEFAULT(1),
--				       
--
--
--		Creator VARCHAR(50) DEFAULT SUSER_SNAME(),
--		DateCreate DATETIME DEFAULT CURRENT_TIMESTAMP,
--		Editor VARCHAR(50) DEFAULT SUSER_SNAME(),
--		DateEdit DATETIME DEFAULT CURRENT_TIMESTAMP,
--		Deleted BIT NOT NULL  DEFAULT(0),
--		DateDelete DATETIME,
--		Deletor VARCHAR(50)
--
--)
--
--GO


--ВЫБОРКА  ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpPeriodClosedSELECT')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpPeriodClosedSELECT as select 1')        

GO 




--stpPeriodClosedSELECT NULL, 1
	ALTER PROC stpPeriodClosedSELECT  @RecordID INT = NULL,
									  @SystemID INT

	AS

	/*
		автор: popovml
		система:  Просмотр закрытых периодов
		описание: 
		

		возвращает:
				(0) - все прошло хорошо

	*/

	BEGIN
		SET NOCOUNT ON 

		SELECT  T1.PeriodClosedID AS RecordID,
				T1.PeriodClosedID,
				T1.YY,
				T1.MM,
					MO.SLRMonthName,
				T1.RBID,
					BI.BName,
				T1.PeriodState,
				T1.GlobalClose,
					
				T1.Creator,
				T1.DateEdit,
				T1.Editor,
				T1.DateEdit,
				T1.Deleted,
				T1.DateDelete,
				T1.Deletor

				
		FROM tblPeriodClosed AS T1
				LEFT JOIN tblRefBusiness AS BI ON BI.RBID=T1.RBID AND BI.flgDelete=0
				LEFT JOIN tblSLRMonths AS MO ON MO.SLRMonthNum=T1.MM
				

		WHERE T1.Deleted = 0 AND T1.SystemID = @SystemID AND T1.PeriodClosedID = ISNULL(@RecordID, T1.PeriodClosedID)
        ORDER BY T1.PeriodClosedID 


		RETURN 0 

	END

GO


--stpPeriodClosedSELECT NULL, 1

BEGIN
	GRANT EXECUTE ON stpPeriodClosedSELECT TO rolBudgetFull
END

GO



--МОДИФИКАЦИЯ ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[stpPeriodClosedDUI]')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpPeriodClosedDUI as select 1')        

GO 

	ALTER PROC stpPeriodClosedDUI 
									@PeriodClosedID INT,
									@YY INT = NULL,
									@MM INT = NULL,
									@RBID INT = NULL,
									@SystemID INT = NULL,
									

									@OpCode INT


	AS

	/*
		автор: popovml
		система: Редактирование закрытых периодов
		описание: 
		

		возвращает:
				(0) - все прошло хорошо
				(-1) - такая запись уже существует
				(2) - 

	*/ 

	BEGIN
		SET NOCOUNT ON 

		IF @OpCode=2
			BEGIN
		
					IF EXISTS(SELECT * FROM tblPeriodClosed WHERE Deleted=0 AND YY=@YY AND MM=@MM AND RBID=@RBID AND SystemID=@SystemID)
						BEGIN
							RETURN -1
						END 
				
					INSERT INTO tblPeriodClosed 
								(YY, MM, RBID, SystemID, Deleted, Creator, DateCreate, Editor, DateEdit)

						 VALUES (@YY, @MM, @RBID, @SystemID, 0, SUSER_SNAME(), GETDATE(), SUSER_SNAME(), GETDATE())
				
		        RETURN 0
			END
		IF @OpCode=1
			BEGIN
				
--					UPDATE tblPeriodClosed SET 
--										YY=@YY,
--										MM=@MM,
--										RBID=@RBID,
--										SystemID=@SystemID,
--
--										Editor=SUSER_SNAME(), 
--										DateEdit=GETDATE()
--			                                       
--					WHERE PeriodClosedID = @PeriodClosedID

				RETURN 0
			END
		IF @OpCode=3
			BEGIN
				UPDATE tblPeriodClosed SET Deleted = 1, DateDelete = GETDATE(), Deletor = SUSER_SNAME() WHERE PeriodClosedID = @PeriodClosedID AND GlobalClose=0
				RETURN 0
			END

	END
GO

BEGIN
	GRANT EXECUTE ON stpPeriodClosedDUI TO rolBudgetFull
END


GO

























