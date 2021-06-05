USE [master]
GO
/****** Object:  Database [Airbnb_db]    Script Date: 05.06.2021 13:15:35 ******/
CREATE DATABASE [Airbnb_db]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Airbnb_db', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Airbnb_db.mdf' , SIZE = 335872KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Airbnb_db_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Airbnb_db_log.ldf' , SIZE = 663552KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Airbnb_db] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Airbnb_db].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Airbnb_db] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Airbnb_db] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Airbnb_db] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Airbnb_db] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Airbnb_db] SET ARITHABORT OFF 
GO
ALTER DATABASE [Airbnb_db] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Airbnb_db] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Airbnb_db] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Airbnb_db] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Airbnb_db] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Airbnb_db] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Airbnb_db] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Airbnb_db] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Airbnb_db] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Airbnb_db] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Airbnb_db] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Airbnb_db] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Airbnb_db] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Airbnb_db] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Airbnb_db] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Airbnb_db] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Airbnb_db] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Airbnb_db] SET RECOVERY FULL 
GO
ALTER DATABASE [Airbnb_db] SET  MULTI_USER 
GO
ALTER DATABASE [Airbnb_db] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Airbnb_db] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Airbnb_db] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Airbnb_db] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Airbnb_db] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Airbnb_db', N'ON'
GO
ALTER DATABASE [Airbnb_db] SET QUERY_STORE = OFF
GO
USE [Airbnb_db]
GO
/****** Object:  Table [dbo].[airbnb_data]    Script Date: 05.06.2021 13:15:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[airbnb_data](
	[id] [int] NOT NULL,
	[scrape_id] [float] NOT NULL,
	[last_scraped] [datetime2](7) NOT NULL,
	[name] [nvarchar](500) NOT NULL,
	[host_id] [int] NOT NULL,
	[host_name] [nvarchar](50) NOT NULL,
	[host_since] [datetime2](7) NOT NULL,
	[host_response_time] [nvarchar](50) NULL,
	[host_response_rate] [nvarchar](10) NULL,
	[host_acceptance_rate] [nvarchar](10) NULL,
	[host_is_superhost] [nvarchar](2) NOT NULL,
	[host_listings_count] [int] NOT NULL,
	[host_has_profile_pic] [nvarchar](2) NOT NULL,
	[host_identity_verified] [nvarchar](2) NOT NULL,
	[latitude] [nvarchar](50) NOT NULL,
	[longitude] [nvarchar](50) NOT NULL,
	[property_type] [nvarchar](50) NOT NULL,
	[room_type] [nvarchar](50) NOT NULL,
	[accommodates] [int] NOT NULL,
	[bathrooms_type] [nvarchar](10) NOT NULL,
	[bedrooms] [int] NOT NULL,
	[beds] [int] NOT NULL,
	[amenities] [nvarchar](2500) NOT NULL,
	[price] [nvarchar](10) NOT NULL,
	[minimum_nights] [int] NOT NULL,
	[maximum_nights] [int] NOT NULL,
	[availability_365] [int] NOT NULL,
	[number_of_reviews] [int] NOT NULL,
	[first_review] [datetime2](7) NOT NULL,
	[last_review] [datetime2](7) NOT NULL,
	[review_scores_rating] [int] NOT NULL,
	[review_scores_accuracy] [int] NOT NULL,
	[review_scores_cleanliness] [int] NOT NULL,
	[review_scores_checkin] [int] NOT NULL,
	[review_scores_communication] [int] NOT NULL,
	[review_scores_location] [int] NOT NULL,
	[review_scores_value] [int] NOT NULL,
	[instant_bookable] [nvarchar](2) NOT NULL,
	[reviews_per_month] [nvarchar](5) NOT NULL,
	[city] [nvarchar](50) NOT NULL,
	[region] [nvarchar](50) NOT NULL,
	[country] [nvarchar](50) NOT NULL,
	[bathrooms] [nvarchar](5) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[airbnb_test3]    Script Date: 05.06.2021 13:15:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[airbnb_test3](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[amenities] [char](500) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Listings]    Script Date: 05.06.2021 13:15:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Listings](
	[id] [int] NULL,
	[scrape_id] [float] NULL,
	[last_scraped] [date] NULL,
	[name] [nvarchar](500) NULL,
	[host_id] [int] NULL,
	[host_name] [nvarchar](50) NULL,
	[host_since] [date] NULL,
	[host_response_time] [nvarchar](20) NULL,
	[host_response_rate] [nvarchar](5) NULL,
	[host_acceptance_rate] [nvarchar](5) NULL,
	[host_is_superhost] [nvarchar](2) NULL,
	[host_listings_count] [int] NULL,
	[host_has_profile_pic] [nvarchar](2) NULL,
	[host_identity_verified] [nvarchar](2) NULL,
	[latitude] [nvarchar](50) NULL,
	[longitude] [nvarchar](50) NULL,
	[property_type] [nvarchar](50) NULL,
	[room_type] [nvarchar](50) NULL,
	[accommodates] [int] NULL,
	[bathrooms_type] [nvarchar](10) NULL,
	[bedrooms] [int] NULL,
	[beds] [int] NULL,
	[amenities] [nvarchar](2500) NULL,
	[price] [nvarchar](10) NULL,
	[minimum_nights] [int] NULL,
	[maximum_nights] [int] NULL,
	[availability_365] [int] NULL,
	[number_of_reviews] [int] NULL,
	[first_review] [date] NULL,
	[last_review] [date] NULL,
	[review_scores_rating] [int] NULL,
	[review_scores_accuracy] [int] NULL,
	[review_scores_cleanliness] [int] NULL,
	[review_scores_checkin] [int] NULL,
	[review_scores_communication] [int] NULL,
	[review_scores_location] [int] NULL,
	[review_scores_value] [int] NULL,
	[instant_bookable] [nvarchar](2) NULL,
	[reviews_per_month] [nvarchar](5) NULL,
	[city] [nvarchar](50) NULL,
	[region] [nvarchar](50) NULL,
	[country] [nvarchar](50) NULL,
	[bathrooms] [nvarchar](5) NULL
) ON [PRIMARY]
GO
USE [master]
GO
ALTER DATABASE [Airbnb_db] SET  READ_WRITE 
GO
