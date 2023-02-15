
--�������  ������ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpSpecificationPosMaskOneRowDelete ')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- ������� ��������
		   exec ('create procedure stpSpecificationPosMaskOneRowDelete  as select 1')        

GO 


ALTER PROC [dbo].stpSpecificationPosMaskOneRowDelete  @SPMID INT

	AS

	/*
		�����: popovml
		�������: ������������ ����������
		��������: �������� ����� ������ �� ������������ �����������
					
		
		
		����������:
				(0) - ��� ������ ������

	*/

	BEGIN
		SET NOCOUNT ON 
		
			DECLARE @SpecID INT
			SELECT @SpecID = SpecID FROM tblSpecPosMask WHERE SPMID = @SPMID
			
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


			/*������������ � ������������ ��� ���????*/


		
			DELETE FROM tblSpecPosMask WHERE SPMID = @SPMID
			
			             
			/*����������� ���������� ������� � ������� ������ ������������ �����������*/
        
			DECLARE @PosMask VARCHAR(6000)
			DECLARE @Quantity NUMERIC(18,4)
			
			SELECT	@PosMask = PosMask,
					@Quantity = Quantity
			FROM dbo.fncGetPosMaskQtyAndRow(@SpecID)
			
			UPDATE tblSpecifications SET PosMask = @PosMask, Quantity = @Quantity WHERE SpecID = @SpecID
        
        
		


	END




GO

GRANT EXECUTE ON stpSpecificationPosMaskOneRowDelete  TO rolFormSpecificationEdit, rolFormSpecificationEditAdd, rolFormSpecificationFull, rolSpecification01
GO






