USE Budget

GO

--ВЫБОРКА  ДАННЫХ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpSpecifComponentLookUp')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- Создаем заглушку
		   exec ('create procedure stpSpecifComponentLookUp as select 1')        

GO 
--stpTP1SELECT 1

ALTER PROC [dbo].stpSpecifComponentLookUp  

	AS

	/*
		автор: popovml
		система: Спецификация комплектов
		описание: Заполнение люкапа с элементами
					
		
		
		возвращает:
				(0) - все прошло хорошо

	*/

	BEGIN
		SET NOCOUNT ON 
	
		
		CREATE TABLE #T 
					(
						RecordID INT IDENTITY(1,1) NOT NULL  PRIMARY KEY,
						ElementID INT,
						ComponentID CHAR(25),
						ComponentName VARCHAR(255),
						SectionID INT,
						SectionName	VARCHAR(255),
						PMSign VARCHAR(5),
						SPID INT
					)	
		
		
		INSERT INTO #T (
						ElementID,
						ComponentID,
						ComponentName,
						SectionID,
						SectionName,
						PMSign,
						SPID 		
						)
		SELECT 	--CAST(-1 AS  INT) AS RecordID,
				CAST(-1 AS  INT) AS ElementID,
				CAST ('                         ' AS  CHAR(25))  as ComponentID,
		
				CAST ('-= Выберите элемент =-' AS VARCHAR(255)) AS ComponentName,
				
				CAST(0 AS  INT) AS SectionID, 
				CAST ('' AS VARCHAR(255)) AS SectionName,
				CAST(0 AS  INT) AS PMSign, 
				CAST(0 AS  INT) AS SPID 
	
				
		
		UNION ALL			
		
		
		SELECT	--t1.ElementID as RecordID,
				t1.ElementID,
				t1.ComponentID, 
				t1.ComponentName, 
				t2.SectionID,
				t2.SectionName,
				t3.PMSign,
				t3.SPID
				
		FROM tblComponents AS t1 
								inner join tblSections AS t2 ON t1.SectionID = t2.SectionID
								left join tblSectionPosMask AS t3 ON t3.SectionID = t1.SectionID
	
		
		

		/*финальная выборка*/
		SELECT	RecordID,
				ElementID,
				ComponentID,
				ComponentName,
				SectionID,
				SectionName,
				PMSign,
				SPID 	
		FROM #T ORDER BY SectionID, case when SectionID in (1, 2, 3, 4, 5, 6, 7, 10, 11, 22, 23, 25, 55, 57) then ComponentID else ComponentName end





		--ORDER BY t1.SectionID, case when t1.SectionID in (1, 2, 3, 4, 5, 6, 7, 10, 11, 22, 23, 25, 55, 57) then  t1.ComponentID else t1.ComponentName end

	END




GO

GRANT EXECUTE ON stpSpecifComponentLookUp TO rolFormSpecificationEdit, rolFormSpecificationEditAdd, rolFormSpecificationFull, rolSpecification01

GO



/*

select * from tblSectionPosMask


*/



