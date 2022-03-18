--Creating tables for SongBird

-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
--Creating the User table

CREATE TABLE sb_User (
	-- Columns for users table:
	sb_UserID int identity,
	UserName varchar(30) not null,
	UserEmail varchar(50) not null,
	UserBio varchar(150),
	-- Constraints on users table:
	CONSTRAINT PK_sb_User PRIMARY KEY (sb_UserID),
	CONSTRAINT U1_sb_User UNIQUE(UserName),
	CONSTRAINT U2_sb_User UNIQUE(userEmail)
)

SELECT * FROM sb_User

-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
--Creating the UserLogin table

CREATE TABLE sb_UserLogin (
	--Columns for UserLogin table:
	sb_UserLoginID int identity,
	sb_UserID int,
	UserLoginTimestamp datetime,
	LoginLocation varchar(50),

	--Constraints on UserLogin table:
	CONSTRAINT PK_sb_UserLogin PRIMARY KEY (sb_UserLoginID),
	CONSTRAINT FK_sb_UserLogin FOREIGN KEY (sb_UserID) REFERENCES sb_User
)

SELECT * FROM sb_UserLogin

-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
--Creating the UserTrack table

CREATE TABLE sb_UserTracks(
	-- Columns for sb_UserTracks table:
	sb_UserTrackID int identity,
	UserTrackTitle varchar(50) NOT NULL,
	UserTrackDesc varchar(100),
	sb_UserID int NOT NULL,
	sb_GenreID int NOT NULL,
	-- Constraints on UserSongs table:
	CONSTRAINT PK_sb_UserTracks PRIMARY KEY (sb_UserTrackID),
	CONSTRAINT FK1_sb_UserTracks FOREIGN KEY (sb_UserID) REFERENCES sb_User(sb_UserID),
	CONSTRAINT FK2_sb_UserTracks FOREIGN KEY (sb_GenreID) REFERENCES sb_Genre(sb_GenreID)
)



SELECT * FROM sb_UserTracks

-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 		
-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
--Creating a Genre table

CREATE TABLE sb_Genre (
	-- Columns for genre table:
	sb_GenreID int identity,
	Genre varchar(20) NOT NULL,

	-- Constraints on Genre table:
	CONSTRAINT PK_sb_Genre PRIMARY KEY (sb_GenreID)
)

SELECT * FROM sb_Genre

-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
-- Creating a Playlist table

CREATE TABLE sb_Playlist (
	-- Columns in sb_UserPlaylist table:
	sb_PlaylistID int identity,
	PlaylistName varchar(30) NOT NULL,
	sb_UserId int

	-- Constraints in sb_UserPlaylist table:
	CONSTRAINT PK_sb_Playlist PRIMARY KEY (sb_PlaylistID),
	CONSTRAINT FK_sb_Playlist FOREIGN KEY (sb_UserID) REFERENCES sb_User(sb_UserID)
	
)

SELECT * FROM sb_Playlist

-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
-- Creating the PlaylistTracks table (bridge table)

CREATE TABLE sb_PlaylistTrack (
	-- Columns in sb_PlaylistTracks table:
	sb_PlaylistTrackID int identity,
	sb_PlaylistID int,
	sb_UserTrackID int,

	-- Constraints in sb_PlaylistTracks table:
	CONSTRAINT PK_sb_PlaylistTrack PRIMARY KEY (sb_PlaylistTrackID),
	CONSTRAINT FK1_sb_PlaylistTrack FOREIGN KEY (sb_PlaylistID) REFERENCES sb_Playlist(sb_PlaylistID),
	CONSTRAINT FK2_sb_PlaylistTrack FOREIGN KEY (sb_UserTrackID) REFERENCES sb_UserTracks(sb_UserTrackID)
)

SELECT * FROM sb_PlaylistTrack

