CREATE TABLE netflix

(
	show_id   VARCHAR(6),
	type	  VARCHAR(10),
	title	  VARCHAR(150),
	director  VARCHAR(208),
	casts	  VARCHAR(1000),
	country	   VARCHAR(150),
	date_added	VARCHAR(50),
	release_year	INT,
	rating	VARCHAR(10),
	duration	VARCHAR(15),
	listed_in	VARCHAR(100),
	description  VARCHAR(250)


);
SELECT * FROM netflix;


--1. Count the number of movies and TV Shows 
SELECT type, COUNT(*) AS TOTAL
FROM netflix
GROUP BY type;


2. Find the most common rating for TVs and movie shows 

SELECT type,rating FROM 

(SELECT  type, rating, count(*), 
RANK() OVER(PARTITION BY type ORDER BY count(*) DESC ) FROM netflix
GROUP BY 1,2) AS T1
WHERE rank = 1;

3. List all movies released in a specific year (e.g 2020)

SELECT Title, type, release_year FROM netflix
WHERE release_year = 2020
AND type = 'Movie';


4. Find the top 5 countries with the most content on netflix

SELECT COUNT(show_id) AS Total_content,
UNNEST(STRING_TO_ARRAY(country,',')) AS countries FROM NETFLIX
GROUP BY 2
ORDER BY 1 DESC LIMIT 5;


5. Identify the longest movie 

SELECT type, title, duration FROM netflix
WHERE type = 'Movie' 
AND duration IS NOT NULL
ORDER BY  CAST(SUBSTRING(duration FROM '[0-9]+') AS INTEGER) DESC
LIMIT 1;

6. Find content added in the last 5 year range 

SELECT Show_id, date_added FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

7. Find all the movies/TV shows Directed by 'Rajiv Chilaka)'

SELECT type,title,UNNEST(STRING_TO_ARRAY(director,',')) AS directors  FROM netflix
WHERE director = 'Rajiv Chilaka';


8. List all TV shows with more tha 5 seasons 

SELECT type, title, duration FROM netflix 
WHERE type = 'TV Show' AND CAST(SUBSTRING(duration FROM '[0-9]+') AS INT) > 5 


9. Count the number of content item in each genre

SELECT COUNT(show_id), 
UNNEST(STRING_TO_ARRAY(listed_in,',')) AS genre FROM netflix
GROUP BY genre

10. Find each year and the average numbers of content released by india on netflix. 
Return top 5 years with highest average content release 

SELECT * FROM netflix;
SELECT 
   EXTRACT (YEAR FROM TO_DATE(date_added, 'Month DD, YYY')) as year,
  ROUND( COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100,2) as avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1

11. List all movies that are documenteries

SELECT * FROM netflix
WHERE
     listed_in ILIKE '%documentaries'

12.Find all content without a director 

SELECT * FROM netflix
WHERE
  director IS NULL

13. Find how many movies actor 'salman Khan' appeared in last 10 years

SELECT * FROM netflix
WHERE casts ILIKE '%Salman Khan%'
AND 
release_year > EXTRACT(YEAR FROM CURRENT_DATE)-10

14. Find the Top 10 actors who have appeared in the highest number of movies produces in india.

SELECT UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
COUNT(*) as total_content
FROM netflix
WHERE country ILIKE 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10


15. Categorize the content based on 
	the presence of the keywords 'kill' and 'violence' in the 
	description field. Label content containing these keywords as 'Bad' and all 
	other content as 'Good'. Count how many items fall into each categoy 



WITH new_table
AS(
SELECT *, 
CASE
WHEN  description ILIKE '%kill%'
OR
description ILIKE '%violence%' THEN 'Bad_Content'
ELSE 'Good_Content'
END AS category
FROM netflix
)
SELECT category, COUNT(*) as Total_content
FROM new_table
GROUP BY 1






