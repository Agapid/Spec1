USE Budget
GO

--�������  ������ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpSpecificationUpdate')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- ������� ��������
		   exec ('create procedure stpSpecificationUpdate as select 1')        

GO 


ALTER PROC [dbo].stpSpecificationUpdate		@SpecID INT,

											@Quantity numeric(18, 4) = null,			--����������
											@PosMask varchar(6000) = null,				--����������� �����������
											@RepDescript varchar(250) = null,			--�������� ������
											--@SPID int = null,							--������ ������������ ����������� �������
											@Note varchar(250) = null					--����������
											
	AS

	/*
		�����: popovml
		�������: ������������ ����������
		��������: �������������� ������ ������������
					
		
		
		����������:
				(0) - ��� ������ ������

	*/

	BEGIN
		SET NOCOUNT ON 
		
		
		/*�������� ��������� � ��������������?*/
		IF EXISTS (SELECT * FROM tblComplete as A
			INNER JOIN tblSpecifications as B ON B.CompleteSetID = A.CompleteSetID and B.SpecID = @SpecID and B.RepDescript = A.RepDescript
			INNER JOIN tblComponents as C ON C.ComponentID = B.ComponentID and C.ElementID = A.ElementID) 
			BEGIN			
				RETURN 1
			END	

		/*�������������� ������������ ��������� �� �������� "� ������������" ���������*/			
		IF NOT EXISTS(SELECT * FROM dbo.tblCompleteSetsStatus AS CSS INNER JOIN dbo.tblSpecifications AS S ON CSS.CompleteSetID=S.CompleteSetID WHERE S.SpecID=@SpecID)
			BEGIN
				RETURN 2
			END			

		BEGIN TRANSACTION			

			--������� ������������ � �����
			INSERT INTO tblSpecArchive (ElementID, CompleteSetID, Quantity, PosMask, RepDescript)
			
			SELECT B.ElementID, A.CompleteSetID, @Quantity, isnull(dbo.fncGetPosMaskInRow(A.SpecID, 0), isnull(@PosMask, '���')), @RepDescript
			FROM tblSpecifications as A
										INNER JOIN tblComponents as B ON B.ComponentID = A.ComponentID
				WHERE A.SpecID = @SpecID --A.CompleteSetID = @CompleteSetID and A.ComponentID = @ComponentID
			
			IF @@ERROR <> 0
				BEGIN
					ROLLBACK TRANSACTION
				RETURN 3
			END


			--�������� ������
			UPDATE tblSpecifications SET	Quantity = @Quantity, 
											PosMask = isnull(dbo.fncGetPosMaskInRow(SpecID, 0), isnull(@PosMask, '���')), 
											RepDescript = case when (@RepDescript is null) or (len(ltrim(rtrim(@RepDescript))) = 0) then '���' else @RepDescript end, 
											Note = @Note, 
											--SPID = @SPID, /*� ��������� ��� ���� ����� ������.*/
											Editor = default, 
											DateEdit = default 
											
			WHERE SpecID = @SpecID								

			IF @@ERROR <> 0
				BEGIN
					ROLLBACK TRANSACTION
				RETURN 4
			END


        COMMIT TRANSACTION

	END




GO

GRANT EXECUTE ON stpSpecificationUpdate TO rolFormSpecificationEdit, rolFormSpecificationEditAdd, rolFormSpecificationFull, rolSpecification01
GO






