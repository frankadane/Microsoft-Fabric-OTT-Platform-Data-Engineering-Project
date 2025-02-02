--1. Date Dimension Table
CREATE TABLE Movies.Date_Dimension (
    full_date DATE ,
    year INT NOT NULL,
    month INT NOT NULL,
    day INT NOT NULL,
    day_name VARCHAR(20),
    month_name VARCHAR(20),
    quarter INT
);

--2. Movie Catalog Dimension Table
CREATE TABLE Movies.Movie_Catalog_Dimension (
    movie_id INT,
    title VARCHAR(255) ,
    imdb_id VARCHAR(20),
    original_language VARCHAR(10),
    genres VARCHAR(255),
    spoken_languages VARCHAR(255)
);


--3. Movie Rating Fact Table
CREATE TABLE Movies.Movie_Rating_Fact (
    movie_id INT NOT NULL,
    vote_average FLOAT NOT NULL,
    vote_count INT NOT NULL,
    status VARCHAR(250),
    release_date_id DATE ,
    runtime_in_mins INT,
    runtime_in_hours FLOAT,
    runtime_category VARCHAR(250),
    budget BIGINT,
    revenue BIGINT,
    popularity FLOAT,
    imdb_category VARCHAR(250),
    AddedDate DATE
);
