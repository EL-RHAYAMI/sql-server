use db1
go
ALTER TABLE db1.dbo.user1 ADD CONSTRAINT Unique_LastName UNIQUE(LastName)
ALTER TABLE db1.dbo.user1 ALTER COLUMN FirstName VARCHAR (100)
ALTER TABLE db1.dbo.user1 ALTER COLUMN Email VARCHAR (60) NULL
ALTER TABLE db1.dbo.user1 DROP COLUMN PlaceOfDeath


--Modifier le type de donnée dans la table 2 
DECLARE	@column varchar(25),
		@dataType varchar(60), 
		@isNullable varchar(8),
		@charPrecision int, 
		@constName varchar (MAX),
		@constType varchar (20)

DECLARE lineCursor CURSOR local FOR
	SELECT	cn.COLUMN_NAME, cn.DATA_TYPE, cn.IS_NULLABLE,
			cn.CHARACTER_OCTET_LENGTH, ccu.CONSTRAINT_NAME,
			tc.CONSTRAINT_TYPE
	FROM INFORMATION_SCHEMA.COLUMNS cn
	FULL OUTER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ccu
	ON(cn.COLUMN_NAME = ccu.COLUMN_NAME)
	FULL OUTER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc 
	ON (ccu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME) 
	WHERE cn.TABLE_NAME = 'user1'
 
OPEN linecursor 
FETCH next FROM linecursor INTO @column, @dataType, @isNullable, @charPrecision, @constName, @constType
WHILE @@fetch_status = 0
	BEGIN
		DECLARE @precise VARCHAR(10), @sqlcmd VARCHAR(MAX)
		IF @isNullable = 'YES'
			SET @isNullable = 'NULL'
		ELSE
			SET @isNullable = 'NOT NULL';
		IF @dataType = 'varchar'
			SET @precise = '('+CAST(@charPrecision AS VARCHAR)+')'
		ELSE
			SET @precise = ''
		SET @sqlcmd = 'ALTER TABLE db2.dbo.user2 ALTER COLUMN '+ @column +' '+ @dataType +@precise  +' ' + @isNullable;
		EXEC (@sqlcmd);
		--print 'ALTER TABLE db2.dbo.user2 ALTER COLUMN '+ @column +' '+ @dataType +@precise  +' ' + @isNullable;

		FETCH next FROM linecursor INTO @column, @dataType, @isNullable, @charPrecision, @constName, @constType
	END
CLOSE linecursor
DEALLOCATE linecursor