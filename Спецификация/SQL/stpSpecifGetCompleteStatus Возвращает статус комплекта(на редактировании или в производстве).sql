USE Budget
GO


	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpSpecifGetCompleteStatus')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpSpecifGetCompleteStatus as select 1')        

GO 


		ALTER PROC [dbo].[stpSpecifGetCompleteStatus] @CompleteSetID int 
	AS

	/*
		автор: popovml
		система:  Спецификация
		описание: возвращает статус комплекта
		

		возвращает:
				(0) - все прошло хорошо

		[stpSpecifGetCompleteStatus] 8214
		[stpSpecifGetCompleteStatus] -999

	*/




	begin
	
		set nocount on

				/*
					статус комплекта:	1 - на редактировании
										0 - в производстве
				*/
				
				

				
				

		declare @CompleteStatusValue int,
				@CompleteStatusCreator varchar(50),
				@CompleteStatusDate varchar(50)
							

		if @CompleteSetID = -1 
			begin
			
				select @CompleteStatusValue = -1, @CompleteStatusCreator = '', @CompleteStatusDate = null
			end
		else
			begin				
				select	@CompleteStatusValue = cast(isnull((CompleteSetID - @CompleteSetID + 1), 0) as int),
						@CompleteStatusCreator = Creator,
						@CompleteStatusDate = convert(varchar, DateCreate, 103)
								
				from tblCompleteSetsStatus where CompleteSetID = @CompleteSetID

			end

		select	isnull(@CompleteStatusValue,0) as CompleteStatusValue,
				@CompleteStatusCreator as CompleteStatusCreator,		
				@CompleteStatusDate as CompleteStatusDate
	
	

	end



GO
GRANT EXECUTE ON stpSpecifGetCompleteStatus  TO rolFormSpecificationEdit, rolFormSpecificationEditAdd, rolFormSpecificationFull, rolSpecification01
GO
