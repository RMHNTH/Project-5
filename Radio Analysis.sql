-- Remove all blank fields in artist
CREATE VIEW cleaned_playlogs
AS
SELECT year,
       month,
	   day,
	   hour,
	   minute,
	   second,
	   album,
	   title,
	   artist,
CAST(CASE WHEN stream1 = '' THEN 0 ELSE stream1 END AS INT)  AS stream1,
CAST(CASE WHEN stream2 = '' THEN 0 ELSE stream2 END AS INT) AS stream2,
CAST(CASE WHEN stream3 = '' THEN 0 ELSE  stream3 END AS INT) AS stream3
FROM [PROJECTS].[dbo].[playlogs]
WHERE TRIM(artist) <> '' and len(year) = 4;

CREATE VIEW listeners
AS
WITH cte_cleaned_playlogs as
(
SELECT year,
       month,
	   day,
	   hour,
      stream1 + stream2 + stream3  AS listeners
FROM cleaned_playlogs
)
SELECT year,
       month,
	   day,
	   hour,
SUM(listeners) AS listeners
FROM cte_cleaned_playlogs
GROUP BY year,
       month,
	   day,
	   hour;

-- Hour with the least number of listeners
SELECT hour,
       SUM(listeners) AS total_listeners
FROM listeners
GROUP BY hour
ORDER BY SUM(listeners) ASC

alter VIEW listenerWeekdays
AS
SELECT
DATEFROMPARTS(year, month, day) AS date,
DATEPART(WEEKDAY,DATEFROMPARTS(year, month, day)) AS weekday,
sum(listeners) as listeners
FROM listeners
group by DATEFROMPARTS(year, month, day)
order by DATEFROMPARTS(year, month, day)

SELECT weekday,
AVG(listeners) AS avg_listeners,
count(listeners),
SUM(listeners) 
, SUM(listeners) / count(listeners)
FROM listenerWeekdays
GROUP BY weekday
ORDER BY AVG(listeners) ASC












