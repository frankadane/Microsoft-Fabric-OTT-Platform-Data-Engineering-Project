---Stored Procedure for Daily Updates
CREATE PROCEDURE Movies.Update_Dimensions_And_Fact_Table
AS
BEGIN

    -- Update Date Dimension
    INSERT INTO Movies.Date_Dimension (full_date, year, month, day, day_name, month_name, quarter)
    SELECT DISTINCT 
        CAST(release_date AS DATE) AS full_date,
        YEAR(release_date) AS year,
        MONTH(release_date) AS month,
        DAY(release_date) AS day,
        DATENAME(WEEKDAY, release_date) AS day_name,
        DATENAME(MONTH, release_date) AS month_name,
        CEILING(MONTH(release_date) / 3.0) AS quarter
    FROM movies.staging_movies_rating smr
    WHERE NOT EXISTS (
        SELECT 1 FROM Movies.Date_Dimension dd WHERE dd.full_date = CAST(smr.release_date AS DATE)
    );

    -- Update Movie Catalog Dimension
    INSERT INTO Movies.Movie_Catalog_Dimension (movie_id, title, imdb_id, original_language, genres, spoken_languages)
    SELECT DISTINCT
        smr.id AS movie_id,
        smr.title,
        smr.imdb_id,
        smr.original_language,
        smr.genres,
        smr.spoken_languages
    FROM movies.staging_movies_rating smr
    WHERE NOT EXISTS (
        SELECT 1 FROM Movies.Movie_Catalog_Dimension mcd WHERE mcd.movie_id = smr.id
    );

    -- Update Movie Rating Fact Table
    INSERT INTO Movies.Movie_Rating_Fact (movie_id, vote_average, vote_count, status, release_date_id, runtime_in_mins, runtime_in_hours, runtime_category, budget, revenue, popularity, imdb_category)
    SELECT 
        smr.id AS movie_id,
        smr.vote_average,
        smr.vote_count,
        smr.status,
        dd.full_date AS release_date_id,
        smr.RuntimeInMins,
        smr.RuntimeInHours,
        smr.Runtime_Category,
        smr.budget,
        smr.revenue,
        smr.popularity,
        smr.IMDB_Category
    FROM movies.staging_movies_rating smr
    JOIN Movies.Date_Dimension dd
        ON CAST(smr.release_date AS DATE) = dd.full_date;
END;
