/* =========================================================
   FILE: ad_hoc_analysis.sql
   PURPOSE:
   - Exploratory business analysis
   - Artist, album, customer, and order insights
   - Used for manual analysis and reporting
   ========================================================= */

-- Displays all tracks by famous artists with album and media type
SELECT 
    fa.icon_id,
    fa.artist_id,
    fa.num_albums,
    ar.artist_name,
    al.album_id,
    t.track_id,
    al.album_name,
    t.track_name,
    t.media_type_id,
    t.track_length
FROM famous_artists fa
JOIN artist ar ON fa.artist_id = ar.artist_id
JOIN album al ON al.artist_id = ar.artist_id
JOIN track t ON t.album_id = al.album_id
ORDER BY fa.icon_id, al.album_id, t.track_id;
