-- Microsoft SQL Server 

CREATE DATABASE Baseball_Stats;

use Baseball_Stats;

-- Checking the tables
SELECT *
FROM LastPitchRays;

SELECT *
FROM RaysPitchingStats;


--Question 1 AVG Pitches Per at Bat Analysis

--1a AVG Pitches Per At Bat (LastPitchRays)

SELECT AVG(1.00 * Pitch_number) AS AvgNumofPitchesPerAtBat
FROM LastPitchRays;

--1b AVG Pitches Per At Bat Home Vs Away (LastPitchRays) -> Union

SELECT 
	'Home' TypeofGame,
	AVG(1.00 * Pitch_number) AS AvgNumofPitchesPerAtBat
FROM LastPitchRays
WHERE home_team = 'TB'
UNION
SELECT 
	'Away' TypeofGame,
	AVG(1.00 * Pitch_number) AS AvgNumofPitchesPerAtBat
FROM LastPitchRays
WhERE away_team = 'TB';

--1c AVG Pitches Per At Bat Lefty Vs Righty  -> Case Statement 

SELECT 
	AVG(CASE WHEN batter_position = 'L' THEN 1.00 * Pitch_number END)  AS LeftyatBats,
	AVG(CASE WHEN batter_position = 'R' THEN 1.00 * Pitch_number END)  AS RightyatBats
FROM LastPitchRays;

--1d AVG Pitches Per At Bat Lefty Vs Righty Pitcher | Each Away Team -> Partition By

SELECT DISTINCT
	home_team,
	Pitcher_position,
	AVG(1.00 * Pitch_number) OVER (PARTITION BY home_team, Pitcher_position)
FROM LastPitchRays
WHERE away_team = 'TB';

--1e Top 3 Most Common Pitch for at bat 1 through 10, and total amounts (LastPitchRays)

WITH totalpitchsequence AS (
	SELECT DISTINCT
		Pitch_name,
		Pitch_number,
		COUNT(pitch_name) OVER (PARTITION BY Pitch_name, Pitch_number) PitchFrequency
	FROM LastPitchRays
	WHERE Pitch_number < 11
),
pitchfrequencyrankquery AS (
	SELECT 
	Pitch_name,
	Pitch_number,
	PitchFrequency,
	RANK() OVER (PARTITION BY Pitch_number ORDER BY PitchFrequency DESC) PitchFrequencyRanking
FROM totalpitchsequence
)
SELECT *
FROM pitchfrequencyrankquery
WHERE PitchFrequencyRanking < 4;

--1f AVG Pitches Per at Bat Per Pitcher with 20+ Innings | Order in descending (LastPitchRays + RaysPitchingStats)

SELECT 
	RPS.Name, 
	AVG(1.00 * Pitch_number) AVGPitches
FROM LastPitchRays LPR
JOIN RaysPitchingStats RPS ON RPS.pitcher_id = LPR.pitcher
WHERE IP >= 20
GROUP BY RPS.Name
ORDER BY AVG(1.00 * Pitch_number) DESC;

--Question 2 Last Pitch Analysis

--2a Count of the Last Pitches Thrown in Desc Order (LastPitchRays)

SELECT pitch_name, COUNT(*) AS timesthrown
FROM LastPitchRays
GROUP BY pitch_name
ORDER BY COUNT(*) DESC;

--2b Count of the different last pitches Fastball or Offspeed (LastPitchRays)

SELECT
	SUM(CASE WHEN pitch_name IN ('4-Seam Fastball', 'Cutter') THEN 1 ELSE 0 END) AS Fastball,
	SUM(CASE WHEN pitch_name NOT IN ('4-Seam Fastball', 'Cutter') THEN 1 ELSE 0 END) AS Offspeed
FROM LastPitchRays;

--2c Percentage of the different last pitches Fastball or Offspeed (LastPitchRays)

SELECT
	100 * SUM(CASE WHEN pitch_name IN ('4-Seam Fastball', 'Cutter') THEN 1 ELSE 0 END) / COUNT(*) FastballPercent,
	100 * SUM(CASE WHEN pitch_name NOT IN ('4-Seam Fastball', 'Cutter') THEN 1 ELSE 0 END) / COUNT(*) OffspeedPercent
FROM LastPitchRays;

--2d Top 5 Most common last pitch for a Relief Pitcher vs Starting Pitcher (LastPitchRays + RaysPitchingStats)

SELECT *
FROM (
	SELECT 
		a.POS, 
		a.pitch_name,
		a.timesthrown,
		RANK() OVER (PARTITION BY a.POS ORDER BY a.timesthrown DESC) PitchRank
	FROM (
		SELECT RPS.POS, LPR.pitch_name, COUNT(*) timesthrown
		FROM LastPitchRays LPR
		JOIN RaysPitchingStats RPS ON RPS.pitcher_id = LPR.pitcher
		GROUP BY RPS.POS, LPR.pitch_name
	) a
)b
WHERE b.PitchRank < 6;


--Question 3 Homerun analysis

--3a What pitches have given up the most HRs (LastPitchRays) 

SELECT pitch_name, COUNT(*) HRs
FROM LastPitchRays
WHERE events = 'home_run'
GROUP BY pitch_name
ORDER BY COUNT(*) DESC;

--3b Show HRs given up by zone and pitch, show top 5 most common

SELECT TOP 5 ZONE, pitch_name, COUNT(*) AS HRs
FROM LastPitchRays
WHERE events = 'home_run'
GROUP BY ZONE, pitch_name
ORDER BY COUNT(*) DESC;

--3c Show HRs for each count type -> Balls/Strikes + Type of Pitcher

SELECT RPS.POS, LPR.balls,lpr.strikes, COUNT(*) AS HRs
FROM LastPitchRays LPR
JOIN RaysPitchingStats RPS ON RPS.pitcher_id = LPR.pitcher
WHERE events = 'home_run'
GROUP BY RPS.POS, LPR.balls,lpr.strikes
ORDER BY COUNT(*) DESC;

--3d Show Each Pitchers Most Common count to give up a HR (Min 30 IP)

WITH hrcountpitchers AS (
SELECT RPS.Name, LPR.balls,lpr.strikes, COUNT(*) AS HRs
FROM LastPitchRays LPR
JOIN RaysPitchingStats RPS ON RPS.pitcher_id = LPR.pitcher
WHERE events = 'home_run' AND IP >= 30
GROUP BY RPS.Name, LPR.balls,lpr.strikes
),
hrcountranks AS (
	SELECT 
	hcp.Name, 
	hcp.balls,
	hcp.strikes, 
	hcp.HRs,
	RANK() OVER (PARTITION BY Name ORDER BY HRs DESC) hrrank
	FROM hrcountpitchers hcp
)
SELECT ht.Name, ht.balls, ht.strikes, ht.HRs
FROM hrcountranks ht
WHERE hrrank = 1;

--Question 4 Shane McClanahan

--4a AVG Release speed, spin rate,  strikeouts, most popular zone ONLY USING LastPitchRays

SELECT 
	AVG(release_speed) AS AvgReleaseSpeed,
	AVG(release_spin_rate) AS AvgSpinRate,
	SUM(CASE WHEN events = 'strikeout' THEN 1 ELSE 0 END) AS strikeouts,
	MAX(zones.zone) AS Zone
FROM LastPitchRays LPR
JOIN (
	SELECT TOP 1 pitcher, zone, COUNT(*) AS zonenum
	FROM LastPitchRays LPR
	WHERE player_name = 'McClanahan, Shane'
	GROUP BY pitcher, zone
	ORDER BY COUNT(*) DESC
) zones ON zones.pitcher = LPR.pitcher
WHERE player_name = 'McClanahan, Shane';

--4b top pitches for each infield position where total pitches are over 5, rank them
SELECT *
FROM (
	SELECT pitch_name, COUNT(*) timeshit, 'Third' Position
	FROM LastPitchRays
	WHERE hit_location = 5 AND player_name = 'McClanahan, Shane'
	GROUP BY pitch_name
	UNION
	SELECT pitch_name, COUNT(*) timeshit, 'Short' Position
	FROM LastPitchRays
	WHERE hit_location = 6 AND player_name = 'McClanahan, Shane'
	GROUP BY pitch_name
	UNION
	SELECT pitch_name, COUNT(*) timeshit, 'Second' Position
	FROM LastPitchRays
	WHERE hit_location = 4 AND player_name = 'McClanahan, Shane'
	GROUP BY pitch_name
	UNION
	SELECT pitch_name, COUNT(*) timeshit, 'First' Position
	FROM LastPitchRays
	WHERE hit_location = 3 AND player_name = 'McClanahan, Shane'
	GROUP BY pitch_name
) a
WHERE timeshit > 4
ORDER BY timeshit DESC;

--4c Show different balls/strikes as well as frequency when someone is on base 

SELECT balls, strikes, COUNT(*) frequency
FROM LastPitchRays
WHERE (on_3b IS NOT NULL OR on_2b IS NOT NULL OR on_1b IS NOT NULL)
AND player_name = 'McClanahan, Shane'
GROUP BY balls, strikes
ORDER BY COUNT(*) DESC;

--4d What pitch causes the lowest launch speed

SELECT TOP 1 pitch_name, AVG(launch_speed * 1.00) LaunchSpeed
FROM LastPitchRays
WHERE player_name = 'McClanahan, Shane'
GROUP BY pitch_name
ORDER BY AVG(launch_speed);