USE Budget
GO

--ВЫБОРКА  ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpSpecificationPosMaskInsert')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpSpecificationPosMaskInsert as select 1')        

GO 


ALTER PROC [dbo].stpSpecificationPosMaskInsert  
												@SpecID INT,					--Ссылка на родительскую записиь в спецификации
												@PosMask varchar(10) = null		--Позицтонное обозначение (номер позиции)
										
										
									

	AS

	/*
		автор: popovml
		система: Спецификация комплектов
		описание: Добавление Позиционного обозначения (номера позиции для элемента)
					
		
		
		возвращает:
				(0) - все прошло хорошо
				
		SELECT * FROM tblSpecPosMask
		sp_help tblSpecPosMask				

	*/

	BEGIN
		SET NOCOUNT ON 
		
		DECLARE @SPID INT			--символ позиционного обозачения раздела
		DECLARE @CompleteSetID INT	--комплект
		
		DECLARE @i int, @Priority int, @flgPr bit

		
		
		SELECT	@CompleteSetID = CompleteSetID,
				@SPID = SPID
		FROM tblSpecifications WHERE SpecID = @SpecID			
		
		
		--проверки
		
		
		
		--Для данного комплекта уже есть такое позиционное обозначение! Операция прервана! Данные были частично сохранены!" (первая проверка)
		IF EXISTS (SELECT * FROM tblComplete as A
			INNER JOIN tblSpecifications as B ON B.CompleteSetID = A.CompleteSetID and B.SpecID = @SpecID and B.RepDescript = A.RepDescript
			INNER JOIN tblComponents as C ON C.ComponentID = B.ComponentID and C.ElementID = A.ElementID)
			
			BEGIN
				RETURN 1
			END


		--Редактирование спецификации комплекта со статусом "В производстве" запрещено!
		IF NOT EXISTS(SELECT * FROM dbo.tblCompleteSetsStatus AS CSS INNER JOIN dbo.tblSpecifications AS S ON CSS.CompleteSetID=S.CompleteSetID WHERE S.SpecID=@SpecID)
			BEGIN
				RETURN 2
			END

		--чтобы был указан вид позиционного обозначения в строке спецификации
		--Примечание: сейчас в базе лежит очень много спецификаций, у которых есть позиционные обозначения у элементов, хранящиеся в поле самой спецификации,
		--но при этом отсутствуют детальные строки позиционных обозначений. При этом в спецификации еще и поле SPID = равно NULL
		IF EXISTS (SELECT * FROM tblSpecifications WHERE SpecID = @SpecID and SPID is null) 
			BEGIN
				RETURN 3
			END

		--Позиционное обозначение должно начинаться с цифры
		IF ASCII(substring(@PosMask, 1, 1)) not between 48 and 57 
			BEGIN
				RETURN 4
			END

		--проверка на наличие кирилицы 
		SET @i = 1
		WHILE 1 < 2
		BEGIN
		  IF ascii(substring(@PosMask, @i, 1)) >= 192
		  BEGIN
			RETURN 5
		  END
		  --попутно определяем пироритет по цифре в позиционном обозначении
		  IF isnull(@flgPr, 0) = 0
		  BEGIN
			IF ascii(substring(@PosMask, @i, 1)) not between 48 and 57 or @i = len(@PosMask)
			BEGIN
			  SET @flgPr = 1
			  SET @Priority = case when ascii(substring(@PosMask, @i, 1)) between 48 and 57 then substring(@PosMask, 1, @i) else isnull(@Priority, substring(@PosMask, 1, @i)) end
			END
			ELSE
			  SET @Priority = substring(@PosMask, 1, @i)
		  END
		  IF @i = len(@PosMask) BREAK
		  SET @i = @i + 1
		END

		
		
		--проверка на наличие такого обозначения (вторая проверка)
		IF EXISTS (SELECT * 
				 FROM tblSpecifications as A
				 INNER JOIN tblSpecPosMask as B ON B.SpecID = A.SpecID --and B.PosMask = @PosMaskDetail
				 INNER JOIN tblSectionPosMask as C ON C.SPID = A.SPID-- and C.SPID = @SPID
				 WHERE CompleteSetID = @CompleteSetID and (C.PMSign + B.PosMask) = ((SELECT PMSign FROM tblSectionPosMask WHERE SPID = @SPID) + @PosMask))
			BEGIN
				RETURN 6
			
			END
		
		
		
		/*Заморочиться с транзакциями или нет????*/
		
		INSERT INTO tblSpecPosMask (SpecID, PosMask, Priority) VALUES (@SpecID, @PosMask, @Priority)
		

	
	
		
		             
		/*пересчитать количество позиций и собрать строку позиционного обозначения*/
    
		DECLARE @PosMaskForSpec VARCHAR(6000)
		DECLARE @Quantity NUMERIC(18,4)
		
		SELECT	@PosMaskForSpec = PosMask,
				@Quantity = Quantity
		FROM dbo.fncGetPosMaskQtyAndRow(@SpecID)
		
		UPDATE tblSpecifications SET PosMask = @PosMaskForSpec, Quantity = @Quantity WHERE SpecID = @SpecID
        


		
	END




GO
GRANT EXECUTE ON stpSpecificationPosMaskInsert TO rolFormSpecificationEdit, rolFormSpecificationEditAdd, rolFormSpecificationFull, rolSpecification01
GO






