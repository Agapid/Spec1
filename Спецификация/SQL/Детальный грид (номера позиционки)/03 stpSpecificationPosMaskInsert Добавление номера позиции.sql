USE Budget
GO

--�������  ������ Begin
	if (not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].stpSpecificationPosMaskInsert')

				 and objECTPROPERTY(id, N'IsProcedure') = 1))
		   -- ������� ��������
		   exec ('create procedure stpSpecificationPosMaskInsert as select 1')        

GO 


ALTER PROC [dbo].stpSpecificationPosMaskInsert  
												@SpecID INT,					--������ �� ������������ ������� � ������������
												@PosMask varchar(10) = null		--����������� ����������� (����� �������)
										
										
									

	AS

	/*
		�����: popovml
		�������: ������������ ����������
		��������: ���������� ������������ ����������� (������ ������� ��� ��������)
					
		
		
		����������:
				(0) - ��� ������ ������
				
		SELECT * FROM tblSpecPosMask
		sp_help tblSpecPosMask				

	*/

	BEGIN
		SET NOCOUNT ON 
		
		DECLARE @SPID INT			--������ ������������ ���������� �������
		DECLARE @CompleteSetID INT	--��������
		
		DECLARE @i int, @Priority int, @flgPr bit

		
		
		SELECT	@CompleteSetID = CompleteSetID,
				@SPID = SPID
		FROM tblSpecifications WHERE SpecID = @SpecID			
		
		
		--��������
		
		
		
		--��� ������� ��������� ��� ���� ����� ����������� �����������! �������� ��������! ������ ���� �������� ���������!" (������ ��������)
		IF EXISTS (SELECT * FROM tblComplete as A
			INNER JOIN tblSpecifications as B ON B.CompleteSetID = A.CompleteSetID and B.SpecID = @SpecID and B.RepDescript = A.RepDescript
			INNER JOIN tblComponents as C ON C.ComponentID = B.ComponentID and C.ElementID = A.ElementID)
			
			BEGIN
				RETURN 1
			END


		--�������������� ������������ ��������� �� �������� "� ������������" ���������!
		IF NOT EXISTS(SELECT * FROM dbo.tblCompleteSetsStatus AS CSS INNER JOIN dbo.tblSpecifications AS S ON CSS.CompleteSetID=S.CompleteSetID WHERE S.SpecID=@SpecID)
			BEGIN
				RETURN 2
			END

		--����� ��� ������ ��� ������������ ����������� � ������ ������������
		--����������: ������ � ���� ����� ����� ����� ������������, � ������� ���� ����������� ����������� � ���������, ���������� � ���� ����� ������������,
		--�� ��� ���� ����������� ��������� ������ ����������� �����������. ��� ���� � ������������ ��� � ���� SPID = ����� NULL
		IF EXISTS (SELECT * FROM tblSpecifications WHERE SpecID = @SpecID and SPID is null) 
			BEGIN
				RETURN 3
			END

		--����������� ����������� ������ ���������� � �����
		IF ASCII(substring(@PosMask, 1, 1)) not between 48 and 57 
			BEGIN
				RETURN 4
			END

		--�������� �� ������� �������� 
		SET @i = 1
		WHILE 1 < 2
		BEGIN
		  IF ascii(substring(@PosMask, @i, 1)) >= 192
		  BEGIN
			RETURN 5
		  END
		  --������� ���������� ��������� �� ����� � ����������� �����������
		  IF isnull(@flgPr, 0) = 0
		  BEGIN
			IF ascii(substring(@PosMask, @i, 1)) not between 48 and 57 or @i = len(@PosMask)
			BEGIN
			  SET @flgPr = 1
			  SET @Priority = case when ascii(substring(@PosMask, @i, 1)) between 48 and 57 then substring(@PosMask, 1, @i) else isnull(@Priority, substring(@PosMask, 1, @i)) end
			END
			ELSE
			  SET @Priority = substring(@PosMask, 1, @i)
		  END
		  IF @i = len(@PosMask) BREAK
		  SET @i = @i + 1
		END

		
		
		--�������� �� ������� ������ ����������� (������ ��������)
		IF EXISTS (SELECT * 
				 FROM tblSpecifications as A
				 INNER JOIN tblSpecPosMask as B ON B.SpecID = A.SpecID --and B.PosMask = @PosMaskDetail
				 INNER JOIN tblSectionPosMask as C ON C.SPID = A.SPID-- and C.SPID = @SPID
				 WHERE CompleteSetID = @CompleteSetID and (C.PMSign + B.PosMask) = ((SELECT PMSign FROM tblSectionPosMask WHERE SPID = @SPID) + @PosMask))
			BEGIN
				RETURN 6
			
			END
		
		
		
		/*������������ � ������������ ��� ���????*/
		
		INSERT INTO tblSpecPosMask (SpecID, PosMask, Priority) VALUES (@SpecID, @PosMask, @Priority)
		

	
	
		
		             
		/*����������� ���������� ������� � ������� ������ ������������ �����������*/
    
		DECLARE @PosMaskForSpec VARCHAR(6000)
		DECLARE @Quantity NUMERIC(18,4)
		
		SELECT	@PosMaskForSpec = PosMask,
				@Quantity = Quantity
		FROM dbo.fncGetPosMaskQtyAndRow(@SpecID)
		
		UPDATE tblSpecifications SET PosMask = @PosMaskForSpec, Quantity = @Quantity WHERE SpecID = @SpecID
        


		
	END




GO
GRANT EXECUTE ON stpSpecificationPosMaskInsert TO rolFormSpecificationEdit, rolFormSpecificationEditAdd, rolFormSpecificationFull, rolSpecification01
GO






