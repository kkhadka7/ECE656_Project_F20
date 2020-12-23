 -- search movies
 https://stackoverflow.com/questions/14290857/sql-select-where-field-contains-words
 SELECT * FROM mytable
WHERE column1 LIKE '%word1%'
   OR column1 LIKE '%word2%'
   OR column1 LIKE '%word3%'
If you need all words to be present, use this:

SELECT * FROM mytable
WHERE column1 LIKE '%word1%'
  AND column1 LIKE '%word2%'
  AND column1 LIKE '%word3%'
 
 -- BY TITLE
 SELECT * FROM movies 
 WHERE title like user_title
 
 SELECT * FROM movies 
 WHERE title like user_title
 
 subquery1 = 'SELECT movieID FROM genres WHERE genre LIKE \'%{}%\''.format(user_genre)
 
 select distinct movieID from movies where title like '%titanic%';
 select distinct movieID from genres where genre like '%adventure%';
 select distinct movieID from keywords where keyword like '%love%';
 
 SELECT * FROM (((select distinct movieID from movies where title like '%titanic%') as table1 INNER JOIN (select distinct movieID from genres where genre like '%adventure%') as table2 ON table1.movieID = table1.movieID) as table3 INNER JOIN (select distinct movieID from keywords where keyword like '%love%') as table4 ON table3.movieID = table4.movieID);


 SELECT * FROM (select table1.movieID from ((select distinct movieID from movies where title like '%titanic%') as table1 
				OUTER JOIN 
				(select distinct movieID from genres where genre like '%adventure%') as table2 ON table1.movieID = table2.movieID)) as table3
				OUTER JOIN
				(select distinct movieID from keywords where keyword like '%love%') as table4 ON table3.movieID=table4.movieID;
 
 subquery2 = 'SELECT moviedID FROM keywords WHERE keyword LIKE \'%{}%\''.format(user_keyword)
 
     #query1 = 'SELECT DISTINCT * FROM movies WHERE title LIKE \'%' + user_title + '%\''
 
 
 
 SELECT 
 
 ((select distinct movieID from genres where genre like '%adventure%' LIMIT 5) 
 UNION
 (select distinct movieID from keywords where keyword like '%love%' LIMIT 5))
 
 SELECT * FROM movies where title like '%titanic%' OR (movieID in 
	((select distinct movieID from genres where genre like '%adventure%') 
	UNION
	(select distinct movieID from keywords where keyword like '%love%')));


SELECT * FROM movies where movieID in  
 ((SELECT distinct movieID FROM movies where title like '%titanic%' ) UNION
 (select distinct movieID from genres where genre like '%adventure%') UNION
 (select distinct movieID from keywords where keyword like '%love%'))
 
 insert into us ers select ratings.userID, users.username, users.address, ratings.movieID, ratings.ratingID  from users right join ratings on users.userID =ratings.userID  limit 15;

INSERT INTO USERS
SELECT * 
FROM (select ratings.userID, users.username, users.address, ratings.movieID, ratings.ratingID  
		from users 
		right join ratings on users.userID =ratings.userID  
		limit 15)




-- Table 8: reviews
DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews(
	reviewID int AUTO INCREMENT,
	userID int NOT NULL, 
	movieID int NOT NULL, 
	review varchar(500), 
	PRIMARY KEY (reviewID, userID, movieID)
);


-- Table 9: users
DROP TABLE IF EXISTS users;
CREATE TABLE users(
	userID int AUTO_INCREMENT,
	username varchar (30) NOT NULL,
	address varchar(50),	
	movieID int,
	ratingID int,
	reviewID int,
	PRIMARY KEY (userID, movieID)
);

-- genres varchar(10) NOT NULL,
DROP TABLE IF EXISTS credits;
CREATE TABLE credits(
	creditsID varchar(50) NOT NULL, -- int NOT NULL, 
	name varchar(50) NOT NULL, 
	movieID int NOT NULL,
	role varchar(50) NOT NULL,
	PRIMARY KEY (creditsID, movieID)
);


DROP TABLE IF EXISTS keywords;
CREATE TABLE keywords(
	movieID int NOT NULL,
	keyword varchar(50) NOT NULL, 
	PRIMARY KEY (movieID) --
);


DROP TABLE IF EXISTS users;
CREATE TABLE users(
	userID int NOT NULL, -- auto increment
	nos_review int NOT NULL, 
	PRIMARY KEY (userID)
);

DROP TABLE IF EXISTS ratings;
CREATE TABLE ratings(
	userID int NOT NULL, 
	movieID int NOT NULL, 
	rating decimal(2,1) NOT NULL,
	PRIMARY KEY (userID, movieID)
);

SHOW TABLES;
DESCRIBE movies;
DESCRIBE credits;
DESCRIBE keywords;
DESCRIBE ratings;
DESCRIBE users;


-- loading data

LOAD DATA LOCAL INFILE './MovieDataset/movies_metadata.csv'
INTO TABLE movies
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@col1, @col2, @col3, genres, @col5, movieID, 
@col7, @col8, @col9, @col10, @col11, @col12, 
production_companies, @col14, release_dates, revenue, 
@col17, @col18, @col19, @col20, title, 
@col22, @col23, @col24);

-- SELECT movieID, title, genres, production_companies, release_dates, revenue
-- FROM movies LIMIT 5; 

LOAD DATA LOCAL INFILE './MovieDataset/credits.csv'
INTO TABLE credits
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@col1, @col2, movieID)
SET casts=@col1, crew=@col1; -- both extract from json @col1 json_extract() 

-- SELECT castID, name, movieID
-- FROM casts LIMIT 5; 



LOAD DATA LOCAL INFILE './MovieDataset/keywords.csv'
INTO TABLE keywords
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(movieID, @col2)
SET keyword=@col2; -- extract from json @col1 json_extract() 

SELECT movieID, keyword
FROM keywords LIMIT 5;


LOAD DATA LOCAL INFILE './MovieDataset/ratings_small.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(userID, @col2, @col3, @col4)
SET nos_review=0; -- add repetitive userid

-- SELECT userID, nos_review
-- FROM users LIMIT 5;

LOAD DATA LOCAL INFILE './MovieDataset/ratings_small.csv'
INTO TABLE review
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(userID, movieID, review)
SET review="hello"; -- add new reviews

-- SELECT userID, movieID, review
-- FROM review LIMIT 5; 

LOAD DATA LOCAL INFILE './MovieDataset/ratings_small.csv'
INTO TABLE ratings
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(userID, movieID, rating, @col4);


-- SELECT userID, movieID, rating
-- FROM ratings LIMIT 5;

-- search the database for movies using keywords, ratings, production companies and so on
-- SELECT COUNT(movieID)
-- FROM ratings 
-- WHERE rating > 3.5
-- LIMIT 5;

-- write comments/rating for the movies
-- INSERT INTO review(userID, movieID, review)
-- VALUES ('1', '800', 'kkkkkk');

-- SELECT userID, movieID, review
-- FROM review
-- WHERE userID = 1
-- LIMIT 5;

-- find movies similar to the ones that the user has watched in the past
SELECT ratings.movieID, userID, genres 
FROM movies JOIN ratings
ON movies.movieID = ratings.movieID
WHERE rating > 3
LIMIT 10; --  AND userID = 1;



-- search movies of the genres that have been highly rated by the user


/*
- search the database for movies using keywords, ratings, production companies and so on
- write comments/rating for the movies
- find movies similar to the ones that the user has watched in the past
- search movies of the genres that have been highly rated by the user
- search for movies that have received good comments
- search movies that other users have also commented in similar words
- link users based on their comments and suggest movies to be watched together
- find movies that are being popular in the user’s location preference

LOAD DATA LOCAL INFILE 'dataset_movies/credits.csv'
INTO TABLE credits 
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;




CREATE TABLE keywords(ID int, keyword varchar(1000));

LOAD DATA LOCAL INFILE 'dataset_movies/keywords.csv'
INTO TABLE keywords
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


CREATE TABLE links_small(movieID int, imdbID int, tmdbID int);

LOAD DATA LOCAL INFILE 'dataset_movies/links_small.csv'
INTO TABLE links_small
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(movieID, @col2, tmdbID);


CREATE TABLE movies_metadata(adult char(5), belongs_to varchar(500), budget int, genres varchar(50), ID int, 
imdb char(20), overview varchar(100),
production_companies varchar(50), release_dates date, revenue int, 
runtime int, spoken_language varchar(50), status char(20), tagline varchar(50), title varchar(50), 
vote_avg float, vote_count int);

LOAD DATA LOCAL INFILE 'dataset_movies/movies_metadata.csv'
INTO TABLE movies_metadata
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(adult, belongs_to, budget, genres, @col5, ID, 
imdb, @col8, @col9, overview, @col11, @col12, 
production_companies, @col14, release_dates, revenue, 
runtime, spoken_language, status, tagline, title, 
@col22, vote_avg, vote_count);

(@col1, @col2, @col3, @col4, @col5, movieID, 
@col7, @col8, @col9, @col10, @col11, @col12, 
@col13, @col14, @col15, @col16, 
@col17, @col18, @col19, @col20, title, 
@col22, @col23, @col24);

CREATE TABLE ratings_small(userID int, movieID int, rating float, timestamp int);

LOAD DATA LOCAL INFILE 'dataset_movies/ratings_small.csv'
INTO TABLE ratings_small
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- SET timestamp  = STR_TO_DATE(@timestamp, '%m/%d/%y');
*/

/*
SHOW TABLES;

-- SELECT ID, cast FROM credits LIMIT 20;
SELECT cast
FROM credits
WHERE JSON_VALID(cast) = 1;

SELECT ID, JSON_VALUE(cast, '$[0].cast_id') AS cast_id
FROM credits LIMIT 5;

SELECT ID, cast-> '$[1].character' AS characters
FROM credits;

	
SELECT ID, 
		JSON_OBJECT(cast, '$[0].cast_id') AS characters	
FROM credits LIMIT 5;

SELECT 
    @path_to_name := json_unquote(json_search(cast, '$[*].cast_id')) AS path_to_name
FROM credits LIMIT 5;    
*/
/*@path_to_parent := trim(TRAILING '.name' from @path_to_name) AS path_to_parent,
    @event_object := json_extract(cast, @path_to_parent) as event_object,
    json_unquote(json_extract(@event_object, '$.id')) as event_id


/*
		JSON_VALUE(cast, '$.gender') AS gender,
		JSON_VALUE(cast, '$.name') AS name
SELECT * FROM credits LIMIT 5;

SELECT * FROM keywords LIMIT 5;
-- SELECT * FROM links LIMIT 5;

SELECT * FROM movies_metadata LIMIT 5;
-- SELECT * FROM ratings LIMIT 5;
SELECT * FROM ratings_small LIMIT 5;
*/

/*
CREATE TABLE links(movieID int, imdbID int, tmdbID int);

LOAD DATA LOCAL INFILE 'dataset_movies/links.csv'
INTO TABLE links
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


CREATE TABLE ratings(userID int, movieID int, rating int, timestamp int);

LOAD DATA LOCAL INFILE 'dataset_movies/ratings.csv'
INTO TABLE ratings
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- SET timestamp  = STR_TO_DATE(@timestamp, '%m/%d/%y');


DROP TABLE IF EXISTS details;
CREATE TABLE details(
	movieID int NOT NULL,
	genre varchar(10) NOT NULL,
	production_companies varchar(50) NOT NULL, 
	release_dates date NOT NULL, 
	revenue int NOT NULL, 
	PRIMARY KEY (movieID) --
);
*/


DROP TABLE IF EXISTS review;
CREATE TABLE review(
	userID int NOT NULL, 
	movieID int NOT NULL, 
	review varchar(100) NOT NULL,
	PRIMARY KEY (userID, movieID)
);