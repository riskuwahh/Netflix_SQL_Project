# Netflix Movies and TV shows Data Analysis Using SQL 

![Netflix_Logo](https://github.com/riskuwahh/Netflix_SQL_Project/blob/main/Netflix_Logo_CMYK.png)

THE DATA FOR THIS PROJECT IS SOURCED FROM KAGGLE DATASET 
-**DATASET LINK:**[Movies_Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows/data)



## Project Overview
This project involves analyzing a dataset containing information about Netflix movies and TV shows. By writing SQL queries, we explore various aspects of the content, such as the distribution of movies and TV shows, genre analysis, country-specific content, and much more.

The dataset includes essential information like the title, director, cast, release year, rating, and duration of content. The goal is to use SQL to extract meaningful insights and answer key questions about Netflix’s library.

Files in this Repository
- **netflix_dataset.csv**: The dataset containing detailed information about Netflix movies and TV shows.
- **netflix_analysis.sql**: The SQL script that contains various queries used to analyze the dataset.
- **Netflix_Logo_CMYK.png**: The Netflix logo used for visual aesthetics in this project.

Dataset Details
The dataset consists of the following fields:

- `show_id`: Unique identifier for each movie or TV show.
- `type`: Whether the content is a Movie or a TV Show.
- `title`: The title of the movie or TV show.
- `director`: Director of the content.
- `casts`: The cast members involved in the movie or show.
- `country`: The country where the content was produced.
- `date_added`: The date when the content was added to Netflix.
- `release_year`: The year the movie or show was released.
- `rating`: The content's rating (e.g., PG, R, TV-MA).
- `duration`: Duration of the content (in minutes for movies and seasons for TV shows).
- `listed_in`: Genres or categories the content belongs to.
- `description`: A brief description of the content.


## SCHEMAS
```sql
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
```

## Business Problems and Solutions 

### 1. Count the number of movies and TV Shows
```sql
SELECT type, COUNT(*) AS TOTAL
FROM netflix
GROUP BY type;
```


### 2. Find the most common rating for TVs and movie shows 
```sql
SELECT type,rating FROM 

(SELECT  type, rating, count(*), 
RANK() OVER(PARTITION BY type ORDER BY count(*) DESC ) FROM netflix
GROUP BY 1,2) AS T1
WHERE rank = 1;
```

### 3. List all movies released in a specific year (e.g 2020)
```sql

SELECT Title, type, release_year FROM netflix
WHERE release_year = 2020
AND type = 'Movie';
```


### 4. Find the top 5 countries with the most content on netflix
```sql
SELECT COUNT(show_id) AS Total_content,
UNNEST(STRING_TO_ARRAY(country,',')) AS countries FROM NETFLIX
GROUP BY 2
ORDER BY 1 DESC LIMIT 5;
```


### 5. Identify the longest movie
```sql
SELECT type, title, duration FROM netflix
WHERE type = 'Movie' 
AND duration IS NOT NULL
ORDER BY  CAST(SUBSTRING(duration FROM '[0-9]+') AS INTEGER) DESC
LIMIT 1;
```

### 6. Find content added in the last 5-year range

```sql
SELECT show_id, date_added 
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

### 7. Find all the movies/TV shows directed by 'Rajiv Chilaka'

```sql
SELECT type, title, UNNEST(STRING_TO_ARRAY(director, ',')) AS directors  
FROM netflix
WHERE director = 'Rajiv Chilaka';
```

### 8. List all TV shows with more than 5 seasons

```sql
SELECT type, title, duration 
FROM netflix 
WHERE type = 'TV Show' 
AND CAST(SUBSTRING(duration FROM '[0-9]+') AS INT) > 5;
```

### 9. Count the number of content items in each genre

```sql
SELECT COUNT(show_id), 
UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre 
FROM netflix
GROUP BY genre;
```

### 10. Find each year and the average number of content releases by India on Netflix (Top 5 years)

```sql
SELECT EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
ROUND(COUNT(*)::numeric / (SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100, 2) AS avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY year
ORDER BY avg_content_per_year DESC
LIMIT 5;
```

### 11. List all movies that are documentaries

```sql
SELECT * FROM netflix
WHERE listed_in ILIKE '%documentaries%';
```

### 12. Find all content without a director

```sql
SELECT * FROM netflix
WHERE director IS NULL;
```

### 13. Find how many movies actor 'Salman Khan' appeared in the last 10 years

```sql
SELECT * FROM netflix
WHERE casts ILIKE '%Salman Khan%'
AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

### 14. Find the Top 10 actors who have appeared in the highest number of movies produced in India

```sql
SELECT UNNEST(STRING_TO_ARRAY(casts, ',')) AS actors,
COUNT(*) AS total_content
FROM netflix
WHERE country ILIKE 'India'
GROUP BY actors
ORDER BY total_content DESC
LIMIT 10;
```

### 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description

```sql
WITH new_table AS (
  SELECT *, 
    CASE 
      WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad_Content'
      ELSE 'Good_Content'
    END AS category
  FROM netflix
)
SELECT category, COUNT(*) AS total_content
FROM new_table
GROUP BY category;
```

## Findings and Conclusion
### Findings:
-Distribution of Movies and TV Shows: The dataset contains both movies and TV shows, and by counting their occurrences, we observe a higher number of movies compared to TV shows in the Netflix library.

-Most Common Ratings: For both movies and TV shows, specific ratings like TV-MA and PG-13 are more frequent, indicating that Netflix has a substantial amount of content for mature audiences as well as teens.

-Content Distribution by Country: The top five countries with the most content on Netflix include United States, India, United Kingdom, Canada, and France, showcasing a diverse range of international content.

-Longest Movie: By analyzing the duration, we identified the longest movie in the Netflix library, providing insight into how Netflix caters to various user preferences, including long-form content.

-Content Added in Recent Years: Netflix continues to grow its library significantly, with a substantial portion of content being added in the last five years, indicating Netflix's aggressive expansion strategy.

-Content Genres: A breakdown of genres reveals that Netflix has a broad range of content, from documentaries and dramas to thrillers and comedies, appealing to a wide variety of viewer interests.

## Conclusion:
-The SQL queries used in this analysis provide a comprehensive overview of Netflix’s content library, revealing interesting patterns and trends.

-The platform offers a diverse range of genres, with significant international content, particularly from countries like the US and India.

-Netflix's content rating system reflects its effort to cater to various audience demographics, with an emphasis on mature audiences.

-The platform is continuously updating its library, ensuring fresh content is available for viewers, particularly in recent years.

-This project highlights the value of SQL in extracting meaningful insights from large datasets and can be expanded further to explore even deeper aspects of the Netflix content library.
