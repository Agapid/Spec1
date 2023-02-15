USE Budget
GO

--ВЫБОРКА  ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpSpecificationUpdate')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpSpecificationUpdate as select 1')        

GO 


ALTER PROC [dbo].stpSpecificationUpdate		@SpecID INT,

											@Quantity numeric(18, 4) = null,			--количество
											@PosMask varchar(6000) = null,				--позиционное обозначение
											@RepDescript varchar(250) = null,			--описание замены
											--@SPID int = null,							--Символ позиционного обозначения раздела
											@Note varchar(250) = null					--примечание
											
	AS

	/*
		автор: popovml
		система: Спецификация комплектов
		описание: редактирование строки спецификации
					
		
		
		возвращает:
				(0) - все прошло хорошо

	*/

	BEGIN
		SET NOCOUNT ON 
		
		
		/*комплект находится в комплектовании?*/
		IF EXISTS (SELECT * FROM tblComplete as A
			INNER JOIN tblSpecifications as B ON B.CompleteSetID = A.CompleteSetID and B.SpecID = @SpecID and B.RepDescript = A.RepDescript
			INNER JOIN tblComponents as C ON C.ComponentID = B.ComponentID and C.ElementID = A.ElementID) 
			BEGIN			
				RETURN 1
			END	

		/*Редактирование спецификации комплекта со статусом "В производстве" запрещено*/			
		IF NOT EXISTS(SELECT * FROM dbo.tblCompleteSetsStatus AS CSS INNER JOIN dbo.tblSpecifications AS S ON CSS.CompleteSetID=S.CompleteSetID WHERE S.SpecID=@SpecID)
			BEGIN
				RETURN 2
			END			

		BEGIN TRANSACTION			

			--заносим спецификацию в архив
			INSERT INTO tblSpecArchive (ElementID, CompleteSetID, Quantity, PosMask, RepDescript)
			
			SELECT B.ElementID, A.CompleteSetID, @Quantity, isnull(dbo.fncGetPosMaskInRow(A.SpecID, 0), isnull(@PosMask, 'нет')), @RepDescript
			FROM tblSpecifications as A
										INNER JOIN tblComponents as B ON B.ComponentID = A.ComponentID
				WHERE A.SpecID = @SpecID --A.CompleteSetID = @CompleteSetID and A.ComponentID = @ComponentID
			
			IF @@ERROR <> 0
				BEGIN
					ROLLBACK TRANSACTION
				RETURN 3
			END


			--изменеие записи
			UPDATE tblSpecifications SET	Quantity = @Quantity, 
											PosMask = isnull(dbo.fncGetPosMaskInRow(SpecID, 0), isnull(@PosMask, 'нет')), 
											RepDescript = case when (@RepDescript is null) or (len(ltrim(rtrim(@RepDescript))) = 0) then 'нет' else @RepDescript end, 
											Note = @Note, 
											--SPID = @SPID, /*В оригинале это поле можно менять.*/
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






