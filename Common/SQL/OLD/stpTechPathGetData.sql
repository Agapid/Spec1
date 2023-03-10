USE [budget]
GO
/****** Объект:  StoredProcedure [dbo].[stpTechPathGetData]    Дата сценария: 03/09/2017 19:59:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--stpTechPathGetData 1
--Процедура достает данные для работы формы.
ALTER PROCEDURE [dbo].[stpTechPathGetData]
  @Switch int,  --1 - список комплектов/модулей, 2 - технологический маршруты, 3 - список действующей документации по данному маршруту,
                --4 - архив документации по данному маршруту, 5 - прилинкованная КД, 6 - оборудование и время операций
                --7 - технологические операции, 8 - список видов документации, 9 - список доступной КД для данного пользователя (для выбора), 10 - оборудование,
                --11 - данные для рассылки, 12 - список адресов для рассылки
  @TOTID int = null

AS

  IF @Switch = 1




    --поле EnabledTP нужно для того, чтобы запретить редактировать строки с трудоемкостью
    SELECT T1.CompleteSetID, null as ModuleID, null as ProductNPID, CompleteSetName as UnitName, 'Комплект' as Type, 
           cast(case when is_member('rolManufacture34') = 1 or user_name() = 'dbo' then 1 else 0 end as bit) as EnabledTP,
			CASE WHEN tDiff.CompleteSetID IS NOT NULL THEN 1 ELSE 0 END AS Diff
        FROM tblCompleteSets AS T1 
            INNER JOIN dbo.vwAccessPersonToCompleteSetsByDomains AS APCSD ON APCSD.CompleteSetID=T1.CompleteSetID -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
            LEFT JOIN 
    			(
    				SELECT DISTINCT A.CompleteSetID 
                        FROM tblTechPaths as A
                            INNER JOIN dbo.vwAccessPersonToProductsNotPieceByDomains AS APPNPD ON APPNPD.ProductNPID=ISNULL(A.ProductNPID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
                            INNER JOIN dbo.vwAccessPersonToModulesByDomains AS APMD ON APMD.ModuleID=ISNULL(A.ModuleID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.              
    					    INNER JOIN tblTechOperTime as B ON B.TPID = A.TPID AND B.flgBasic=1
    				WHERE DATEDIFF(mm, B.DateBAccount, B.DateEdit) >=6 
    			) AS tDiff ON tDiff.CompleteSetID=T1.CompleteSetID
    	WHERE [View] = 1
    UNION ALL
    SELECT null as CompleteSetID, T1.ModuleID, null as ProductNPID, ModuleName as UnitName, 'Модуль' as Type, 
           cast(case when is_member('rolManufacture34') = 1 or user_name() = 'dbo' then 1 else 0 end as bit) as EnabledTP,
			CASE WHEN tDiff.ModuleID IS NOT NULL THEN 1 ELSE 0 END AS Diff	
        FROM tblModules T1 
            INNER JOIN dbo.vwAccessPersonToModulesByDomains AS APMD ON APMD.ModuleID=T1.ModuleID -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
            LEFT JOIN 
    			(
    				SELECT DISTINCT A.ModuleID 
                        FROM tblTechPaths as A
                            INNER JOIN dbo.vwAccessPersonToProductsNotPieceByDomains AS APPNPD ON APPNPD.ProductNPID=ISNULL(A.ProductNPID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
                            INNER JOIN dbo.vwAccessPersonToCompleteSetsByDomains AS APCSD ON APCSD.CompleteSetID=ISNULL(A.CompleteSetID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
    					    INNER JOIN tblTechOperTime as B ON B.TPID = A.TPID AND B.flgBasic=1
    				WHERE DATEDIFF(mm, B.DateBAccount, B.DateEdit) >=6 
    			) AS tDiff ON tDiff.ModuleID=T1.ModuleID
    	WHERE flgView = 0
    UNION ALL
    SELECT null as CompleteSetID, null as ModuleID, T1.ProductNPID, ProductName as UnitName, 'Несерийное изделие' as Type, 
           cast(case when is_member('rolManufacture34') = 1 or user_name() = 'dbo' then 1 else 0 end as bit) as EnabledTP,
			CASE WHEN tDiff.ProductNPID IS NOT NULL THEN 1 ELSE 0 END AS Diff
        FROM tblProductNotPiece AS T1 
            INNER JOIN dbo.vwAccessPersonToProductsNotPieceByDomains AS APPNPD ON APPNPD.ProductNPID=T1.ProductNPID -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
            LEFT JOIN 
    			(
    				SELECT DISTINCT A.ProductNPID 
                        FROM tblTechPaths as A
                            INNER JOIN dbo.vwAccessPersonToCompleteSetsByDomains AS APCSD ON APCSD.CompleteSetID=ISNULL(A.CompleteSetID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
                            INNER JOIN dbo.vwAccessPersonToModulesByDomains AS APMD ON APMD.ModuleID=ISNULL(A.ModuleID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.              
    					    INNER JOIN tblTechOperTime as B ON B.TPID = A.TPID AND B.flgBasic=1
    				WHERE DATEDIFF(mm, B.DateBAccount, B.DateEdit) >=6 
    			) AS tDiff  ON tDiff.ProductNPID=T1.ProductNPID
        ORDER BY UnitName


  IF @Switch = 2
    SELECT A.TPID, I.TechSectorName, A.TSOID, A.Note, A.Priority, A.CompleteSetID, A.ModuleID, A.ProductNPID, A.DateBAccount
        FROM tblTechPaths as A
            INNER JOIN dbo.vwAccessPersonToProductsNotPieceByDomains AS APPNPD ON APPNPD.ProductNPID=ISNULL(A.ProductNPID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
            INNER JOIN dbo.vwAccessPersonToCompleteSetsByDomains AS APCSD ON APCSD.CompleteSetID=ISNULL(A.CompleteSetID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
            INNER JOIN dbo.vwAccessPersonToModulesByDomains AS APMD ON APMD.ModuleID=ISNULL(A.ModuleID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.              
            INNER JOIN tblTechSOLinks as H ON H.TSOID = A.TSOID
            INNER JOIN tblTechSectors as I ON I.TSID = H.TSID
        ORDER BY A.Priority


  IF @Switch = 3
    SELECT A.TPID, B.TPDID, B.TDTID, C.DTName, B.[FileName], B.DateRec, cast(null as varchar(1000)) as FilePath, C.flgOpen, B.Note
        FROM tblTechPaths as A
            INNER JOIN dbo.vwAccessPersonToProductsNotPieceByDomains AS APPNPD ON APPNPD.ProductNPID=ISNULL(A.ProductNPID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
            INNER JOIN dbo.vwAccessPersonToCompleteSetsByDomains AS APCSD ON APCSD.CompleteSetID=ISNULL(A.CompleteSetID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
            INNER JOIN dbo.vwAccessPersonToModulesByDomains AS APMD ON APMD.ModuleID=ISNULL(A.ModuleID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.              
            INNER JOIN Files.dbo.tblTechPathDoc as B ON B.TPID = A.TPID and B.flgArchive = 0
            INNER JOIN tblTechDocTypes as C ON C.TDTID = B.TDTID
        ORDER BY B.[FileName], B.DateRec


  IF @Switch = 4
    SELECT A.TPID, B.TPDID, C.DTName, B.[FileName], B.DateRec, B.DateEdit, C.flgOpen, B.Note
        FROM tblTechPaths as A
            INNER JOIN dbo.vwAccessPersonToProductsNotPieceByDomains AS APPNPD ON APPNPD.ProductNPID=ISNULL(A.ProductNPID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
            INNER JOIN dbo.vwAccessPersonToCompleteSetsByDomains AS APCSD ON APCSD.CompleteSetID=ISNULL(A.CompleteSetID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
            INNER JOIN dbo.vwAccessPersonToModulesByDomains AS APMD ON APMD.ModuleID=ISNULL(A.ModuleID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.              
            INNER JOIN Files.dbo.tblTechPathDoc as B ON B.TPID = A.TPID and B.flgArchive = 1
            INNER JOIN tblTechDocTypes as C ON C.TDTID = B.TDTID
        ORDER BY B.[FileName], B.DateRec


  IF @Switch = 5
    SELECT B.TPLDDID, A.TPID, B.DDID, D.DTName, C.[FileName], C.DateRec, cast(null as varchar(1000)) as FilePath, D.flgOpen, C.Note
        FROM tblTechPaths as A
            INNER JOIN dbo.vwAccessPersonToProductsNotPieceByDomains AS APPNPD ON APPNPD.ProductNPID=ISNULL(A.ProductNPID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
            INNER JOIN dbo.vwAccessPersonToCompleteSetsByDomains AS APCSD ON APCSD.CompleteSetID=ISNULL(A.CompleteSetID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
            INNER JOIN dbo.vwAccessPersonToModulesByDomains AS APMD ON APMD.ModuleID=ISNULL(A.ModuleID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.              
            INNER JOIN tblTechPathLinkDD as B ON B.TPID = A.TPID
            INNER JOIN Files.dbo.tblDesignerDoc as C ON C.DDID = B.DDID and C.flgArchive = 0
            INNER JOIN tblTechDocTypes as D ON D.TDTID = C.TDTID


  IF @Switch = 6
    SELECT B.TOTID, A.TPID, B.TSHID, B.PreparTime, B.BasicTime, B.flgBasic, A.TSOID, B.Factor, B.DateBAccount, B.DateEdit, DATEDIFF(mm, B.DateBAccount, B.DateEdit) AS Diff
        FROM tblTechPaths as A
            INNER JOIN dbo.vwAccessPersonToProductsNotPieceByDomains AS APPNPD ON APPNPD.ProductNPID=ISNULL(A.ProductNPID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
            INNER JOIN dbo.vwAccessPersonToCompleteSetsByDomains AS APCSD ON APCSD.CompleteSetID=ISNULL(A.CompleteSetID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
            INNER JOIN dbo.vwAccessPersonToModulesByDomains AS APMD ON APMD.ModuleID=ISNULL(A.ModuleID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.              
            INNER JOIN tblTechOperTime as B ON B.TPID = A.TPID


  IF @Switch = 7
    SELECT A.TSOID, B.TechSectorName, C.OperName, case when A.flgBan = 0 then 'Разрешена' else 'Запрещена' end as Ban, C.DateEdit
    FROM tblTechSOLinks as A
    INNER JOIN tblTechSectors as B ON B.TSID = A.TSID
    INNER JOIN tblTechOperations as C ON C.OperID = A.OperID
	WHERE A.flgBan=0
    ORDER BY B.TechSectorName, C.OperName



  IF @Switch = 8
    SELECT TDTID, DTName  
    FROM tblTechDocTypes
    WHERE SubjectOwn = 2
    ORDER BY DTName


  IF @Switch = 9
  BEGIN
    IF user_name() = 'dbo'
      SELECT A.DDID, B.DTName, A.TDTID, A.CompleteSetID, A.ModuleID, null as ProductNPID, A.[FileName], cast(null as image) as FileData, A.Note, A.flgArchive, A.DateRec, 
             cast(null as varchar(1000)) as FilePath, B.flgOpen
          FROM Files.dbo.tblDesignerDoc as A
                INNER JOIN dbo.vwAccessPersonToCompleteSetsByDomains AS APCSD ON APCSD.CompleteSetID=ISNULL(A.CompleteSetID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
                INNER JOIN dbo.vwAccessPersonToModulesByDomains AS APMD ON APMD.ModuleID=ISNULL(A.ModuleID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.              
                INNER JOIN dbo.vwAccessPersonToProductsByDomains AS APPD ON APPD.ProductID=ISNULL(A.ProductID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
                INNER JOIN tblTechDocTypes as B ON B.TDTID = A.TDTID
          WHERE A.flgArchive = 0
    ELSE
      SELECT A.DDID, A.TDTID, B.DTName, A.CompleteSetID, A.ModuleID, null as ProductNPID, A.[FileName], cast(null as image) as FileData, A.Note, A.flgArchive, A.DateRec, 
             cast(null as varchar(1000)) as FilePath, B.flgOpen
          FROM Files.dbo.tblDesignerDoc as A
                INNER JOIN dbo.vwAccessPersonToCompleteSetsByDomains AS APCSD ON APCSD.CompleteSetID=ISNULL(A.CompleteSetID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
                INNER JOIN dbo.vwAccessPersonToModulesByDomains AS APMD ON APMD.ModuleID=ISNULL(A.ModuleID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.              
                INNER JOIN dbo.vwAccessPersonToProductsByDomains AS APPD ON APPD.ProductID=ISNULL(A.ProductID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
                INNER JOIN tblTechDocTypes as B ON B.TDTID = A.TDTID
                INNER JOIN tblDesineDocPermission as C ON C.TDTID = B.TDTID and C.PersonID = dbo.fncGetUserID(dbo.fncGetUserName(suser_sname()))
          WHERE A.flgArchive = 0
  END


  IF @Switch = 10
    SELECT D.TSHID, E.TPLName, C.TechSectorName, F.OperName, A.TSOID, A.CompleteSetID, A.ModuleID, A.ProductNPID--, A.*
        FROM tblTechPaths as A
            INNER JOIN dbo.vwAccessPersonToProductsNotPieceByDomains AS APPNPD ON APPNPD.ProductNPID=ISNULL(A.ProductNPID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
            INNER JOIN dbo.vwAccessPersonToCompleteSetsByDomains AS APCSD ON APCSD.CompleteSetID=ISNULL(A.CompleteSetID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
            INNER JOIN dbo.vwAccessPersonToModulesByDomains AS APMD ON APMD.ModuleID=ISNULL(A.ModuleID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.              
            INNER JOIN tblTechSOLinks as B ON B.TSOID = A.TSOID
            INNER JOIN tblTechSectors as C ON C.TSID = B.TSID
            INNER JOIN tblTechStandardHour as D ON D.TSOID = A.TSOID
            INNER JOIN tblTechPlant as E ON E.TPLID = D.TPLID
            INNER JOIN tblTechOperations as F ON F.OperID = B.OperID
    --where a.tsoid = 14 and a.completesetid = 3009
        ORDER BY E.TPLName
    --select * from tblcompletesets where completesetid = 3009
    --select * from tblTechPaths where tpid = 10351


  IF @Switch = 11
  BEGIN
    DECLARE @TOTAID int
    --нужно выявить новая эта запись или нет
    --у новых записей в архиве всегда только одна запись и добавляется в архив при ее создании в рабочей таблице
    IF (SELECT count(*) FROM tblTechOperTimeArchive WHERE TOTID = @TOTID) = 1
    BEGIN
      --если новая, то просто заносим в 'стало'
      SELECT dbo.fncGetUserFIO(dbo.fncGetUserName(A.Creator)) as CrSurname, 
            case when B.CompleteSetID is not null then 'Комплект: '
              when B.ModuleID is not null then 'Модуль: '
              when B.ProductNPID is not null then 'Несерийное изделие: ' end as UnitTypeName,
            isnull(F.CompleteSetName, isnull(G.ModuleName, H.ProductName)) as UnitName,
            D.TechSectorName, E.OperName, 
            --было
            '' as TPLNameOld, '' as PreparTimeOld, '' as BasicTimeOld, '' as flgBasicOld, '' as FactorOld,
            --стало
            J.TPLName as TPLNameNew, A.PreparTime as PreparTimeNew, A.BasicTime as BasicTimeNew, case when A.flgBasic = 0 then '...' else '+' end as flgBasicNew, A.Factor as FactorNew,
            'BORDER-RIGHT: lightgrey 1pt solid; BORDER-TOP: lightgrey 1pt solid; FONT-WEIGHT: bold; FONT-SIZE: 12px; BORDER-LEFT: lightgrey 1pt solid; BORDER-BOTTOM: lightgrey 1pt solid; FONT-STYLE: normal; FONT-FAMILY: Verdana; TEXT-ALIGN: center' as StyleTitle,
            'BORDER-RIGHT: lightgrey 1pt solid; BORDER-TOP: lightgrey 1pt solid; BORDER-LEFT: lightgrey 1pt solid; BORDER-BOTTOM: lightgrey 1pt solid; FONT-SIZE: 12px; FONT-STYLE: normal; FONT-FAMILY: Verdana' as Style
          FROM tblTechOperTimeArchive as A
                INNER JOIN tblTechPaths as B ON B.TPID = A.TPID
                INNER JOIN dbo.vwAccessPersonToProductsNotPieceByDomains AS APPNPD ON APPNPD.ProductNPID=ISNULL(B.ProductNPID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
                INNER JOIN dbo.vwAccessPersonToCompleteSetsByDomains AS APCSD ON APCSD.CompleteSetID=ISNULL(B.CompleteSetID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
                INNER JOIN dbo.vwAccessPersonToModulesByDomains AS APMD ON APMD.ModuleID=ISNULL(B.ModuleID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.              
                INNER JOIN tblTechSOLinks as C ON C.TSOID = B.TSOID
                INNER JOIN tblTechSectors as D ON D.TSID = C.TSID
                INNER JOIN tblTechOperations as E ON E.OperID = C.OperID
                LEFT JOIN tblCompleteSets as F ON F.CompleteSetID = B.CompleteSetID
                LEFT JOIN tblModules as G ON G.ModuleID = B.ModuleID
                LEFT JOIN tblProductNotPiece as H ON H.ProductNPID = B.ProductNPID
                INNER JOIN tblTechStandardHour as I ON I.TSHID = A.TSHID
                INNER JOIN tblTechPlant as J ON J.TPLID = I.TPLID
          WHERE A.TOTID = @TOTID
    END
    ELSE
    BEGIN
      SET @TOTAID = (SELECT top 1 TOTAID FROM tblTechOperTimeArchive WHERE TOTID = @TOTID order by TOTAID DESC)

      --стало
      SELECT top 1 a.TOTAID, a.TOTID, dbo.fncGetUserFIO(dbo.fncGetUserName(A.Creator)) as CrSurname, 
            case when B.CompleteSetID is not null then 'Комплект: '
              when B.ModuleID is not null then 'Модуль: '
              when B.ProductNPID is not null then 'Несерийное изделие: ' end as UnitTypeName,
            isnull(F.CompleteSetName, isnull(G.ModuleName, H.ProductName)) as UnitName,
            D.TechSectorName, E.OperName, 
            case when A.flgDelete = 1 then '...' else J.TPLName end as TPLNameNew, 
            case when A.flgDelete = 1 then '...' else cast(A.PreparTime as varchar) end as PreparTimeNew, 
            case when A.flgDelete = 1 then '...' else cast(A.BasicTime as varchar) end as BasicTimeNew, 
            case when A.flgDelete = 1 then '...' else (case when A.flgBasic = 0 then '...' else '+' end) end as flgBasicNew, 
            case when A.flgDelete = 1 then '...' else cast(A.Factor as varchar) end as FactorNew
          INTO #So
          FROM tblTechOperTimeArchive as A
                INNER JOIN tblTechPaths as B ON B.TPID = A.TPID
                INNER JOIN dbo.vwAccessPersonToProductsNotPieceByDomains AS APPNPD ON APPNPD.ProductNPID=ISNULL(B.ProductNPID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
                INNER JOIN dbo.vwAccessPersonToCompleteSetsByDomains AS APCSD ON APCSD.CompleteSetID=ISNULL(B.CompleteSetID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.
                INNER JOIN dbo.vwAccessPersonToModulesByDomains AS APMD ON APMD.ModuleID=ISNULL(B.ModuleID, -1) -- Добавил 02/2016 Денис всвязи с введением разграничений по территориям.               
                INNER JOIN tblTechSOLinks as C ON C.TSOID = B.TSOID
                INNER JOIN tblTechSectors as D ON D.TSID = C.TSID
                INNER JOIN tblTechOperations as E ON E.OperID = C.OperID
                LEFT JOIN tblCompleteSets as F ON F.CompleteSetID = B.CompleteSetID
                LEFT JOIN tblModules as G ON G.ModuleID = B.ModuleID
                LEFT JOIN tblProductNotPiece as H ON H.ProductNPID = B.ProductNPID
                INNER JOIN tblTechStandardHour as I ON I.TSHID = A.TSHID
                INNER JOIN tblTechPlant as J ON J.TPLID = I.TPLID
          WHERE A.TOTID = @TOTID
          ORDER BY TOTAID desc

      --было
      SELECT top 1 A.TOTAID, A.TOTID, C.TPLName as TPLNameOld, A.PreparTime as PreparTimeOld, A.BasicTime as BasicTimeOld, 
             case when isnull(A.flgBasic, 0) = 0 then '...' else '+' end as flgBasicOld, 
             A.Factor as FactorOld
      INTO #Past
      FROM tblTechOperTimeArchive as A
      INNER JOIN tblTechStandardHour as B ON B.TSHID = A.TSHID
      INNER JOIN tblTechPlant as C ON C.TPLID = B.TPLID
      WHERE A.TOTID = @TOTID and A.TOTAID < @TOTAID ORDER BY A.TOTAID desc

      SELECT A.CrSurname, A.UnitTypeName, A.UnitName, A.TechSectorName, A.OperName, 
            B.TPLNameOld, B.PreparTimeOld, B.BasicTimeOld, B.flgBasicOld, B.FactorOld,
            A.TPLNameNew, A.PreparTimeNew, A.BasicTimeNew, A.flgBasicNew, A.FactorNew,
           'BORDER-RIGHT: lightgrey 1pt solid; BORDER-TOP: lightgrey 1pt solid; FONT-WEIGHT: bold; FONT-SIZE: 12px; BORDER-LEFT: lightgrey 1pt solid; BORDER-BOTTOM: lightgrey 1pt solid; FONT-STYLE: normal; FONT-FAMILY: Verdana; TEXT-ALIGN: center' as StyleTitle,
           'BORDER-RIGHT: lightgrey 1pt solid; BORDER-TOP: lightgrey 1pt solid; BORDER-LEFT: lightgrey 1pt solid; BORDER-BOTTOM: lightgrey 1pt solid; FONT-SIZE: 12px; FONT-STYLE: normal; FONT-FAMILY: Verdana' as Style
      FROM #So as A
      INNER JOIN #Past as B ON B.TOTID = A.TOTID

--stpTechPathGetData 11
    END
  END

  IF @Switch = 12
  BEGIN
    IF (SELECT @@servername) = 'ATLAS'
      SELECT 'zagriazkin@altonika.ru' as email
--      UNION ALL
--      SELECT 'greg@altonika.ru' as email
    ELSE
      SELECT  email

      FROM tblNewsPersonGroups as A
      INNER JOIN tblNPGLinks as B ON B.NPGID = A.NPGID
      INNER JOIN tblPeople as C ON C.PeopleID = B.PeopleID
      INNER JOIN tblComputers as D ON D.PeopleID = C.PeopleID
      WHERE A.NPGID in (79)

  END

--stpTechPathGetData 12


