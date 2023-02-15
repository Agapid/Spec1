



INSERT INTO tblTPDocStatus(TPID, ConfirmFunctionID, Remark)
SELECT TPID, 7, 'Изначально выставленный статус'

FROM 	 tblTechPaths AS TP 
WHERE EXISTS(SELECT * FROM Files.dbo.tblTechPathDoc AS DOC WHERE DOC.TPID=TP.TPID AND DOC.flgArchive = 0)
