USE [budget]
GO
/****** Объект:  StoredProcedure [dbo].[stpTechPathSaveOperTime]    Дата сценария: 03/30/2017 20:20:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Процедура для сохранения времени операций.
ALTER PROCEDURE [dbo].[stpTechPathSaveOperTime]
  @Switch int,    --1 - добавление, 2 - редактирование, 3 - удвление
  @TOTID int = null OUTPUT,
  @TPID int = null,
  @TSHID int = null,
  @PreparTime numeric(18, 5) = null,
  @BasicTime numeric(18, 5) = null,
  @flgBasic bit = null,
  @Factor numeric(18, 4) = null,
  @DateBAccount datetime = null,
  @Remark varchar(500) = null,

  @MessageStr varchar(500) = null OUTPUT
AS
SET NOCOUNT ON

  --добавление
  IF @Switch = 1
  BEGIN
    IF EXISTS (SELECT * FROM tblTechOperTime WHERE TPID = @TPID and TSHID = @TSHID)
    BEGIN
      SET @MessageStr = 'Для данного пункта тех-маршрута в базе данных уже есть запись с таким оборудованием! Выполнение операции прервано!'
      RETURN 1
    END

    IF (SELECT count(*) FROM tblTechOperTime WHERE TPID = @TPID and flgBasic = 1) = 1 and isnull(@flgBasic, 0) = 1
    BEGIN
      SET @MessageStr = 'Признак основного оборудования на операции должен быть только у одного оборудования! Выполнение операции прервано!'
      RETURN 1
    END

    IF isnull(@Factor, 0) < 0
    BEGIN
      SET @MessageStr = 'Значение коэффициента должно быть больше или равно нулю! Выполнение операции прервано!'
      RETURN 1
    END

    BEGIN TRANSACTION
      INSERT INTO tblTechOperTime (TPID, TSHID, PreparTime, BasicTime, flgBasic, Factor, DateBAccount, Remark)
      VALUES (@TPID, @TSHID, isnull(@PreparTime, 0), isnull(@BasicTime, 0), isnull(@flgBasic, 0), isnull(@Factor, 1), isnull(@DateBAccount, dbo.fncFlashDate(getdate())), @Remark)
      IF @@ERROR <> 0
      BEGIN
        ROLLBACK TRANSACTION
        SET @MessageStr = 'Произошла ошибка при выполнении операции! Обратитесь к разработчикам!'
        RETURN 1
      END
  
      SET @TOTID = @@Identity
      IF @@ERROR <> 0
      BEGIN
        ROLLBACK TRANSACTION
        SET @MessageStr = 'Произошла ошибка при выполнении операции! Обратитесь к разработчикам!'
        RETURN 1
      END
    COMMIT TRANSACTION
  END

  --редактирование
  IF @Switch = 2
  BEGIN
    IF is_member('rolManufacture34') <> 1 and user_name() <> 'dbo'
    BEGIN
      SET @MessageStr = 'Вы не имеете прав для удаления данной записи! Выполнение операции прервано!'
      RETURN 1
    END

    IF (SELECT count(*) FROM tblTechOperTime WHERE TPID = @TPID AND TOTID<>@TOTID and flgBasic = 1 ) = 1 and isnull(@flgBasic, 0) = 1
    BEGIN
      SET @MessageStr = 'Признак основного оборудования на операции должен быть только у одного оборудования! Выполнение операции прервано!'
      RETURN 1
    END


    IF EXISTS (SELECT * FROM tblTechOperTime WHERE TPID = @TPID and TSHID = @TSHID and TOTID <> @TOTID)
    BEGIN
      SET @MessageStr = 'Для данного пункта тех-маршрута в базе данных уже есть запись с таким оборудованием! Выполнение операции прервано!'
      RETURN 1
    END

    IF isnull(@Factor, 0) < 0
    BEGIN
      SET @MessageStr = 'Значение коэффициента должно быть больше или равно нулю! Выполнение операции прервано!'
      RETURN 1
    END

    BEGIN TRANSACTION
      UPDATE tblTechOperTime SET TSHID = @TSHID, PreparTime = isnull(@PreparTime, 0), BasicTime = isnull(@BasicTime, 0), flgBasic = isnull(@flgBasic, 0), 
                                 Factor = isnull(@Factor, 1), DateBAccount = isnull(@DateBAccount, dbo.fncFlashDate(getdate())), Remark=@Remark, Editor = default, DateEdit = default
      WHERE TOTID = @TOTID
      IF @@ERROR <> 0
      BEGIN
        ROLLBACK TRANSACTION
        SET @MessageStr = 'Произошла ошибка при выполнении операции! Обратитесь к разработчикам!'
        RETURN 1
      END
    COMMIT TRANSACTION
  END

  --удаление
  IF @Switch = 3
  BEGIN
    IF is_member('rolManufacture34') <> 1 and user_name() <> 'dbo'
    BEGIN
      SET @MessageStr = 'Вы не имеете прав для удаления данной записи! Выполнение операции прервано!'
      RETURN 1
    END

    BEGIN TRANSACTION
      DELETE FROM tblTechOperTime WHERE TOTID = @TOTID
      IF @@ERROR <> 0
      BEGIN
        ROLLBACK TRANSACTION
        SET @MessageStr = 'Произошла ошибка при выполнении операции! Обратитесь к разработчикам!'
        RETURN 1
      END
    COMMIT TRANSACTION
  END

RETURN 0
