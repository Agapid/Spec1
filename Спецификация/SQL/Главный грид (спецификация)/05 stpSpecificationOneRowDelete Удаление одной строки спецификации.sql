USE Budget
GO

--�������  ������ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpSpecificationOneRowDelete')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- ������� ��������
		   exec ('create procedure stpSpecificationOneRowDelete as select 1')        

GO 


ALTER PROC [dbo].stpSpecificationOneRowDelete  @SpecID INT

	AS

	/*
		�����: popovml
		�������: ������������ ����������
		��������: �������� ����� ������ �� ������������ ����������
					
		
		
		����������:
				(0) - ��� ������ ������

	*/




	BEGIN
		SET NOCOUNT ON 
		
			/*������ ������� ������� �� ������������, ��� ��� �������� ��������� � �������� ��������������*/
			IF EXISTS (SELECT * FROM tblComplete as A
				 INNER JOIN tblSpecifications as B ON B.CompleteSetID = A.CompleteSetID and B.SpecID = @SpecID and B.RepDescript = A.RepDescript
				 INNER JOIN tblComponents as C ON C.ComponentID = B.ComponentID and C.ElementID = A.ElementID) 
				begin
					return 1
				end
				 
             
            /*�������������� ������������ ��������� �� �������� "� ������������" ���������!*/ 
			IF NOT EXISTS(SELECT * FROM dbo.tblCompleteSetsStatus AS CSS INNER JOIN dbo.tblSpecifications AS S ON CSS.CompleteSetID=S.CompleteSetID WHERE S.SpecID=@SpecID)
				begin
					return 2
				end

			/*������ ������� ������� �� ������������, ��� ��� �� ���� ���� ����*/
			IF (SELECT isnull(Duty, 0) FROM tblSpecifications WHERE SpecID = @SpecID) <> 0
				begin
					return 3
				end

			BEGIN TRANSACTION
				--������� ������������ � �����
				INSERT INTO tblSpecArchive (ElementID, CompleteSetID, Quantity, PosMask, RepDescript, Deleted)
				SELECT B.ElementID, A.CompleteSetID, A.Quantity, A.PosMask, A.RepDescript, 1
				FROM tblSpecifications as A
				INNER JOIN tblComponents as B ON B.ComponentID = A.ComponentID
				WHERE A.SpecID = @SpecID --CompleteSetID = @CompleteSetID and A.ComponentID = @ComponentID
				IF @@ERROR <> 0
				BEGIN
				  ROLLBACK TRANSACTION
				  RETURN 4
				END
				
				/*������� ���������� � ���� ������������*/
				DELETE FROM tblSpecPosMask WHERE SpecID = @SpecID
				IF @@ERROR <> 0
				BEGIN
				  ROLLBACK TRANSACTION
				  RETURN 5
				END

				DELETE FROM tblSpecifications WHERE SpecID = @SpecID
				IF @@ERROR <> 0
				BEGIN
				  ROLLBACK TRANSACTION
				  RETURN 6
				END




             COMMIT TRANSACTION
             
             RETURN 0

            
        

	END




GO

GRANT EXECUTE ON stpSpecificationOneRowDelete TO rolFormSpecificationEdit, rolFormSpecificationEditAdd, rolFormSpecificationFull, rolSpecification01
GO






