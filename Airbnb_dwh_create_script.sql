USE [master]
GO
/****** Object:  Database [Airbnb_dwh]    Script Date: 05.06.2021 13:06:42 ******/
CREATE DATABASE [Airbnb_dwh]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Airbnb_dwh', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Airbnb_dwh.mdf' , SIZE = 204800KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Airbnb_dwh_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Airbnb_dwh_log.ldf' , SIZE = 1843200KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Airbnb_dwh] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Airbnb_dwh].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Airbnb_dwh] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Airbnb_dwh] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Airbnb_dwh] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Airbnb_dwh] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Airbnb_dwh] SET ARITHABORT OFF 
GO
ALTER DATABASE [Airbnb_dwh] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Airbnb_dwh] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Airbnb_dwh] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Airbnb_dwh] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Airbnb_dwh] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Airbnb_dwh] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Airbnb_dwh] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Airbnb_dwh] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Airbnb_dwh] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Airbnb_dwh] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Airbnb_dwh] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Airbnb_dwh] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Airbnb_dwh] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Airbnb_dwh] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Airbnb_dwh] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Airbnb_dwh] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Airbnb_dwh] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Airbnb_dwh] SET RECOVERY FULL 
GO
ALTER DATABASE [Airbnb_dwh] SET  MULTI_USER 
GO
ALTER DATABASE [Airbnb_dwh] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Airbnb_dwh] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Airbnb_dwh] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Airbnb_dwh] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Airbnb_dwh] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Airbnb_dwh', N'ON'
GO
ALTER DATABASE [Airbnb_dwh] SET QUERY_STORE = OFF
GO
USE [Airbnb_dwh]
GO
/****** Object:  UserDefinedFunction [dbo].[GetEasterHolidays]    Script Date: 05.06.2021 13:06:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GetEasterHolidays](@year INT) 
RETURNS TABLE
WITH SCHEMABINDING
AS 
RETURN 
(
  WITH x AS 
  (
    SELECT [Date] = CONVERT(DATE, RTRIM(@year) + '0' + RTRIM([Month]) 
        + RIGHT('0' + RTRIM([Day]),2))
      FROM (SELECT [Month], [Day] = DaysToSunday + 28 - (31 * ([Month] / 4))
      FROM (SELECT [Month] = 3 + (DaysToSunday + 40) / 44, DaysToSunday
      FROM (SELECT DaysToSunday = paschal - ((@year + @year / 4 + paschal - 13) % 7)
      FROM (SELECT paschal = epact - (epact / 28)
      FROM (SELECT epact = (24 + 19 * (@year % 19)) % 30) 
        AS epact) AS paschal) AS dts) AS m) AS d
  )
  SELECT [Date], HolidayName = 'Easter Sunday' FROM x
    UNION ALL SELECT DATEADD(DAY,-2,[Date]), 'Good Friday'   FROM x
    UNION ALL SELECT DATEADD(DAY, 1,[Date]), 'Easter Monday' FROM x
);
GO
/****** Object:  Table [dbo].[Amenity]    Script Date: 05.06.2021 13:06:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Amenity](
	[AmenityID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](500) NOT NULL,
 CONSTRAINT [PK__Amenity__842AF52B60CFBAFF] PRIMARY KEY CLUSTERED 
(
	[AmenityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DateDimension]    Script Date: 05.06.2021 13:06:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DateDimension](
	[DateID] [int] NOT NULL,
	[Date] [date] NOT NULL,
	[Day] [tinyint] NOT NULL,
	[DaySuffix] [char](2) NOT NULL,
	[Weekday] [tinyint] NOT NULL,
	[WeekDayName] [varchar](10) NOT NULL,
	[IsWeekend] [bit] NOT NULL,
	[IsHoliday] [bit] NOT NULL,
	[HolidayText] [varchar](64) SPARSE  NULL,
	[DOWInMonth] [tinyint] NOT NULL,
	[DayOfYear] [smallint] NOT NULL,
	[WeekOfMonth] [tinyint] NOT NULL,
	[WeekOfYear] [tinyint] NOT NULL,
	[ISOWeekOfYear] [tinyint] NOT NULL,
	[Month] [tinyint] NOT NULL,
	[MonthName] [varchar](10) NOT NULL,
	[Quarter] [tinyint] NOT NULL,
	[QuarterName] [varchar](6) NOT NULL,
	[Year] [int] NOT NULL,
	[MMYYYY] [char](6) NOT NULL,
	[MonthYear] [char](7) NOT NULL,
	[FirstDayOfMonth] [date] NOT NULL,
	[LastDayOfMonth] [date] NOT NULL,
	[FirstDayOfQuarter] [date] NOT NULL,
	[LastDayOfQuarter] [date] NOT NULL,
	[FirstDayOfYear] [date] NOT NULL,
	[LastDayOfYear] [date] NOT NULL,
	[FirstDayOfNextMonth] [date] NOT NULL,
	[FirstDayOfNextYear] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Host]    Script Date: 05.06.2021 13:06:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Host](
	[HostID] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[HostSinceDateID] [int] NOT NULL,
	[IsSuperHost] [nvarchar](7) NOT NULL,
	[HasProfilePicture] [nvarchar](7) NOT NULL,
	[HasIdentityVerified] [nvarchar](7) NOT NULL,
	[ResponseTime] [nvarchar](20) NOT NULL,
	[ResponseRate] [nvarchar](7) NOT NULL,
	[AcceptanceRate] [nvarchar](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[HostID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ListingAmenity]    Script Date: 05.06.2021 13:06:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ListingAmenity](
	[ListingID] [int] NOT NULL,
	[AmenityID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ListingID] ASC,
	[AmenityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ListingFact]    Script Date: 05.06.2021 13:06:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ListingFact](
	[ListingID] [int] NOT NULL,
	[UpdateDateID] [int] NOT NULL,
	[HostID] [int] NOT NULL,
	[LocationID] [int] NOT NULL,
	[Name] [nvarchar](500) NOT NULL,
	[Latitude] [float] NOT NULL,
	[Longitude] [float] NOT NULL,
	[PropertyType] [nvarchar](100) NOT NULL,
	[RoomType] [nvarchar](100) NOT NULL,
	[InstantBookable] [nvarchar](7) NOT NULL,
	[FirstReviewDateID] [int] NOT NULL,
	[LastReviewDateID] [int] NOT NULL,
	[Accommodates] [int] NOT NULL,
	[Bathrooms] [int] NOT NULL,
	[BathroomType] [nvarchar](50) NOT NULL,
	[Beds] [int] NOT NULL,
	[PricePerNight] [float] NOT NULL,
	[MinNights] [int] NOT NULL,
	[MaxNights] [int] NOT NULL,
	[Availability365] [int] NOT NULL,
	[NumberOfReviews] [int] NOT NULL,
	[NumberOfReviewsPerMonth] [float] NOT NULL,
	[ReviewScoresTotal] [int] NOT NULL,
	[ReviewScoresCleanliness] [int] NOT NULL,
	[ReviewScoresCheckIn] [int] NOT NULL,
	[ReviewScoresCommunication] [int] NOT NULL,
	[ReviewScoresLocation] [int] NOT NULL,
	[HostListingsCount] [int] NOT NULL,
	[RegionTouristArrivals] [int] NOT NULL,
	[RegionTouristEstablishments] [int] NOT NULL,
	[RegionAirTransportPassengers] [int] NOT NULL,
	[RegionPopulation] [int] NOT NULL,
 CONSTRAINT [PK__ListingF__BF3EBEF05A5E6B96] PRIMARY KEY CLUSTERED 
(
	[ListingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Location]    Script Date: 05.06.2021 13:06:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Location](
	[LocationID] [int] IDENTITY(1,1) NOT NULL,
	[Country] [nvarchar](50) NOT NULL,
	[Region] [nvarchar](100) NOT NULL,
	[City] [nvarchar](50) NOT NULL,
	[CountryCode] [nchar](3) NOT NULL,
	[RegionCode] [nchar](4) NOT NULL,
 CONSTRAINT [PK__Location__E7FEA47790D4FBE0] PRIMARY KEY CLUSTERED 
(
	[LocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Host]  WITH CHECK ADD  CONSTRAINT [FK_Host_DateDimension] FOREIGN KEY([HostSinceDateID])
REFERENCES [dbo].[DateDimension] ([DateID])
GO
ALTER TABLE [dbo].[Host] CHECK CONSTRAINT [FK_Host_DateDimension]
GO
ALTER TABLE [dbo].[ListingAmenity]  WITH CHECK ADD  CONSTRAINT [FK_ListingAmenity_Amenity1] FOREIGN KEY([AmenityID])
REFERENCES [dbo].[Amenity] ([AmenityID])
GO
ALTER TABLE [dbo].[ListingAmenity] CHECK CONSTRAINT [FK_ListingAmenity_Amenity1]
GO
ALTER TABLE [dbo].[ListingAmenity]  WITH CHECK ADD  CONSTRAINT [FK_ListingAmenity_ListingFact] FOREIGN KEY([ListingID])
REFERENCES [dbo].[ListingFact] ([ListingID])
GO
ALTER TABLE [dbo].[ListingAmenity] CHECK CONSTRAINT [FK_ListingAmenity_ListingFact]
GO
ALTER TABLE [dbo].[ListingFact]  WITH CHECK ADD  CONSTRAINT [FK_ListingFact_DateDimension] FOREIGN KEY([FirstReviewDateID])
REFERENCES [dbo].[DateDimension] ([DateID])
GO
ALTER TABLE [dbo].[ListingFact] CHECK CONSTRAINT [FK_ListingFact_DateDimension]
GO
ALTER TABLE [dbo].[ListingFact]  WITH CHECK ADD  CONSTRAINT [FK_ListingFact_DateDimension1] FOREIGN KEY([LastReviewDateID])
REFERENCES [dbo].[DateDimension] ([DateID])
GO
ALTER TABLE [dbo].[ListingFact] CHECK CONSTRAINT [FK_ListingFact_DateDimension1]
GO
ALTER TABLE [dbo].[ListingFact]  WITH CHECK ADD  CONSTRAINT [FK_ListingFact_DateDimension2] FOREIGN KEY([UpdateDateID])
REFERENCES [dbo].[DateDimension] ([DateID])
GO
ALTER TABLE [dbo].[ListingFact] CHECK CONSTRAINT [FK_ListingFact_DateDimension2]
GO
ALTER TABLE [dbo].[ListingFact]  WITH CHECK ADD  CONSTRAINT [FK_ListingFact_Host] FOREIGN KEY([HostID])
REFERENCES [dbo].[Host] ([HostID])
GO
ALTER TABLE [dbo].[ListingFact] CHECK CONSTRAINT [FK_ListingFact_Host]
GO
ALTER TABLE [dbo].[ListingFact]  WITH CHECK ADD  CONSTRAINT [FK_ListingFact_Location] FOREIGN KEY([LocationID])
REFERENCES [dbo].[Location] ([LocationID])
GO
ALTER TABLE [dbo].[ListingFact] CHECK CONSTRAINT [FK_ListingFact_Location]
GO
USE [master]
GO
ALTER DATABASE [Airbnb_dwh] SET  READ_WRITE 
GO
