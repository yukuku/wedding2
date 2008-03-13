Our Wedding Dinner Planner
==========================

Table of Contents
-----------------

1. Package Contents
   1.1 Program Files
   1.2 Application Files
   1.3 Source Code
2. Installation


1. Package Contents
-------------------
The software is packaged in Wedding-date-time.exe file.
It contains the things needed to run it on Windows 2000 or newer machine.

1.1 Program Files
-----------------
The following program files are included:
- firefox: Mozilla Firefox 2
- jre: Java Runtime Environment 6
- mysql: MySQL 5
- tomcat: Apache Tomcat 6

1.2 Application Files
---------------------
The following files that we developed and deployed are included:
- tomcat/webapps/Wedding: the main application context root (Wedding)
- mysql/data: database forms and data

1.3 Source Code
---------------
The source codes are included for review:
- javasrc: Java class sources
- websrc: Web root directory (JSP, CSS, Javascript)

2. Installation
---------------
Run Wedding-date-time.exe and you will be asked for extraction directory.
Use path name without spaces if possible.
After extraction, go to the directory and execute the run.bat file.
It will start mysql, tomcat, and finally the firefox browser to go to
the URL of the application: http://localhost:40040/Wedding/
If the browser does not launch, use your other browser to go to:
http://localhost:40040/Wedding/
