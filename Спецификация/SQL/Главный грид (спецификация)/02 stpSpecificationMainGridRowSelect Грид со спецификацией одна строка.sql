USE Budget
GO

--ВЫБОРКА  ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpSpecificationMainGridRowSelect')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpSpecificationMainGridRowSelect as select 1')        

GO 

--stpTP1SELECT 1

ALTER PROC [dbo].stpSpecificationMainGridRowSelect  @RecordID INT

	AS

	/*
		автор: popovml
		система: Спецификация комплектов
		описание: выборка одной строки срецификации
					
		
		--stpSpecif1Select 6867
		возвращает:
				(0) - все прошло хорошо

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
				C.PMSign, --это буквенное название раздела (DD, C, R и т.д.)
				
				
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
			   CASE WHEN ISNULL(Dcnt.Cnt, 0) = 0 THEN 'Нет'  ELSE 'Есть' END AS DocExist
		FROM tblSpecifications as A
				
				INNER JOIN tblComponents as B ON B.ComponentID = A.ComponentID
				
				LEFT JOIN tblSectionPosMask as C ON C.SectionID = B.SectionID and C.SPID = A.SPID -- не знаю, зачем это здесь (and C.SPID = A.SPID). Достаточно было бы связи и по C.SectionID = B.SectionID
				
				LEFT JOIN #tDocCount AS Dcnt ON B.ComponentID=Dcnt.ComponentID
			WHERE A.SpecID = @RecordID
			

	END




GO

GRANT EXECUTE ON stpSpecificationMainGridRowSelect TO rolFormSpecificationEdit, rolFormSpecificationEditAdd, rolFormSpecificationFull, rolSpecification01

GO







