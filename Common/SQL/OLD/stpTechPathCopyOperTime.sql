USE [budget]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Процедура для копирования времени операций.
ALTER PROCEDURE [dbo].[stpTechPathCopyOperTime]
												@TPIDFrom INT,
												@TPIDTo INT
												
  
  
AS
BEGIN
SET NOCOUNT ON


	INSERT INTO tblTechOperTime 
		(TPID, TSHID, PreparTime, BasicTime, flgBasic, Factor, DateBAccount, Remark)
	
	SELECT @TPIDTo, TSHID, PreparTime, BasicTime, flgBasic, Factor, 
		CAST(CAST(YEAR(getdate()) AS VARCHAR(4)) +  RIGHT('00' + CAST(MONTH(getdate()) AS VARCHAR(4)) ,2) + '01' AS SMALLDATETIME) AS DateBAccount,
		Remark FROM tblTechOperTime WHERE TPID=@TPIDFrom


  
RETURN 0

END

GO

GRANT EXECUTE ON [stpTechPathCopyOperTime] TO rolManufacture34, rolTEchDoc06

