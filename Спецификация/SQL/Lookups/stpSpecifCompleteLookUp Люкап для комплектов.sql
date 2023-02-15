USE Budget
GO


	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpSpecifCompleteLookUp')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpSpecifCompleteLookUp as select 1')        

GO 


		ALTER PROC [dbo].[stpSpecifCompleteLookUp] 
	AS

	/*
		автор: popovml
		система:  Спецификация
		описание: люкапы
		

		возвращает:
				(0) - все прошло хорошо

	*/


/*
select * from tblCompleteSetsStatus
select * from tblSubjects View
*/

	begin
	
		set nocount on

		select	cast(-1 as int) as CompleteSetID,
				cast ('-= Выберите комплект =-' as varchar(255)) as CompleteSetName,
				
				cast(-1 as int) as CompleteStatusValue, 
				cast ('n/a' as varchar(30)) as CompleteStatusName,
				cast ('n/a' as varchar(125)) as SubjectName,
				cast ('n/a' as varchar(50)) as CompleteStatusCreator,
				cast ('n/a' as varchar(50)) as CompleteStatusDate
				
		
		union all				

		select	A.CompleteSetID,
				A.CompleteSetName, 
				
				/*
					статус комплекта:	1 - на редактировании
										0 - в производстве
				*/
				cast(
						isnull((A.CompleteSetID-complSta.CompleteSetID+1),0) 
						
						as int) as CompleteStatusValue,
						
				case when complSta.CompleteSetID is null
					then	'В производстве'
					else	'На редактировании'	end as CompleteStatusName,
					
										
				sbj.Description as SubjectName,
				complSta.Creator as CompleteStatusCreator,
				convert(varchar, complSta.DateCreate, 103) as CompleteStatusDate
				
				
		from tblCompleteSets as A	inner join dbo.vwAccessPersonToCompleteSetsByDomains as APCSD on APCSD.CompleteSetID=A.CompleteSetID -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
									left join dbo.tblCompleteSetsStatus as complSta on complSta.CompleteSetID = A.CompleteSetID
									left join tblSubjects as sbj on sbj.SubjectID = a.SubjectID

		where A.[View] = 1

		order by A.CompleteSetName
	

	end



GO
GRANT EXECUTE ON stpSpecifCompleteLookUp TO rolFormSpecificationEdit, rolFormSpecificationEditAdd, rolFormSpecificationFull, rolSpecification01
GO


