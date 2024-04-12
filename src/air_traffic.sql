-- from the terminal run:
-- psql < air_traffic.sql

-- Initial schema
DROP DATABASE IF EXISTS air_traffic;

CREATE DATABASE air_traffic;

\c air_traffic

CREATE TABLE tickets
(
  id SERIAL PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  seat TEXT NOT NULL,
  departure TIMESTAMP NOT NULL,
  arrival TIMESTAMP NOT NULL,
  airline TEXT NOT NULL,
  from_city TEXT NOT NULL,
  from_country TEXT NOT NULL,
  to_city TEXT NOT NULL,
  to_country TEXT NOT NULL
);

INSERT INTO tickets
  (first_name, last_name, seat, departure, arrival, airline, from_city, from_country, to_city, to_country)
VALUES
  ('Jennifer', 'Finch', '33B', '2018-04-08 09:00:00', '2018-04-08 12:00:00', 'United', 'Washington DC', 'United States', 'Seattle', 'United States'),
  ('Thadeus', 'Gathercoal', '8A', '2018-12-19 12:45:00', '2018-12-19 16:15:00', 'British Airways', 'Tokyo', 'Japan', 'London', 'United Kingdom'),
  ('Sonja', 'Pauley', '12F', '2018-01-02 07:00:00', '2018-01-02 08:03:00', 'Delta', 'Los Angeles', 'United States', 'Las Vegas', 'United States'),
  ('Jennifer', 'Finch', '20A', '2018-04-15 16:50:00', '2018-04-15 21:00:00', 'Delta', 'Seattle', 'United States', 'Mexico City', 'Mexico'),
  ('Waneta', 'Skeleton', '23D', '2018-08-01 18:30:00', '2018-08-01 21:50:00', 'TUI Fly Belgium', 'Paris', 'France', 'Casablanca', 'Morocco'),
  ('Thadeus', 'Gathercoal', '18C', '2018-10-31 01:15:00', '2018-10-31 12:55:00', 'Air China', 'Dubai', 'UAE', 'Beijing', 'China'),
  ('Berkie', 'Wycliff', '9E', '2019-02-06 06:00:00', '2019-02-06 07:47:00', 'United', 'New York', 'United States', 'Charlotte', 'United States'),
  ('Alvin', 'Leathes', '1A', '2018-12-22 14:42:00', '2018-12-22 15:56:00', 'American Airlines', 'Cedar Rapids', 'United States', 'Chicago', 'United States'),
  ('Berkie', 'Wycliff', '32B', '2019-02-06 16:28:00', '2019-02-06 19:18:00', 'American Airlines', 'Charlotte', 'United States', 'New Orleans', 'United States'),
  ('Cory', 'Squibbes', '10D', '2019-01-20 19:30:00', '2019-01-20 22:45:00', 'Avianca Brasil', 'Sao Paolo', 'Brazil', 'Santiago', 'Chile');

-- New schema
CREATE TABLE airlines
(
  airline_id SERIAL PRIMARY KEY
  , airline_name TEXT NOT NULL
);

INSERT INTO airlines
  (airline_name)
VALUES
  ('United')
  , ('British Airways')
  , ('Delta')
  , ('TUI Fly Belgium')
  , ('Air China')
  , ('American Airlines')
  , ('Avianca Brasil');

CREATE TABLE countries
(
  country_id SERIAL PRIMARY KEY
  , country_name TEXT NOT NULL
);

INSERT INTO countries
  (country_name)
VALUES
('Brazil'),
 ('Chile'),
 ('China'),
 ('France'),
 ('Japan'),
 ('Mexico'),
 ('Morocco'),
 ('UAE'),
 ('United Kingdom'),
 ('United States');

CREATE TABLE cities
(
  city_id SERIAL PRIMARY KEY
  , city_name TEXT NOT NULL
  , country_id INT
  , CONSTRAINT fk_country_id
      FOREIGN KEY(country_id)
      REFERENCES countries(country_id)
);

INSERT INTO cities
  (city_name, country_id)
VALUES
('Sao Paolo', 1),
 ('Santiago', 2),
 ('Beijing', 3),
 ('Paris', 4),
 ('Tokyo', 5),
 ('Mexico City', 6),
 ('Casablanca', 7),
 ('Dubai', 8),
 ('London', 9),
 ('Seattle', 10),
 ('Washington DC', 10),
 ('Chicago', 10),
 ('Los Angeles', 10),
 ('Charlotte', 10),
 ('Cedar Rapids', 10),
 ('New York', 10),
 ('New Orleans', 10),
 ('Las Vegas', 10);

CREATE TABLE flights
(
  flight_id SERIAL PRIMARY KEY
  , departure_time TIMESTAMP NOT NULL
  , arrival_time TIMESTAMP NOT NULL
  , airline_id INT
  , from_city_id INT
  , to_city_id INT
  , CONSTRAINT fk_airline_id
      FOREIGN KEY(airline_id)
      REFERENCES airlines(airline_id)
  , CONSTRAINT fk_from_city_id
      FOREIGN KEY(from_city_id)
      REFERENCES cities(city_id)
  , CONSTRAINT fk_to_city_id
      FOREIGN KEY(to_city_id)
      REFERENCES cities(city_id)
);

INSERT INTO flights
  (departure_time, arrival_time, airline_id, from_city_id, to_city_id)
VALUES
('2019-01-20 19:30:00', '2019-01-20 22:45:00', 7, 1, 2),
 ('2018-08-01 18:30:00', '2018-08-01 21:50:00', 4, 4, 7),
 ('2018-12-19 12:45:00', '2018-12-19 16:15:00', 2, 5, 9),
 ('2018-10-31 01:15:00', '2018-10-31 12:55:00', 5, 8, 3),
 ('2018-04-15 16:50:00', '2018-04-15 21:00:00', 3, 10, 6),
 ('2018-04-08 09:00:00', '2018-04-08 12:00:00', 1, 11, 10),
 ('2018-01-02 07:00:00', '2018-01-02 08:03:00', 3, 13, 18),
 ('2019-02-06 16:28:00', '2019-02-06 19:18:00', 6, 14, 17),
 ('2018-12-22 14:42:00', '2018-12-22 15:56:00', 6, 15, 12),
 ('2019-02-06 06:00:00', '2019-02-06 07:47:00', 1, 16, 14);

CREATE TABLE customers
(
  cust_id SERIAL PRIMARY KEY
  , first_name TEXT NOT NULL
  , last_name TEXT NOT NULL
);

INSERT INTO customers
  (first_name, last_name)
VALUES
 ('Alvin', 'Leathes'),
 ('Berkie', 'Wycliff'),
 ('Cory', 'Squibbes'),
 ('Jennifer', 'Finch'),
 ('Sonja', 'Pauley'),
 ('Thadeus', 'Gathercoal'),
 ('Waneta', 'Skeleton');

 CREATE TABLE seat_numbers
 (
  seat_id SERIAL PRIMARY KEY
  , seat_number TEXT NOT NULL
 );

INSERT INTO seat_numbers
  (seat_number)
VALUES
 ('10D'),
 ('23D'),
 ('8A'),
 ('18C'),
 ('20A'),
 ('33B'),
 ('12F'),
 ('32B'),
 ('1A'),
 ('9E');

CREATE TABLE customers_flights
 (
  cust_flight_id SERIAL PRIMARY KEY
  , cust_id INT
  , flight_id INT
  , seat_id INT
  , CONSTRAINT fk_cust_id
      FOREIGN KEY(cust_id)
      REFERENCES customers(cust_id)
  , CONSTRAINT fk_flight_id
      FOREIGN KEY(flight_id)
      REFERENCES flights(flight_id)
  , CONSTRAINT fk_seat_id
      FOREIGN KEY(seat_id)
      REFERENCES seat_numbers(seat_id)
 );

INSERT INTO customers_flights
  (cust_id, flight_id, seat_id)
VALUES
 (3, 1, 1),
 (7, 2, 2),
 (6, 3, 3),
 (6, 4, 4),
 (4, 5, 5),
 (4, 6, 6),
 (5, 7, 7),
 (2, 8, 8),
 (1, 9, 9),
 (2, 10, 10);