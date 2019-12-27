use db1
go
CREATE TRIGGER user1_IUD
ON dbo.user1
AFTER INSERT, UPDATE, DELETE
AS 
BEGIN
	DECLARE @userId  INT,
		@lastName  VARCHAR(15),
		@firstName  VARCHAR(15),
		@gender CHAR(1), 
		@email VARCHAR(60),
		@dateOfBirth  DATETIME,
		@placeOfDeath  VARCHAR(30)
    SET NOCOUNT ON;
    --
    -- Check if this is an INSERT, UPDATE or DELETE Action.
    -- 
    DECLARE @action as char(1);
    SET @action = 'I'; -- Set Action to Insert by default.
    IF EXISTS(SELECT * FROM DELETED)
		BEGIN
			SET @action = 
				CASE
					WHEN EXISTS(SELECT * FROM INSERTED) THEN 'U' -- Set Action to Updated.
					ELSE 'D' -- Set Action to Deleted.       
				END
		END
    ELSE 
        IF NOT EXISTS(SELECT * FROM INSERTED) RETURN; -- Nothing updated or inserted.
	
	IF @action = 'I'
		BEGIN 
			SELECT	@userId=UserID,
					@lastName=LastName, 
					@firstName=FirstName, 
					@gender=Gender, 
					@email=Email, 
					@dateOfBirth=DateOfBirth, 
					@placeOfDeath=PlaceOfDeath FROM inserted
			INSERT db2.dbo.user2(UserId, LastName, FirstName, Gender, Email, DateOfBirth, PlaceOfDeath)
			VALUES(@userId, @lastName, @firstName, @gender, @email, @dateOfBirth, @placeOfDeath)
		END
	ELSE IF @action = 'U'
		BEGIN 
			SELECT	@userId=UserID,
					@lastName=LastName, 
					@firstName=FirstName, 
					@gender=Gender, 
					@email=Email, 
					@dateOfBirth=DateOfBirth, 
					@placeOfDeath=PlaceOfDeath FROM inserted
			UPDATE db2.dbo.user2 
			SET	LastName=@lastName, 
				FirstName=@firstName, Gender=@gender, 
				Email=@email, DateOfBirth=@dateOfBirth, PlaceOfDeath=@placeOfDeath
			WHERE UserId=@userId
		END
	ELSE
		BEGIN 
			SELECT	@userId=UserID FROM deleted
			DELETE FROM db2.dbo.user2 WHERE db2.dbo.user2.UserID = @userId
		END
	 
END