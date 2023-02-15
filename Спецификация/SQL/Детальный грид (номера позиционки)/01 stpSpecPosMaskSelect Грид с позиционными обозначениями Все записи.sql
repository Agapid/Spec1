USE Budget
GO


--�������  ������ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpSpecPosMaskSelect')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- ������� ��������
		   exec ('create procedure stpSpecPosMaskSelect as select 1')        

GO 


ALTER PROC [dbo].stpSpecPosMaskSelect  @SpecID INT

	AS

	/*
		�����: popovml
		�������: ������������ ����������. 
		��������: ���������� ����� � ������������ �����������
					
		
		--stpSpecif1Select 146356
		--SELECT * FROM tblSpecPosMask WHERE 
		
		����������:
				(0) - ��� ������ ������

	*/

	BEGIN
		SET NOCOUNT ON 
		
		select	SPMID as RecordID,
				SPMID, 
				SpecID, 
				PosMask, 
				Priority
		from tblSpecPosMask where SpecID = @SpecID 
            
		ORDER BY Priority  ASC          
        

	END




GO

GRANT EXECUTE ON stpSpecPosMaskSelect TO rolFormSpecificationEdit, rolFormSpecificationEditAdd, rolFormSpecificationFull, rolSpecification01
GO



--stpSpecPosMaskSelect 146356



