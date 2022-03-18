-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
--A basic query to alter the table:




-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
--Coding a stored procedure for INSERTING data:



	 CREATE PROCEDURE sb_AddUser(@UserName varchar(30), @UserEmail varchar(50), @UserBio varchar(100) null)
	 AS  
  BEGIN  
		INSERT INTO sb_User (UserName, UserEmail, UserBio)
		VALUES (@UserName, @UserEmail, @UserBio)
	END
	GO

	--Testing procedure by adding a user: 
	EXEC sb_AddUser 'JohnLennon', 'John@Beatles.org', 'guitar, vocals, and writing'
	SELECT * FROM sb_User WHERE UserName = 'JohnLennon'
	--Procedure works, John is posthumously added to the database

-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
--Coding stored procedures for MANIPULATING data:

--Change a track title:
CREATE PROCEDURE sb_changeTrackTitle(@UserTrackID int, @newTrackTitle varchar(50))
AS
BEGIN
	UPDATE sb_UserTracks SET UserTrackTitle = @newTrackTitle
	WHERE sb_UserTrackID = @UserTrackID
END
GO

	--Testing procedure to change track title:

	SELECT *  FROM sb_UserTracks
	EXEC sb_changeTrackTitle 7, 'Endless Blue'
	SELECT * FROM sb_UserTracks
	WHERE UserTrackTitle = 'Endless Blue'
	--Change took effect, Track title changed successfully.

-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
--Procedure to change an email address:
CREATE PROCEDURE sb_ChangeUserEmail(@userName varchar(30), @newEmail varchar(50))
AS
BEGIN
	UPDATE sb_User SET UserEmail = @newEmail
	WHERE UserName = @userName
END
GO
	--Testing procedure and changing an email address:
	SELECT UserName, UserEmail
	FROM sb_User
	WHERE UserName = 'astone24'

	EXEC sb_ChangeUserEmail'astone24', 'astone24@hotmail.com' 

	SELECT UserName, UserEmail
	FROM sb_User
	WHERE UserName = 'astone24'
	--change took effect, user email changed.

-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
--Creating a VIEW to see who the top 10 most uploading artists are:

CREATE VIEW sb_BiggestArtists AS
	SELECT TOP 10
	u.UserName,
	COUNT(ut.UserTrackTitle) AS trackCount
	FROM sb_UserTracks ut
	JOIN sb_User u ON u.sb_UserID = ut.sb_UserID
	GROUP BY UserName
	ORDER BY trackCount DESC
GO


SELECT * FROM sb_BiggestArtists

-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
--Creating a VIEW to see who the top 3 biggest Hip Hop uploaders are

CREATE VIEW HipHopTop3 AS

	SELECT TOP 3
		u.UserName, COUNT(g.Genre) AS 'Total In Genre'
	FROM sb_Genre g
		JOIN sb_UserTracks ut ON ut.sb_GenreID = g.sb_GenreID
		JOIN sb_User u ON u.sb_UserID = ut.sb_UserID
	WHERE g.Genre = 'Hip Hop'
	GROUP BY u.UserName
	ORDER BY 'Total In Genre' DESC
GO

SELECT * FROM HipHopTop3

--Alter View to change the output column label to say "Total in Hip Hop" instead of "Total in Genre"

ALTER VIEW HipHopTop3 AS

	SELECT TOP 3
		u.UserName, COUNT(g.Genre) AS 'Total In Hip Hop'
	FROM sb_Genre g
		JOIN sb_UserTracks ut ON ut.sb_GenreID = g.sb_GenreID
		JOIN sb_User u ON u.sb_UserID = ut.sb_UserID
	WHERE g.Genre = 'Hip Hop'
	GROUP BY u.UserName
	ORDER BY 'Total In Hip Hop' DESC
GO

		--Testing if the change took effect:
		SELECT * FROM HipHopTop3
		--Change took effect!