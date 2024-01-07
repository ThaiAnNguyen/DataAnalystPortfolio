/* 
International Football Tournaments Project SQL Queries
*/

-----------------------------------------------------------------------------------------------------------------------------------------------------------

/* 
Scorecards
*/

-- Total international matches played


SELECT COUNT(*) AS total_international_matches
FROM [PortfolioProject].[dbo].[results];


-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Average goals per match


SELECT CAST((SUM(home_score) + SUM(away_score)) / 45315.0 AS DECIMAL(5, 2)) AS average_goals_per_match
FROM [PortfolioProject].[dbo].[results];


-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Total Teams


SELECT COUNT(*) AS total_teams
FROM
(
    SELECT home_team AS team_name FROM [PortfolioProject].[dbo].[results]
    UNION
    SELECT away_team AS team_name FROM [PortfolioProject].[dbo].[results]
) AS combined_teams;


-----------------------------------------------------------------------------------------------------------------------------------------------------------
/* 
Treemap (excluded)
*/

-- Tournaments percentage


SELECT
    CASE WHEN Tournament_percentage >= 2 THEN tournament ELSE 'Others' END AS tournament,
    SUM(Tournament_matches) AS Total_matches,
    CAST(SUM(Tournament_percentage) AS DECIMAL(5, 2)) AS Total_percentage
FROM
(
    SELECT
        a.tournament,
        COUNT(*) AS Tournament_matches,
        (COUNT(*) * 100.0 / b.total_games)  AS Tournament_percentage
    FROM
        [PortfolioProject].[dbo].[results] AS a
    CROSS JOIN
        (
            SELECT
                COUNT(*) AS total_games
            FROM
                [PortfolioProject].[dbo].[results]
        ) AS b
    GROUP BY a.tournament, b.total_games
) AS sq
GROUP BY CASE WHEN Tournament_percentage >= 2 THEN tournament ELSE 'Others' END
ORDER BY Total_percentage DESC;


-----------------------------------------------------------------------------------------------------------------------------------------------------------
/* 
Bar charts
*/

-- Top 5 teams with most matches


SELECT TOP 5 team_name, COUNT(*) AS total_matches
FROM
(
    SELECT home_team AS team_name FROM [PortfolioProject].[dbo].[results]
    UNION ALL
    SELECT away_team AS team_name FROM [PortfolioProject].[dbo].[results]
) AS combined_teams
GROUP BY team_name
ORDER BY total_matches DESC;


-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Top 5 teams with highest goal-scoring records


SELECT TOP 5 team_name, SUM(goals) AS total_goals_scored
FROM
(
    SELECT home_team AS team_name, home_score AS goals FROM [PortfolioProject].[dbo].[results]
    UNION ALL
    SELECT away_team AS team_name, away_score AS goals FROM [PortfolioProject].[dbo].[results]
) AS combined_teams
GROUP BY team_name
ORDER BY total_goals_scored DESC;


-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Top 5 teams with highest winning rates (at least 100 games played)


SELECT TOP 5 team_name, sum(sum_wins)*100/sum(sum_games) as winning_rates
FROM (
    SELECT team_name, sum_wins, sum_games,
           COUNT(*) OVER (PARTITION BY team_name) AS appearances
    FROM (
        SELECT home_team AS team_name, 
               CASE WHEN home_score > away_score THEN 1 ELSE 0 END AS sum_wins,
               1 AS sum_games
        FROM [PortfolioProject].[dbo].[results]
        UNION ALL
        SELECT away_team AS team_name, 
               CASE WHEN away_score > home_score THEN 1 ELSE 0 END AS sum_wins,
               1 AS sum_games
        FROM [PortfolioProject].[dbo].[results]
    ) AS combined_teams
) AS filtered_teams
WHERE appearances >= 100
GROUP BY team_name
ORDER BY winning_rates DESC;


-----------------------------------------------------------------------------------------------------------------------------------------------------------
/* 
Donut chart
*/

-- Match outcomes of home teams at non-neutral venues


SELECT
    CAST((win_count * 100.0 / total_count) AS DECIMAL(5, 2)) AS winning_percentage,
    CAST((draw_count * 100.0 / total_count) AS DECIMAL(5, 2)) AS drawing_percentage,
    CAST((loss_count * 100.0 / total_count) AS DECIMAL(5, 2)) AS losing_percentage
FROM
(
    SELECT
        COUNT(CASE WHEN home_score > away_score THEN 1 END) AS win_count,
        COUNT(CASE WHEN home_score = away_score THEN 1 END) AS draw_count,
        COUNT(CASE WHEN home_score < away_score THEN 1 END) AS loss_count,
        COUNT(*) AS total_count
    FROM [PortfolioProject].[dbo].[results]
	WHERE neutral = 'FALSE'
) AS result;


-----------------------------------------------------------------------------------------------------------------------------------------------------------
/* 
Line chart
*/


-- Average number of goals scored per match over time


SELECT date, tournament, home_score + away_score as goals_per_match 
FROM [PortfolioProject].[dbo].[results];


-----------------------------------------------------------------------------------------------------------------------------------------------------------
/* 
Map
*/

--Countries having hosted the most international matches


SELECT country, COUNT(*) as Matches_hosted
FROM [PortfolioProject].[dbo].[results]
GROUP BY country
ORDER BY Matches_hosted DESC;


-----------------------------------------------------------------------------------------------------------------------------------------------------------
/* 
Note: This analysis was conducted based on the whole database. In Tableau Visualization, only the popular tournaments were used and the rest were filtered out.
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------
