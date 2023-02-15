USE Budget
GO



	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpSpecifCommonLookUp')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpSpecifCommonLookUp as select 1')        

GO 


		ALTER PROC [dbo].[stpSpecifCommonLookUp]  
													@LookUpID INT,
													@Param1 INT = NULL, 
													@ChoiseRowVisible BIT = 1
	AS

	/*
		автор: popovml
		система:  Спецификация
		описание: люкапы
		
		--[stpSpecifCommonLookUp] 1
		возвращает:
				(0) - все прошло хорошо

	*/




	begin
	
		set nocount on

		if @LookUpID = 1
		
		begin
		
			if @@servername = 'TITAN' 
				begin
					SELECT 'esp-doc@altonika.ru' AS Email
						UNION 
					SELECT 'tech-doc@altonika.ru' AS Email
						UNION 
					SELECT 'sklad@altonika.ru' AS Email
						UNION 
					SELECT 'mts@altonika.ru' AS Email
				end
			else
				begin
					SELECT 'popovml@altonika.ru' AS Email	
				end	
		end

	end



GO
GRANT EXECUTE ON stpSpecifCommonLookUp TO rolFormSpecificationEdit, rolFormSpecificationEditAdd, rolFormSpecificationFull, rolSpecification01
GO


