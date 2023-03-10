USE [budget]
GO
/****** Объект:  StoredProcedure [dbo].[stpTechPathSave]    Дата сценария: 03/20/2017 18:23:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Процедура работает добавления/редактирования/удаления.
ALTER PROCEDURE [dbo].[stpTechPathSave]
  @TPID int = null OUTPUT,
  @CompleteSetID int = null,
  @ModuleID int = null,
  @ProductNPID int = null,
  @TSOID int = null,
  @Note varchar(250) = null,
  @DateBAccount datetime = null,
  @RowState int  --1 - Добавление, 
                 --2 - редактирование, 
                 --3 - удаление записи
                 
AS
SET NOCOUNT ON
DECLARE
  @Priority int

  IF @RowState <> 3 and @TSOID is not null
    IF NOT EXISTS (SELECT * FROM tblTechSOLinks WHERE TSOID = @TSOID) RETURN 1

  --КУСОК ДЛЯ ПРОВЕРОК СВЯЗАННЫХ С ДВИЖЕНИЕМ
  IF @RowState <> 1  --если параметр @TSOID не известен, то находим его значение из строки тех-маршрута
    SELECT @CompleteSetID = CompleteSetID, @ModuleID = ModuleID, @ProductNPID = ProductNPID, @TSOID = case when @TSOID is null then TSOID else @TSOID end FROM tblTechPaths as A WHERE A.TPID = @TPID

  --при изменении маршрута у комплекта/модуля нужно проверить, чтобы в движении на операциях этого маршрута не было этого комплекта/модуля
  --проверки только для штрихованных комплектов/модулей и ручного движения 
  --при добавлении
  IF @RowState = 1 or (@RowState = 2 and @TSOID <> (SELECT TSOID FROM tblTechPaths as A WHERE A.TPID = @TPID)) or @RowState = 3
  BEGIN
    --определяем штрихованный комплект/модуль или нет
    IF @ModuleID is not null or (SELECT flgBarCode FROM tblCompleteSets WHERE CompleteSetID = @CompleteSetID) = 1
    BEGIN
      --штрих-коды комплектов и модулей могут наследоваться, по этому обязательно привязваемся к тех-маршруту
      --комплекты и модули могут находиться в мультипликациях, по этому для комплектов запрос строим через журнал запусков
      --для комплектов
      IF @CompleteSetID is not null
      BEGIN
        IF (SELECT sum(D.Quantity)
            FROM tblTechPaths as A
            INNER JOIN tblMagComplete as B ON B.CompleteSetID = A.CompleteSetID
            INNER JOIN tblMoveCMBarCodeLink as C ON C.MagCompleteID = B.MagCompleteID
            INNER JOIN tblMoveCM as D ON D.BCLID = C.BCLID and (D.TPID = A.TPID or D.TSOID = 48)
            WHERE A.CompleteSetID = @CompleteSetID) <> 0
          RETURN 7  --данный комплект находится в незавершенном производстве
      END

      --для модулей
      IF @ModuleID is not null
      BEGIN
        IF (SELECT sum(C.Quantity)
            FROM tblTechPaths as A
            INNER JOIN tblMoveCMBarCodeLink as B ON B.ModuleID = A.ModuleID
            INNER JOIN tblMoveCM as C ON C.BCLID = B.BCLID and (C.TPID = A.TPID or C.TSOID = 48)
            WHERE A.ModuleID = @ModuleID) <> 0
          RETURN 8  --данный модуль находится в незавершенном производстве
      END
    END
    ELSE  --если это не штрихованный объект, то значит это комплект ручного движения
    BEGIN
      --смотрим в движении по этому комплекту
      IF (SELECT sum(B.Quantity)
          FROM tblTechPaths as A
          INNER JOIN tblMoveCM as B ON B.CompleteSetID = A.CompleteSetID and (B.TPID = A.TPID or B.TSOID = 48)
          WHERE A.CompleteSetID = @CompleteSetID) <> 0
        RETURN 7  --данный комплект находится в незавершенном производстве
    END

    --для несерийных изделий
    IF @ProductNPID is not null
    BEGIN
      IF (SELECT isnull(sum(C.Quantity), 0)
          FROM tblTechPaths as A
          INNER JOIN tblMagProductionTooling as B ON B.ProductNPID = A.ProductNPID
          INNER JOIN tblMovePNP as C ON C.MPTID = B.MPTID and (C.TPIDIn = A.TPID or C.TSOIDIn = 48)
          WHERE A.ProductNPID = @ProductNPID) <> 0
        RETURN 14
    END
  END


    --проверяем, чтобы операция на участке была разрешена
  IF @RowState = 1 or @RowState = 2
  BEGIN
    IF (SELECT flgBan FROM tblTechSOLinks WHERE TSOID = @TSOID) = 1 RETURN 13
  END

  --при редактировании
  --при удалении
  --КОНЕЦ ПРОВЕРОК СВЯЗАННЫХ С ДВИЖЕНИЕМ  

  --добавление
  IF @RowState = 1
  BEGIN
    IF @CompleteSetID is not null
    BEGIN
      IF EXISTS (SELECT * FROM tblTechPaths WHERE CompleteSetID = @CompleteSetID and TSOID = @TSOID) RETURN 2
      SET @Priority = (SELECT isnull(max(Priority), 0) + 1 FROM tblTechPaths WHERE CompleteSetID = @CompleteSetID)
    END
    IF @ModuleID is not null
    BEGIN
      IF EXISTS (SELECT * FROM tblTechPaths WHERE ModuleID = @ModuleID and TSOID = @TSOID) RETURN 3
      SET @Priority = (SELECT isnull(max(Priority), 0) + 1 FROM tblTechPaths WHERE ModuleID = @ModuleID)
    END
    IF @ProductNPID is not null
    BEGIN
      IF EXISTS (SELECT * FROM tblTechPaths WHERE ProductNPID = @ProductNPID and TSOID = @TSOID) RETURN 3
      SET @Priority = (SELECT isnull(max(Priority), 0) + 1 FROM tblTechPaths WHERE ProductNPID = @ProductNPID)
    END

--ProductNPID
    BEGIN TRANSACTION
      INSERT INTO tblTechPaths (TSOID, CompleteSetID, ModuleID, ProductNPID, Note, Priority, DateBAccount)
      --VALUES (@TSOID, @CompleteSetID, @ModuleID, @ProductNPID, @Note, @Priority, isnull(@DateBAccount, dbo.fncFlashDate(getdate())))
		VALUES (@TSOID, @CompleteSetID, @ModuleID, @ProductNPID, @Note, @Priority, isnull(@DateBAccount, CAST(YEAR(GETDATE()) AS VARCHAR(4)) + RIGHT('00' + CAST(MONTH(GETDATE()) AS VARCHAR(2)),2) + '01'))
  

      SET @TPID =  SCOPE_IDENTITY()
  
      IF @@ERROR <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RETURN 4
      END
    COMMIT TRANSACTION
  END

  --редактирование
  IF @RowState = 2
  BEGIN
/*
    --проверка на наличие модуля/комлпекта при изменении пункта тех-маршрута на другой
    IF @TSOID is not null and @TSOID <> (SELECT TSOID FROM tblTechPaths WHERE TPID = @TPID)
      IF (SELECT isnull(sum(isnull(A.Quantity, 0)), 0) 
          FROM tblMoveCM as A 
          INNER JOIN tblTechPaths as C ON C.TPID = A.TPID
          INNER JOIN tblModuleStructComplete as B ON B.NumStructure = A.NumStructure and (B.CompleteSetID = C.CompleteSetID or B.ModuleID = C.ModuleID)
          WHERE A.TPID = @TPID) <> 0 RETURN 5
*/
    BEGIN TRANSACTION
      UPDATE tblTechPaths SET Note = case when isnull(@Note, '') <> isnull(Note, '') then @Note else Note end, TSOID = isnull(@TSOID, TSOID), 
                              DateBAccount = isnull(@DateBAccount, dbo.fncFlashDate(getdate())), Editor = default, DateEdit = default
      WHERE TPID = @TPID
  
      IF @@ERROR <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RETURN 6
      END
    COMMIT TRANSACTION
  END

  --удаление
  IF @RowState = 3
  BEGIN
/*
    --проверка на наличие модуля/комлпекта при удалении пункта из тех-маршрута
    IF (SELECT isnull(sum(isnull(A.Quantity, 0)), 0) 
        FROM tblMoveCM as A 
        INNER JOIN tblTechPaths as C ON C.TPID = A.TPID
        LEFT JOIN tblMoveCM as B ON B.ParentID = A.MMCMID
--        INNER JOIN tblModuleStructComplete as B ON B.NumStructure = A.NumStructure and (B.CompleteSetID = C.CompleteSetID or B.ModuleID = C.ModuleID)
        WHERE A.TPID = @TPID and A.ParentID is null) <> 0 RETURN 7
*/
    --проверка на наличие документов
    IF EXISTS (SELECT * FROM Files.dbo.tblTechPathDoc WHERE TPID = @TPID) RETURN 9
    IF EXISTS (SELECT * FROM tblTechOperTime WHERE TPID = @TPID) RETURN 11    --наличие времени операций
    IF EXISTS (SELECT * FROM tblTechPathLinkDD WHERE TPID = @TPID) RETURN 12    --привязка к конструкторсокй документации
  
    BEGIN TRANSACTION
      --если эта запись в не последняя в списке, то меняем приоритет у записей стоящих после удаляемой на одну позицию выше
      --у комплектов
      IF (SELECT CompleteSetID FROM tblTechPaths WHERE TPID = @TPID) is not null
      BEGIN
        UPDATE tblTechPaths SET Priority = Priority - 1 WHERE CompleteSetID = (SELECT CompleteSetID FROM tblTechPaths WHERE TPID = @TPID) and Priority > (SELECT Priority FROM tblTechPaths WHERE TPID = @TPID)
        IF @@ERROR <> 0
        BEGIN
          ROLLBACK TRANSACTION
          RETURN 10
        END
      END

      IF (SELECT ModuleID FROM tblTechPaths WHERE TPID = @TPID) is not null
      BEGIN
        UPDATE tblTechPaths SET Priority = Priority - 1 WHERE ModuleID = (SELECT ModuleID FROM tblTechPaths WHERE TPID = @TPID) and Priority > (SELECT Priority FROM tblTechPaths WHERE TPID = @TPID)
        IF @@ERROR <> 0
        BEGIN
          ROLLBACK TRANSACTION
          RETURN 10
        END
      END

      IF (SELECT ProductNPID FROM tblTechPaths WHERE TPID = @TPID) is not null
      BEGIN
        UPDATE tblTechPaths SET Priority = Priority - 1 WHERE ProductNPID = (SELECT ProductNPID FROM tblTechPaths WHERE TPID = @TPID) and Priority > (SELECT Priority FROM tblTechPaths WHERE TPID = @TPID)
        IF @@ERROR <> 0
        BEGIN
          ROLLBACK TRANSACTION
          RETURN 10
        END
      END
--ProductNPID  
      DELETE FROM tblTechPaths WHERE TPID = @TPID
  
      IF @@ERROR <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RETURN 10
      END
    COMMIT TRANSACTION
  END

RETURN 0
