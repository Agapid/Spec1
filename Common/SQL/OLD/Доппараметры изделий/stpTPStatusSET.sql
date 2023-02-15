ALTER PROC stpTPStatusSET	@RecID INT = NULL OUTPUT,
							@ProductTypeID INT,
							@ProductID INT,
							@ConfirmFunctionID INT,
							@Remark VARCHAR(500)
							
							
AS


BEGIN

	INSERT INTO tblTPStatus (ProductTypeID, ProductID, ConfirmFunctionID, Remark, PeopleID, UserLogin, Creator, DateCreate, Editor,  DateEdit)
	VALUES (@ProductTypeID, @ProductID, @ConfirmFunctionID, @Remark, [dbo].[fncPurOrderCurUserID](), (replace(replace(replace(suser_sname(),'ATLAS\',''),'TITAN\',''),'SATURN\','')), (suser_sname()), (getdate()), (suser_sname()), (getdate()))
	
	SET @RecID = SCOPE_IDENTITY()	
	

END							
							
							
GO
GRANT EXECUTE ON stpTPStatusSET TO rolManufacture34