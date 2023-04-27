/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Rank]
      ,[Game]
      ,[Month]
      ,[Year]
      ,[Hours_watched]
      ,[Hours_streamed]
      ,[Peak_viewers]
      ,[Peak_channels]
      ,[Streamers]
      ,[Avg_viewers]
      ,[Avg_channels]
      ,[Avg_viewer_ratio]
  FROM [PortfolioProject].[dbo].[Twitch_game_data]

 /* Make sure there are no duplicates */

 SELECT [Rank]
      ,[Game]
      ,[Month]
      ,[Year]
      ,[Hours_watched]
      ,[Hours_streamed]
      ,[Peak_viewers]
      ,[Peak_channels]
      ,[Streamers]
      ,[Avg_viewers]
      ,[Avg_channels]
      ,[Avg_viewer_ratio],
	  COUNT(*) AS CNT
	FROM PortfolioProject.dbo.Twitch_game_data
	GROUP BY [Rank]
      ,[Game]
      ,[Month]
      ,[Year]
      ,[Hours_watched]
      ,[Hours_streamed]
      ,[Peak_viewers]
      ,[Peak_channels]
      ,[Streamers]
      ,[Avg_viewers]
      ,[Avg_channels]
      ,[Avg_viewer_ratio]
	HAVING COUNT(*) >1;

/*Find and delete null */
SELECT *
FROM PortfolioProject.dbo.Twitch_game_data
WHERE Rank IS NULL OR Game IS NULL OR Month IS NULL OR Year IS NULL OR Hours_watched IS NULL OR Hours_streamed IS NULL OR Peak_viewers IS NULL OR Peak_channels IS NULL OR Streamers IS NULL OR Avg_viewers IS NULL OR Avg_channels IS NULL OR Avg_viewer_ratio IS NULL;

/*Since there is one row where the Game value is NULL, let's delete that row */

DELETE FROM PortfolioProject.dbo.Twitch_game_data WHERE Game IS NULL;

/* Let's explore the data and see what insights we can draw. The ranking is based on the Hours_Watched category.

See which game/categories has ranked first place, second place, and third place the most amount of times 2016-present.*/

SELECT Rank, Game
	INTO #Number_of_times_first
	FROM PortfolioProject.dbo.Twitch_game_data
	WHERE Rank=1;

SELECT Game, count(Game) as Numer_of_times_first
FROM #Number_of_times_first
GROUP BY Game
ORDER BY count(Game) desc;

SELECT Rank, Game
	INTO #Number_of_times_second
	FROM PortfolioProject.dbo.Twitch_game_data
	WHERE Rank=2;

SELECT Game, count(Game) as Numer_of_times_second
FROM #Number_of_times_second
GROUP BY Game
ORDER BY count(Game) desc;

SELECT Rank, Game
	INTO #Number_of_times_third
	FROM PortfolioProject.dbo.Twitch_game_data
	WHERE Rank=3;

SELECT Game, count(Game) as Number_of_times_third
FROM #Number_of_times_third
GROUP BY Game
ORDER BY count(Game) desc;

/* As we can see, the top two games/categories are Just Chatting and League of Legends. Let's see which one has more total hours watched. */

SELECT Game, Hours_watched
	INTO #LoL_JC_hours_watched
	FROM PortfolioProject.dbo.Twitch_game_data
	WHERE Game='League of Legends' OR Game='Just Chatting';

SELECT *
FROM #LoL_JC_hours_watched;

/* When I tried to run this below, I got an error message so I need to convert datatype to BIGINT. */

SELECT Game, SUM(Hours_watched) as Sum_Hours_Watched
FROM #LoL_JC_hours_watched
GROUP BY Game;

SELECT Game, SUM(CAST(Hours_watched AS BIGINT)) as Sum_Hours_Watched
FROM #LoL_JC_hours_watched
GROUP BY Game;

/* Even though the Just Chatting category was only incorporated in late 2018, it has overtaken League of Legends in number of hours watched between 2016-present.

Now let's look at top 10 games between 2016-present based on total number of hours watched. */

SELECT Game, SUM(CAST(Hours_watched AS BIGINT)) as Sum_Hours_Watched
	FROM PortfolioProject.dbo.Twitch_game_data
	GROUP BY Game
	ORDER BY Sum_Hours_Watched desc;

/* We can see the top ten games are in this order: Just Chatting, Leage of Legends, GTA V, Fortnite, CS:GO, Dota 2, Valorant, Minecraft, Hearthstone, and CoD:Warzone.

We will make a new table with data from top ten games every month and manipulate this table in Tableau. */

SELECT *
	FROM PortfolioProject.dbo.Twitch_game_data
	WHERE Rank=1 OR Rank=2 OR Rank=3 OR Rank=4 OR Rank=5 OR Rank=6 OR Rank=7 OR Rank=8 OR Rank=9 OR Rank=10;