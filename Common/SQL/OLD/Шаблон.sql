DROP TABLE tblKeeTimePerLogDetails


CREATE TABLE tblKeeTimePerLogDetails
(
    --Счетчик.
	PerLogDetailsID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,

	PerLogID INT NOT NULL,
	CheckPeopleID INT NOT NULL,
	CheckDate SMALLDATETIME,
	Remark VARCHAR(1000),
	StateID INT NOT NULL,



	Deleted BIT NOT NULL  DEFAULT(0),

	/*Служебные поля*/
    Creator VARCHAR(50) DEFAULT SUSER_SNAME(),
    DateCreate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Editor VARCHAR(50) DEFAULT SUSER_SNAME(),
    DateEdit DATETIME DEFAULT CURRENT_TIMESTAMP,

    Deletor VARCHAR(50),
    DateDelete DATETIME




)


GO







--ВЫБОРКА  ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpKeeTimePerLogDetailsSELECT')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpKeeTimePerLogDetailsSELECT as select 1')        

GO 


	ALTER PROC stpKeeTimePerLogDetailsSELECT @PerLogID INT

	AS

	/*
		автор: popovml
		система:  
		описание: просмотр детализации Журнала периодического контроля, заполнение грида с детальными строками
		

		возвращает:
				(0) - все прошло хорошо

	*/


	BEGIN
		SET NOCOUNT ON 

		SELECT  T1.PerLogDetailsID AS RecordID,
				T1.PerLogDetailsID,
				T1.CheckPeopleID,
					INF1.FIO,
				T1.CheckDate,
				T1.Remark AS RemarkDetails,
				T1.StateID,
					T2.StateName


		FROM tblKeeTimePerLogDetails AS T1 
				INNER JOIN tblKeeTimeState AS T2 ON T2.StateID=T1.StateID AND T2.Deleted=0
				LEFT JOIN tblSLRSTR AS INF1 ON T1.CheckPeopleID=INF1.PeopleID AND INF1.YY=YEAR(GETDATE()) AND INF1.MM=MONTH(GETDATE())


		WHERE T1.PerLogID=@PerLogID AND T1.Deleted=0

    
	END

GO

IF @@SERVERNAME = 'TITAN'
	BEGIN
		GRANT EXECUTE ON stpKeeTimePerLogDetailsSELECT TO rolKeeTimeFullControl
	END
--ВЫБОРКА  ДАННЫХ End
GO







	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpKeeTimePerLogDetailsRowSELECT')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpKeeTimePerLogDetailsRowSELECT as select 1')        

GO 


	ALTER PROC stpKeeTimePerLogDetailsRowSELECT @RecordID INT

	AS

	/*
		автор: popovml
		система: Управление качеством. 
		описание: просмотр одной строки детализации Журнала периодического контроля
		

		возвращает:
				(0) - все прошло хорошо

	*/

	BEGIN
		SET NOCOUNT ON 

			SELECT  T1.PerLogDetailsID AS RecordID,
				T1.PerLogDetailsID,
				T1.CheckPeopleID,
					INF1.FIO,
				T1.CheckDate,
				T1.Remark AS RemarkDetails,
				T1.StateID,
					T2.StateName


		FROM tblKeeTimePerLogDetails AS T1 
				INNER JOIN tblKeeTimeState AS T2 ON T2.StateID=T1.StateID AND T2.Deleted=0
				LEFT JOIN tblSLRSTR AS INF1 ON T1.CheckPeopleID=INF1.PeopleID AND INF1.YY=YEAR(GETDATE()) AND INF1.MM=MONTH(GETDATE())


		WHERE T1.PerLogDetailsID=@RecordID AND T1.Deleted=0


    
	END

GO

IF @@SERVERNAME = 'TITAN'
	BEGIN
		GRANT EXECUTE ON stpKeeTimePerLogDetailsRowSELECT TO rolKeeTimeFullControl
	END
--ВЫБОРКА  ДАННЫХ End
GO







--SELECT * FROM tblQualDefectCardDetails


--МОДИФИКАЦИЯ ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[stpKeeTimePerLogDetailsDUI]')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure [stpKeeTimePerLogDetailsDUI] as select 1')        

GO 

	ALTER PROC [stpKeeTimePerLogDetailsDUI] 
									@PerLogDetailsID INT = 0,
									@PerLogID INT = 0,
									@CheckPeopleID INT = 0,
									@CheckDate SMALLDATETIME,
									@Remark VARCHAR(1000),
									@StateID INT = 0,
									@OpCode INT


	AS

	/*
		автор: popovml
		система: Управление качеством 
		описание: полная модификация детализации журнала периодического контроля
		

		возвращает:
				(0) - все прошло хорошо
				(1) - 
				(2) - 

	*/ 

	BEGIN
		SET NOCOUNT ON 

		IF @OpCode=2
			BEGIN

				
					INSERT INTO tblKeeTimePerLogDetails 
								(PerLogID, CheckPeopleID, CheckDate, StateID, Remark, Deleted, Creator, DateCreate, Editor, DateEdit)

						 VALUES (@PerLogID, @CheckPeopleID, @CheckDate, @StateID, @Remark, 0, SUSER_SNAME(), GETDATE(), SUSER_SNAME(), GETDATE())
				
		        RETURN 0
			END
		IF @OpCode=1
			BEGIN
				
					UPDATE tblKeeTimePerLogDetails SET 
										CheckPeopleID=@CheckPeopleID,
										CheckDate=@CheckDate,
										StateID=@StateID,
										Remark=@Remark,
 										Editor=SUSER_SNAME(), 
										DateEdit=GETDATE()
			                                       
					WHERE PerLogDetailsID = @PerLogDetailsID

					 IF @@ERROR <> 0 
						BEGIN
							ROLLBACK TRAN
							RETURN
						END

				RETURN 0
			END
		IF @OpCode=3
			BEGIN
				UPDATE tblKeeTimePerLogDetails SET Deleted = 1, Deletor=SUSER_SNAME(), DateDelete=GETDATE() WHERE PerLogDetailsID = @PerLogDetailsID
				RETURN 0
			END

	END
GO

--IF @@SERVERNAME = 'TITAN'
	BEGIN
		GRANT EXECUTE ON [stpKeeTimePerLogDetailsDUI] TO rolKeeTimeFullControl
	END
--МОДИФИКАЦИЯ ДАННЫХ End

GO
