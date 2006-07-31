/*
Created		28/11/2005
Modified		28/11/2005
Project		
Model		
Company		
Author		
Version		
Database		Oracle 9i 
*/



-- Create Types section





-- Create Tables section


Create table "blogcategories" (
	"blogid" Char (50) NOT NULL ,
	"category" Char (50) NOT NULL ,
primary key ("blogid","category") 
) 
/

Create table "categories" (
	"name" Char (50) NOT NULL ,
primary key ("name") 
) 
/

Create table "cms" (
	"id" Char (50) NOT NULL ,
	"name" Char (50),
	"ordername" Char (4),
	"category" Char (50),
	"ordercategory" Char (4),
	"description" Long,
	"sdate" Char (50),
	"stime" Char (50),
primary key ("id") 
) 
/

Create table "comments" (
	"id" Char (50) NOT NULL ,
	"blogid" Char (50),
	"sdate" Char (50),
	"stime" Char (50),
	"author" Char (50),
	"email" Char (50),
	"description" Long,
	"emailvisible" Char (5),
	"private" Char (5),
	"published" Char (5),
primary key ("id") 
) 
/

Create table "library" (
	"id" Char (50) NOT NULL ,
	"name" Char (50),
	"category" Char (50),
	"description" Long,
	"file" Char (50),
	"sdate" Char (50),
primary key ("id") 
) 
/

Create table "links" (
	"id" Char (50) NOT NULL ,
	"name" Char (50),
	"address" Char (50),
	"ordercolumn" Integer Default 0,
primary key ("id") 
) 
/

Create table "logs" (
	"id" Char (50),
	"sdate" Char (8),
	"stime" Char (8),
	"type" Char (200),
	"svalue" Long
) 
/

Create table "photoblog" (
	"id" Char (50) NOT NULL ,
	"id_gallery" Char (50),
	"name" Char (50),
	"file" Char (50),
	"description" Long,
	"sdate" Char (50),
primary key ("id") 
) 
/

Create table "photobloggallery" (
	"id" Char (50) NOT NULL ,
	"name" Char (50),
	"category" Char (50),
	"description" Long,
	"sdate" Char (50),
primary key ("id") 
) 
/

Create table "posts" (
	"id" Char (50) NOT NULL ,
	"sdate" Char (8),
	"stime" Char (8),
	"author" Char (100),
	"email" Char (100),
	"menuitem" Char (100),
	"title" Char (200),
	"excerpt" Long,
	"description" Long,
	"published" Char (5),
primary key ("id") 
) 
/

Create table "subscriptions" (
	"blogid" Char (50) NOT NULL ,
	"userid" Char (50) NOT NULL ,
	"email" Char (50) NOT NULL ,
primary key ("blogid","userid","email") 
) 
/

Create table "trackbacks" (
	"id" Char (50) NOT NULL ,
	"blogid" Char (50),
	"sdate" Char (50),
	"stime" Char (50),
	"url" Char (255),
	"blog_name" Char (200),
	"excerpt" Long,
	"title" Char (200),
	"published" Char (5),
primary key ("id") 
) 
/

Create table "users" (
	"id" Char (50) NOT NULL ,
	"fullname" Char (50),
	"email" Char (50),
	"us" Char (50),
	"pwd" Char (50),
	"role" Char (50),
primary key ("id") 
) 
/

Create table "spamlist" (
	"item" Char (200)
) 
/

Create table "enclosures" (
	"id" Char (50) NOT NULL ,
	"blogid" Char (50),
	"name" Char (200),
	"length" Char (50),
	"type" Char (50),
primary key ("id") 
) 
/

-- Create Object Tables section



-- Create XMLType Tables section



-- Create Functions section



-- Create Sequences section




-- Create Packages section





-- Create Synonyms section



-- Create Table comments section


-- Create Attribute comments section



