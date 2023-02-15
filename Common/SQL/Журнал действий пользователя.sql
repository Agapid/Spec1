
USE BUDGET 
GO
SET NOCOUNT ON
GO

/*****
******
******
	������ �������� ������������
******
******
******/





--������� Begin

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tblQualUserOperLog') and objECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].tblQualUserOperLog
GO



/*������ �������� ������������*/
CREATE TABLE tblQualUserOperLog

(

    --�������.
	QualUserOperLogID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	--�������� ��������� � ����������� ��� �����
	NativeCall VARCHAR(500),
	--����� ������ �������
	RunTimeBegin DATETIME,
	--����� ��������� �������
	RunTimeEnd DATETIME,
	--��� �������: ������, �����, ������ ������� � �. �.
	RunType INT,
	--��������
	Description VARCHAR(1000),
	--�������� ����������, ������������� �����
	AppName VARCHAR(100),
	--�������� �������� ��� ���������, �� ������� ��������� �����
	ParentName VARCHAR(100),


	/*��������� ����*/
    Creator VARCHAR(50) DEFAULT SUSER_SNAME(),
    DateCreate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Editor VARCHAR(50) DEFAULT SUSER_SNAME(),
    DateEdit DATETIME DEFAULT CURRENT_TIMESTAMP

)


GO



CREATE  NONCLUSTERED INDEX ix_tblQualUserOperLog_AppName_01 ON tblQualUserOperLog (AppName ASC) 
    

GO



--�������� �����

exec sp_addextendedproperty N'MS_Description', N'�������, ����', N'user', N'dbo', N'table', N'tblQualUserOperLog', N'column', N'QualUserOperLogID'
exec sp_addextendedproperty N'MS_Description', N'�������� ��������� � ����������� ��� �����', N'user', N'dbo', N'table', N'tblQualUserOperLog', N'column', N'NativeCall'
exec sp_addextendedproperty N'MS_Description', N'����� ������ �������', N'user', N'dbo', N'table', N'tblQualUserOperLog', N'column', N'RunTimeBegin'
exec sp_addextendedproperty N'MS_Description', N'����� ��������� �������', N'user', N'dbo', N'table', N'tblQualUserOperLog', N'column', N'RunTimeEnd'
exec sp_addextendedproperty N'MS_Description', N'��� �������: ������, �����, ������ ������� � �. �.', N'user', N'dbo', N'table', N'tblQualUserOperLog', N'column', N'RunType'

exec sp_addextendedproperty N'MS_Description', N'��������', N'user', N'dbo', N'table', N'tblQualUserOperLog', N'column', N'Description'
exec sp_addextendedproperty N'MS_Description', N'�������� ����������, ������������� �����', N'user', N'dbo', N'table', N'tblQualUserOperLog', N'column', N'AppName'
exec sp_addextendedproperty N'MS_Description', N'�������� �������� ��� ���������, �� ������� ��������� �����', N'user', N'dbo', N'table', N'tblQualUserOperLog', N'column', N'ParentName'



/*������*/
--INSERT INTO tblQualUserOperLog () VALUES ()

--������� End



GO







--�������  ������ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[stpQualUserOperLogSELECT]')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- ������� ��������
		   exec ('create procedure [stpQualUserOperLogSELECT] as select 1')        

GO 


	ALTER PROC [stpQualUserOperLogSELECT] 

	AS

	/*
		�����: popovml
		�������: ���������� ��������� 
		��������: �������� ������� �������� ������������
		

		����������:
				(0) - ��� ������ ������

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

--�������  ������ End

GO



--����������� ������ Begin

	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[stpQualUserOperLogINSERT]')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- ������� ��������
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

	
--		�����: popovml
--		�������: ���������� ���������
--		��������: �������������� �������� ������������
--		
--
--		����������:
--				(0) - ��� ������ ������
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

--����������� ������ End



GO



















