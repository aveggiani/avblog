/*
Created		28/11/2005
Modified		28/11/2005
Project		
Model			
Company		
Author		
Version		
Database		PostgreSQL 8 
*/


/* Create Tables */


Create table "blogcategories"
(
	"blogid" Char(50) NOT NULL,
	"category" Char(50) NOT NULL,
 primary key ("blogid","category")
) With Oids;

Create table "categories"
(
	"name" Char(50) NOT NULL,
 primary key ("name")
) With Oids;

Create table "cms"
(
	"id" Char(50) NOT NULL,
	"name" Char(50),
	"ordername" Char(4),
	"category" Char(50),
	"ordercategory" Char(4),
	"description" Text,
	"sdate" Char(50),
	"stime" Char(50),
 primary key ("id")
) With Oids;

Create table "comments"
(
	"id" Char(50) NOT NULL,
	"blogid" Char(50),
	"sdate" Char(50),
	"stime" Char(50),
	"author" Char(50),
	"email" Char(50),
	"description" Text,
	"emailvisible" Char(5),
	"private" Char(5),
	"published" Char(5),
 primary key ("id")
) With Oids;

Create table "library"
(
	"id" Char(50) NOT NULL,
	"name" Char(50),
	"category" Char(50),
	"description" Text,
	"file" Char(50),
	"sdate" Char(50),
 primary key ("id")
) With Oids;

Create table "links"
(
	"id" Char(50) NOT NULL,
	"name" Char(50),
	"address" Char(50),
	"ordercolumn" Integer Default 0,
 primary key ("id")
) With Oids;

Create table "logs"
(
	"id" Char(50),
	"sdate" Char(8),
	"stime" Char(8),
	"type" Char(200),
	"svalue" Text
) With Oids;

Create table "photoblog"
(
	"id" Char(50) NOT NULL,
	"id_gallery" Char(50),
	"name" Char(50),
	"file" Char(50),
	"description" Text,
	"sdate" Char(50),
 primary key ("id")
) With Oids;

Create table "photobloggallery"
(
	"id" Char(50) NOT NULL,
	"name" Char(50),
	"category" Char(50),
	"description" Text,
	"sdate" Char(50),
 primary key ("id")
) With Oids;

Create table "posts"
(
	"id" Char(50) NOT NULL,
	"sdate" Char(8),
	"stime" Char(8),
	"author" Char(100),
	"email" Char(100),
	"menuitem" Char(100),
	"title" Char(200),
	"excerpt" Text,
	"description" Text,
	"published" Char(5),
 primary key ("id")
) With Oids;

Create table "subscriptions"
(
	"blogid" Char(50) NOT NULL,
	"userid" Char(50) NOT NULL,
	"email" Char(50) NOT NULL,
 primary key ("blogid","userid","email")
) With Oids;

Create table "trackbacks"
(
	"id" Char(50) NOT NULL,
	"blogid" Char(50),
	"sdate" Char(50),
	"stime" Char(50),
	"url" Char(255),
	"blog_name" Char(200),
	"excerpt" Text,
	"title" Char(200),
	"published" Char(5),
 primary key ("id")
) With Oids;

Create table "users"
(
	"id" Char(50) NOT NULL,
	"fullname" Char(50),
	"email" Char(50),
	"us" Char(50),
	"pwd" Char(50),
	"role" Char(50),
 primary key ("id")
) With Oids;

Create table "spamlist"
(
	"item" Char(200)
) With Oids;

Create table "enclosures"
(
	"id" Char(50) NOT NULL,
	"blogid" Char(50),
	"name" Char(200),
	"length" Char(50),
	"type" Char(50),
 primary key ("id")
) With Oids;



