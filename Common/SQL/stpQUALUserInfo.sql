

ALTER PROC [dbo].[stpQUALUserInfo] 
AS
BEGIN



	/*
		автор: popovml
		система: ”правление качеством. 
		описание: информаци€ о текущем пользователе
	
	*/


	SET NOCOUNT ON

	DECLARE @PeopleID INT
	SELECT @PeopleID = PersonID FROM tblUserLogins	WHERE Login	= REPLACE(REPLACE(SUSER_SNAME(), 'ATLAS\', ''), 'TITAN\','') AND flgArchive=0

	SELECT ISNULL(PEOP.LastName,'') + ' ' + ISNULL(PEOP.FirstName,'') + ' ' + ISNULL(PEOP.SecondName,'') AS FIO,
			 PEOP.PeopleID,
			 UL.Login
	  FROM tblPeople AS PEOP INNER JOIN tblUserlogins  AS UL ON PEOP.PeopleID=UL.PersonID AND UL.flgArchive=0
			WHERE PEOP.PeopleID = @PeopleID


END

GO


GRANT EXECUTE ON [stpQUALUserInfo] TO public 