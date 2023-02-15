if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tblTPConfirm') and objECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].tblTPConfirm
GO

--������� ��������� ����� ������������ �� ������������� ConfirmState
--�.�. ������ ������: ConfirmState=1, ������ ConfirmState=2 � �.�.
--������������ ConfirmState ����� ��������������� �������� ���������
CREATE TABLE tblTPConfirm
(
    
	TPConfirmID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	
	TPID INT NOT NULL,
	ConfirmState INT NOT NULL,
	ConfirmDate	SMALLDATETIME NOT NULL,
	ConfirmPeopleID INT NOT NULL,
	


    Creator VARCHAR(50) DEFAULT SUSER_SNAME(),
    DateCreate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Editor VARCHAR(50) DEFAULT SUSER_SNAME(),
    DateEdit DATETIME DEFAULT CURRENT_TIMESTAMP,

)

GO




----�������  ������ Begin
--	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpKeeTimeStateSELECT')
--
--				 and objECTPROPERTY(id, N'IsProcedure') = 1))
--		   -- ������� ��������
--		   exec ('create procedure stpKeeTimeStateSELECT as select 1')        
--
--GO 
--
--
--	ALTER PROC stpKeeTimeStateSELECT  @RecordID INT = NULL
--
--	AS
--
--	/*
--		�����: popovml
--		�������:  
--		��������: ������ �������� ����������� ��������� ����������� ���������
--		
--
--		����������:
--				(0) - ��� ������ ������
--
--	*/
--
--	BEGIN
--		SET NOCOUNT ON 
--
--		SELECT  StateID AS RecordID,
--				StateID,
--				StateName,
--				
--				Creator,
--				DateEdit,
--				Editor,
--				DateEdit
--				Deleted,
--				DateDelete,
--				Deletor
--
--				
--		FROM tblKeeTimeState
--				
--		WHERE Deleted = 0 AND StateID = ISNULL(@RecordID, StateID)
--
--        ORDER BY StateID
--
--
--		RETURN 0 
--
--	END
--
--GO
--
--
--
----IF @@SERVERNAME = 'TITAN'
--	BEGIN
--		GRANT EXECUTE ON stpKeeTimeStateSELECT TO rolKeeTimeFullControl
--	END
----�������  ������ End
--GO
--
--
--
--
--
----����������� ������ Begin
--	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[stpKeeTimeStateDUI]')
--
--				 and objECTPROPERTY(id, N'IsProcedure') = 1))
--		   -- ������� ��������
--		   exec ('create procedure [stpKeeTimeStateDUI] as select 1')        
--
--GO 
--
--	ALTER PROC [stpKeeTimeStateDUI] 
--									@StateID INT,
--									@StateName VARCHAR(500),
--									@OpCode INT
--
--
--	AS
--
--	/*
--		�����: popovml
--		�������: ���������� ��������� 
--		��������: ������ ����������� ����������� ��������� ����������� ���������
--		
--
--		����������:
--				(0) - ��� ������ ������
--				(1) - 
--				(2) - 
--
--	*/ 
--
--	BEGIN
--		SET NOCOUNT ON 
--
--		IF @OpCode=2
--			BEGIN
--		
--				
--					INSERT INTO tblKeeTimeState 
--								(StateName, Deleted, Creator, DateCreate, Editor, DateEdit)
--
--						 VALUES (@StateName, 0, SUSER_SNAME(), GETDATE(), SUSER_SNAME(), GETDATE())
--				
--		        RETURN 0
--			END
--		IF @OpCode=1
--			BEGIN
--				
--					UPDATE tblKeeTimeState SET 
--										StateName=@StateName,
--										Editor=SUSER_SNAME(), 
--										DateEdit=GETDATE()
--			                                       
--					WHERE StateID = @StateID
--
--				RETURN 0
--			END
--		IF @OpCode=3
--			BEGIN
--				UPDATE tblKeeTimeState SET Deleted = 1, DateDelete = GETDATE(), Deletor = SUSER_SNAME() WHERE StateID = @StateID
--				RETURN 0
--			END
--
--	END
--GO
--
----IF @@SERVERNAME = 'TITAN'
--	BEGIN
--		GRANT EXECUTE ON [stpKeeTimeStateDUI] TO rolKeeTimeFullControl
--	END
----����������� ������ End
--
--GO
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
