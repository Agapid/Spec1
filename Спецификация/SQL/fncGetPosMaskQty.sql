USE [Budget]
GO

--SELECT dbo.fncGetPosMaskQty (117083)

--SELECT dbo.fncGetPosMaskInRow (200146, 0)



ALTER FUNCTION [dbo].[fncGetPosMaskQtyAndRow] (@SpecID int)
	RETURNS @T TABLE (SpecID int, PosMask varchar(6000), Quantity numeric(18,4))
AS
	BEGIN
	
	/*функци€ считает количество позиций, использу€ строку позиционного обозначени€ ('R1,R15-R19,RN5-RN6')
		(эта строка возвращаетс€ другой функией: dbo.fncGetPosMaskInRow).
		
		
	*/
	
	
		declare @PosMask varchar(6000), @PosMask1 varchar(6000)
		--set @PosMask = 'R1,R15-R19,RN5-RN6'



		SELECT @PosMask = dbo.fncGetPosMaskInRow (@SpecID, 0)
		SET @PosMask1 = @PosMask

		

		declare @elements table
		(
			Element varchar(10),
			[Count] int
		)

		declare @element varchar(10)
		declare @index int
		declare @count int
		declare @left varchar(10)
		declare @right varchar(10)
		declare @position int

		while (len(@PosMask) > 0 and charindex(',', @PosMask) > 0)
		begin
			set @element = substring(@PosMask, 0, charindex(',', @PosMask))
			if (charindex('-', @element) > 0)
			begin
				set @index = charindex('-', @element)
				set @left = left(@element, @index - 1)
				set @right = substring(@element, @index + 1, len(@element) - len(@left))

				set @position = 0
				while (isnumeric(substring(@left, @position, 1)) = 0)
				begin
					set @position = @position + 1
				end
				set @left = substring(@left, @position, len(@left))

				set @position = 0
				while (isnumeric(substring(@right, @position, 1)) = 0)
				begin
					set @position = @position + 1
				end
				set @right = substring(@right, @position, len(@right))

				set @count = cast(@right as int) - cast(@left as int) + 1
			end
			else
			begin
				set @count = 1
			end
			insert into @elements select @element, @count
			set @PosMask = replace(@PosMask, @element + ',', '')
		end

			if (len(@PosMask) > 0)
			begin
				set @element = @PosMask
				if (charindex('-', @element) > 0)
				begin
					set @index = charindex('-', @element)
					set @left = left(@element, @index - 1)
					set @right = substring(@element, @index + 1, len(@element) - len(@left))

					set @position = 0
					while (isnumeric(substring(@left, @position, 1)) = 0)
					begin
						set @position = @position + 1
					end
					set @left = substring(@left, @position, len(@left))

					set @position = 0
					while (isnumeric(substring(@right, @position, 1)) = 0)
					begin
						set @position = @position + 1
					end
					set @right = substring(@right, @position, len(@right))

					set @count = cast(@right as int) - cast(@left as int) + 1
				end
				else
				begin
					set @count = 1
				end
				insert into @elements select @element, @count
			end
			--select * from @elements
			
			
			DECLARE  @Quantity numeric(18,4)
			SELECT @Quantity = sum([Count]) from @elements	
			
			
			INSERT INTO @T(SpecID, PosMask, Quantity)
			VALUES (@SpecID, @PosMask1, @Quantity)
			
		
		  RETURN
		  
	END

