


ALTER PROC [dbo].[stpA1LookUps] 
									@LookUpID INT,
									@ChoiseRowVisible BIT = 1,		--показывать первую строку с просьбой о выборе(1); не показывать (0)
									@Prm1 INT = -1					--необязательный параметр
AS
BEGIN



	/*
		автор: popovml
		система: Общие люкапы
		описание: Люкапы
		stpA1LookUps 2, 1


	*/




	SET NOCOUNT ON

	
	IF @LookUpID = 1
		BEGIN


			SELECT	CAST(0 AS INT) AS PeopleID,
					CAST('Выберите значение' AS VARCHAR(100)) AS FIO,
					CAST('' AS VARCHAR(100)) AS PositionName,
					CAST('' AS VARCHAR(100)) AS BisName
					WHERE @ChoiseRowVisible=1
			UNION ALL	

			SELECT T1.PeopleID, T1.FIO, T1.NativePositionName AS PositionName, T1.BisName FROM tblSLRSTR AS T1
			WHERE T1.YY = YEAR(GETDATE()) AND T1.MM = MONTH(GETDATE()) AND T1.PeopleID NOT IN(30,121)
		END
	
	IF @LookUpID = 2
		BEGIN
			SELECT	CAST(0 AS INT) AS AttributeID,
					CAST('Выберите значение' AS VARCHAR(100)) AS AttributeName
					WHERE @ChoiseRowVisible=1
			UNION ALL	

			SELECT AttributeID, AttributeName FROM tblAttributes WHERE AttributeID IN (215, 227, 216, 228)

		END

	IF @LookUpID = 3
		BEGIN
			SELECT	CAST(0 AS INT) AS RBID,
					CAST('Выберите значение' AS VARCHAR(100)) AS BName
					WHERE @ChoiseRowVisible=1
			UNION ALL	

			SELECT RBID, BName FROM tblRefBusiness WHERE flgDelete=0 ORDER BY BName 

		END


	IF @LookUpID = 4
		BEGIN

			SELECT YEAR(OperDate) AS YY, YEAR(OperDate) AS YYText FROM tblVAIn GROUP BY YEAR(OperDate) ORDER BY YEAR(OperDate)

		END


	IF @LookUpID = 5
		BEGIN

			SELECT CAST(MonthNumber AS INT) AS MMValue, MonthName AS MMText FROM v_MonthsList WHERE MonthNumber > 0 ORDER BY MonthNumber ASC

		END

	



END




GO
GRANT EXECUTE ON stpA1LookUps TO rolEnyUser
GO

