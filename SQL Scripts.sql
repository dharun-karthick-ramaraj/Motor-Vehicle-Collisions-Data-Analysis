create database finalDAMGproject;

#ContributingFactor
Select * from finaldamgproject.stg_ContributingFactor;
Select COUNT(*) from finaldamgproject.stg_ContributingFactor;

#Austin
select * from finaldamgproject.stg_austin;
select count(*) from finaldamgproject.stg_austin;
select * from finaldamgproject.transform_austin;
select count(*) from finaldamgproject.transform_austin;

#NewYork
select * from finaldamgproject.stg_nyc;
select COUNT(*) from finaldamgproject.stg_nyc;
select * from finaldamgproject.transform_nyc;
select count(*) from finaldamgproject.transform_nyc;

#Chicago
select * from finaldamgproject.stg_chicago;
select COUNT(*) from finaldamgproject.stg_chicago;
select * from finaldamgproject.transform_chicago;
select COUNT(*) from finaldamgproject.transform_chicago;

#Merged
select * from finaldamgproject.merged_report;
select COUNT(*) from finaldamgproject.merged_report;
select * from finaldamgproject.merged_report where City='Austin';
select * from finaldamgproject.merged_report where City ='Chicago';
select * from finaldamgproject.merged_report where City='New York';


create database finalProject_DataWarehouse;

#Date Dimension
select * from finalProject_DataWarehouse.Dim_Date;
select COUNT(*) from finalProject_DataWarehouse.Dim_Date;

#Time Dimension
select * from finalProject_DataWarehouse.Dim_Time;
select COUNT(*) from finalProject_DataWarehouse.Dim_Time;

#Weather Dimension
select * from finalProject_DataWarehouse.Dim_Weather;
select COUNT(*) from finalProject_DataWarehouse.Dim_Weather;

#Source Dimension
select * from finalProject_DataWarehouse.Dim_Source;
select COUNT(*) from finalProject_DataWarehouse.Dim_Source;

#Location Dimension
select * from finalProject_DataWarehouse.Dim_Location;
select COUNT(*) from finalProject_DataWarehouse.Dim_Location;

#Factor Dimension
select * from finalProject_DataWarehouse.Dim_Factor;
select COUNT(*) from finalProject_DataWarehouse.Dim_Factor;

#Factor VehicleType
select * from finalProject_DataWarehouse.Dim_VehicleType;
select COUNT(*) from finalProject_DataWarehouse.Dim_VehicleType;

#Fact Accident
select * from finalProject_DataWarehouse.Fact_Accident;
select COUNT(*) from finalProject_DataWarehouse.Fact_Accident;

#Fact VehicleInvolved
select * from finalProject_DataWarehouse.Fact_VehicleInvolved;
select COUNT(*) from finalProject_DataWarehouse.Fact_VehicleInvolved;

#Fact ContributingFactors
select * from finalProject_DataWarehouse.Fact_ContributingFactors;
select COUNT(*) from finalProject_DataWarehouse.Fact_ContributingFactors;

select * from finaldamgproject.temp1;

use `finalproject_datawarehouse`;

#How many accidents occurred in NYC, Austin, and Chicago?
SELECT
  dl.City,
  COUNT(*) AS AccidentCount
FROM fact_accident fa
JOIN dim_location dl ON fa.LocationSK = dl.LocationSK
WHERE dl.City IN ('New York', 'Austin', 'Chicago')
GROUP BY dl.City;

#Which areas in the 3 cities had the greatest number of accidents? (top 3 areas in each city)
SELECT
  dl.City,
  dl.Area,
  COUNT(*) AS AccidentCount
FROM fact_accident fa
JOIN dim_location dl ON fa.LocationSK = dl.LocationSK
WHERE dl.City IN ('New York', 'Austin', 'Chicago')
  AND NOT (dl.City = 'New York' AND (dl.Area IS NULL OR dl.Area = ''))
GROUP BY dl.City, dl.Area
ORDER BY dl.City, AccidentCount DESC
LIMIT 3;

# How many accidents resulted in just injuries? (Overall and by city)
-- Overall
SELECT
  COUNT(*) AS AccidentsWithInjuries
FROM fact_accident
WHERE TotalInjured > 0 AND TotalKilled = 0;


-- By City
SELECT
  dl.City,
  COUNT(*) AS AccidentsWithInjuries
FROM fact_accident fa
JOIN dim_location dl ON fa.LocationSK = dl.LocationSK
WHERE TotalInjured > 0 AND TotalKilled = 0
GROUP BY dl.City;

# How often are pedestrians involved in accidents? (Overall and by city)
-- Overall
SELECT
  COUNT(*) AS PedestrianInvolvedAccidents
FROM fact_accident
WHERE PedastriansInjured > 0 OR PedastriansKilled > 0;

-- By City
SELECT
  dl.City,
  COUNT(*) AS PedestrianInvolvedAccidents
FROM fact_accident fa
JOIN dim_location dl ON fa.LocationSK = dl.LocationSK
WHERE PedastriansInjured > 0 OR PedastriansKilled > 0
GROUP BY dl.City;

# When do most accidents happen? (Seasonality report)
SELECT
  dd.Quarter,
  dd.MonthName,
  COUNT(*) AS AccidentCount
FROM fact_accident fa
JOIN dim_date dd ON fa.DateSK = dd.DateSK
GROUP BY dd.Quarter, dd.MonthName
ORDER BY dd.Quarter, MIN(dd.MonthNumberOfYear)
LIMIT 0, 1000;

# How many motorists are injured or killed in accidents? (Overall and by city)
-- Overall
SELECT
  SUM(MotoristInjured) AS TotalMotoristInjured,
  SUM(MotoristKilled) AS TotalMotoristKilled
FROM fact_accident;

-- By City
SELECT
  dl.City,
  SUM(MotoristInjured) AS TotalMotoristInjured,
  SUM(MotoristKilled) AS TotalMotoristKilled
FROM fact_accident fa
JOIN dim_location dl ON fa.LocationSK = dl.LocationSK
GROUP BY dl.City;

# Which top 5 areas in 3 cities have the most fatal number of accidents?
SELECT
  dl.City,
  dl.Area,
  SUM(TotalKilled) AS FatalAccidents
FROM fact_accident fa
JOIN dim_location dl ON fa.LocationSK = dl.LocationSK
GROUP BY dl.City, dl.Area
ORDER BY dl.City, FatalAccidents DESC
LIMIT 5;

# Time-based analysis of accidents (Time of the day, day of the week, weekdays or weekends)
-- Time of the Day
SELECT
  dt.TimeOfTheDay,
  COUNT(*) AS AccidentCount
FROM fact_accident fa
JOIN dim_time dt ON fa.TimeSK = dt.TimeSK
GROUP BY dt.TimeOfTheDay;

-- Day of the Week
SELECT
  dd.DayNameOfWeek,
  COUNT(*) AS AccidentCount
FROM fact_accident fa
JOIN dim_date dd ON fa.DateSK = dd.DateSK
GROUP BY dd.DayNameOfWeek;

-- Weekdays vs Weekends
SELECT
  CASE 
    WHEN dd.WeekendIndicator = 'Yes' THEN 'Weekend' 
    ELSE 'Weekday' 
  END AS DayType,
  COUNT(*) AS AccidentCount
FROM fact_accident fa
JOIN dim_date dd ON fa.DateSK = dd.DateSK
GROUP BY dd.WeekendIndicator;

# Fatality analysis
-- Are pedestrians killed more often than road users?
SELECT
  'Pedestrians' AS VictimType,
  SUM(PedastriansKilled) AS Deaths
FROM fact_accident
UNION ALL
SELECT
  'Motorists' AS VictimType,
  SUM(MotoristKilled) AS Deaths
FROM fact_accident
UNION ALL
SELECT
  'Cyclists' AS VictimType,
  SUM(CyclistKilled) AS Deaths
FROM fact_accident;

# What are the most common factors involved in accidents?
SELECT
  df.FactorDescription,
  COUNT(*) AS Occurrences
FROM fact_contributingfactors fcf
JOIN dim_factor df ON fcf.FactorSK = df.FactorSK
GROUP BY df.FactorDescription
ORDER BY Occurrences DESC
LIMIT 10;







