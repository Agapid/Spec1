USE [Budget]
GO

/****** Object:  Table [dbo].[tblSpecificationsOld]    Script Date: 12/26/2022 00:25:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblSpecificationsOld](
	[SpecificationOldID] [int] IDENTITY(1,1) NOT NULL,
	[CompleteSetID] [int] NOT NULL,
	[ComponentID] [char](25) NOT NULL,
	[Quantity] [numeric](18, 4) NULL,
	[Creator] [varchar](50) NULL,
	[DateRec] [datetime] NULL,
 CONSTRAINT [PK_tblOldSpecifications] PRIMARY KEY CLUSTERED 
(
	[SpecificationOldID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID записи' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblSpecificationsOld', @level2type=N'COLUMN',@level2name=N'SpecificationOldID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID комплекта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblSpecificationsOld', @level2type=N'COLUMN',@level2name=N'CompleteSetID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Код компонента' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblSpecificationsOld', @level2type=N'COLUMN',@level2name=N'ComponentID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Количество элементов' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblSpecificationsOld', @level2type=N'COLUMN',@level2name=N'Quantity'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Создатель' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblSpecificationsOld', @level2type=N'COLUMN',@level2name=N'Creator'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblSpecificationsOld', @level2type=N'COLUMN',@level2name=N'DateRec'
GO

ALTER TABLE [dbo].[tblSpecificationsOld] ADD  CONSTRAINT [DF_tblOldSpecifications_Creator]  DEFAULT (suser_sname()) FOR [Creator]
GO

ALTER TABLE [dbo].[tblSpecificationsOld] ADD  CONSTRAINT [DF_tblOldSpecifications_DateRec]  DEFAULT (getdate()) FOR [DateRec]
GO


--select * from tblSpecificationsOld