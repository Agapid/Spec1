USE Budget
GO

--�������  ������ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpSpecificationInsert')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- ������� ��������
		   exec ('create procedure stpSpecificationInsert as select 1')        

GO 


ALTER PROC [dbo].stpSpecificationInsert  

										@CompleteSetID int,					--��� ���������
										@ComponentID varchar(25),			--��� ��������
										@Quantity numeric(18, 4),			--����������
										@SPID int = null,					--����������� �����������
										@RepDescript varchar(250) = null,	--�������� ������
										@Note varchar(250) = null			--����������

	AS

	/*
		�����: popovml
		�������: ������������ ����������
		��������: ���������� ��������
					
		
		
		����������:
				(0) - ��� ������ ������

	*/

	BEGIN
		SET NOCOUNT ON 
		
		
		
		 --�������� �� ������� ������ �������� � ������ ������������
		IF EXISTS (SELECT * FROM tblSpecifications WHERE CompleteSetID = @CompleteSetID and ComponentID = @ComponentID and 
                                                   RepDescript = case when @RepDescript is null or len(ltrim(rtrim(@RepDescript))) = 0 then '���' else @RepDescript end)
		BEGIN
			RETURN 1
		END
		
		
		--�������������� ������������ ��������� �� �������� "� ������������" ���������
		IF NOT EXISTS(SELECT * FROM tblCompleteSetsStatus WHERE CompleteSetID=@CompleteSetID)
		BEGIN
			RETURN 2
		END


		-- �������� �� ������������ ��������������� ���������������. ������� ����� 04/2016.
		IF NOT EXISTS
			(SELECT *
       			FROM dbo.tblCompleteSets AS CS
					INNER JOIN dbo.tblSubjects AS S ON S.SubjectID=CS.SubjectID
					INNER JOIN dbo.tblComponents AS C ON C.ComponentID=@ComponentID
					INNER JOIN dbo.tblComponentSPLinks AS CSPL ON CSPL.ElementID=C.ElementID
					INNER JOIN dbo.fncComponentSPTreeLinks() AS CSPTL ON CSPTL.SID=CSPL.SID AND ISNULL(CSPTL.ParentCSPTID, CSPTL.CSPTID)=1
					INNER JOIN dbo.tblBuildingsCorrelations AS BC ON BC.BuildID1=CSPTL.ParentBuildID
				WHERE CS.CompleteSetID=@CompleteSetID AND BC.BuildID2=S.BuildID
			)
		BEGIN
			RETURN 3
		END



		BEGIN TRANSACTION

			INSERT INTO tblSpecifications(CompleteSetID, ComponentID, Quantity, SPID, RepDescript, Note)
			VALUES(@CompleteSetID, @ComponentID, @Quantity, @SPID, 
			case when @RepDescript is null or len(ltrim(rtrim(@RepDescript))) = 0 then '���' else @RepDescript end, @Note)

			IF @@ERROR <> 0
			BEGIN
			  ROLLBACK TRANSACTION
			  RETURN 4
			END


			--������� ������������ � �����
			INSERT INTO tblSpecArchive (ElementID, CompleteSetID, Quantity, PosMask, RepDescript)
			SELECT B.ElementID, A.CompleteSetID, A.Quantity, A.PosMask, A.RepDescript
			FROM tblSpecifications as A
			INNER JOIN tblComponents as B ON B.ComponentID = A.ComponentID
			WHERE A.CompleteSetID = @CompleteSetID and A.ComponentID = @ComponentID

 
			IF @@ERROR <> 0
			BEGIN
			  ROLLBACK TRANSACTION
			  RETURN 5
			END
			
		COMMIT TRANSACTION

	
		RETURN 0
	END




GO

GRANT EXECUTE ON stpSpecificationInsert TO rolFormSpecificationEdit, rolFormSpecificationEditAdd, rolFormSpecificationFull, rolSpecification01
GO






