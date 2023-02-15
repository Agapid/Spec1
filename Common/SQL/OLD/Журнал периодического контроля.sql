--if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tblKeeTimePerLog') and objECTPROPERTY(id, N'IsUserTable') = 1)
--drop table [dbo].tblKeeTimePerLog
--GO
--
--/*Журнал периодического контроля*/
--CREATE TABLE tblKeeTimePerLog
--(
--    
--	PerLogID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,	--Счетчик.
--	KeeObjID INT NOT NULL,								--Элемент
--	MakedDate SMALLDATETIME NULL,						--Дата изготовления
--	KeeTime SMALLDATETIME  NULL,						--Срок годности
--	InComeDate SMALLDATETIME  NULL,						--Дата приема на хранение
--	Remark VARCHAR(1000) NULL,							--Примечание
--	--PeriodElID INT NOT NULL,	--Периодичность проверки
--
--	
--	
--
--	/*Служебные поля*/
--	Deleted BIT NOT NULL  DEFAULT(0),
--    Creator VARCHAR(50) DEFAULT SUSER_SNAME(),
--    DateCreate DATETIME DEFAULT CURRENT_TIMESTAMP,
--    Editor VARCHAR(50) DEFAULT SUSER_SNAME(),
--    DateEdit DATETIME DEFAULT CURRENT_TIMESTAMP,
--    Deletor VARCHAR(50),
--    DateDelete DATETIME
--
--
--)
--
--GO



--ВЫБОРКА  ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpKeeTimePerLogSELECT')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpKeeTimePerLogSELECT as select 1')        

GO 


	ALTER PROC stpKeeTimePerLogSELECT @RecordID INT = NULL

	AS

	/*
		автор: popovml
		система:  
		описание: просмотр журнала периодического контроля
		

		возвращает:
				(0) - все прошло хорошо

	*/

	BEGIN
		SET NOCOUNT ON 


		SELECT  T1.PerLogID AS RecordID,

				T1.InComeDate,
				CH.CheckDate AS LastCheckDate,
				DATEADD(mm, T3.QTY, ISNULL(CH.CheckDate, T1.InComeDate)) AS NextCheckDate,
				T3.QTY,
				T3.QTY AS PeriodToCheck,
				DATEDIFF(mm, ISNULL(CH.CheckDate,T1.InComeDate),  GETDATE()) AS MMFromLastChek,

				--DATEDIFF(mm, ISNULL(CH.CheckDate,T1.InComeDate),  GETDATE())-T3.QTY, 

				CASE WHEN 
							DATEDIFF(mm, ISNULL(CH.CheckDate,T1.InComeDate),  GETDATE())-T3.QTY > 0 THEN
							DATEDIFF(mm, ISNULL(CH.CheckDate,T1.InComeDate),  GETDATE())-T3.QTY
				ELSE NULL END
				AS MMOutOfPeriod,


				T1.PerLogID,
				T1.KeeObjID,
					T2.ComponentName AS KeeObjName,
				T1.MakedDate,
				T1.KeeTime,

				T1.Remark
					



				
		FROM dbo.tblKeeTimePerLog AS T1 
				INNER JOIN tblComponents AS T2 ON T2.ElementID=T1.KeeObjID AND T2.flgView<>0
				LEFT JOIN v_KeeTimePeriodEl AS T3 ON T3.ElementID=T1.KeeObjID
				LEFT JOIN v_KeeTimeLastChecks AS CH ON CH.PerLogID = T1.PerLogID
		WHERE T1.Deleted = 0 
							AND T1.PerLogID = ISNULL(@RecordID, T1.PerLogID)

		ORDER BY T1.PerLogID

		RETURN 0 

	END

GO



--IF @@SERVERNAME = 'TITAN'
	BEGIN
		GRANT EXECUTE ON stpKeeTimePerLogSELECT TO rolKeeTimeFullControl
	END
--ВЫБОРКА  ДАННЫХ End
GO



--МОДИФИКАЦИЯ ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[stpKeeTimePerLogDUI]')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure [stpKeeTimePerLogDUI] as select 1')        

GO 

	ALTER PROC [stpKeeTimePerLogDUI] 
									@PerLogID INT = 0,
									@KeeObjID INT,
									@MakedDate SMALLDATETIME,
									@KeeTime SMALLDATETIME,
									@InComeDate SMALLDATETIME,
									@Remark VARCHAR(1000),
									@OpCode INT,
									@RecID  INT  = NULL OUTPUT


	AS

	/*
		автор: popovml
		система: 
		описание: полная модификация Журнал периодического контроля
		

		возвращает:
				(0) - все прошло хорошо
				(1) - 
				(2) - 

	*/ 

	BEGIN
		SET NOCOUNT ON 

		IF @OpCode=2
			BEGIN

				
					INSERT INTO tblKeeTimePerLog 
								(KeeObjID, MakedDate, KeeTime, InComeDate, Remark, Deleted, Creator, DateCreate, Editor, DateEdit)

						 VALUES (@KeeObjID, @MakedDate, @KeeTime, @InComeDate, @Remark, 0, SUSER_SNAME(), GETDATE(), SUSER_SNAME(), GETDATE())
					SET @RecID = SCOPE_IDENTITY()
					DECLARE @CurUser INT
					SET @CurUser = dbo.fncPurOrderCurUserID()
					EXEC stpKeeTimePerLogDetailsDUI	
													NULL, 
													@RecID, 
													@CurUser, 
													@InComeDate, 
													NULL, 
													1, 
													2			

		        RETURN 0
			END
		IF @OpCode=1
			BEGIN
				
					UPDATE tblKeeTimePerLog SET 
										KeeObjID=@KeeObjID,
										MakedDate=@MakedDate,
										KeeTime=@KeeTime,
										InComeDate=@InComeDate,
										Remark=@Remark,
 										Editor=SUSER_SNAME(), 
										DateEdit=GETDATE()
			                                       
					WHERE PerLogID = @PerLogID

					 IF @@ERROR <> 0 
						BEGIN
							ROLLBACK TRAN
							RETURN
						END

				RETURN 0
			END
		IF @OpCode=3
			BEGIN
				UPDATE tblKeeTimePerLog SET Deleted = 1, Deletor=SUSER_SNAME(), DateDelete=GETDATE() WHERE PerLogID = @PerLogID
				RETURN 0
			END

	END
GO

--IF @@SERVERNAME = 'TITAN'
	BEGIN
		GRANT EXECUTE ON [stpKeeTimePerLogDUI] TO rolKeeTimeFullControl
	END
--МОДИФИКАЦИЯ ДАННЫХ End

GO








