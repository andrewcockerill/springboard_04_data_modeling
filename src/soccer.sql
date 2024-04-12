DROP DATABASE IF EXISTS soccer;

CREATE DATABASE soccer;

\c soccer

-- Seasons
CREATE TABLE seasons
(
    season_id SERIAL PRIMARY KEY
    , season_start_date DATE
    , season_end_date DATE
);

INSERT INTO seasons
    (season_start_date, season_end_date)
VALUES
    ('2022-08-01', '2023-02-01');

-- Games
CREATE TABLE games
(
    game_id SERIAL PRIMARY KEY
    , game_date DATE
    , season_id INT
    , CONSTRAINT fk_season_id
        FOREIGN KEY(season_id)
        REFERENCES seasons(season_id)
);

INSERT INTO games
    (game_date, season_id)
VALUES
    ('2022-08-01', 1)
    , ('2022-12-01', 1)
    , ('2023-02-01', 1);

-- Teams
CREATE TABLE teams
(
    team_id SERIAL PRIMARY KEY
    , team_city TEXT NOT NULL
    , team_name TEXT NOT NULL
);

INSERT INTO teams
    (team_city, team_name)
VALUES
    ('Dallas', 'Cattlemen')
    , ('Las Vegas', 'Llamas')
    , ('San Francisco', 'Trolleys');

-- Referees
CREATE TABLE referees
(
    referee_id SERIAL PRIMARY KEY
    , first_name TEXT NOT NULL
    , last_name TEXT NOT NULL
);

INSERT INTO referees
    (first_name, last_name)
VALUES
    ('Velma', 'Dinkley')
    , ('J. Qunicy', 'Magoo');

-- Players
CREATE TABLE players
(
    player_id SERIAL PRIMARY KEY
    , first_name TEXT NOT NULL
    , last_name TEXT NOT NULL
    , team_id INT
    , CONSTRAINT fk_team_id
        FOREIGN KEY(team_id)
        REFERENCES teams(team_id)
);

INSERT INTO players
    (first_name, last_name, team_id)
VALUES
    ('Troy', 'Smith', 1)
    , ('Deion', 'Irvin', 1)
    , ('Teller', 'Jillette', 2)
    , ('Lucky', 'Duckworth', 2)
    , ('Steve', 'Montana', 3)
    , ('Jerry', 'McCaffrey', 3);

-- Matchups
CREATE TABLE matchups
(
    matchup_id SERIAL PRIMARY KEY
    , game_id INT
    , team_id INT
    , CONSTRAINT fk_game_id
        FOREIGN KEY(game_id)
        REFERENCES games(game_id)
);

INSERT INTO matchups
    (game_id, team_id)
VALUES
    (1, 1)
    , (1, 2)
    , (2, 1)
    , (2, 3)
    , (3, 2)
    , (3, 3);

-- Officators
CREATE TABLE officiators
(
    officiator_id SERIAL PRIMARY KEY
    , referee_id INT
    , game_id INT
    , CONSTRAINT fk_referee_id
        FOREIGN KEY(referee_id)
        REFERENCES referees(referee_id)
    , CONSTRAINT fk_game_id
        FOREIGN KEY(game_id)
        REFERENCES games(game_id)
);

INSERT INTO officiators
    (referee_id, game_id)
VALUES
    (1, 1),
    (2, 2),
    (1, 3),
    (2, 3);

-- Goals
CREATE TABLE goals
(
    goal_id SERIAL PRIMARY KEY
    , game_clock_time INT
    , game_id INT
    , player_id INT
    , CONSTRAINT fk_game_id
        FOREIGN KEY(game_id)
        REFERENCES games(game_id)
    , CONSTRAINT fk_player_id
        FOREIGN KEY(player_id)
        REFERENCES players(player_id)
);

INSERT INTO goals
    (game_clock_time, game_id, player_id)
VALUES
    (5, 1, 3)
    , (15, 1, 4)
    , (8, 2, 5)
    , (10, 3, 6);

/*
with team_game_points as
(select
	b.game_id
	, c.team_id
 	, f.team_city
 	, f.team_name
	, sum(case when e.player_id is not null then 1 else 0 end) as goals
from
	seasons a
inner join 
	games b
	on a.season_id = b.season_id
inner join 
	matchups c
	on b.game_id = c.game_id
inner join 
	players d
	on c.team_id = d.team_id
left join 
	goals e
	on d.player_id = e.player_id
 	and b.game_id = e.game_id
inner join 
 	teams f
 	on c.team_id = f.team_id
where 
 	a.season_id = 1
group by 
	b.game_id
	, c.team_id
	, f.team_city
	, f.team_name),
	
differentials as
(select
	game_id
	, team_id
 	, team_city
 	, team_name
	, goals
	, goals - lead(goals) over (partition by game_id order by team_id) as differential
	, lead(team_id) over (partition by game_id order by team_id) as opp_team
	, row_number() over (partition by game_id order by team_id) as rn
from
	team_game_points),
	
win_ids as
(select
	*
	, case
		when differential > 0 then team_id
		when differential < 0 then opp_team
		else null end as winning_team_id
from 
	differentials
where 
	rn = 1),
	
game_counts as
(select 
	team_id
	, team_city
	, team_name
	, count(*) as games_played
from 
	team_game_points
group by 
	team_id 
	, team_city
	, team_name)
	
select 
	a.team_city
	, a.team_name
	, a.games_played
	, sum(case when a.team_id = b.winning_team_id then 1 else 0 end) as wins
	, a.games_played - sum(case when a.team_id = b.winning_team_id then 1 else 0 end) as losses
from
	game_counts a
left join 
	win_ids b
	on a.team_id = b.winning_team_id
group by 
	a.team_city
	, a.team_name
	, a.games_played
order by 
	wins desc;
*/