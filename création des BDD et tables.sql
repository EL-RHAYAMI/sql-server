--Création de la base de donneés 1
USE master
go
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'db1')
		CREATE DATABASE db1;
go
use db1
go
--Création de la table user1
if NOT EXISTS (select * from sysobjects where name='user1')
    BEGIN
		CREATE TABLE dbo.user1 (
			UserId  INT NOT NULL PRIMARY KEY IDENTITY(1,1),
			LastName  VARCHAR(15) NOT NULL,
			FirstName  VARCHAR(15) NOT NULL,
			Gender CHAR(1) NOT NULL, 
			Email VARCHAR(60) NOT NULL,
			DateOfBirth  DATETIME  NULL,
			PlaceOfDeath  VARCHAR(30) NOT NULL
			);
		INSERT dbo.user1 (LastName, FirstName, Gender, Email, DateOfBirth, PlaceOfDeath)
			VALUES('ABIDI', 'Salim', 'M', 'abd.salim@gmail.com', NULL,'Rabat')
		INSERT dbo.user1 (LastName, FirstName, Gender, Email, DateOfBirth, PlaceOfDeath)
			VALUES('ALAOUI', 'Asmae', 'F', 'sam.alaoui@yahoo.com', CONVERT(date, '25-2-1982', 105),'Tanger')
		INSERT dbo.user1 (LastName, FirstName, Gender, Email, DateOfBirth, PlaceOfDeath)
			VALUES('BANASSAR', 'Adil', 'M', 'adil.ban@outlook.fr', CONVERT(date, '12-10-1999', 105),'Agadir')
		INSERT dbo.user1 (LastName, FirstName, Gender, Email, DateOfBirth, PlaceOfDeath)
			VALUES('ESSADI', 'Samir', 'M', 'essadi.amir@google.mail.com', CONVERT(date, '16-7-1996', 105),'Casablaca');
	END;

--Création de la base de donneés 2
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'db2')
		CREATE DATABASE db2


----Création de la table user2
if NOT EXISTS (select * from sysobjects where name='user2')
	SELECT * INTO db2.dbo.user2 FROM db1.dbo.user1;