SELECT * FROM INFORMATION_SCHEMA.TABLES

-- Create the new "hotels" table with the same structure as one of the source tables (e.g., [2018$])
SELECT *
INTO hotels
FROM dbo.['2018$']
WHERE 1 = 0; -- This creates an empty "hotels" table with the same structure

-- Insert data from all three tables into the "hotels" table using UNION
INSERT INTO hotels
SELECT * FROM dbo.['2018$']
UNION
SELECT * FROM dbo.['2019$']
UNION
SELECT * FROM dbo.['2020$'];

select * from hotels

-- Data Exploration
-- What are the hotels revenue from 2018 to 2020 by hotel category?

select arrival_date_year, hotel, round(sum((stays_in_weekend_nights+stays_in_week_nights)*adr),2)
from hotels
group by hotel,arrival_date_year 
order by arrival_date_year asc

-- Describe top 10 country by number of traveller nd their market segment and distribution channels
select top 10 country,market_segment,distribution_channel,count(country) as total_traveller from hotels
group by country,market_segment,distribution_channel
order by total_traveller desc

-- Number of travellers over the year

select arrival_date_year,arrival_date_month, 
sum(stays_in_weekend_nights+stays_in_week_nights)
from hotels 
group by arrival_date_year,arrival_date_month
ORDER BY arrival_date_year, CASE 
    WHEN arrival_date_month = 'January' THEN 1
    WHEN arrival_date_month = 'February' THEN 2
    WHEN arrival_date_month = 'March' THEN 3
    WHEN arrival_date_month = 'April' THEN 4
    WHEN arrival_date_month = 'May' THEN 5
    WHEN arrival_date_month = 'June' THEN 6
    WHEN arrival_date_month = 'July' THEN 7
    WHEN arrival_date_month = 'August' THEN 8
    WHEN arrival_date_month = 'September' THEN 9
    WHEN arrival_date_month = 'October' THEN 10
    WHEN arrival_date_month = 'November' THEN 11
    WHEN arrival_date_month = 'December' THEN 12
    ELSE 0
END;
-- Repeated guest ratio per country to understand guest returning ratio and
-- identify opportunity to capture returning guest. 
select top 10 country, round(sum(is_repeated_guest)/count(country)*100,2) 
as pct_return_guest
from hotels
group by country
order by pct_return_guest desc