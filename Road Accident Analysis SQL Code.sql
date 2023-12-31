--Select all records from the road_accident table:
--This query retrieves all columns and records from the road_accident table.
SELECT * FROM road_accident

--Calculate the total number of casualties in the year 2022:
--This query sums up the number_of_casualties for accidents that occurred in the year 2022.
SELECT SUM(number_of_casualties) AS CY_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022' 

--Count the number of distinct accidents in the year 2022:
--This query counts the distinct accidents in the year 2022.
SELECT COUNT(DISTINCT accident_index) AS CY_Accidents
FROM road_accident
WHERE YEAR(accident_date) = '2022' 

--Calculate the total number of casualties for accidents with 'Fatal' severity:
--This query sums up the number_of_casualties for accidents with 'Fatal' severity.
SELECT SUM(number_of_casualties) AS CY_Fatal_Casualties
FROM road_accident
WHERE accident_severity = 'Fatal'

--Calculate the total number of casualties for 'Serious' accidents in the year 2022:
--This query sums up the number_of_casualties for 'Serious' accidents that occurred in the year 2022.
SELECT SUM(number_of_casualties) AS CY_Serious_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022' AND accident_severity = 'Serious'

--Calculate the total number of casualties for 'Slight' accidents in the year 2022 
--This query sums up the number_of_casualties for 'Slight' accidents that occurred in the year 2022.
SELECT SUM(number_of_casualties) AS CY_Slight_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022' AND accident_severity = 'Slight'

--Percentage of total casualties slight
SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) * 100/
(SELECT CAST(SUM(number_of_casualties)  AS DECIMAL(10,2)) FROM road_accident) AS Percentage_Of_Total 
FROM road_accident
WHERE accident_severity = 'Slight'

--Percentage of total casualties serious
SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) * 100/
(SELECT CAST(SUM(number_of_casualties)  AS DECIMAL(10,2)) FROM road_accident) AS Percentage_Of_Total 
FROM road_accident
WHERE accident_severity = 'Serious'

--Percentage of total casualties Fatal
SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) * 100/
(SELECT CAST(SUM(number_of_casualties)  AS DECIMAL(10,2)) FROM road_accident) AS Percentage_Of_Total 
FROM road_accident
WHERE accident_severity = 'Fatal'

--Casualties by vehicle type (You can filter by 2022 if you want)
--This query groups the casualties by different vehicle types and calculates the total casualties for each group.
SELECT
	CASE 
		WHEN vehicle_type IN ('Agricultural vehicle') THEN 'Agricultural'
		WHEN vehicle_type IN ('Car','Taxi/Private hire car') THEN 'Cars'
		WHEN vehicle_type IN ('Motorcycle 125cc and under','Motorcycle 50cc and under','Motorcycle over 125cc and up to 500cc','Motorcycle over 500cc','Pedal cycle') THEN 'Motorcycle'
		WHEN vehicle_type IN ('Bus or coach (17 or more pass seats)','Minibus (8 - 16 passenger seats)') THEN 'Buses'
		WHEN vehicle_type IN ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t','Van / Goods 3.5 tonnes mgw or under') THEN 'Truck'
		ELSE 'Other'
	END AS vehicle_group,
	SUM(number_of_casualties) AS CY_Casualties
FROM road_accident
--WHERE YEAR(accident_date) = '2022'
GROUP BY 
	CASE
		WHEN vehicle_type IN ('Agricultural vehicle') THEN 'Agricultural'
		WHEN vehicle_type IN ('Car','Taxi/Private hire car') THEN 'Cars'
		WHEN vehicle_type IN ('Motorcycle 125cc and under','Motorcycle 50cc and under','Motorcycle over 125cc and up to 500cc','Motorcycle over 500cc','Pedal cycle') THEN 'Motorcycle'
		WHEN vehicle_type IN ('Bus or coach (17 or more pass seats)','Minibus (8 - 16 passenger seats)') THEN 'Buses'
		WHEN vehicle_type IN ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t','Van / Goods 3.5 tonnes mgw or under') THEN 'Truck'
		ELSE 'Other'
	END

--Monthly trend
--This query sums up the number_of_casualties by month
SELECT DATENAME(MONTH, accident_date) AS Months , SUM(number_of_casualties) AS Number_Of_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY DATENAME(MONTH, accident_date)

--Casualties by road type
--This query groups casualties by road type for the year 2022.
SELECT road_type, SUM(number_of_casualties) AS Number_Of_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY road_type

--Classified by area
--This query groups casualties by urban or rural area for the year 2022.
SELECT urban_or_rural_area, SUM(number_of_casualties) AS Number_Of_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY urban_or_rural_area

--Percentage by area
--This query calculates the percentage of casualties for each urban or rural area.
SELECT urban_or_rural_area, SUM(number_of_casualties) AS Number_of_Casualties, CAST(SUM(number_of_casualties) AS DECIMAL(10,2))*100/
(SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2))
FROM road_accident
--WHERE YEAR(accident_date) = '2022'
) AS Percentage 
FROM road_accident
--WHERE YEAR(accident_date) = '2022'
GROUP BY urban_or_rural_area

--Casualties by light conditions
--This query groups casualties by light conditions and calculates the percentage for the year 2022.
SELECT 
	CASE
		WHEN light_conditions IN ('Daylight') THEN 'Day'
		WHEN light_conditions IN ('Darkness - lighting unknown',
		'Darkness - lights lit','Darkness - lights unlit','Darkness - no lighting') THEN
		'Night'
	END AS Light_Conditions,
	CAST(CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) * 100/
	(SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) 
	FROM road_accident WHERE YEAR(accident_date) = '2022') AS DECIMAL(10,2)) 
	AS Percentage_Casualties
	FROM road_accident WHERE YEAR(accident_date) = '2022'
	GROUP BY
	CASE
		WHEN light_conditions IN ('Daylight') THEN 'Day'
		WHEN light_conditions IN ('Darkness - lighting unknown',
		'Darkness - lights lit','Darkness - lights unlit','Darkness - no lighting') THEN
		'Night'
	END

--Top 10 Location by number of casualties
--This query retrieves the top 10 locations with the highest total number of casualties.
SELECT TOP 10 local_authority, SUM(number_of_casualties) AS Total_Casualties
FROM road_accident
GROUP BY local_authority
ORDER BY Total_Casualties DESC