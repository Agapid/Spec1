
USE BUDGET 
GO
SET NOCOUNT ON
GO

/*****
******
******
	Журнал действий пользователя
******
******
******/





--ТАБЛИЦА Begin

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tblQualUserOperLog') and objECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].tblQualUserOperLog
GO



/*Журнал действий пользователя*/
CREATE TABLE tblQualUserOperLog

(

    --Счетчик.
	QualUserOperLogID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	--Название процедуры с параметрами или вьюхи
	NativeCall VARCHAR(500),
	--Время начала запуска
	RunTimeBegin DATETIME,
	--Время окончания запуска
	RunTimeEnd DATETIME,
	--Тип запуска: расчет, отчет, просто выборка и т. д.
	RunType INT,
	--описание
	Description VARCHAR(1000),
	--Название приложения, использующего вызов
	AppName VARCHAR(100),
	--Название контрола или процедуры, из которой произошел вызов
	ParentName VARCHAR(100),


	/*Служебные поля*/
    Creator VARCHAR(50) DEFAULT SUSER_SNAME(),
    DateCreate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Editor VARCHAR(50) DEFAULT SUSER_SNAME(),
    DateEdit DATETIME DEFAULT CURRENT_TIMESTAMP

)


GO



CREATE  NONCLUSTERED INDEX ix_tblQualUserOperLog_AppName_01 ON tblQualUserOperLog (AppName ASC) 
    

GO



--Описания полей

exec sp_addextendedproperty N'MS_Description', N'Счетчик, ключ', N'user', N'dbo', N'table', N'tblQualUserOperLog', N'column', N'QualUserOperLogID'
exec sp_addextendedproperty N'MS_Description', N'Название процедуры с параметрами или вьюхи', N'user', N'dbo', N'table', N'tblQualUserOperLog', N'column', N'NativeCall'
exec sp_addextendedproperty N'MS_Description', N'Время начала запуска', N'user', N'dbo', N'table', N'tblQualUserOperLog', N'column', N'RunTimeBegin'
exec sp_addextendedproperty N'MS_Description', N'Время окончания запуска', N'user', N'dbo', N'table', N'tblQualUserOperLog', N'column', N'RunTimeEnd'
exec sp_addextendedproperty N'MS_Description', N'Тип запуска: расчет, отчет, просто выборка и т. д.', N'user', N'dbo', N'table', N'tblQualUserOperLog', N'column', N'RunType'

exec sp_addextendedproperty N'MS_Description', N'описание', N'user', N'dbo', N'table', N'tblQualUserOperLog', N'column', N'Description'
exec sp_addextendedproperty N'MS_Description', N'Название приложения, использующего вызов', N'user', N'dbo', N'table', N'tblQualUserOperLog', N'column', N'AppName'
exec sp_addextendedproperty N'MS_Description', N'Название контрола или процедуры, из которой произошел вызов', N'user', N'dbo', N'table', N'tblQualUserOperLog', N'column', N'ParentName'



/*Данные*/
--INSERT INTO tblQualUserOperLog () VALUES ()

--ТАБЛИЦА End



GO







--ВЫБОРКА  ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[stpQualUserOperLogSELECT]')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure [stpQualUserOperLogSELECT] as select 1')        

GO 


	ALTER PROC [stpQualUserOperLogSELECT] 

	AS

	/*
		автор: popovml
		система: Управление качеством 
		описание: просмотр журнала действий пользователя
		

		возвращает:
				(0) - все прошло хорошо

	*/

	BEGIN
		SET NOCOUNT ON 

		SELECT  QualUserOperLogID, 
				NativeCall, 
				RunTimeBegin, 
				RunTimeEnd,
				RunType,
				Description,
				AppName,
				ParentName,
				Creator,
				DateCreate, 
				Editor, 
				DateEdit 
		FROM dbo.tblQualUserOperLog 

		ORDER BY QualUserOperLogID 

		RETURN 0 


	END

GO

------IF @@SERVERNAME = 'TITAN'
------	BEGIN
------		GRANT EXECUTE ON [stpQualUserOperLogSELECT]
------	END

--ВЫБОРКА  ДАННЫХ End

GO



--МОДИФИКАЦИЯ ДАННЫХ Begin

	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[stpQualUserOperLogINSERT]')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure [stpQualUserOperLogINSERT] as select 1')        

GO 


	ALTER PROC [stpQualUserOperLogINSERT] 
								
					@NativeCall VARCHAR(500) = NULL, 
					@RunTimeBegin DATETIME = NULL, 
					@RunTimeEnd DATETIME = NULL, 
					@RunType INT = NULL, 
					@Description VARCHAR(1000) = NULL, 
					@AppName VARCHAR(100) = NULL, 
					@ParentName VARCHAR(100) = NULL 


	AS

	
--		автор: popovml
--		система: Управление качеством
--		описание: журналирование действий пользователя
--		
--
--		возвращает:
--				(0) - все прошло хорошо
--				(1) - 
--				(2) - 
--
--	

	BEGIN
		SET NOCOUNT ON 

			
				
				
				INSERT INTO tblQualUserOperLog (NativeCall, RunTimeBegin, RunTimeEnd, RunType, Description, AppName, ParentName,
											  Creator, DateCreate, Editor, DateEdit)
					VALUES (@NativeCall, @RunTimeBegin, @RunTimeEnd, @RunType, @Description, @AppName, @ParentName, 
							SUSER_SNAME(), GETDATE(), SUSER_SNAME(), GETDATE())
            RETURN 0
	END
GO



GRANT EXECUTE ON [stpQualUserOperLogINSERT] TO public

--МОДИФИКАЦИЯ ДАННЫХ End



GO



















