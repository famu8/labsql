-- Listar las pistas (tabla Track) con precio mayor o igual a 1€
SELECT * FROM dbo.Track T
WHERE T.UnitPrice >= 1;

-- Listar las pistas de más de 4 minutos de duración
-- 1 min == 6000 ms
SELECT * FROM dbo.Track T
WHERE T.Milliseconds > 240000;

-- Listar las pistas que tengan entre 2 y 3 minutos de duración
SELECT * FROM dbo.Track T
WHERE T.Milliseconds BETWEEN 120000 AND 180000;

-- Listar las pistas que uno de sus compositores (columna Composer) sea Mercury
SELECT * FROM dbo.Track T
WHERE T.Composer = 'Mercury';

-- Calcular la media de duración de las pistas (Track) de la plataforma
-- Dividir entre 60000 da el resultado en segundos (s)
SELECT AVG(T.Milliseconds)/60000
FROM dbo.Track T;

-- Listar los clientes (tabla Customer) de USA, Canada y Brazil
SELECT * FROM dbo.Customer C
WHERE C.Country IN ('USA', 'Brazil', 'Canada');

SELECT * FROM dbo.Customer C
WHERE C.Country = 'USA' OR C.Country = 'Brazil' OR C.Country = 'Canada';

-- Listar todas las pistas del artista 'Queen' (Artist.Name = 'Queen')
SELECT * FROM dbo.Artist A
WHERE A.Name = 'Queen';

-- Listar las pistas del artista 'Queen' en las que haya participado como compositor David Bowie
SELECT T.Name
FROM dbo.Track T
INNER JOIN dbo.Album Ab
ON T.AlbumId = Ab.AlbumId
INNER JOIN dbo.Artist A
ON Ab.ArtistId = A.ArtistId
WHERE A.Name='Queen' AND T.Composer = 'David Bowie';
-- David Bowie no aparece en la bbdd por eso la query anterior no devuelve resultados
SELECT T.Composer from dbo.Track T
ORDER BY T.Composer ASC;

-- Listar las pistas de la playlist 'Heavy Metal Classic'
SELECT T.Name
FROM dbo.Track T
INNER JOIN dbo.PlaylistTrack PT
ON T.TrackId = PT.TrackId
WHERE PT.PlaylistId = 17;
-- Devuelve 26 pistas, correcto
SELECT COUNT(*) AS NumeroTracks
FROM dbo.PlaylistTrack PT
WHERE PT.PlaylistId = 17;

-- Listar las playlist junto con el número de pistas que contienen
SELECT P.Name, COUNT(T.TrackId) AS Recuento
FROM dbo.Playlist P
FULL JOIN dbo.PlaylistTrack PT
ON PT.PlaylistId = P.PlaylistId
LEFT JOIN dbo.Track T
ON T.TrackId = PT.TrackId
GROUP BY (P.Name);
-- Para comprobar simplemente buscamos contamos las pistas de algunas de las playlist
-- la playlist 5 (90's music) contiene 1477 canciones
SELECT T.Name
FROM dbo.Track T
INNER JOIN dbo.PlaylistTrack PT
ON T.TrackId = PT.TrackId
WHERE PT.PlaylistId = 5;
-- SELECT P.Name FROM dbo.Playlist P;

-- Listar las playlist (sin repetir ninguna) que tienen alguna canción de AC/DC
-- solo hay canciones de AC/Dc en la playlist Music, para mostrar las playlist y que no se repitan
-- hbaria que quitar el T.Name. Es correcto porque AC/DC solo tiene 8 tracks en toda la bbdd
SELECT DISTINCT P.Name, T.Name
FROM dbo.Playlist P
FULL JOIN dbo.PlaylistTrack PT
ON PT.PlaylistId = P.PlaylistId
LEFT JOIN dbo.Track T
ON T.TrackId = PT.TrackId
WHERE T.Composer = 'AC/DC';

-- Listar las playlist que tienen alguna canción del artista Queen, junto con la cantidad que tienen
SELECT DISTINCT P.Name, COUNT(DISTINCT T.TrackId) AS Recuento
FROM dbo.Playlist P
FULL JOIN dbo.PlaylistTrack PT
ON PT.PlaylistId = P.PlaylistId
LEFT JOIN dbo.Track T
ON T.TrackId = PT.TrackId
WHERE T.Composer = 'Queen'
GROUP BY (P.Name);

-- Listar las pistas que no están en ninguna playlist
SELECT *
FROM dbo.Track T
WHERE T.TrackId NOT IN (
  SELECT dbo.PlaylistTrack.TrackId
  FROM dbo.PlaylistTrack
);

-- Listar los artistas que no tienen album
SELECT A.Name
FROM dbo.Artist A
WHERE A.ArtistId NOT IN (
  SELECT dbo.Album.ArtistId 
  FROM dbo.Album
);
-- Otro modo:
SELECT DISTINCT A.Name, Ab.Title
FROM dbo.Artist A
LEFT JOIN dbo.Album Ab
ON A.ArtistId = Ab.ArtistId
WHERE Ab.AlbumId IS NULL;

-- Listar los artistas con el número de albums que tienen
SELECT A.Name, COUNT(Ab.AlbumId) AS NumAlbums
FROM dbo.Artist A
FULL JOIN dbo.Album Ab
ON A.ArtistId = Ab.ArtistId
GROUP BY A.ArtistId, A.Name
ORDER BY NumAlbums DESC;