USE [budget]
GO
/****** Object:  StoredProcedure [dbo].[stpTechPathDocSaveData]    Script Date: 11/22/2016 18:54:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

--Процедура сохранения файлов документации в базе данных.
ALTER PROCEDURE [dbo].[stpTPDocSaveData] 
  @Switch int,  --  1 - добавление, 2 - архивирование, 3 - удаление, 4 - редактирование
  @TPID int = null,					--ID записи тех-маршрута
  @TDTID int = null,				--Вид документации
  @FileName varchar(100) = null,
  @FileData image = null,
  @Note varchar(250) = null,
  @flgArch	INT = 0,
  @TPDID int = null OUTPUT			--ID записи (счетчик)
AS

BEGIN

    IF @Switch = 1
    BEGIN
      INSERT INTO Files.dbo.tblTechPathDoc (TPID, TDTID, [FileName], FileData, flgArchive, Note)
      VALUES (@TPID, @TDTID, @FileName, @FileData, 0, @Note)
      SET @TPDID = @@Identity
      IF @@ERROR <> 0
      BEGIN
        RETURN 1
      END
    END

    IF @Switch = 2
    BEGIN
      UPDATE Files.dbo.tblTechPathDoc SET flgArchive = 1, Editor = default, DateEdit = default
      WHERE TPDID = @TPDID
      IF @@ERROR <> 0
      BEGIN
        RETURN 2
      END
    END

    IF @Switch = 3
    BEGIN
      DELETE FROM Files.dbo.tblTechPathDoc WHERE TPDID = @TPDID
      IF @@ERROR <> 0
      BEGIN
        RETURN 3
      END
    END

    IF @Switch = 4
    BEGIN
      UPDATE Files.dbo.tblTechPathDoc SET
				TDTID=@TDTID,
				--[FileName]=ISNULL(@FileName,[FileName]),
				--FileData=ISNULL(@FileData,FileData),
				flgArchive=@flgArch,
				--Note = isnull(@Note, Note)
				Note = @Note,
				Editor = SUSER_SNAME(), 
				DateEdit = GETDATE()
				
       
      WHERE TPDID = @TPDID
      IF @@ERROR <> 0
      BEGIN
        RETURN 2
      END
    END

	RETURN 0


END
GO

GRANT EXECUTE ON stpTPDocSaveData TO rolManufacture34, rolTechDoc06

GO
