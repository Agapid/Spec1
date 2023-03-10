USE [budget]
GO
/****** Объект:  StoredProcedure [dbo].[stpQualPMLaunchPassSELECT]    Дата сценария: 07/20/2017 10:21:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


	ALTER PROC [dbo].[stpTP13SELECT ]  @ProductTypeID INT, @ProductID INT

	AS

	/*
		автор: popovml
		система: Технологические маршруты. 
		описание: просмотр паспорта запуска ПМ
		

		возвращает:
				(0) - все прошло хорошо

	*/

	BEGIN
		SET NOCOUNT ON 

		SELECT 

		T1.LaunchPassID,
		T1.LaunchPassID AS RecordID,
		T1.FirmID,
			FR.FirmName,

		T1.ProductTypeID,
			QPT.ProductTypeName,
		T1.ProductID,
			QP.Name AS ProductName,
		T1.LaunchOrderNum,
			MC.NumLaunch,
		T1.MountingPlaceID,
			D1.MarkValueDescrpt AS MountingPlaceName,
		T1.MountingDate,
		T1.TechnologistID,
			INF1.FIO AS TechnologistFIO,
			INF1.NativePodrName AS TechnologistPodrName,
			
		T1.SolderPasteID,
			MLC.MLCItemName AS SolderPasteName,

		T1.PasteKeepingDate,
		T1.PasteTracingID,
			D2.MarkValueDescrpt AS PasteTracingName,
		T1.LineID,
			QL.LineName,
		T1.TermoPID,
			TP.TermoPName,
		T1.TermoProgramm,
		T1.ContactPadCoverID,
			CPC.ContactPadCoverName,

		T1.MountingControlID,
			D3.MarkValueDescrpt AS MountingControlName,
		T1.Remark,
		T1.PassFileName,
		T1.DocumentsList,
		MC.Amount

		FROM tblQualPMLaunchPass AS T1
			LEFT JOIN tblFirmReferens AS FR ON FR.FirmID=T1.FirmID
			LEFT JOIN tblQualProductTypes AS QPT ON QPT.ProductTypeID=T1.ProductTypeID 
			LEFT JOIN v_QUALProductView AS QP ON QP.ProductTypeID=T1.ProductTypeID AND QP.ID=T1.ProductID
			LEFT JOIN tblQualDict AS D1 ON D1.Mark='MountingPlace' AND D1.MarkValue=T1.MountingPlaceID
			LEFT JOIN tblSLRSTR AS INF1 ON T1.TechnologistID=INF1.PeopleID AND INF1.YY=YEAR(T1.DateCreate) AND INF1.MM=MONTH(T1.DateCreate)
			LEFT JOIN tblMLCItems AS MLC ON MLC.MLCSectionID=73 AND MLC.MLCItemID=T1.SolderPasteID
			LEFT JOIN tblQualDict AS D2 ON D2.Mark='PasteTracing' AND D2.MarkValue=T1.PasteTracingID
			LEFT JOIN tblQualLines AS QL ON QL.LineID=T1.LineID
			LEFT JOIN tblQualTermoP AS TP ON TP.TermoPID=T1.TermoPID
			LEFT JOIN tblQualContactPadCover AS CPC ON CPC.ContactPadCoverID=T1.ContactPadCoverID
			LEFT JOIN tblQualDict AS D3 ON D3.Mark='MountingControl' AND D3.MarkValue=T1.MountingControlID
			LEFT JOIN v_QUALZakZapView AS MC ON MC.MagCompleteID=T1.LaunchOrderNum AND MC.ProductTypeID=T1.ProductTypeID
		WHERE  T1.ProductTypeID=@ProductTypeID AND T1.ProductID=@ProductID AND T1.Deleted=0 ORDER BY T1.LaunchPassID


		RETURN 0 

	END

GO

GRANT EXECUTE ON stpTP13SELECT TO rolFactoryTP1, rolManufacture34,  rolTechDoc06

GO
