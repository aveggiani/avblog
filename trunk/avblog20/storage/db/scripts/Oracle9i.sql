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


Create table blogcategories (
	blogid varchar (50) NOT NULL ,
	category varchar (50) NOT NULL ,
primary key (blogid,category) 
) 
/

Create table categories (
	name varchar (50) NOT NULL ,
primary key (name) 
) 
/

Create table cms (
	id varchar (50) NOT NULL ,
	name varchar (50),
	ordername varchar (4),
	category varchar (50),
	ordercategory varchar (4),
	description clob,
	sdate varchar (50),
	stime varchar (50),
primary key (id) 
) 
/

Create table comments (
	id varchar (50) NOT NULL ,
	blogid varchar (50),
	sdate varchar (50),
	stime varchar (50),
	author varchar (50),
	email varchar (50),
	description clob,
	emailvisible varchar (5),
	private varchar (5),
	published varchar (5),
primary key (id) 
) 
/

Create table library (
	id varchar (50) NOT NULL ,
	name varchar (50),
	category varchar (50),
	description clob,
	sfile varchar (50),
	sdate varchar (50),
primary key (id) 
) 
/

Create table links (
	id varchar (50) NOT NULL ,
	name varchar (50),
	address varchar (50),
	ordercolumn Integer Default 0,
primary key (id) 
) 
/

Create table logs (
	id varchar (50),
	sdate varchar (8),
	stime varchar (8),
	type varchar (200),
	svalue clob
) 
/

Create table photoblog (
	id varchar (50) NOT NULL ,
	id_gallery varchar (50),
	name varchar (50),
	sfile varchar (50),
	description clob,
	sdate varchar (50),
	imageorder varchar (3),
primary key (id) 
) 
/

Create table photobloggallery (
	id varchar (50) NOT NULL ,
	name varchar (50),
	category varchar (50),
	description clob,
	sdate varchar (50),
primary key (id) 
) 
/

Create table posts (
	id varchar (50) NOT NULL ,
	sdate varchar (8),
	stime varchar (8),
	author varchar (100),
	email varchar (100),
	menuitem varchar (100),
	title varchar (200),
	excerpt clob,
	description clob,
	published varchar (5),
primary key (id) 
) 
/

Create table subscriptions (
	blogid varchar (50) NOT NULL ,
	userid varchar (50) NOT NULL ,
	email varchar (50) NOT NULL ,
primary key (blogid,userid,email) 
) 
/

Create table trackbacks (
	id varchar (50) NOT NULL ,
	blogid varchar (50),
	sdate varchar (50),
	stime varchar (50),
	url varchar (255),
	blog_name varchar (200),
	excerpt clob,
	title varchar (200),
	published varchar (5),
primary key (id) 
) 
/

Create table users (
	id varchar (50) NOT NULL ,
	fullname varchar (50),
	email varchar (50),
	us varchar (50),
	pwd varchar (50),
	role varchar (50),
primary key (id) 
) 
/

Create table spamlist (
	item varchar (200)
) 
/

Create table enclosures (
	id varchar (50) NOT NULL ,
	blogid varchar (50),
	name varchar (200),
	length varchar (50),
	type varchar (50),
primary key (id) 
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



