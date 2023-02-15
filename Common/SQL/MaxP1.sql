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
			@F_301� INT,
			@F_302� INT,
			@F_303� INT,
			@F_305� INT,
			@F_306� INT,
			@F_307� INT,
			@F_311� INT,
			@DefectCardID INT




    DECLARE @SN VARCHAR(50)
    DECLARE Cur CURSOR LOCAL FAST_FORWARD FOR
            SELECT	
					ISNULL(P2.PeopleID, 1544) AS PersonControllerID,
					ControllDate,
					T2.PeopleID AS PersonOperatorID,
					T3.CompleteSetID,
					ISNULL(MC.MagCompleteID,56119),
					QtyChecked, F301�, F302�, F303�, F305�, F306�, F307�, F311�

        FROM ex1 AS T1 
		LEFT JOIN v_SLRPersons AS T2 ON T2.FIO1 = T1.PersonOperatorID 
		LEFT JOIN v_SLRPersons AS P2 ON P2.FIO1 = T1.PersonControllerID 
		LEFT JOIN tblCompleteSets AS T3 ON T3.CompleteSetName=T1.CompleteSetID
		LEFT JOIN tblMagComplete AS MC ON MC.CompleteSetID=T3.CompleteSetID AND MC.NumLaunch=T1.MagCompleteID

		WHERE MC.MagCompleteID IS  NULL

    DECLARE @ClaimOrderedCompletesID INT


    OPEN Cur
    
    FETCH NEXT FROM Cur INTO @PersonControllerID, @ControllDate, @PersonOperatorID, @CompleteSetID, @MagCompleteID, @QtyChecked,
							 @F_301�, @F_302�, @F_303�, @F_305�, @F_306�, @F_307�, @F_311�
    WHILE @@FETCH_STATUS = 0
    BEGIN


		PRINT @PersonControllerID 
		PRINT @PersonOperatorID 
		PRINT @CompleteSetID

----		EXEC [stpQualDefectCardDUI] @ClaimOrderedProductID OUTPUT, 1105, @SN, 684, 1, NULL, NULL, 2, 0, NULL, 1, NULL, NULL, 'I'
		EXEC [stpQualDefectCardDUI] NULL, NULL, @PersonControllerID, @ControllDate, @PersonOperatorID, @CompleteSetID, @MagCompleteID, @QtyChecked, '������', 2, @DefectCardID OUTPUT

		IF @F_301� IS NOT NULL 
			BEGIN
				EXEC [stpQualDefectCardDetailsDUI] NULL, @DefectCardID, 0, 68, @F_301�, '������', 2
			END 

		IF @F_302� IS NOT NULL 
			BEGIN
				EXEC [stpQualDefectCardDetailsDUI] NULL, @DefectCardID, 0, 70, @F_302�, '������', 2
			END

		IF @F_303� IS NOT NULL 
			BEGIN
				EXEC [stpQualDefectCardDetailsDUI] NULL, @DefectCardID, 0, 72, @F_303�, '������', 2
			END

		IF @F_305� IS NOT NULL 
			BEGIN
				EXEC [stpQualDefectCardDetailsDUI] NULL, @DefectCardID, 0, 75, @F_305�, '������', 2
			END

		IF @F_306� IS NOT NULL 
			BEGIN
				EXEC [stpQualDefectCardDetailsDUI] NULL, @DefectCardID, 0, 77, @F_306�, '������', 2
			END

		IF @F_307� IS NOT NULL 
			BEGIN
				EXEC [stpQualDefectCardDetailsDUI] NULL, @DefectCardID, 0, 78, @F_307�, '������', 2
			END

		IF @F_311� IS NOT NULL 
			BEGIN
				EXEC [stpQualDefectCardDetailsDUI] NULL, @DefectCardID, 0, 86, @F_311�, '������', 2
			END

        FETCH NEXT FROM Cur INTO @PersonControllerID, @ControllDate, @PersonOperatorID, @CompleteSetID, @MagCompleteID, @QtyChecked,
							  @F_301�, @F_302�, @F_303�, @F_305�, @F_306�, @F_307�, @F_311�
    END

    CLOSE Cur
    DEALLOCATE Cur