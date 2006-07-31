if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[blogcategories]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)

drop table [dbo].[blogcategories]

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[categories]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)

drop table [dbo].[categories]

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[cms]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)

drop table [dbo].[cms]

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[comments]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)

drop table [dbo].[comments]

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[library]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)

drop table [dbo].[library]

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[links]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)

drop table [dbo].[links]

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[logs]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)

drop table [dbo].[logs]

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[photoblog]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)

drop table [dbo].[photoblog]

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[photobloggallery]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)

drop table [dbo].[photobloggallery]

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[posts]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)

drop table [dbo].[posts]

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[subscriptions]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)

drop table [dbo].[subscriptions]

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trackbacks]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)

drop table [dbo].[trackbacks]

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[users]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)

drop table [dbo].[users]

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[spamlist]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)

drop table [dbo].[spamlist]

GO



CREATE TABLE [dbo].[blogcategories] (

	[blogid] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[category] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 

) ON [PRIMARY]

GO



CREATE TABLE [dbo].[categories] (

	[name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 

) ON [PRIMARY]

GO



CREATE TABLE [dbo].[cms] (

	[id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[ordername] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[category] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[ordercategory] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[sdate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[stime] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO



CREATE TABLE [dbo].[comments] (

	[id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[blogid] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[sdate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[stime] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[author] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[email] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[emailvisible] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[private] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[published] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO



CREATE TABLE [dbo].[library] (

	[id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[category] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[file] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[sdate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO



CREATE TABLE [dbo].[links] (

	[id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[address] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[ordercolumn] [int] NULL 

) ON [PRIMARY]

GO



CREATE TABLE [dbo].[logs] (

	[id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[sdate] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[stime] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[type] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[svalue] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL 

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO



CREATE TABLE [dbo].[photoblog] (

	[id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[id_gallery] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[file] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[sdate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO



CREATE TABLE [dbo].[photobloggallery] (

	[id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[category] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[sdate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO



CREATE TABLE [dbo].[posts] (

	[id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[sdate] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[stime] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[author] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[email] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[menuitem] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[title] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[excerpt] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[published] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO



CREATE TABLE [dbo].[subscriptions] (

	[blogid] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[userid] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[email] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 

) ON [PRIMARY]

GO



CREATE TABLE [dbo].[trackbacks] (

	[id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[blogid] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[sdate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[stime] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[url] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[blog_name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[excerpt] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[title] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[published] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO



CREATE TABLE [dbo].[users] (

	[id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[fullname] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[email] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[us] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[pwd] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[role] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 

) ON [PRIMARY]

GO

CREATE TABLE [dbo].[spamlist] (

	[item] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

CREATE TABLE [dbo].[enclosures] (

	[id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[blogid] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[length] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

) ON [PRIMARY]

GO
