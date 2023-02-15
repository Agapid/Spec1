--if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tblKeeTimePeriodEl') and objECTPROPERTY(id, N'IsUserTable') = 1)
--drop table [dbo].tblKeeTimePeriodEl
--GO
--
--
----SELECT * FROM tblKeeTimePeriodEl
--/*Периодичность*/
--CREATE TABLE tblKeeTimePeriodEl
--(
--    
--	PeriodElID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
--
--	ElementID INT,
--	PeriodID INT,
--
--
--    Creator VARCHAR(50) DEFAULT SUSER_SNAME(),
--    DateCreate DATETIME DEFAULT CURRENT_TIMESTAMP,
--    Editor VARCHAR(50) DEFAULT SUSER_SNAME(),
--    DateEdit DATETIME DEFAULT CURRENT_TIMESTAMP,
--	Deleted BIT NOT NULL  DEFAULT(0),
--	DateDelete DATETIME,
--	Deletor VARCHAR(50),
--
--)
--
--GO

--ВЫБОРКА  ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpKeeTimePeriodElSELECT')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpKeeTimePeriodElSELECT as select 1')        

GO 


	ALTER PROC stpKeeTimePeriodElSELECT  @RecordID INT = NULL

	AS

	/*
		автор: popovml
		система:  
		описание: полный просмотр справочника Периоды проверки элементов на хранении
		

		возвращает:
				(0) - все прошло хорошо

	*/

	BEGIN
		SET NOCOUNT ON 

		SELECT  T1.PeriodElID AS RecordID,
				T1.ElementID,
					T3.ComponentName, 
				T1.PeriodID,
					T2.QTY,
				

				
				T1.Creator,
				T1.DateEdit,
				T1.Editor,
				T1.DateEdit,
				T1.Deleted,
				T1.DateDelete,
				T1.Deletor

				
		FROM tblKeeTimePeriodEl AS T1
				INNER JOIN tblKeeTimePeriod AS T2 ON T2.PeriodID=T1.PeriodID AND T2.Deleted = 0
				INNER JOIN tblComponents AS T3 ON T3.ElementID=T1.ElementID AND T3.flgView <> 0
				
		WHERE T1.Deleted = 0 AND T1.PeriodElID = ISNULL(@RecordID, T1.PeriodElID)

        ORDER BY T1.PeriodElID


		RETURN 0 

	END

GO



--IF @@SERVERNAME = 'TITAN'
	BEGIN
		GRANT EXECUTE ON stpKeeTimePeriodElSELECT TO rolKeeTimeFullControl
	END
--ВЫБОРКА  ДАННЫХ End
GO





--МОДИФИКАЦИЯ ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[stpKeeTimePeriodElDUI]')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure [stpKeeTimePeriodElDUI] as select 1')        

GO 

	ALTER PROC [stpKeeTimePeriodElDUI] 
									@PeriodElID INT,
									@ElementID INT,
									@PeriodID INT,

									@OpCode INT


	AS

	/*
		автор: popovml
		система: Управление качеством 
		описание: полная модификация справочника Периоды проверки элементов на хранении
		

		возвращает:
				(0) - все прошло хорошо
				(1) - 
				(2) - 

	*/ 

	BEGIN
		SET NOCOUNT ON 

		IF @OpCode=2
			BEGIN
		
				
					INSERT INTO tblKeeTimePeriodEl 
								(ElementID, PeriodID, Deleted, Creator, DateCreate, Editor, DateEdit)

						 VALUES (@ElementID, @PeriodID, 0, SUSER_SNAME(), GETDATE(), SUSER_SNAME(), GETDATE())
				
		        RETURN 0
			END
		IF @OpCode=1
			BEGIN
				
					UPDATE tblKeeTimePeriodEl SET 
										ElementID=@ElementID,
										PeriodID=@PeriodID,
										Editor=SUSER_SNAME(), 
										DateEdit=GETDATE()
			                                       
					WHERE PeriodElID = @PeriodElID

				RETURN 0
			END
		IF @OpCode=3
			BEGIN
				UPDATE tblKeeTimePeriodEl SET Deleted = 1, DateDelete = GETDATE(), Deletor = SUSER_SNAME() WHERE PeriodElID = @PeriodElID
				RETURN 0
			END

	END
GO

--IF @@SERVERNAME = 'TITAN'
	BEGIN
		GRANT EXECUTE ON [stpKeeTimePeriodElDUI] TO rolKeeTimeFullControl
	END
--МОДИФИКАЦИЯ ДАННЫХ End

GO

















