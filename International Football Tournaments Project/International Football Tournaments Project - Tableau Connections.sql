/* 
International Football Tournaments Project - Tableau Connections 
*/

-----------------------------------------------------------------------------------------------------------------------------------------------------------

/*
The purpose of these queries is to reduce the amount of data needed to import to Tableau Public, thus lower loading speed and enhance user experience. 
Relationships in fields inlcuding: date, tournament and team_name (if any) will be established between the following tables and the original "result" table. 
The rest of the charts in the preliminary queries can be visualized using data in the original table only.
*/

-----------------------------------------------------------------------------------------------------------------------------------------------------------
--Donut chart: Match result of home teams


SELECT	tournament, date,
        COUNT(CASE WHEN home_score > away_score THEN 1 END) AS win_count,
        COUNT(CASE WHEN home_score = away_score THEN 1 END) AS draw_count,
        COUNT(CASE WHEN home_score < away_score THEN 1 END) AS loss_count,
        COUNT(*) AS total_count
FROM [PortfolioProject].[dbo].[results]
WHERE neutral = 'FALSE'
GROUP BY tournament, date


-----------------------------------------------------------------------------------------------------------------------------------------------------------
--Bar chart: Teams with highest winning rates (>100 games only)


SELECT team_name, date, tournament, sum_wins, sum_games
FROM (
    SELECT team_name, date, tournament, sum_wins, sum_games,
           COUNT(*) OVER (PARTITION BY team_name) AS appearances
    FROM (
        SELECT date, tournament, home_team AS team_name, 
               CASE WHEN home_score > away_score THEN 1 ELSE 0 END AS sum_wins,
               1 AS sum_games
        FROM [PortfolioProject].[dbo].[results]
        UNION ALL
        SELECT date, tournament, away_team AS team_name, 
               CASE WHEN away_score > home_score THEN 1 ELSE 0 END AS sum_wins,
               1 AS sum_games
        FROM [PortfolioProject].[dbo].[results]
    ) AS combined_teams
) AS filtered_teams
WHERE appearances > 100;


-----------------------------------------------------------------------------------------------------------------------------------------------------------
--Scorecard:Total Teams and Bar chart: Teams with highest goal-scoring records


SELECT team_name, date, tournament, SUM(goals) AS total_goals
FROM
(
    SELECT date, tournament, home_team AS team_name, home_score AS goals FROM [PortfolioProject].[dbo].[results]
    UNION ALL
    SELECT date, tournament, away_team AS team_name, away_score AS goals FROM [PortfolioProject].[dbo].[results]
) AS combined_teams
GROUP BY team_name, date, tournament;


-----------------------------------------------------------------------------------------------------------------------------------------------------------
--COMBINED TABLE: join the above 2 tables


WITH CTE1 AS (

	SELECT team_name, date, tournament, SUM(goals) AS total_goals
	FROM
	(
		SELECT date, tournament, home_team AS team_name, home_score AS goals FROM [PortfolioProject].[dbo].[results]
		UNION ALL
		SELECT date, tournament, away_team AS team_name, away_score AS goals FROM [PortfolioProject].[dbo].[results]
	) AS combined_teams
	GROUP BY team_name, date, tournament

),
CTE2 AS (

	SELECT team_name, date, tournament, sum_wins, sum_games
	FROM (
			SELECT team_name, date, tournament, sum_wins, sum_games,
				   COUNT(*) OVER (PARTITION BY team_name) AS appearances
			FROM (
				SELECT date, tournament, home_team AS team_name, 
					   CASE WHEN home_score > away_score THEN 1 ELSE 0 END AS sum_wins,
					   1 AS sum_games
				FROM [PortfolioProject].[dbo].[results]
				UNION ALL
				SELECT date, tournament, away_team AS team_name, 
					   CASE WHEN away_score > home_score THEN 1 ELSE 0 END AS sum_wins,
					   1 AS sum_games
				FROM [PortfolioProject].[dbo].[results]
			) AS combined_teams
		) AS filtered_teams
	WHERE appearances > 100

)
SELECT CTE1.team_name, CTE1.date, CTE1.tournament, total_goals, sum_wins, sum_games
FROM CTE1 
LEFT JOIN CTE2
ON CTE1.team_name=CTE2.team_name and CTE1.date=CTE2.date and CTE1.tournament=CTE2.tournament
ORDER BY total_goals DESC


-----------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------