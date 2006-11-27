Only some points here, you can find some docs on the docs folder;

Here just some informations:

- 	in order to access the administration mode add mode=admin parameter to your address:
	example: http://yourblogurl/index.cfm?mode=admin
	and use 'admin' for both user and password
-	in order to made future upgrade easier you'll find a new personal folder;
	in this folder there should be all files about user personalizations of the blog;
	future implementations of AVBLOG will never touch this folder
-	PLEASE HELP ME IN TESTING; AVblog should work on any platform (CF 7, CF 6.1, BlueDragon and Railo)
	and with every DB (or using XML without DB) but it's very time consuming testing so probably
	there are problems around on platform different from CF 7 with XML as storage; tests on other
	platforms are heavily appreciated.
	
For any information: andrea@dinamica.it