SET FOREIGN_KEY_CHECKS = 0;
INSERT INTO genre (genre_id, genre_name, genre_description) VALUES
(1, 'Pop', 'Popular contemporary music.'),
(2, 'Rock', 'Rock and roll and its derivatives.'),
(3, 'Jazz', 'Smooth and improvised music.'),
(4, 'Classical', 'Orchestral and instrumental masterpieces.'),
(5, 'Hip Hop', 'Rap and rhythmic lyrics.'),
(6, 'Electronic', 'Synth and digitally produced music.'),
(7, 'Reggae', 'Caribbean influenced beats.'),
(8, 'Blues', 'Soulful and emotional guitar-driven music.'),
(9, 'Country', 'Southern US storytelling tunes.'),
(10, 'K-pop', 'Korean popular music.');


INSERT INTO media_type (media_type_id, media_type_name) VALUES
(1, 'MP3'),
(2, 'WAV'),
(3, 'AAC'),
(4, 'FLAC'),
(5, 'OGG');


INSERT INTO order_type (order_type_id, order_type_name) VALUES
(1, 'Online'),
(2, 'Store Pickup');

SET FOREIGN_KEY_CHECKS = 1;