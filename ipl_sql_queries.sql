CREATE TABLE IPL_Matchs (
    id INT,
    city NVARCHAR(100),
    date DATE,
    player_of_match NVARCHAR(100),
    venue NVARCHAR(255),
    neutral_venue INT,
    team1 NVARCHAR(100),
    team2 NVARCHAR(100),
    toss_winner NVARCHAR(100),
    toss_decision NVARCHAR(50),
    winner NVARCHAR(100),
    result NVARCHAR(50),
    result_margin NVARCHAR(50),
    eliminator NVARCHAR(10),
    method NVARCHAR(50),
    umpire1 NVARCHAR(100),
    umpire2 NVARCHAR(100)
);
--Most Successful Team
SELECT winner, COUNT(*) AS wins
FROM IPL_Matches
WHERE winner IS NOT NULL
GROUP BY winner
ORDER BY wins DESC;

SELECT player_of_match, COUNT(*) AS awards
FROM IPL_Matches
WHERE player_of_match IS NOT NULL
GROUP BY player_of_match
ORDER BY awards DESC;

--Top 5 Most Popular Venues
SELECT venue, COUNT(*) AS matches_played
FROM IPL_Matches
WHERE venue IS NOT NULL
GROUP BY venue
ORDER BY matches_played DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

--Toss-Win to Match-Win Correlation
SELECT 
    CASE WHEN toss_winner = winner THEN 1 ELSE 0 END AS won_after_toss,
    COUNT(*) AS match_count
FROM IPL_Matches
WHERE toss_winner IS NOT NULL AND winner IS NOT NULL
GROUP BY 
    CASE WHEN toss_winner = winner THEN 1 ELSE 0 END;

--Match Result Type Distribution
SELECT result, COUNT(*) AS count
FROM IPL_Matches
GROUP BY result;


--Number of Matches Per Year
SELECT YEAR(date) AS year, COUNT(*) AS matches
FROM IPL_Matches
GROUP BY YEAR(date)
ORDER BY year;

--Highest Win Margin by Runs
SELECT TOP 1 *
FROM IPL_Matches
WHERE result = 'runs'
ORDER BY TRY_CAST(result_margin AS INT) DESC;

--Teams Who Most Frequently Reached Finals
SELECT team1 AS team, COUNT(*) AS finals_appearances
FROM IPL_Matches
WHERE eliminator = 1
GROUP BY team1
UNION ALL
SELECT team2 AS team, COUNT(*) AS finals_appearances
FROM IPL_Matches
WHERE eliminator = 1
GROUP BY team2;

--BONUS: Win % After Winning Toss
SELECT
    COUNT(*) AS total_toss_winners,
    SUM(CASE WHEN toss_winner = winner THEN 1 ELSE 0 END) AS matches_won_after_toss,
    ROUND(
        100.0 * SUM(CASE WHEN toss_winner = winner THEN 1 ELSE 0 END) / COUNT(*), 
        2
    ) AS win_percentage
FROM IPL_Matches
WHERE toss_winner IS NOT NULL AND winner IS NOT NULL;
