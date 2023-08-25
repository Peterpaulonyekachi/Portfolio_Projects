SELECT *
FROM PortfolioProject..covid_deaths
WHERE continent IS NOT NULL
ORDER BY 3, 4;

--Select data that we are going to use

SELECT Location, date, total_cases, new_cases, total_deaths,population
FROM PortfolioProject..covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

--Looking at Total Cases vs Total Deaths
--Shows the likelihood of dying if you contract covid in your country

SELECT Location, date, total_cases, new_cases, total_deaths,(total_deaths/total_cases) *100 as Death_Percentage
FROM PortfolioProject..covid_deaths
WHERE Location like '%Nigeria%' AND continent IS NOT NULL
ORDER BY 1, 2;

--Looking at the Total Cases vs Population
--Shows what percentage of population got covid

SELECT Location, date, population, total_cases, (total_cases/population) * 100 as Percentage_Infected_Cases
FROM PortfolioProject..covid_deaths
WHERE Location like '%Nigeria%' AND continent IS NOT NULL
ORDER BY 1, 2;

-- Looking at countries with highest infection rate compared to Population

SELECT Location, population, MAX(total_cases) as Highest_Infection_Count, MAX((total_cases/population)) * 100 as Percenage_Population_Infected
FROM PortfolioProject..covid_deaths
--WHERE Location like '%Nigeria%' AND continent IS NOT NULL
GROUP BY location, population
ORDER BY Percenage_Population_Infected DESC

--Showing countries with highest death count per population

SELECT Location, MAX(total_deaths) as Total_Death
FROM PortfolioProject..covid_deaths
--WHERE Location like '%Nigeria%' 
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY Total_Death DESC

--Breaking by Continent

SELECT Continent, Population, MAX(total_deaths) as Total_Death
FROM PortfolioProject..covid_deaths
--WHERE Location like '%Nigeria%' 
WHERE continent IS NOT NULL
GROUP BY Continent, Population
ORDER BY Total_Death DESC

--Global Numbers

Select date, SUM(NEW_CASES) Total_cases, SUM(CAST(NEW_DEATHS AS INT)) Total_Deaths, SUM(CAST(NEW_DEATHS AS INT))/SUM(NEW_CASES)*100 DEATH_PERCENTAGE
From PortfolioProject..covid_deaths
--Where location like '%Nigeria%'
where continent is not null
group by date
order by 1, 2


--Looking at Total Population Vs Total Vaccinations

SELECT CD.continent, CD.location, cd.date, cd.population , cv.new_vaccinations, SUM(CONVERT(INT, CV.NEW_VACCINATIONS)) 
OVER (PARTITION BY CD.location Order by CD.location, cd.date) Rolling_People_Vaccinated
--, (Rolling_People_Vaccinated/population)*100
FROM PortfolioProject..covid_deaths CD
JOIN PortfolioProject..covid_vaccinations CV
	ON CD.location = CV.location
	AND CD.date = CV.date
WHERE CD.continent IS NOT NULL
ORDER BY 2, 3


-- USE CTE

WITH PopVsVac (Continent, Location, Date, Population,New_Vaccinations, Rolling_People_Vaccinated)
as
(SELECT CD.continent, CD.location, cd.date, cd.population , cv.new_vaccinations, SUM(CONVERT(INT, CV.NEW_VACCINATIONS)) 
OVER (PARTITION BY CD.location Order by CD.location, cd.date) Rolling_People_Vaccinated
--, (Rolling_People_Vaccinated/population)*100
FROM PortfolioProject..covid_deaths CD
JOIN PortfolioProject..covid_vaccinations CV
	ON CD.location = CV.location
	AND CD.date = CV.date
WHERE CD.continent IS NOT NULL
--ORDER BY 2, 3
)
Select *,(Rolling_People_Vaccinated/Population)*100
From PopVsVac


--TEMP TABLE
DROP TABLE if exists #Percent_Population_Vaccinated
CREATE TABLE #Percent_Population_Vaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
Rolling_People_Vaccinated numeric)

INSERT INTO #Percent_Population_Vaccinated
SELECT CD.continent, CD.location, cd.date, cd.population , cv.new_vaccinations, SUM(CONVERT(INT, CV.NEW_VACCINATIONS)) 
OVER (PARTITION BY CD.location Order by CD.location, cd.date) Rolling_People_Vaccinated
--, (Rolling_People_Vaccinated/population)*100
FROM PortfolioProject..covid_deaths CD
JOIN PortfolioProject..covid_vaccinations CV
	ON CD.location = CV.location
	AND CD.date = CV.date
WHERE CD.continent IS NOT NULL
ORDER BY 2, 3

Select *,(Rolling_People_Vaccinated/Population)*100
From #Percent_Population_Vaccinated


--Creating view to store data for later vizualization
USE [PortfolioProject]

CREATE VIEW Percentage_Population_Vaccinated AS

SELECT CD.continent, CD.location, cd.date, cd.population , cv.new_vaccinations, SUM(CONVERT(INT, CV.NEW_VACCINATIONS)) 
OVER (PARTITION BY CD.location Order by CD.location, cd.date) Rolling_People_Vaccinated
--, (Rolling_People_Vaccinated/population)*100
FROM PortfolioProject..covid_deaths CD
JOIN PortfolioProject..covid_vaccinations CV
	ON CD.location = CV.location
	AND CD.date = CV.date
WHERE CD.continent IS NOT NULL
--ORDER BY 2, 3



SELECT*
FROM Percentage_Population_Vaccinated