USE Budget
GO

--ВЫБОРКА  ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpSpecificationOneRowDelete')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpSpecificationOneRowDelete as select 1')        

GO 


ALTER PROC [dbo].stpSpecificationOneRowDelete  @SpecID INT

	AS

	/*
		автор: popovml
		система: Спецификация комплектов
		описание: Удаление одной строки из спецификации комплпекта
					
		
		
		возвращает:
				(0) - все прошло хорошо

	*/




	BEGIN
		SET NOCOUNT ON 
		
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

			/*Нельзя удалить элемент из спецификации, так как по нему есть долг*/
			IF (SELECT isnull(Duty, 0) FROM tblSpecifications WHERE SpecID = @SpecID) <> 0
				begin
					return 3
				end

			BEGIN TRANSACTION
				--заносим спецификацию в архив
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
				
				/*удаляем позиционки и саму спецификацию*/
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






