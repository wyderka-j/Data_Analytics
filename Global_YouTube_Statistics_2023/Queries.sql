-- MySQL 

CREATE DATABASE yt_stats;
USE yt_stats;

-- YOUTUBE TOP PLAYERS

-- 1a. Top continets in the YT space; Uploads, views, earnings and Subs
SELECT
	 CASE
		 WHEN Country IN ("Algeria","Angola","Benin","Botswana","Burkina Faso","Burundi","Cabo Verde","Cameroon","Central African Republic",
			  "Chad","Comoros","Congo, Dem. Rep", "Congo, Rep.","Cote d'Ivoire","Djibouti","Egypt","Equatorial Guinea","Eritrea",
			  "Eswatini (formerly Swaziland)","Ethiopia","Gabon","Gambia","Ghana","Guinea","Guinea-Bissau","Kenya", "Lesotho",
			  "Liberia",'Libya',"Madagascar","Malawi","Mali","Mauritania","Mauritius","Morocco","Mozambique","Namibia",
			  "Niger","Nigeria","Rwanda","Sao Tome and Principe","Senegal","Seychelles","Sierra Leone","Somalia","South Africa",
			  "South Sudan","Sudan","Tanzania""Togo","Tunisia","Uganda","Zambia","Zimbabwe") THEN 'Africa'
		 WHEN Country IN ("Albania","Andorra", "Armenia","Austria","Azerbaijan","Belarus","Belgium","Bosnia and Herzegovina",
			  "Bulgaria","Croatia","Cyprus","Czechia","Denmark","Estonia","Finland","France","Georgia","Germany",
			  "Greece","Hungary","Iceland","Ireland","Italy","Kazakhstan","Kosovo","Latvia","Liechtenstein","Lithuania",
			  "Luxembourg","Malta","Moldova","Monaco","Montenegro","Netherlands","Macedonia, FYR","Norway","Poland","Portugal",
			  "Romania","Russia","San Marino","Serbia","Slovakia","Slovenia","Spain","Sweden","Switzerland","Turkey",
			 "Ukraine","United Kingdom","Vatican City") THEN 'Europe'
		 WHEN Country IN ("Afghanistan","Armenia","Azerbaijan","Bahrain","Bangladesh", "Bhutan","Brunei","Cambodia","China","Cyprus",
			"Georgia","India","Indonesia","Iran","Iraq","Israel","Japan","Jordan","Kazakhstan","Kuwait","Kyrgyzstan","Laos",
			"Lebanon","Malaysia","Maldives","Mongolia","Myanmar","Nepal","North Korea","Oman","Pakistan","Palestine","Philippines",
			"Qatar","Russia","Saudi Arabia","Singapore","South Korea","Sri Lanka","Syria","Taiwan","Tajikistan","Thailand",
			"Timor-Leste","Turkey","Turkmenistan","United Arab Emirates","Uzbekistan","Vietnam","Yemen") THEN 'Asia'
		 WHEN Country IN ("Antigua and Barbuda","Bahamas","Barbados","Belize","Canada","Costa Rica","Cuba","Dominica",
			 "Dominican Republic","El Salvador","Grenada","Guatemala","Haiti","Honduras","Jamaica","Mexico",
			"Nicaragua","Panama","Saint Vincent and the Grenadines","United States") THEN 'North_America'
		 WHEN Country IN ("Argentina","Bolivia","Brazil","Chile","Colombia","Ecuador","Guyana","Paraguay","Peru","Suriname",
			 "Uruguay","Venezuela") THEN 'South_America'
		 WHEN Country IN ("Australia","Fiji","Kiribati","Marshall Islands","Micronesia","Nauru","New Zealand","Palau",
			 "Papua New Guinea","Samoa","Solomon Islands","Tonga","Tuvalu","Vanuatu") THEN 'Australia_and_Oceania '
		END AS continents,
	  SUM(subscribers) AS total_subs,
	  SUM(uploads) AS total_uploads,
	  SUM(`video views`) AS total_views,
	  ROUND(SUM(highest_yearly_earnings),0) AS total_earnings,
	  COUNT(Youtuber) AS num_of_youtubers
FROM global_youtube_statistics
GROUP BY continents
ORDER BY total_earnings DESC;

-- b. Pct of pay per continent
WITH pct_pay AS(
SELECT
	 CASE
		 WHEN Country IN ("Algeria","Angola","Benin","Botswana","Burkina Faso","Burundi","Cabo Verde","Cameroon","Central African Republic",
			  "Chad","Comoros","Congo, Dem. Rep", "Congo, Rep.","Cote d'Ivoire","Djibouti","Egypt","Equatorial Guinea","Eritrea",
			  "Eswatini (formerly Swaziland)","Ethiopia","Gabon","Gambia","Ghana","Guinea","Guinea-Bissau","Kenya", "Lesotho",
			  "Liberia",'Libya',"Madagascar","Malawi","Mali","Mauritania","Mauritius","Morocco","Mozambique","Namibia",
			  "Niger","Nigeria","Rwanda","Sao Tome and Principe","Senegal","Seychelles","Sierra Leone","Somalia","South Africa",
			  "South Sudan","Sudan","Tanzania""Togo","Tunisia","Uganda","Zambia","Zimbabwe") THEN 'Africa'
		 WHEN Country IN ("Albania","Andorra", "Armenia","Austria","Azerbaijan","Belarus","Belgium","Bosnia and Herzegovina",
			  "Bulgaria","Croatia","Cyprus","Czechia","Denmark","Estonia","Finland","France","Georgia","Germany",
			  "Greece","Hungary","Iceland","Ireland","Italy","Kazakhstan","Kosovo","Latvia","Liechtenstein","Lithuania",
			  "Luxembourg","Malta","Moldova","Monaco","Montenegro","Netherlands","Macedonia, FYR","Norway","Poland","Portugal",
			  "Romania","Russia","San Marino","Serbia","Slovakia","Slovenia","Spain","Sweden","Switzerland","Turkey",
			 "Ukraine","United Kingdom","Vatican City") THEN 'Europe'
		 WHEN Country IN ("Afghanistan","Armenia","Azerbaijan","Bahrain","Bangladesh", "Bhutan","Brunei","Cambodia","China","Cyprus",
			"Georgia","India","Indonesia","Iran","Iraq","Israel","Japan","Jordan","Kazakhstan","Kuwait","Kyrgyzstan","Laos",
			"Lebanon","Malaysia","Maldives","Mongolia","Myanmar","Nepal","North Korea","Oman","Pakistan","Palestine","Philippines",
			"Qatar","Russia","Saudi Arabia","Singapore","South Korea","Sri Lanka","Syria","Taiwan","Tajikistan","Thailand",
			"Timor-Leste","Turkey","Turkmenistan","United Arab Emirates","Uzbekistan","Vietnam","Yemen") THEN 'Asia'
		 WHEN Country IN ("Antigua and Barbuda","Bahamas","Barbados","Belize","Canada","Costa Rica","Cuba","Dominica",
			 "Dominican Republic","El Salvador","Grenada","Guatemala","Haiti","Honduras","Jamaica","Mexico",
			"Nicaragua","Panama","Saint Vincent and the Grenadines","United States") THEN 'North_America'
		 WHEN Country IN ("Argentina","Bolivia","Brazil","Chile","Colombia","Ecuador","Guyana","Paraguay","Peru","Suriname",
			 "Uruguay","Venezuela") THEN 'South_America'
		 WHEN Country IN ("Australia","Fiji","Kiribati","Marshall Islands","Micronesia","Nauru","New Zealand","Palau",
			 "Papua New Guinea","Samoa","Solomon Islands","Tonga","Tuvalu","Vanuatu") THEN 'Australia_and_Oceania '
		END AS continents,
	  ROUND(SUM(highest_yearly_earnings),0) AS total_earnings
FROM global_youtube_statistics
GROUP BY continents
ORDER BY total_earnings DESC
)
SELECT
	SUM(total_earnings) AS total_earnings,
	ROUND(1.0 * SUM(CASE WHEN continents = 'Africa' THEN total_earnings ELSE 0 END)/ NULLIF(SUM(total_earnings),0) *100,2) AS pct_earnings_Africa,
	ROUND(1.0 * SUM(CASE WHEN continents = 'Asia' THEN total_earnings ELSE 0 END)/ NULLIF(SUM(total_earnings),0) *100,2) AS pct_earnings_Asia,
	ROUND(1.0 * SUM(CASE WHEN continents = 'North_America' THEN total_earnings ELSE 0 END)/ NULLIF(SUM(total_earnings),0) *100,2) AS pct_earnings_North_America,
	ROUND(1.0 * SUM(CASE WHEN continents = 'Europe' THEN total_earnings ELSE 0 END)/ NULLIF(SUM(total_earnings),0) *100,2) AS pct_earnings_Europe,
	ROUND(1.0 * SUM(CASE WHEN continents = 'South_America' THEN total_earnings ELSE 0 END)/ NULLIF(SUM(total_earnings),0) *100,2) AS pct_earnings_South_America,
	ROUND(1.0 * SUM(CASE WHEN continents = 'Australia_and_Oceania' THEN total_earnings ELSE 0 END)/ NULLIF(SUM(total_earnings),0) *100,2) AS pct_earnings_Australia_and_Oceania
FROM pct_pay;

-- 2. Top 8 Countries, pct pay
SELECT 
	Country,
    ROUND(SUM(highest_yearly_earnings),0) AS total_earnings
FROM global_youtube_statistics
GROUP BY Country
ORDER BY total_earnings DESC
LIMIT 8;

-- United States, India, Brazil, South Korea, United Kingdom, Pakistan, Argentina, Russia

WITH country_pct AS (
SELECT
	Country,
	ROUND(SUM(highest_yearly_earnings),0) AS total_earnings
FROM global_youtube_statistics
GROUP BY Country
ORDER BY total_earnings DESC
)
SELECT
	SUM(total_earnings) AS total_earnings,
	ROUND(1.0*SUM(CASE WHEN Country = 'United States' THEN total_earnings ELSE 0 END)/NULLIF(SUM(total_earnings),0)*100,2) AS pct_us,
	ROUND(1.0*SUM(CASE WHEN Country = 'India' THEN total_earnings ELSE 0 END)/NULLIF(SUM(total_earnings),0)*100,2) AS pct_india,
	ROUND(1.0*SUM(CASE WHEN Country = 'Brazil' THEN total_earnings ELSE 0 END)/NULLIF(SUM(total_earnings),0)*100,2) AS pct_brazil,
	ROUND(1.0*SUM(CASE WHEN Country = 'South Korea' THEN total_earnings ELSE 0 END)/NULLIF(SUM(total_earnings),0)*100,2) AS pct_southKorea,
	ROUND(1.0*SUM(CASE WHEN Country = 'United Kingdom' THEN total_earnings ELSE 0 END)/NULLIF(SUM(total_earnings),0)*100,2) AS pct_uk,
	ROUND(1.0*SUM(CASE WHEN Country = 'Pakistan' THEN total_earnings ELSE 0 END)/NULLIF(SUM(total_earnings),0)*100,2) AS pct_pakistan,
	ROUND(1.0*SUM(CASE WHEN Country = 'Argentina' THEN total_earnings ELSE 0 END)/NULLIF(SUM(total_earnings),0)*100,2) AS pct_argentina,
	ROUND(1.0*SUM(CASE WHEN Country = 'Russia' THEN total_earnings ELSE 0 END)/NULLIF(SUM(total_earnings),0)*100,2) AS pct_russia
FROM country_pct;

-- 3. Top 8 Channel Types, sum views
SELECT
	channel_type,
	SUM(`video views`) AS total_views
FROM global_youtube_statistics
GROUP BY 1
ORDER BY 2 DESC
LIMIT 8;