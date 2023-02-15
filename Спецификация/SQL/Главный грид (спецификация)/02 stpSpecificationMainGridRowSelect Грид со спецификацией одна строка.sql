USE Budget
GO

--�������  ������ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpSpecificationMainGridRowSelect')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- ������� ��������
		   exec ('create procedure stpSpecificationMainGridRowSelect as select 1')        

GO 

--stpTP1SELECT 1

ALTER PROC [dbo].stpSpecificationMainGridRowSelect  @RecordID INT

	AS

	/*
		�����: popovml
		�������: ������������ ����������
		��������: ������� ����� ������ ������������
					
		
		--stpSpecif1Select 6867
		����������:
				(0) - ��� ������ ������

	*/

	BEGIN
		SET NOCOUNT ON 
		
		SELECT  ComponentID, COUNT(*) AS Cnt   INTO #tDocCount FROM tblPDFs GROUP BY ComponentID
		
		SELECT A.SpecID as RecordID,
		
				A.SpecID,
				A.CompleteSetID, 
				A.ComponentID, 
				B.ComponentName, 
				A.Quantity, 
				isnull(dbo.fncGetPosMaskInRow(A.SpecID, 0), A.PosMask) as PosMaskCalc, 
				A.PosMask as PosMaskStored, 
				A.RepDescript, 
				A.Duty,
				B.SectionID, 
				A.Note, 
				A.SPID, 
				C.PMSign,
				C.PMSign, --��� ��������� �������� ������� (DD, C, R � �.�.)
				
				
				cast(case when exists (SELECT * FROM tblSectionPosMask WHERE SectionID = B.SectionID) then 1 else 0 end as bit) as CheckPM,
				cast(case when 
								case when exists (SELECT * FROM tblSectionPosMask WHERE SectionID = B.SectionID) 
									then 1 
									else 0 
								end = 1 and A.Quantity <> 0
						then 
							case when (SELECT count(*) FROM tblSpecPosMask WHERE SpecID = A.SpecID) <> A.Quantity 
								then 1 
								else 0 end 
						 else 0 end as bit) as flgCondition1,
						 
			   CAST(ISNULL(B.BPCount,0) AS INT) AS BPCount, 
			   CASE WHEN ISNULL(Dcnt.Cnt, 0) = 0 THEN '���'  ELSE '����' END AS DocExist
		FROM tblSpecifications as A
				
				INNER JOIN tblComponents as B ON B.ComponentID = A.ComponentID
				
				LEFT JOIN tblSectionPosMask as C ON C.SectionID = B.SectionID and C.SPID = A.SPID -- �� ����, ����� ��� ����� (and C.SPID = A.SPID). ���������� ���� �� ����� � �� C.SectionID = B.SectionID
				
				LEFT JOIN #tDocCount AS Dcnt ON B.ComponentID=Dcnt.ComponentID
			WHERE A.SpecID = @RecordID
			

	END




GO

GRANT EXECUTE ON stpSpecificationMainGridRowSelect TO rolFormSpecificationEdit, rolFormSpecificationEditAdd, rolFormSpecificationFull, rolSpecification01

GO







