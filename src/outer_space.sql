-- from the terminal run:
-- psql < outer_space.sql

-- Original code
DROP DATABASE IF EXISTS outer_space;

CREATE DATABASE outer_space;

\c outer_space

CREATE TABLE planets
(
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  orbital_period_in_years FLOAT NOT NULL,
  orbits_around TEXT NOT NULL,
  galaxy TEXT NOT NULL,
  moons TEXT[]
);

INSERT INTO planets
  (name, orbital_period_in_years, orbits_around, galaxy, moons)
VALUES
  ('Earth', 1.00, 'The Sun', 'Milky Way', '{"The Moon"}'),
  ('Mars', 1.88, 'The Sun', 'Milky Way', '{"Phobos", "Deimos"}'),
  ('Venus', 0.62, 'The Sun', 'Milky Way', '{}'),
  ('Neptune', 164.8, 'The Sun', 'Milky Way', '{"Naiad", "Thalassa", "Despina", "Galatea", "Larissa", "S/2004 N 1", "Proteus", "Triton", "Nereid", "Halimede", "Sao", "Laomedeia", "Psamathe", "Neso"}'),
  ('Proxima Centauri b', 0.03, 'Proxima Centauri', 'Milky Way', '{}'),
  ('Gliese 876 b', 0.23, 'Gliese 876', 'Milky Way', '{}');

-- New normalized tables
CREATE TABLE galaxies
(
  galaxy_id SERIAL PRIMARY KEY
  , galaxy_name TEXT NOT NULL
);

INSERT INTO galaxies
  (galaxy_name)
VALUES
  ('Milky Way');

CREATE TABLE stars
(
  star_id SERIAL PRIMARY KEY
  , star_name TEXT NOT NULL
  , galaxy_id INT
  , CONSTRAINT fk_galaxy_id
      FOREIGN KEY(galaxy_id)
      REFERENCES galaxies(galaxy_id)
);

INSERT INTO stars
  (star_name, galaxy_id)
VALUES
  ('The Sun', 1),
  ('Proxima Centauri', 1),
  ('Gliese 876', 1);

CREATE TABLE planets_new
(
  planet_id SERIAL PRIMARY KEY
  , planet_name TEXT NOT NULL
  , orbital_period_in_years FLOAT NOT NULL
  , star_id INT
  , CONSTRAINT fk_star_id
      FOREIGN KEY(star_id)
      REFERENCES stars(star_id)
);

INSERT INTO planets_new
  (planet_name, orbital_period_in_years, star_id)
VALUES
  ('Earth', 1.00, 1),
  ('Mars', 1.88, 1),
  ('Venus', 0.62, 1),
  ('Neptune', 164.8, 1),
  ('Proxima Centauri b', 0.03, 2),
  ('Gliese 876 b', 0.23, 3);

CREATE TABLE moons
(
  moon_id SERIAL PRIMARY KEY
  , planet_id INT
  , moon_name TEXT NOT NULL
  , CONSTRAINT fk_planet_id
      FOREIGN KEY(planet_id)
      REFERENCES planets_new(planet_id)
);

INSERT INTO moons
  (planet_id, moon_name)
VALUES
  (1, 'The Moon')
  , (2, 'Phobos')
  , (2, 'Deimos')
  , (4, 'Naiad')
  , (4, 'Thalassa')
  , (4, 'Despina')
  , (4, 'Galatea')
  , (4, 'Larissa')
  , (4, 'S/2004 N 1')
  , (4, 'Proteus')
  , (4, 'Triton')
  , (4, 'Nereid')
  , (4, 'Halimede')
  , (4, 'Sao')
  , (4, 'Laomedeia')
  , (4, 'Psamathe')
  , (4, 'Neso');