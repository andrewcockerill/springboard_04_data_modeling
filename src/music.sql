-- from the terminal run:
-- psql < music.sql

-- Initial schema
DROP DATABASE IF EXISTS music;

CREATE DATABASE music;

\c music

CREATE TABLE songs
(
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  duration_in_seconds INTEGER NOT NULL,
  release_date DATE NOT NULL,
  artists TEXT[] NOT NULL,
  album TEXT NOT NULL,
  producers TEXT[] NOT NULL
);

INSERT INTO songs
  (title, duration_in_seconds, release_date, artists, album, producers)
VALUES
  ('MMMBop', 238, '04-15-1997', '{"Hanson"}', 'Middle of Nowhere', '{"Dust Brothers", "Stephen Lironi"}'),
  ('Bohemian Rhapsody', 355, '10-31-1975', '{"Queen"}', 'A Night at the Opera', '{"Roy Thomas Baker"}'),
  ('One Sweet Day', 282, '11-14-1995', '{"Mariah Cary", "Boyz II Men"}', 'Daydream', '{"Walter Afanasieff"}'),
  ('Shallow', 216, '09-27-2018', '{"Lady Gaga", "Bradley Cooper"}', 'A Star Is Born', '{"Benjamin Rice"}'),
  ('How You Remind Me', 223, '08-21-2001', '{"Nickelback"}', 'Silver Side Up', '{"Rick Parashar"}'),
  ('New York State of Mind', 276, '10-20-2009', '{"Jay Z", "Alicia Keys"}', 'The Blueprint 3', '{"Al Shux"}'),
  ('Dark Horse', 215, '12-17-2013', '{"Katy Perry", "Juicy J"}', 'Prism', '{"Max Martin", "Cirkut"}'),
  ('Moves Like Jagger', 201, '06-21-2011', '{"Maroon 5", "Christina Aguilera"}', 'Hands All Over', '{"Shellback", "Benny Blanco"}'),
  ('Complicated', 244, '05-14-2002', '{"Avril Lavigne"}', 'Let Go', '{"The Matrix"}'),
  ('Say My Name', 240, '11-07-1999', '{"Destiny''s Child"}', 'The Writing''s on the Wall', '{"Darkchild"}');

-- New schema
CREATE TABLE artists
(
  artist_id SERIAL PRIMARY KEY
  , artist_name TEXT NOT NULL
);

INSERT INTO artists
  (artist_name)
VALUES
  ('Hanson')
  , ('Queen')
  , ('Mariah Cary')
  , ('Boyz II Men')
  , ('Lady Gaga')
  , ('Bradley Cooper')
  , ('Nickelback')
  , ('Jay Z')
  , ('Alicia Keys')
  , ('Katy Perry')
  , ('Juicy J')
  , ('Maroon 5')
  , ('Christina Aguilera')
  , ('Avril Lavigne')
  , ('Destiny''s Child');

CREATE TABLE producers
(
  producer_id SERIAL PRIMARY KEY
  , producer_name TEXT NOT NULL
);

INSERT INTO producers
  (producer_name)
VALUES
  ('Dust Brothers')
  , ('Stephen Lironi')
  , ('Roy Thomas Baker')
  , ('Walter Afanasieff')
  , ('Benjamin Rice')
  , ('Rick Parashar')
  , ('Al Shux')
  , ('Max Martin')
  , ('Cirkut')
  , ('Shellback')
  , ('Benny Blanco')
  , ('The Matrix')
  , ('Darkchild');

CREATE TABLE albums
  (
    album_id SERIAL PRIMARY KEY
    , album_name TEXT NOT NULL
  );

INSERT INTO albums
  (album_name)
VALUES  
  ('Middle of Nowhere'),
  ('A Night at the Opera'),
  ('Daydream'),
  ('A Star Is Born'),
  ('Silver Side Up'),
  ('The Blueprint 3'),
  ('Prism'),
  ('Hands All Over'),
  ('Let Go'),
  ('The Writing''s on the Wall');

CREATE TABLE songs_new
(
  song_id SERIAL PRIMARY KEY
  , song_name TEXT NOT NULL
  , duration_in_seconds INTEGER NOT NULL
  , release_date DATE NOT NULL
  , album_id INT
  , CONSTRAINT fk_album_id
      FOREIGN KEY(album_id)
      REFERENCES albums(album_id)
);

INSERT INTO songs_new
  (song_name, duration_in_seconds, release_date, album_id)
VALUES
  ('MMMBop', 238, '04-15-1997', 1),
  ('Bohemian Rhapsody', 355, '10-31-1975', 2),
  ('One Sweet Day', 282, '11-14-1995', 3),
  ('Shallow', 216, '09-27-2018', 4),
  ('How You Remind Me', 223, '08-21-2001', 5),
  ('New York State of Mind', 276, '10-20-2009', 6),
  ('Dark Horse', 215, '12-17-2013', 7),
  ('Moves Like Jagger', 201, '06-21-2011', 8),
  ('Complicated', 244, '05-14-2002', 9),
  ('Say My Name', 240, '11-07-1999', 10);

CREATE TABLE songs_artists
(
  song_artist_id SERIAL PRIMARY KEY
  , song_id INT
  , artist_id INT
  , CONSTRAINT fk_song_id
      FOREIGN KEY(song_id)
      REFERENCES songs_new(song_id)
  , CONSTRAINT fk_artist_id
      FOREIGN KEY(artist_id)
      REFERENCES artists(artist_id)
);

INSERT INTO songs_artists
  (song_id, artist_id)
VALUES
  (1,1)
  , (2,2)
  , (3,3)
  , (3,4)
  , (4,5)
  , (4,6)
  , (5,7)
  , (6,8)
  , (6,9)
  , (7,10)
  , (7,11)
  , (8,12)
  , (8,13)
  , (9,14)
  , (10,15);

CREATE TABLE songs_producers
(
  song_producer_id SERIAL PRIMARY KEY
  , song_id INT
  , producer_id INT
  , CONSTRAINT fk_song_id
      FOREIGN KEY(song_id)
      REFERENCES songs_new(song_id)
  , CONSTRAINT fk_producer_id
      FOREIGN KEY(producer_id)
      REFERENCES producers(producer_id)
);

INSERT INTO songs_producers
  (song_id, producer_id)
VALUES
  (1,1)
  , (1,2)
  , (2,3)
  , (3,4)
  , (4,5)
  , (5,6)
  , (6,7)
  , (7,8)
  , (7,9)
  , (8,10)
  , (8,11)
  , (9,12)
  , (10,13);