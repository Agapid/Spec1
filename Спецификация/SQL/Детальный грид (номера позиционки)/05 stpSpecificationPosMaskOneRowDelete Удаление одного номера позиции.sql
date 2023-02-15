
--ВЫБОРКА  ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpSpecificationPosMaskOneRowDelete ')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpSpecificationPosMaskOneRowDelete  as select 1')        

GO 


ALTER PROC [dbo].stpSpecificationPosMaskOneRowDelete  @SPMID INT

	AS

	/*
		автор: popovml
		система: Спецификация комплектов
		описание: Удаление одной строки из позиционного обозначения
					
		
		
		возвращает:
				(0) - все прошло хорошо

	*/

	BEGIN
		SET NOCOUNT ON 
		
			DECLARE @SpecID INT
			SELECT @SpecID = SpecID FROM tblSpecPosMask WHERE SPMID = @SPMID
			
			/*Нельзя удалить элемент из спецификации, так как комплект находится в процессе комплектования*/
			IF EXISTS (SELECT * FROM tblComplete as A
				 INNER JOIN tblSpecifications as B ON B.CompleteSetID = A.CompleteSetID and B.SpecID = @SpecID and B.RepDescript = A.RepDescript
				 INNER JOIN tblComponents as C ON C.ComponentID = B.ComponentID and C.ElementID = A.ElementID) 
				begin
					return 1
				end
				 
             
            /*Редактирование спецификации комплекта со статусом "В производстве" запрещено!*/ 
			IF NOT EXISTS(SELECT * FROM dbo.tblCompleteSetsStatus AS CSS INNER JOIN dbo.tblSpecifications AS S ON CSS.CompleteSetID=S.CompleteSetID WHERE S.SpecID=@SpecID)
				begin
					return 2
				end


			/*Заморочиться с транзакциями или нет????*/


		
			DELETE FROM tblSpecPosMask WHERE SPMID = @SPMID
			
			             
			/*пересчитать количество позиций и собрать строку позиционного обозначения*/
        
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






