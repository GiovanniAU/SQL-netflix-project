-- =============================================
-- Netflix Content Analysis Project
-- =============================================
-- File: netflix_analysis.sql
-- Description: Complete SQL analysis of Netflix content library
-- Author: [Il tuo nome]
-- Created: January 2025
-- =============================================

-- -----------------------------
-- 1. DATABASE STRUCTURE SETUP
-- -----------------------------
-- Optimize table structure with appropriate field lengths

-- Unique identifier optimization
ALTER TABLE netflix MODIFY show_id varchar(6);

-- Content type field (Movie/TV Show)
ALTER TABLE netflix MODIFY type varchar(10);

-- Title field optimization
ALTER TABLE netflix MODIFY title varchar(150);

-- Director field optimization
ALTER TABLE netflix modify director varchar(208);

-- Cast field - allowing for multiple actors
ALTER TABLE netflix MODIFY casts varchar(1000);

-- Country field optimization
ALTER TABLE netflix MODIFY country varchar(150);

-- Date added field
ALTER TABLE netflix MODIFY date_added varchar(50);

-- Rating field optimization
ALTER TABLE netflix MODIFY rating varchar(10);

-- Duration field optimization
ALTER TABLE netflix MODIFY duration varchar(15);

-- Genre field optimization
ALTER TABLE netflix MODIFY listed_in varchar(25);

-- Description field optimization
ALTER TABLE netflix MODIFY description varchar(250);

-- -----------------------------
-- 2. BASIC CONTENT ANALYSIS
-- -----------------------------

-- Total content count
SELECT COUNT(*) FROM netflix as total;

-- Distinct content types
SELECT DISTINCT type FROM netflix;

-- Content distribution by type
SELECT
    type,
    count(*) as total_type
FROM netflix
GROUP BY type;

-- -----------------------------
-- 3. RATING ANALYSIS
-- -----------------------------

-- Most common rating by content type
SELECT 
    type,
    rating
FROM (
    SELECT 
        type,
        rating, 
        count(*),
        RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
    FROM netflix
    GROUP BY type, rating 
    ORDER BY 1, 3 DESC
) as t1
WHERE ranking = 1;

-- -----------------------------
-- 4. TEMPORAL ANALYSIS
-- -----------------------------

-- Movies distribution by year
SELECT 
    release_year,
    COUNT(*) as total_movies
FROM netflix 
WHERE type = 'Movie'
GROUP BY release_year
ORDER BY release_year DESC;

-- TV Shows distribution by year
SELECT 
    release_year,
    COUNT(*) as total_shows
FROM netflix 
WHERE type = 'TV Show'
GROUP BY release_year
ORDER BY release_year DESC;

-- -----------------------------
-- 5. GEOGRAPHICAL ANALYSIS
-- -----------------------------

-- Content count by country
SELECT 
    country,
    count(show_id) as total_content
FROM netflix
GROUP BY 1;

-- Top 5 producing countries (handling multiple countries)
WITH RECURSIVE numbers AS (
    SELECT 1 AS num
    UNION ALL
    SELECT num + 1
    FROM numbers
    WHERE num <= 100
)
SELECT 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(country, ',', numbers.num), ',', -1)) AS new_country
FROM netflix
JOIN numbers ON numbers.num <= CHAR_LENGTH(country) - CHAR_LENGTH(REPLACE(country, ',', '')) + 1
WHERE country IS NOT NULL 
    AND TRIM(country) != ''  
GROUP BY new_country
ORDER BY COUNT(new_country) DESC
LIMIT 5;

-- -----------------------------
-- 6. DURATION ANALYSIS
-- -----------------------------

-- Content duration categorization
SELECT 
    type AS content_type,
    CASE 
        WHEN type = 'Movie' AND duration LIKE '%min%' THEN 
            CASE 
                WHEN CAST(SUBSTRING(duration, 1, LENGTH(duration) - 4) AS UNSIGNED) < 60 THEN 'Short'
                WHEN CAST(SUBSTRING(duration, 1, LENGTH(duration) - 4) AS UNSIGNED) >= 60 
                     AND CAST(SUBSTRING(duration, 1, LENGTH(duration) - 4) AS UNSIGNED) <= 120 THEN 'Medium'
                WHEN CAST(SUBSTRING(duration, 1, LENGTH(duration) - 4) AS UNSIGNED) > 120 THEN 'Long'
                ELSE 'Unknown'
            END
        WHEN type = 'TV Show' AND (duration LIKE '%Season%' OR duration LIKE '%Seasons%') THEN 
            CASE 
                WHEN CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) BETWEEN 1 AND 2 THEN 'Short'
                WHEN CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) BETWEEN 3 AND 4 THEN 'Medium'
                WHEN CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) >= 5 THEN 'Long'
                ELSE 'Unknown'
            END
        WHEN duration IS NULL THEN 'Unknown'
        ELSE 'Unknown'
    END AS duration_category,
    COUNT(show_id) AS total_content
FROM netflix
WHERE duration IS NOT NULL
GROUP BY content_type, duration_category
ORDER BY content_type, 
    CASE duration_category 
        WHEN 'Short' THEN 1
        WHEN 'Medium' THEN 2
        WHEN 'Long' THEN 3
        ELSE 4
    END;

-- -----------------------------
-- 7. INTERESTING FINDINGS
-- -----------------------------

-- Oldest Movie
SELECT *
FROM netflix
WHERE type = 'Movie'
ORDER BY release_year ASC
LIMIT 1;

-- Oldest TV Show
SELECT *
FROM netflix
WHERE type = 'TV Show'
ORDER BY release_year ASC
LIMIT 1;

-- Most productive directors
SELECT 
    director,
    COUNT(*) as total_content,
    GROUP_CONCAT(DISTINCT type) as content_types,
    GROUP_CONCAT(DISTINCT rating) as ratings
FROM netflix
WHERE director IS NOT NULL AND director != ''
GROUP BY director
HAVING total_content > 3
ORDER BY total_content DESC
LIMIT 10;