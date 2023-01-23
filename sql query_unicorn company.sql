--CREATE DATABASE
--CREATE TABLE AND INSERT VALUES (check folder sql table)

SELECT * FROM unicorn_companies
SELECT * FROM unicorn_dates
SELECT * FROM unicorn_funding
SELECT * FROM unicorn_industries

--Question 1
--Which continent has the most unicorn company?
--Source table: unicorn_companies

SELECT COUNT(company_id) AS total_companies,
	continent 
FROM unicorn_companies
GROUP BY continent
ORDER BY total_companies DESC;

--Answer: North America has the most unicorn startup with 589 companies valued over one billion, 
--followed by Asia (310) and Europe (143)

--Question 2
--Q: which country that has more than 100 unicorns?
--Source table: unicorn_companies

SELECT COUNT(company_id) AS total_companies,
	country
FROM unicorn_companies
GROUP BY country
HAVING COUNT(company_id) > 100
ORDER BY total_companies DESC;

--Answer: United States have 562 unicorns, followed by China with 173 Unicorns. Only 
--those two countries are having more than 100 unicorns.

--Question 3
--Q: which industry has the highest total fundings accumulated? what is their average valuation?
--Source table: unicorn_industries, unicorn_funding

SELECT ui.industry,
	SUM(uf.funding) AS total_funding,
	ROUND(AVG(uf.valuation),2) AS average_valuation
FROM unicorn_industries AS ui
INNER JOIN unicorn_funding AS uf
ON ui.company_id = uf.company_id
GROUP BY ui.industry
ORDER BY total_funding DESC;

--Answer: Fintech industry received the largest amount of funding with 107,996,000,000. 
--Fintech industries are valued at 3,937,500,000.

--Question 4
--Q: based on these datasets, how many fintech company that became unicorn each year from 2016-2022?
--Source table: unicorn_companies, unicorn_industries, unicorn_dates

SELECT COUNT(DISTINCT uc.company_id) AS total_company,
	EXTRACT (YEAR FROM (ud.date_joined)) AS year_joined_unicorn
FROM unicorn_companies AS uc
INNER JOIN unicorn_dates AS ud
ON uc.company_id = ud.company_id
INNER JOIN unicorn_industries AS ui
ON uc.company_id = ui.company_id
WHERE ui.industry = 'Fintech'
GROUP BY year_joined_unicorn
HAVING EXTRACT (YEAR FROM (ud.date_joined)) BETWEEN 2016 AND 2022
ORDER BY year_joined_unicorn DESC;

--Answer: 6 (2017), 10 (2018), 20 (2019), 15 (2020), 138 (2021), 31 (2022)

--Question 5
--Show the details of companies (name, city, country, and continent) along with their industry and valuation
--Which company has the highest valuation? 

SELECT uc.company_id,
	uc.company,
	uc.city,
	uc.country,
	uc.continent,
	ui.industry,
	uf.valuation
FROM unicorn_companies AS uc
INNER JOIN unicorn_industries AS ui
ON uc.company_id = ui.company_id
INNER JOIN unicorn_funding AS uf
ON uc.company_id = uf.company_id
ORDER BY uf.valuation DESC
LIMIT 5;

--Answer: Bytedance has the highest valuation at 180,000,000,000. 
--They are a China-based artifical intelligence industry

--For Indonesia?
--Source table: unicorn_companies, unicorn_industries, unicorn_funding

SELECT uc.company_id,
	uc.company,
	uc.city,
	uc.country,
	uc.continent,
	ui.industry,
	uf.valuation
FROM unicorn_companies AS uc
INNER JOIN unicorn_industries AS ui
ON uc.company_id = ui.company_id
INNER JOIN unicorn_funding AS uf
ON uc.company_id = uf.company_id
WHERE uc.country = 'Indonesia'
ORDER BY uf.valuation DESC
LIMIT 5;

--Answer: J&T Express has the highest valuation among unicorn startups in Indonesia,
--Valued at 20,000,000,000

--Question 6
--Which company was the oldest when they first became unicorn?From which country?
--Source table: unicorn_companies, unicorn_dates

SELECT uc.company_id,
	uc.company,
	EXTRACT(YEAR FROM ud.date_joined) - ud.year_founded AS age_when_became_unicorn,
	ud.year_founded,
	ud.date_joined,
	uc.country
FROM unicorn_companies AS uc
INNER JOIN unicorn_dates AS ud
ON uc.company_id = ud.company_id
ORDER BY age_when_became_unicorn DESC
LIMIT 10;

--Answer: Otto Bock HealthCare, a German company, was the oldest company that earned their 
--unicorn status at the age of 98

--Question 7
--Q: for companies that were founded between 1960 to 2000: which one was the oldest when they became unicorn?  
--Source table: unicorn_companies, unicorn_dates

SELECT uc.company,
	EXTRACT(YEAR FROM ud.date_joined) - ud.year_founded AS age_when_joined_unicorn,
	ud.year_founded,
	ud.date_joined,
	uc.country
FROM unicorn_companies AS uc
INNER JOIN unicorn_dates AS ud ON uc.company_id = ud.company_id
WHERE ud.year_founded BETWEEN 1960 AND 2000
ORDER BY age_when_joined_unicorn DESC
LIMIT 10;

--Answer: Five Star Business Finance from India was the oldest company founded between 1960 and 2000
--to join the unicorn group. They earned that status at the age of 37.

--Question 8
--Q1: How many companies that were funded by at least one 'venture' investor?

SELECT uc.company,
	uf.select_investors
FROM unicorn_companies AS uc
INNER JOIN unicorn_funding AS uf
ON uc.company_id = uf.company_id
WHERE LOWER(uf.select_investors) LIKE '%venture%';

--Answer: as data output

--Q2: How many companies that were funded by at least one investor that contains following words in their name:
--Venture
--Capital
--Partner
--Hint: use LIKE dan CASE WHEN inside COUNT DISTINCT

SELECT 
    COUNT (DISTINCT CASE WHEN LOWER(select_investors) 
		LIKE '%venture%' THEN company_id END) AS total_venture,
	COUNT (DISTINCT CASE WHEN LOWER(select_investors)
		LIKE '%capital%' THEN company_id END) AS total_capital,
	COUNT (DISTINCT CASE WHEN LOWER(select_investors)
		LIKE '%partner%' THEN company_id END) AS total_partner
FROM unicorn_funding;

--Answer: 603 (venture), 611 (capital), and 398 (partner)

--Question 9

--how many logistic industries that hold unicorn status in Asia?

SELECT COUNT (DISTINCT(uc.company_id)) AS logistic_startup,
uc.continent
FROM unicorn_companies AS uc
INNER JOIN unicorn_industries AS ui
ON uc.company_id = ui.company_id
WHERE uc.continent = 'Asia'
AND ui.industry LIKE '%logistic%'
GROUP BY uc.continent;

--Answer: there are 26 Asian-based unicorn startups in logistic industry

--What about that in Indonesia?
--Hint: Use DISTINCT dan CASE WHEN
--Source table: unicorn_companies, unicorn_industries

SELECT COUNT (DISTINCT(uc.company_id)) AS logistic_startup,
uc.country
FROM unicorn_companies AS uc
INNER JOIN unicorn_industries AS ui
ON uc.company_id = ui.company_id
WHERE uc.country = 'Indonesia'
AND ui.industry LIKE '%logistic%'
GROUP BY uc.country;

--Answer: there are only one Indonesian startup unicorn in the logistic industry.

--Question 10
--Top 3 countries that has the most unicorns in Asia

SELECT COUNT (DISTINCT(uc.company_id)) AS unicorn_startups,
uc.country
FROM unicorn_companies AS uc
INNER JOIN unicorn_industries AS ui
ON uc.company_id = ui.company_id
WHERE uc.continent = 'Asia'
GROUP BY uc.country
ORDER BY unicorn_startups DESC;

--TOP 3: China (173), India (65), Israel (20)

--Show the number of unicorns by industry and country in Asia (excluding China, India, and Israel)
--Sort by number of company (descending)
--Hint: use combination of CTE/subquery/JOIN/NOT IN
--Source table: unicorn_companies, unicorn_industries

SELECT ui.industry,
COUNT (DISTINCT(uc.company_id)) AS unicorn_startups,
uc.country
FROM unicorn_companies AS uc
INNER JOIN unicorn_industries AS ui
ON uc.company_id = ui.company_id
WHERE uc.continent = 'Asia'
AND uc.country NOT IN ('China', 'India', 'Israel')
GROUP BY ui.industry, uc.country
ORDER BY unicorn_startups DESC;

--OR USING CTE
--- Create Table Expression
WITH top_3 as (
    SELECT country,
    COUNT(DISTINCT(company_id)) AS total_company
    FROM unicorn_companies
    WHERE continent = 'Asia'
    GROUP BY country
    ORDER BY total_company DESC
    LIMIT 3
)
SELECT
	ui.industry,
	uc.country,
	COUNT(DISTINCT uc.company_id) AS total_company
FROM unicorn_companies AS uc
INNER JOIN unicorn_industries AS ui
ON uc.company_id = ui.company_id
WHERE uc.continent = 'Asia' 
AND uc.country not in (
    SELECT DISTINCT country
    FROM top_3
)
group by ui.industry, uc.country
ORDER BY total_company DESC;

--Question 11
--Is there any industry that does not have Indian unicorn? 
--Hint: use combination of CTE/subquery/JOIN/NOT IN
--Source table: unicorn_industries, unicorn_companies

SELECT ui.industry,
	COUNT (DISTINCT(uc.company_id)) AS unicorn_startups,
	uc.country
FROM unicorn_industries AS ui
LEFT JOIN unicorn_companies AS uc
ON uc.company_id = ui.company_id
WHERE uc.country = 'India'
GROUP BY ui.industry, uc.country
ORDER BY unicorn_startups DESC;

--Answer: the query only return 11 rows from possible 15.
--That means 4 industries do not have Indian unicorn startups.
--Answering this way is not really intuitive

--Using CTE to answer the same question
WITH india AS (
	SELECT DISTINCT ui.industry
	FROM unicorn_industries AS ui
	INNER JOIN unicorn_companies AS uc
	ON uc.company_id = ui.company_id
	WHERE uc.country = 'India'
)
SELECT DISTINCT ui.industry
FROM unicorn_industries AS ui
LEFT JOIN india AS i
ON ui.industry = i.industry
WHERE i.industry IS NULL

--Answer: India does not have unicorn startup in the industry of AI, 
--Consumer and Retail, Cybersecurity, and Hardware

--Question 12
--What are the three industries with the most unicorns between 2019-2021? 
--Show the number of unicorns and the average valuation (in billion)
--Source table: unicorn_industries, unicorn_dates, unicorn_funding

SELECT ui.industry, 
	EXTRACT (YEAR FROM (ud.date_joined)) AS year_joined_unicorn, 
	COUNT(DISTINCT (ui.company_id)) AS total_company,
	ROUND(AVG(uf.valuation),2) AS average_valuation
FROM unicorn_industries AS ui
INNER JOIN unicorn_dates AS ud
ON ui.company_id = ud.company_id
INNER JOIN unicorn_funding AS uf
ON ui.company_id = uf.company_id
GROUP BY ui.industry, year_joined_unicorn
HAVING EXTRACT (YEAR FROM (ud.date_joined)) BETWEEN 2019 AND 2021
ORDER BY ui.industry, year_joined_unicorn, total_company DESC;
--Not really effective to answer the questions

--using WITH function
WITH top_3 AS (
	SELECT ui.industry,
		COUNT(DISTINCT ui.company_id)
	FROM unicorn_industries AS ui
	INNER JOIN unicorn_dates AS ud
	ON ui.company_id = ud.company_id
	WHERE EXTRACT(YEAR FROM ud.date_joined) IN (2019,2020,2021)
	GROUP BY ui.industry
	ORDER BY COUNT(DISTINCT ui.company_id) DESC
	LIMIT 3
),

yearly_rank AS (
	SELECT ui.industry,
		EXTRACT(YEAR FROM ud.date_joined) AS year_joined,
		COUNT(DISTINCT ui.company_id) AS total_company,
		ROUND(AVG(uf.valuation)/1000000000,2) AS average_valuation_billion
	FROM unicorn_industries AS ui
	INNER JOIN unicorn_dates AS ud
	ON ui.company_id = ud.company_id
	INNER JOIN unicorn_funding AS uf
	ON ui.company_id = uf.company_id
	GROUP BY ui.industry, year_joined
)

SELECT y.* FROM yearly_rank AS y
INNER JOIN top_3 AS t
ON y.industry = t.industry
WHERE y.year_joined IN (2019,2020,2021)
ORDER BY 1,2 DESC;

--Question 13
--Which country has the most unicorn in this dataset?
--Hint: use window function SUM() OVER() dan CTE
--Source table: unicorn_companies

SELECT country,
	COUNT (DISTINCT company_id) AS total_per_country,
	ROUND((COUNT (DISTINCT company_id)/SUM(COUNT (DISTINCT company_id)) OVER() * 100),2) AS pct_company
	FROM unicorn_companies
	GROUP BY country
	ORDER BY pct_company DESC;
	
--Answer: US have the most unicorn with 52.33 percent of total unicorns in the dataset