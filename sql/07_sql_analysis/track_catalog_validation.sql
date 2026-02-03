/*
File: track_catalog_validation.sql

Purpose:
Validate track, album, and artist coverage.
Ensures completeness of track catalog, famous artists coverage,
and detects albums or artists missing track data.
*/


-- =========================================================
-- BASIC TRACK & ALBUM COUNTS
-- =========================================================

-- Total number of tracks in catalog
SELECT COUNT(*) AS total_tracks
FROM track;

-- Number of distinct albums that have at least one track
SELECT COUNT(DISTINCT album_id) AS albums_with_tracks
FROM track;

-- Total albums in album master table
SELECT COUNT(*) AS total_albums
FROM album;

-- =========================================================
-- TRACK DISTRIBUTION BY ARTIST
-- =========================================================

-- Artists and number of tracks (sorted descending)
SELECT 
    art.artist_id,
    art.artist_name,
    COUNT(t.track_id) AS track_count
FROM track t
JOIN album a ON t.album_id = a.album_id
JOIN artist art ON a.artist_id = art.artist_id
GROUP BY art.artist_id, art.artist_name
ORDER BY track_count DESC;

-- =========================================================
-- FAMOUS ARTISTS (TOP 35) COVERAGE
-- =========================================================

-- Proportion of tracks belonging to famous 50 artists
SELECT
    SUM(CASE WHEN fa.artist_id IS NOT NULL THEN 1 ELSE 0 END) AS tracks_in_famous50,
    COUNT(*) AS total_tracks,
    ROUND(
        100 * SUM(CASE WHEN fa.artist_id IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS pct_tracks_famous50
FROM track t
JOIN album a ON t.album_id = a.album_id
LEFT JOIN famous_artists fa ON a.artist_id = fa.artist_id;

-- Albums-with-tracks belonging to famous 50
SELECT
    SUM(CASE WHEN fa.artist_id IS NOT NULL THEN 1 ELSE 0 END) AS albums_with_tracks_famous50,
    COUNT(DISTINCT t.album_id) AS total_albums_with_tracks,
    ROUND(
        100 * SUM(CASE WHEN fa.artist_id IS NOT NULL THEN 1 ELSE 0 END) / COUNT(DISTINCT t.album_id),
        2
    ) AS pct_albums_famous50
FROM track t
JOIN album a ON t.album_id = a.album_id
LEFT JOIN famous_artists fa ON a.artist_id = fa.artist_id;

-- Famous artists that currently have ZERO tracks
SELECT
    fa.artist_id,
    fa.artist_name
FROM famous_artists fa
LEFT JOIN artist ar ON fa.artist_id = ar.artist_id
LEFT JOIN album a ON ar.artist_id = a.artist_id
LEFT JOIN track t ON a.album_id = t.album_id
GROUP BY fa.artist_id, fa.artist_name
HAVING SUM(CASE WHEN t.track_id IS NOT NULL THEN 1 ELSE 0 END) = 0;

-- =========================================================
-- NON-FAMOUS ARTISTS ANALYSIS
-- =========================================================

-- Top 50 non-famous albums by track count
SELECT
    a.album_id,
    a.album_name,
    art.artist_id,
    art.artist_name,
    COUNT(t.track_id) AS track_count
FROM track t
JOIN album a ON t.album_id = a.album_id
JOIN artist art ON a.artist_id = art.artist_id
LEFT JOIN famous_artists fa ON art.artist_id = fa.artist_id
WHERE fa.artist_id IS NULL
GROUP BY a.album_id, a.album_name, art.artist_id, art.artist_name
ORDER BY track_count DESC
LIMIT 50;

-- Number of distinct artists appearing in track table
SELECT COUNT(DISTINCT art.artist_id) AS artists_with_tracks
FROM track t
JOIN album a ON t.album_id = a.album_id
JOIN artist art ON a.artist_id = art.artist_id;

-- Famous artists present in artist master table
SELECT COUNT(*) AS famous50_in_artist_master
FROM famous_artists fa
JOIN artist art ON fa.artist_id = art.artist_id;

-- =========================================================
-- ALBUMS WITH NO TRACKS
-- =========================================================

-- Albums that currently have no tracks (limited for inspection)
SELECT
    a.album_id,
    a.album_name,
    art.artist_name,
    a.genre_id
FROM album a
LEFT JOIN track t ON a.album_id = t.album_id
JOIN artist art ON a.artist_id = art.artist_id
WHERE t.track_id IS NULL
ORDER BY art.artist_name, a.album_name
LIMIT 200;

-- Order items referencing albums that have no tracks
SELECT DISTINCT
    oi.album_id,
    a.album_name,
    art.artist_name
FROM order_items oi
LEFT JOIN album a ON oi.album_id = a.album_id
LEFT JOIN track t ON a.album_id = t.album_id
LEFT JOIN artist art ON a.artist_id = art.artist_id
WHERE t.track_id IS NULL
LIMIT 200;

-- =========================================================
-- ARTIST TRACK COUNT THRESHOLDS
-- =========================================================

-- Artists with 10 or more tracks
SELECT
    art.artist_id,
    art.artist_name,
    COUNT(t.track_id) AS track_count
FROM artist art
JOIN album a ON art.artist_id = a.artist_id
JOIN track t ON a.album_id = t.album_id
GROUP BY art.artist_id, art.artist_name
HAVING COUNT(t.track_id) >= 10
ORDER BY track_count DESC;

-- Percentage of artists with >=10 tracks who are famous
WITH artists_with_10 AS (
    SELECT art.artist_id
    FROM artist art
    JOIN album a ON art.artist_id = a.artist_id
    JOIN track t ON a.album_id = t.album_id
    GROUP BY art.artist_id
    HAVING COUNT(t.track_id) >= 10
)
SELECT
    COUNT(*) AS total_artists_with_10,
    SUM(CASE WHEN fa.artist_id IS NOT NULL THEN 1 ELSE 0 END) AS famous_artists_with_10,
    ROUND(
        100 * SUM(CASE WHEN fa.artist_id IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS pct_famous_among_10
FROM artists_with_10 aw
LEFT JOIN famous_artists fa ON aw.artist_id = fa.artist_id;

-- =========================================================
-- NON-FAMOUS ARTIST TRACK DISTRIBUTION
-- =========================================================

-- Track count distribution for non-famous artists
WITH nonf_artist_tracks AS (
    SELECT
        art.artist_id,
        art.artist_name,
        COUNT(t.track_id) AS track_count
    FROM artist art
    JOIN album a ON art.artist_id = a.artist_id
    LEFT JOIN track t ON a.album_id = t.album_id
    WHERE art.artist_id NOT IN (SELECT artist_id FROM famous_artists)
    GROUP BY art.artist_id, art.artist_name
)
SELECT
    track_count,
    COUNT(*) AS artists_with_that_count,
    ROUND(
        100 * COUNT(*) / (SELECT COUNT(*) FROM nonf_artist_tracks),
        2
    ) AS pct_of_nonfamous_artists
FROM nonf_artist_tracks
GROUP BY track_count
ORDER BY track_count DESC;

-- Top 20 non-famous artists by track count
SELECT
    art.artist_id,
    art.artist_name,
    COUNT(t.track_id) AS track_count
FROM artist art
JOIN album a ON art.artist_id = a.artist_id
JOIN track t ON a.album_id = t.album_id
WHERE art.artist_id NOT IN (SELECT artist_id FROM famous_artists)
GROUP BY art.artist_id, art.artist_name
ORDER BY track_count DESC
LIMIT 20;

-- Bottom 20 non-famous artists (including zero-track artists)
SELECT
    art.artist_id,
    art.artist_name,
    COALESCE(cnt, 0) AS track_count
FROM artist art
LEFT JOIN (
    SELECT
        art.artist_id AS aid,
        COUNT(t.track_id) AS cnt
    FROM artist art
    JOIN album a ON art.artist_id = a.artist_id
    LEFT JOIN track t ON a.album_id = t.album_id
    GROUP BY art.artist_id
) x ON art.artist_id = x.aid
WHERE art.artist_id NOT IN (SELECT artist_id FROM famous_artists)
ORDER BY track_count ASC
LIMIT 20;

-- Cumulative distribution of non-famous artist track counts
WITH nat AS (
    SELECT art.artist_id, COUNT(t.track_id) AS track_count
    FROM artist art
    JOIN album a ON art.artist_id = a.artist_id
    LEFT JOIN track t ON a.album_id = t.album_id
    WHERE art.artist_id NOT IN (SELECT artist_id FROM famous_artists)
    GROUP BY art.artist_id
),
dist AS (
    SELECT track_count, COUNT(*) AS cnt
    FROM nat
    GROUP BY track_count
)
SELECT
    d.track_count,
    d.cnt,
    SUM(d2.cnt) AS cumulative_count,
    ROUND(
        100 * SUM(d2.cnt) / (SELECT COUNT(*) FROM nat),
        2
    ) AS cumulative_pct
FROM dist d
JOIN dist d2 ON d2.track_count <= d.track_count
GROUP BY d.track_count, d.cnt
ORDER BY d.track_count;

-- Average track count per non-famous artist
SELECT ROUND(AVG(track_count), 2) AS avg_tracks_per_nonfamous_artist
FROM (
    SELECT art.artist_id, COUNT(t.track_id) AS track_count
    FROM artist art
    JOIN album a ON art.artist_id = a.artist_id
    LEFT JOIN track t ON a.album_id = t.album_id
    WHERE art.artist_id NOT IN (SELECT artist_id FROM famous_artists)
    GROUP BY art.artist_id
) x;
