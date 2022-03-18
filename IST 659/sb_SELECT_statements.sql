-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ *
-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ *
-- Querying to show all Tracks in the database, along with their artist (User) and Genre 


SELECT ut.UserTrackTitle, u.UserName,  g.Genre 
FROM sb_Genre g
JOIN sb_UserTracks ut ON ut.sb_GenreID = g.sb_GenreID
JOIN sb_User u ON u.sb_UserID = ut.sb_UserID
ORDER BY UserTrackTitle

SELECT * FROM sb_User

-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
--Querying for total number of tracks in the DB
SELECT COUNT (UserTrackTitle) AS num_tracks
FROM sb_UserTracks

-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
--Querying to see all songs by an artist

	--Showing Username and track name
		SELECT u.UserName, ut.UserTrackTitle
		FROM sb_UserTracks ut
		JOIN sb_User ua ON ua.sb_UserID = ut.sb_UserID
		JOIN sb_User u ON u.sb_UserID = ua.sb_UserID
		ORDER BY ua.sb_UserID DESC

	--Showing only UserID and track name
		SELECT ut.sb_UserID, UserTrackTitle
		FROM sb_UserTracks ut
		JOIN sb_User ua ON ua.sb_UserID = ut.sb_UserID
		JOIN sb_User u ON u.sb_UserID = ua.sb_UserID
		ORDER BY ut.sb_UserID


SELECT * FROM sb_UserTracks

-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
--Querying for the track total of each User

SELECT
	u.UserName,
	COUNT(ut.UserTrackTitle) AS trackCount
	FROM sb_UserTracks ut
	JOIN sb_User u ON u.sb_UserID = ut.sb_UserID
	GROUP BY UserName
	ORDER BY trackCount DESC

-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
--Querying to view the tracks of a particular UserArtist

SELECT 
	u.UserName, ut.UserTrackTitle, g.Genre
	FROM sb_User u
	JOIN sb_UserTracks ut ON ut.sb_UserID = u.sb_UserID
	JOIN sb_Genre g ON ut.sb_GenreID = g.sb_GenreID
	WHERE UserName = 'King_of_Rap'
	ORDER BY UserTrackTitle
			
			--Many SongBird users are clearly multi-talented musicians...

-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
--Querying for how many songs a particular user has in each Genre

SELECT 
	  
	CONCAT(Username, '''s releases in ', Genre) as 'User Releases'
	, COUNT(g.Genre) Total
	FROM sb_Genre g
	JOIN sb_UserTracks ut ON ut.sb_GenreID = g.sb_GenreID
	JOIN sb_User u ON u.sb_UserID = ut.sb_UserID
	WHERE UserName = 'King_of_Rap'
	GROUP BY Genre, UserName
	ORDER BY Total DESC
			
			--Based on these results, "King_of_Rap" should change their name to "King_of_Classical".

-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
--Querying for which users have released tracks in a particular genre

SELECT 
	u.sb_UserID, ut.UserTrackTitle,  sb_Genre.Genre
	FROM sb_Genre
	JOIN sb_UserTracks ut ON ut.sb_GenreID = sb_Genre.sb_GenreID
	JOIN sb_User u ON u.sb_UserID = ut.sb_UserID
	WHERE sb_Genre.Genre = 'Electronic'
	ORDER BY u.sb_UserID

-- Similar query to get a total of Electronic tracks for each user instead of 
-- listing all their tracks:

	SELECT u.UserName, COUNT(g.Genre) AS 'Total In Genre'
	FROM sb_Genre g
	JOIN sb_UserTracks ut ON ut.sb_GenreID = g.sb_GenreID
	JOIN sb_User u ON u.sb_UserID = ut.sb_UserID
	WHERE g.Genre = 'Electronic'
	GROUP BY u.UserName
	ORDER BY 'Total In Genre' DESC

-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
-- Querying for the most popular genre on SongBird

SELECT 
	g.Genre,
	COUNT(g.Genre) GenreTotal
	FROM sb_Genre g
	JOIN sb_UserTracks ut ON ut.sb_GenreID = g.sb_GenreID
	GROUP BY g.Genre
	ORDER BY GenreTotal DESC
		
			--Country happens to be the least popular genre

-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
--Query to look at which users (artists or otherwise) have made playlists

SELECT 
	u.UserName, p.PlaylistName
	FROM sb_Playlist p
	JOIN sb_User u
	ON u.sb_UserID = p.sb_UserID
	ORDER BY UserName

-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
--Query to see which users have made the MOST playlists

SELECT
	u.UserName, 
	COUNT(p.PlaylistName) PlaylistCount
	FROM sb_Playlist p
	JOIN sb_User u ON u.sb_UserID = p.sb_UserId
	GROUP BY UserName
	ORDER BY PlaylistCount DESC

-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
-- ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * 
--Trying a query to see the tracks on a Playlist
SELECT u.UserName, p.PlaylistName, ut.UserTrackTitle 
FROM sb_UserTracks ut
JOIN sb_User u ON u.sb_UserID = ut.sb_UserID
JOIN sb_Playlist p ON p.sb_UserId = u.sb_UserID
WHERE sb_PlaylistID = 5

		--The query did execute but the result came up blank, as if there's no record. 

--Trying the query again, this time using a RIGHT JOIN.
SELECT u.UserName, p.PlaylistName,  ut.UserTrackTitle
FROM sb_UserTracks ut
RIGHT JOIN sb_User u ON u.sb_UserID = ut.sb_UserID
RIGHT JOIN sb_Playlist p ON p.sb_UserId = u.sb_UserID
RIGHT JOIN sb_PlaylistTrack pt ON pt.sb_PlaylistID = p.sb_PlaylistID
WHERE p.sb_PlaylistID = 5
ORDER BY UserName
		--This gave us a result, but UserTrackTitle is blank. Now to try to understand why...