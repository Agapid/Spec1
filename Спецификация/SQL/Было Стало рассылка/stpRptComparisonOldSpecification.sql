USE [Budget]
GO
/****** Object:  StoredProcedure [dbo].[stpRptComparisonOldSpecification]    Script Date: 12/26/2022 00:27:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- Используется для вывода в отчёте различий в забекапленной спецификации и текущей.
ALTER PROCEDURE [dbo].[stpRptComparisonOldSpecification]
    @CompleteSetID int -- ID комплекта, для которого нужно сравнить спецификации.

	--stpRptComparisonOldSpecification 8
AS
    SET NOCOUNT ON

    SELECT S.CompleteSetID,
            CS.CompleteSetName,
            S.ComponentID,
            C.ComponentName,
            (CASE WHEN C.SectionID IN (1, 2, 3, 4, 5, 6, 7, 10, 11, 22, 23, 25, 50, 55) 
                THEN CONVERT(varchar(255), S.ComponentID)
                ELSE C.ComponentName 
            END) AS ComponentPriority,
            S.Quantity,
            Sec.SectionName, Sec.Priority AS SectionPriority,
            SOld.Quantity AS QuantityOld,
            -- ComponentDifferences - признак различий элемента в текущей спецификации комплекта с забекапленной:
            --    0 - различий нет, 1 - различаются кол-вом, 
            --    2 - компонент отсутствует в забекапленной спецификации,
            --    3 - компонент отсутствует в текщей спецификации комплекта.
            (CASE WHEN SOld.ComponentID IS NULL THEN 2 WHEN S.Quantity=SOld.Quantity THEN 0 ELSE 1 END) AS ComponentDifferences
        FROM dbo.tblSpecifications AS S
            INNER JOIN dbo.tblComponents AS C ON C.ComponentID=S.ComponentID
            INNER JOIN dbo.tblCompleteSets AS CS ON CS.CompleteSetID=S.CompleteSetID
            INNER JOIN dbo.tblSections AS Sec ON Sec.SectionID=C.SectionID
            LEFT JOIN dbo.tblSpecificationsOld AS SOld ON SOld.CompleteSetID=S.CompleteSetID AND SOld.ComponentID=S.ComponentID
        WHERE S.CompleteSetID=@CompleteSetID
        
    UNION ALL
        
    SELECT SOld.CompleteSetID,
            CS.CompleteSetName,
            SOld.ComponentID,
            C.ComponentName,
            (CASE WHEN C.SectionID IN (1, 2, 3, 4, 5, 6, 7, 10, 11, 22, 23, 25, 50, 55) 
                THEN CONVERT(varchar(255), SOld.ComponentID)
                ELSE C.ComponentName 
            END) AS ComponentPriority,
            NULL AS Quantity,
            Sec.SectionName, Sec.Priority AS SectionPriority,
            SOld.Quantity AS QuantityOld,
            3 AS ComponentDifferences
        FROM dbo.tblSpecificationsOld AS SOld
            INNER JOIN dbo.tblComponents AS C ON C.ComponentID=SOld.ComponentID
            INNER JOIN dbo.tblCompleteSets AS CS ON CS.CompleteSetID=SOld.CompleteSetID
            INNER JOIN dbo.tblSections AS Sec ON Sec.SectionID=C.SectionID
        WHERE SOld.CompleteSetID=@CompleteSetID AND NOT EXISTS(SELECT * FROM dbo.tblSpecifications AS S WHERE S.CompleteSetID=SOld.CompleteSetID AND S.ComponentID=SOld.ComponentID)