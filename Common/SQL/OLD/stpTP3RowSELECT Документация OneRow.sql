
--�������  ������ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpTP3RowSELECT')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- ������� ��������
		   exec ('create procedure stpTP3RowSELECT as select 1')        

GO 
--stpTP3RowSELECT 1

	ALTER PROC stpTP3RowSELECT @RecordID INT

	AS

	/*
		�����: popovml
		�������: ��������������� ��������
		��������: ������������ (���� ������ ��� ����� �����)
		

		����������:
				(0) - ��� ������ ������

	*/

	BEGIN
		SET NOCOUNT ON 
		
		--����������� ������������
		SELECT	B.TPDID AS RecordID,
				B.TDTID,
				C.DTName, 
				B.[FileName], 
				B.DateRec, 
				B.DateEdit, 
				B.flgArchive,
				C.flgOpen, 
				B.Note
		FROM Files.dbo.tblTechPathDoc as B 
						INNER JOIN tblTechDocTypes as C ON C.TDTID = B.TDTID
		WHERE B.TPDID=@RecordID --AND B.flgArchive = 0
		
			--SELECT TOP 10 * FROM Files.dbo.tblTechPathDoc

	RETURN 0 

	END

GO

GRANT EXECUTE ON stpTP3RowSELECT TO rolManufacture34, rolTechDoc06

GO








