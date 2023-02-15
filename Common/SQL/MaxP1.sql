--SELECT * FROM v_ClaimOrders ORDER BY ClaimOrderID DESC

--DELETE FROM tblClaimOrderedPRoducts WHERE ClaimOrderID  = 1104

ALTER PROC MaxP1
AS


    DECLARE @PersonControllerID INT,
			@ControllDate SMALLDATETIME,
			@PersonOperatorID INT,
			@CompleteSetID INT,
			@MagCompleteID INT,
			@QtyChecked INT,
			@F_301В INT,
			@F_302В INT,
			@F_303В INT,
			@F_305В INT,
			@F_306В INT,
			@F_307В INT,
			@F_311В INT,
			@DefectCardID INT




    DECLARE @SN VARCHAR(50)
    DECLARE Cur CURSOR LOCAL FAST_FORWARD FOR
            SELECT	
					ISNULL(P2.PeopleID, 1544) AS PersonControllerID,
					ControllDate,
					T2.PeopleID AS PersonOperatorID,
					T3.CompleteSetID,
					ISNULL(MC.MagCompleteID,56119),
					QtyChecked, F301В, F302В, F303В, F305В, F306В, F307В, F311В

        FROM ex1 AS T1 
		LEFT JOIN v_SLRPersons AS T2 ON T2.FIO1 = T1.PersonOperatorID 
		LEFT JOIN v_SLRPersons AS P2 ON P2.FIO1 = T1.PersonControllerID 
		LEFT JOIN tblCompleteSets AS T3 ON T3.CompleteSetName=T1.CompleteSetID
		LEFT JOIN tblMagComplete AS MC ON MC.CompleteSetID=T3.CompleteSetID AND MC.NumLaunch=T1.MagCompleteID

		WHERE MC.MagCompleteID IS  NULL

    DECLARE @ClaimOrderedCompletesID INT


    OPEN Cur
    
    FETCH NEXT FROM Cur INTO @PersonControllerID, @ControllDate, @PersonOperatorID, @CompleteSetID, @MagCompleteID, @QtyChecked,
							 @F_301В, @F_302В, @F_303В, @F_305В, @F_306В, @F_307В, @F_311В
    WHILE @@FETCH_STATUS = 0
    BEGIN


		PRINT @PersonControllerID 
		PRINT @PersonOperatorID 
		PRINT @CompleteSetID

----		EXEC [stpQualDefectCardDUI] @ClaimOrderedProductID OUTPUT, 1105, @SN, 684, 1, NULL, NULL, 2, 0, NULL, 1, NULL, NULL, 'I'
		EXEC [stpQualDefectCardDUI] NULL, NULL, @PersonControllerID, @ControllDate, @PersonOperatorID, @CompleteSetID, @MagCompleteID, @QtyChecked, 'запуск', 2, @DefectCardID OUTPUT

		IF @F_301В IS NOT NULL 
			BEGIN
				EXEC [stpQualDefectCardDetailsDUI] NULL, @DefectCardID, 0, 68, @F_301В, 'запуск', 2
			END 

		IF @F_302В IS NOT NULL 
			BEGIN
				EXEC [stpQualDefectCardDetailsDUI] NULL, @DefectCardID, 0, 70, @F_302В, 'запуск', 2
			END

		IF @F_303В IS NOT NULL 
			BEGIN
				EXEC [stpQualDefectCardDetailsDUI] NULL, @DefectCardID, 0, 72, @F_303В, 'запуск', 2
			END

		IF @F_305В IS NOT NULL 
			BEGIN
				EXEC [stpQualDefectCardDetailsDUI] NULL, @DefectCardID, 0, 75, @F_305В, 'запуск', 2
			END

		IF @F_306В IS NOT NULL 
			BEGIN
				EXEC [stpQualDefectCardDetailsDUI] NULL, @DefectCardID, 0, 77, @F_306В, 'запуск', 2
			END

		IF @F_307В IS NOT NULL 
			BEGIN
				EXEC [stpQualDefectCardDetailsDUI] NULL, @DefectCardID, 0, 78, @F_307В, 'запуск', 2
			END

		IF @F_311В IS NOT NULL 
			BEGIN
				EXEC [stpQualDefectCardDetailsDUI] NULL, @DefectCardID, 0, 86, @F_311В, 'запуск', 2
			END

        FETCH NEXT FROM Cur INTO @PersonControllerID, @ControllDate, @PersonOperatorID, @CompleteSetID, @MagCompleteID, @QtyChecked,
							  @F_301В, @F_302В, @F_303В, @F_305В, @F_306В, @F_307В, @F_311В
    END

    CLOSE Cur
    DEALLOCATE Cur