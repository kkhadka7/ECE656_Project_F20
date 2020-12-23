-- creating database
SHOW DATABASES;
DROP DATABASE IF EXISTS ProjectDB;
CREATE DATABASE ProjectDB;
USE ProjectDB;


-- creating tables and loading data from .csv dataset 
-- Table 1: movies
DROP TABLE IF EXISTS movies;
CREATE TABLE movies(
	movieID int NOT NULL, 
	title varchar(110) NOT NULL, 
	lang char(2),
	budget float,
	revenue float,
	releasedate date,
	PRIMARY KEY (movieID)
);
-- loading data into Table 1: movies
LOAD DATA LOCAL INFILE './MovieDataset/movies_df.csv'
INTO TABLE movies
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(movieID, title, lang, budget, revenue,releasedate);


-- Table 2: genres
DROP TABLE IF EXISTS genres;
CREATE TABLE genres(
	genreID int NOT NULL, 
	movieID int NOT NULL, 
	genre varchar(20) NOT NULL, 
	PRIMARY KEY (genreID, movieID)
);
-- loading data into Table 2: genres
LOAD DATA LOCAL INFILE './MovieDataset/genres_df.csv'
INTO TABLE genres
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(genreID, movieID, genre);


-- Table 3: companies
DROP TABLE IF EXISTS companies;
CREATE TABLE companies(
	companyID int NOT NULL, 
	movieID int NOT NULL, 
	companyname varchar(110) NOT NULL, 
	PRIMARY KEY (companyID, movieID)
);
-- loading data into Table 3: companies
LOAD DATA LOCAL INFILE './MovieDataset/production_companies_df.csv'
INTO TABLE companies
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(companyID, movieID, companyname);


-- Table 4: casts
DROP TABLE IF EXISTS casts;
CREATE TABLE casts(
	castID int NOT NULL, 
	movieID int NOT NULL, 
	name varchar(50) NOT NULL, 
	characterplayed varchar(400) NOT NULL,
	gender int,
	PRIMARY KEY (castID, movieID)
);
-- loading data into Table 4: casts
LOAD DATA LOCAL INFILE './MovieDataset/cast_credits_df.csv'
INTO TABLE casts
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(castID, movieID, name, characterplayed, gender);


-- Table 5: crews
DROP TABLE IF EXISTS crews;
CREATE TABLE crews(
	crewID int NOT NULL, 
	movieID int NOT NULL, 
	name varchar(50) NOT NULL,
	department varchar(25) NOT NULL,
	job varchar(60) NOT NULL,	
	gender int NOT NULL,
	PRIMARY KEY (crewID, movieID)
);
-- loading data into Table 5: crews
LOAD DATA LOCAL INFILE './MovieDataset/crew_credits_df.csv'
INTO TABLE crews
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(crewID, movieID, name, department,job, gender);


-- Table 6: keywords
DROP TABLE IF EXISTS keywords;
CREATE TABLE keywords(
	keyID int NOT NULL, 
	movieID int NOT NULL, 
	keyword varchar(50) NOT NULL, 
	PRIMARY KEY (keyID, movieID)
);
-- loading data into Table 6: keywords
LOAD DATA LOCAL INFILE './MovieDataset/keywords_df.csv'
INTO TABLE keywords
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(keyID, movieID, keyword);



-- Table 7: ratings
DROP TABLE IF EXISTS ratings;
CREATE TABLE ratings(
	ratingID int AUTO_INCREMENT,
	userID int NOT NULL, 
	movieID int NOT NULL, 
	rating float, 
	review varchar(500),
	PRIMARY KEY (ratingID, userID, movieID)
);
-- loading data into Table 7: ratings
LOAD DATA LOCAL INFILE './MovieDataset/ratings_df.csv'
INTO TABLE ratings
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(userID, movieID, rating);


-- Table 8: users
DROP TABLE IF EXISTS users;
CREATE TABLE users(
	userID int AUTO_INCREMENT,
	username varchar (30) DEFAULT 'defaultUser',
	address varchar(50) DEFAULT 'defaultAddress',	
	movieID int,
	ratingID int,
	PRIMARY KEY (userID, movieID)
);

-- Add contents to Table 8: users content from existing Table 7: ratings
INSERT INTO users(userID, movieID, ratingID)
SELECT * FROM (
		SELECT ratings.userID, ratings.movieID ,ratings.ratingID 
		FROM users RIGHT JOIN ratings ON users.userID=ratings.userID) 
		AS TableX;
