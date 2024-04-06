DROP DATABASE IF EXISTS craigslist;

CREATE DATABASE craigslist;

\c craigslist

-- Physicians table
CREATE TABLE regions
(
    region_id SERIAL PRIMARY KEY
    , region_name TEXT NOT NULL
    , population_num INT
);

INSERT INTO regions
    (region_name, population_num)
VALUES
    ('West Coast', 53000000)
    , ('New England', 15000000);

-- Individuals
CREATE TABLE individuals
(
    user_id SERIAL PRIMARY KEY
    , first_name TEXT NOT NULL
    , last_name TEXT NOT NULL
    , preferred_region_id INT
    , CONSTRAINT fk_preferred_region_id
        FOREIGN KEY(preferred_region_id)
        REFERENCES regions(region_id)
);

INSERT INTO individuals
    (first_name, last_name, preferred_region_id)
VALUES
    ('Peter', 'Griffin', 2)
    , ('Homer', 'Simpson', 1);

-- Categories
CREATE TABLE categories
(
    category_id SERIAL PRIMARY KEY
    , category_name TEXT NOT NULL
    , category_desc TEXT NOT NULL
);

INSERT INTO categories
    (category_name, category_desc)
VALUES
    ('Technology', 'Listings for technical expertise')
    , ('Deliveries', 'Listings for delivery services');

-- Posts
CREATE TABLE posts
(
    post_id SERIAL PRIMARY KEY
    , title TEXT NOT NULL
    , post_text TEXT NOT NULL
    , post_location TEXT NOT NULL
    , user_id INT
    , post_region_id INT
    , category_id INT
    , CONSTRAINT fk_user_id
        FOREIGN KEY(user_id)
        REFERENCES individuals(user_id)
    , CONSTRAINT fk_post_region_id
        FOREIGN KEY(post_region_id)
        REFERENCES regions(region_id)
    , CONSTRAINT fk_category_id
        FOREIGN KEY(category_id)
        REFERENCES categories(category_id)
);

INSERT INTO posts
    (title, post_text, post_location, user_id, post_region_id, category_id)
VALUES
    ('Pizza delivery', 'I need someone to deliver my pizza tonight! Call 555-5555.',
    'New York Hotel', 2, 2, 2)
    , ('Drop off couch', 'I need someone to deliver new couch from the store. Call 555-5555.',
    '123 Western Lane', 2, 1, 2)
    , ('Time Travel', 'Looking for someone to go back in time with me. Safety not guaranteed.',
    '123 Quahog Lane', 1, 2, 1);

/*
select
	a.post_id
	, b.first_name || ' ' || b.last_name as poster_name
	, c.category_name 
	, c.category_desc
	, a.title
	, a.post_text
	, a.post_location
	, d.region_name as post_region_name
	, e.region_name as preferred_region_name
from
	posts a
inner join 
	individuals b
	on a.user_id = b.user_id
inner join 
	categories c
	on a.category_id = c.category_id
inner join 
	regions d
	on a.post_region_id = d.region_id
inner join 
	regions e
	on b.preferred_region_id = e.region_id;
*/