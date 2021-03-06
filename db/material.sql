USE [master]
GO
/****** Object:  Database [MATERIAL_MGM]    Script Date: 6/3/2022 4:48:07 PM ******/
CREATE DATABASE [MATERIAL_MGM]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MATERIAL_MGM', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\MATERIAL_MGM.mdf' , SIZE = 270336KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'MATERIAL_MGM_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\MATERIAL_MGM_log.ldf' , SIZE = 401408KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [MATERIAL_MGM] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MATERIAL_MGM].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MATERIAL_MGM] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MATERIAL_MGM] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MATERIAL_MGM] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MATERIAL_MGM] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MATERIAL_MGM] SET ARITHABORT OFF 
GO
ALTER DATABASE [MATERIAL_MGM] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MATERIAL_MGM] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MATERIAL_MGM] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MATERIAL_MGM] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MATERIAL_MGM] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MATERIAL_MGM] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MATERIAL_MGM] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MATERIAL_MGM] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MATERIAL_MGM] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MATERIAL_MGM] SET  ENABLE_BROKER 
GO
ALTER DATABASE [MATERIAL_MGM] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MATERIAL_MGM] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MATERIAL_MGM] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MATERIAL_MGM] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MATERIAL_MGM] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MATERIAL_MGM] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MATERIAL_MGM] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MATERIAL_MGM] SET RECOVERY FULL 
GO
ALTER DATABASE [MATERIAL_MGM] SET  MULTI_USER 
GO
ALTER DATABASE [MATERIAL_MGM] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MATERIAL_MGM] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MATERIAL_MGM] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MATERIAL_MGM] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [MATERIAL_MGM] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [MATERIAL_MGM] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'MATERIAL_MGM', N'ON'
GO
ALTER DATABASE [MATERIAL_MGM] SET QUERY_STORE = OFF
GO
USE [MATERIAL_MGM]
GO
/****** Object:  User [admin]    Script Date: 6/3/2022 4:48:08 PM ******/
CREATE USER [admin] FOR LOGIN [admin] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Table [dbo].[Import_History]    Script Date: 6/3/2022 4:48:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Import_History](
	[Seq] [int] IDENTITY(1,1) NOT NULL,
	[QCode] [nchar](10) NULL,
	[Pur_Date] [nchar](30) NULL,
	[Quantity] [float] NULL,
	[Price] [float] NULL,
	[Supplier] [nchar](100) NULL,
	[Buyer] [nchar](40) NULL,
	[Receiver] [nchar](40) NULL,
	[Po] [nchar](30) NULL,
	[Allocated] [nchar](1) NULL,
	[Remark] [nchar](50) NULL,
	[ImportNo] [nchar](10) NULL,
	[userid] [nchar](6) NULL,
	[locator] [nchar](22) NULL,
	[INSPECTION] [nchar](1) NULL,
	[INSPECTION_DATE] [nchar](30) NULL,
	[INSPECTOR] [nvarchar](50) NULL,
	[RESULT] [nvarchar](100) NULL,
 CONSTRAINT [PK_Import_History] PRIMARY KEY CLUSTERED 
(
	[Seq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MATERIAL]    Script Date: 6/3/2022 4:48:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MATERIAL](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[QCODE] [nchar](10) NULL,
	[ZONE] [nvarchar](50) NULL,
	[LOCATION] [nvarchar](50) NULL,
	[ITEM] [nchar](200) NULL,
	[SPEC] [nchar](300) NULL,
	[UNIT] [nchar](10) NULL,
	[QTY] [nchar](10) NULL,
	[PRICE] [float] NULL,
	[REMARK] [nchar](300) NULL,
	[Pur_Date] [nchar](30) NULL,
 CONSTRAINT [PK_MATERIAL] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[DAILY_BARCD]    Script Date: 6/3/2022 4:48:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[DAILY_BARCD] AS 
select B.QCODE,A.PUR_DATE,RTRIM(b.QCODE)+a.Pur_Date as 'BAR_CD',b.ZONE,b.LOCATION,b.ITEM,b.SPEC,b.UNIT
from dbo.Import_History a, dbo.MATERIAL b
where a.QCode=b.QCODE
and a.Pur_Date >= (select CONVERT(VARCHAR(8), DATEADD(DAY,-1,SYSDATETIME()), 112) )

GO
/****** Object:  Table [dbo].[Out_history]    Script Date: 6/3/2022 4:48:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Out_history](
	[Seq] [int] IDENTITY(1,1) NOT NULL,
	[QCode] [nchar](10) NULL,
	[Pur_Date] [nchar](30) NULL,
	[Out_date] [nchar](30) NULL,
	[inventory] [float] NULL,
	[Quantity] [float] NULL,
	[Line] [nchar](20) NULL,
	[CodeCenter] [nchar](35) NULL,
	[CostAccount] [nchar](15) NULL,
	[Requestor] [nchar](40) NULL,
	[Remark] [nchar](100) NULL,
	[IssueNo] [nchar](10) NULL,
	[userid] [nchar](10) NULL,
	[Note] [nchar](30) NULL,
	[Imp_Price] [float] NULL,
	[Locator] [nchar](22) NULL,
 CONSTRAINT [PK_Out_history] PRIMARY KEY CLUSTERED 
(
	[Seq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[V_Out_History]    Script Date: 6/3/2022 4:48:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[V_Out_History]
AS
SELECT     Seq, QCode,Locator, Pur_Date, LEFT(Out_date, 4) + SUBSTRING(Out_date, 6, 2) + SUBSTRING(Out_date, 9, 2) AS Out_date, inventory, Quantity, Line, CodeCenter, CostAccount, 
                      Requestor, Remark,Note, Imp_Price
FROM         dbo.Out_history

GO
/****** Object:  Table [dbo].[ImpData]    Script Date: 6/3/2022 4:48:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ImpData](
	[Item] [nvarchar](255) NULL,
	[QtyERP] [float] NULL,
	[QtyWeb] [float] NULL,
	[Dif] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Import_History_20220110]    Script Date: 6/3/2022 4:48:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Import_History_20220110](
	[Seq] [int] IDENTITY(1,1) NOT NULL,
	[QCode] [nchar](10) NULL,
	[Pur_Date] [nchar](30) NULL,
	[Quantity] [float] NULL,
	[Price] [float] NULL,
	[Supplier] [nchar](100) NULL,
	[Buyer] [nchar](40) NULL,
	[Receiver] [nchar](40) NULL,
	[Po] [nchar](30) NULL,
	[Allocated] [nchar](1) NULL,
	[Remark] [nchar](50) NULL,
	[ImportNo] [nchar](10) NULL,
	[userid] [nchar](6) NULL,
	[locator] [nchar](22) NULL,
	[INSPECTION] [nchar](1) NULL,
	[INSPECTION_DATE] [nchar](30) NULL,
	[INSPECTOR] [nvarchar](50) NULL,
	[RESULT] [nvarchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Issue]    Script Date: 6/3/2022 4:48:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Issue](
	[ID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[ISS_DATE] [nchar](8) NOT NULL,
	[RECEIVER] [nvarchar](50) NOT NULL,
	[REV_DEPT] [nvarchar](50) NOT NULL,
	[TOT_ORD_QTY] [numeric](10, 2) NOT NULL,
	[TOT_ACT_QTY] [numeric](10, 2) NOT NULL,
	[REASON] [nvarchar](100) NOT NULL,
	[STATUS] [char](1) NOT NULL,
	[CREATE_ID] [char](10) NOT NULL,
	[CREATE_DATE] [char](14) NOT NULL,
	[MOD_ID] [char](10) NULL,
	[MOD_DATE] [char](14) NULL,
 CONSTRAINT [PK_Issue] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Issue_detail]    Script Date: 6/3/2022 4:48:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Issue_detail](
	[ID] [numeric](18, 0) NOT NULL,
	[SEQ_OUT] [int] NOT NULL,
	[QCODE] [char](10) NOT NULL,
	[DESC_NAME] [nvarchar](100) NOT NULL,
	[DESC_DETAIL] [nvarchar](200) NOT NULL,
	[UNIT] [nvarchar](10) NOT NULL,
	[REQUEST] [numeric](10, 2) NOT NULL,
	[ACTUAL] [numeric](10, 2) NOT NULL,
	[NOTE] [nvarchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Material_20220110]    Script Date: 6/3/2022 4:48:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Material_20220110](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[QCODE] [nchar](10) NULL,
	[ZONE] [nvarchar](50) NULL,
	[LOCATION] [nvarchar](50) NULL,
	[ITEM] [nchar](200) NULL,
	[SPEC] [nchar](300) NULL,
	[UNIT] [nchar](10) NULL,
	[QTY] [nchar](10) NULL,
	[PRICE] [float] NULL,
	[REMARK] [nchar](300) NULL,
	[Pur_Date] [nchar](30) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Out_history_20220110]    Script Date: 6/3/2022 4:48:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Out_history_20220110](
	[Seq] [int] IDENTITY(1,1) NOT NULL,
	[QCode] [nchar](10) NULL,
	[Pur_Date] [nchar](30) NULL,
	[Out_date] [nchar](30) NULL,
	[inventory] [float] NULL,
	[Quantity] [float] NULL,
	[Line] [nchar](20) NULL,
	[CodeCenter] [nchar](35) NULL,
	[CostAccount] [nchar](15) NULL,
	[Requestor] [nchar](40) NULL,
	[Remark] [nchar](100) NULL,
	[IssueNo] [nchar](10) NULL,
	[userid] [nchar](10) NULL,
	[Note] [nchar](30) NULL,
	[Imp_Price] [float] NULL,
	[Locator] [nchar](22) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Receipt]    Script Date: 6/3/2022 4:48:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Receipt](
	[ID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[RCPT_DATE] [nchar](8) NOT NULL,
	[PO_NUMBER] [char](50) NOT NULL,
	[DELIVERY_NAME] [nvarchar](50) NULL,
	[DELIVERY_COMPANY] [nvarchar](100) NOT NULL,
	[TOT_ORD_QTY] [int] NOT NULL,
	[TOT_ACT_QTY] [int] NOT NULL,
	[AMOUNT] [numeric](18, 0) NOT NULL,
	[LOCATION] [nvarchar](100) NULL,
	[REASON] [nvarchar](100) NULL,
	[NOTE] [nvarchar](100) NULL,
	[STATUS] [char](1) NOT NULL,
	[CREAT_ID] [char](10) NOT NULL,
	[CREAT_DATE] [char](14) NOT NULL,
	[MOD_DATE] [char](14) NULL,
	[MOD_ID] [char](10) NULL,
 CONSTRAINT [PK_Receipt] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Receipt_Detail]    Script Date: 6/3/2022 4:48:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Receipt_Detail](
	[ID] [numeric](18, 0) NOT NULL,
	[seq_imp] [int] NOT NULL,
	[QCODE] [char](10) NOT NULL,
	[DESC_NAME] [nvarchar](100) NOT NULL,
	[DESC_DETAIL] [nvarchar](200) NOT NULL,
	[UNIT] [nvarchar](10) NOT NULL,
	[ORD_QTY] [int] NOT NULL,
	[ACT_QTY] [int] NOT NULL,
	[CURRENCY] [char](4) NOT NULL,
	[PRICE] [numeric](18, 2) NOT NULL,
	[TOT_PRICE] [numeric](18, 2) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TB_cost]    Script Date: 6/3/2022 4:48:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_cost](
	[times] [nchar](10) NULL,
	[total] [nchar](12) NULL,
	[packing] [nchar](12) NULL,
	[mainternain] [nchar](12) NULL,
	[product] [nchar](12) NULL,
	[others] [nchar](12) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TB_History]    Script Date: 6/3/2022 4:48:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_History](
	[UserName] [nchar](20) NULL,
	[IP] [nchar](15) NULL,
	[Operation] [nchar](30) NULL,
	[Contention] [nchar](100) NULL,
	[ModifyDate] [nchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TB_Line]    Script Date: 6/3/2022 4:48:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_Line](
	[Seq] [int] IDENTITY(1,1) NOT NULL,
	[LineName] [nchar](18) NULL,
	[CostCenter] [nchar](35) NULL,
 CONSTRAINT [PK_TB_Line] PRIMARY KEY CLUSTERED 
(
	[Seq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tb_logimport]    Script Date: 6/3/2022 4:48:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tb_logimport](
	[updatetime] [nchar](12) NULL,
	[strlog] [nchar](20) NULL,
	[ipclient] [nchar](16) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TB_USER]    Script Date: 6/3/2022 4:48:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_USER](
	[USERNAME] [nchar](20) NOT NULL,
	[PASSWORD] [nchar](50) NULL,
	[ROLE] [int] NULL,
 CONSTRAINT [PK_TB_USER] PRIMARY KEY CLUSTERED 
(
	[USERNAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblog]    Script Date: 6/3/2022 4:48:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblog](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Qcode] [nchar](10) NULL,
	[Info] [nchar](200) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[USER_INFO]    Script Date: 6/3/2022 4:48:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USER_INFO](
	[ID] [char](15) NULL,
	[PASSWORD] [char](20) NULL,
	[USERNAME] [nchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[USER_INFO1]    Script Date: 6/3/2022 4:48:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USER_INFO1](
	[ID] [char](15) NULL,
	[PASSWORD] [char](50) NULL,
	[USERNAME] [nchar](20) NULL
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Out_history"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 11
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_Out_History'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_Out_History'
GO
USE [master]
GO
ALTER DATABASE [MATERIAL_MGM] SET  READ_WRITE 
GO
