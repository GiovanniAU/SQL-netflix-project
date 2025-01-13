# Netflix Content Analysis Project

## Overview
This project analyzes Netflix's content library using SQL to extract meaningful insights about streaming content, regional distribution, content types, and viewing patterns. The analysis focuses on various aspects such as content duration, ratings, release trends, and geographical distribution.

## Database Structure
The database contains a primary table with the following columns:
- `show_id` (varchar(6)): Unique identifier for each show
- `type` (varchar(10)): Content type (Movie/TV Show)
- `title` (varchar(150)): Title of the content
- `director` (varchar(208)): Director(s) of the content
- `casts` (varchar(1000)): Cast members
- `country` (varchar(150)): Country/countries of production
- `date_added` (varchar(50)): Date when added to Netflix
- `rating` (varchar(10)): Content rating
- `duration` (varchar(15)): Duration (in minutes for movies, seasons for TV shows)
- `listed_in` (varchar(25)): Genre(s)
- `description` (varchar(250)): Content description

## Key Analyses

### 1. Content Type Distribution
- Analysis of the distribution between Movies and TV Shows
- Calculation of total content by type
- Most common ratings for each content type

### 2. Geographic Analysis
- Content distribution by country
- Top 5 countries by content production
- Recursive analysis of multi-country productions

### 3. Duration Analysis
The project includes a sophisticated duration categorization system:
- For Movies:
  - Short: < 60 minutes
  - Medium: 60-120 minutes
  - Long: > 120 minutes
- For TV Shows:
  - Short: 1-2 seasons
  - Medium: 3-4 seasons
  - Long: 5+ seasons

### 4. Content Metrics
- Total content count
- Distinct content types
- Distribution analysis by release year
- Rating distribution analysis

## Key Features
1. Data Normalization
   - Properly structured varchar lengths for optimal storage
   - Standardized field formats

2. Advanced SQL Techniques
   - Recursive CTEs for complex data parsing
   - Window functions for ranking and analysis
   - Case statements for sophisticated categorization
   - Subqueries for detailed filtering

3. Content Classification
   - Detailed duration categorization
   - Rating analysis
   - Type-specific metrics

## Technical Implementation
The project uses various SQL techniques including:
- ALTER TABLE statements for database optimization
- WITH RECURSIVE for handling complex data structures
- Window functions (RANK(), PARTITION BY)
- Complex CASE statements
- String manipulation functions
- Aggregation and grouping
- Data filtering and sorting

## Usage
To use this project:
1. Import the Netflix dataset into your MySQL database
2. Run the table modification queries to optimize the structure
3. Execute the analysis queries to generate insights
4. Modify the queries as needed for specific analysis requirements

## Future Enhancements
Potential areas for expansion:
- Time-based trend analysis
- Genre correlation studies
- Viewer rating integration
- Regional preference analysis
- Content recommendation algorithms

## Requirements
- MySQL 5.7 or higher
- Netflix content dataset
- Basic SQL knowledge for query modification

## Contributing
Feel free to fork this project and submit pull requests with improvements or additional analyses.
