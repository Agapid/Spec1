
--ВЫБОРКА  ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpSpecPosMaskRowSelect')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpSpecPosMaskRowSelect as select 1')        

GO 


ALTER PROC [dbo].stpSpecPosMaskRowSelect  @RecordID INT

	AS

	/*
		автор: popovml
		система: Спецификация комплектов. Позиционные обозначения(одна строка)
		описание: 
					
		
		
		возвращает:
				(0) - все прошло хорошо

	*/

	BEGIN
		SET NOCOUNT ON 
		
		select	SPMID as RecordID,
				SPMID, 
				SpecID, 
				PosMask, 
				Priority
		from tblSpecPosMask where SPMID = @RecordID 
            
        

	END




GO

GRANT EXECUTE ON stpSpecPosMaskRowSelect TO rolFormSpecificationEdit, rolFormSpecificationEditAdd, rolFormSpecificationFull, rolSpecification01
GO




--sp_help 'tblSpecPosMask'


