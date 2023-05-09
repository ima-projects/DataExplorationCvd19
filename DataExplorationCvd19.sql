SELECT *
From  [dbo].[CovidDeaths]
Where continent is not NULL
Order by 3,4

--SELECT *
--From [dbo].[CovidVaccinations]
--Order by 3,4

-- Select Data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
From  [dbo].[CovidDeaths]
Where continent is not NULL
Order by 1,2


-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if one contracts covid in the United Kingdom
SELECT location, date, total_cases, total_deaths, cast(total_deaths/cast(total_cases as float) as float)*100 as DeathPercentage
From  [dbo].[CovidDeaths]
Where location like '%kingdom%' 
Order by 1,2

--Observations
--Highest death percentage rate peaked at 22.9% on 23/04/2020

-- Looking at the Total Cases vs Population
-- Shows what percentage of population contracted covid
SELECT location, date, Population, total_cases, cast(total_cases/cast(population as float) as float)*100 as PercentPopulationInfected
From  [dbo].[CovidDeaths]
Where location like '%kingdom%'
Order by 1,2


-- Looking at Countries with Highest Infection Rate compared to Population (and has been reported)
SELECT location, Population, MAX(total_cases) as HighestInfectionCount, MAX(cast(total_cases/cast(population as float) as float))*100 as PercentPopulationInfected
From  [dbo].[CovidDeaths]
-- Where location like '%kingdom%'
Group by Location, Population
Order by PercentPopulationInfected DESC

-- Observations
-- Cyprus retains the highest infection rate percentage at 73.5% which has been reported
-- As of 09/05/2023, it appears that countries that are known holiday destinations top the list e.g. Cyprus, Greece, Portugal, etc.


-- Showing the Countries with the Highest Death Count per Population
SELECT location, MAX(total_deaths) as TotalDeathCount
From  [dbo].[CovidDeaths]
-- Where location like '%kingdom%'
Where continent is not NULL
Group by Location
Order by TotalDeathCount DESC

-- Observations
-- United States has the highest total death count



-- Segmenting by Continent

-- Showing the continents with the highest death count per population
SELECT continent, MAX(total_deaths) as TotalDeathCount
From  [dbo].[CovidDeaths]
-- Where location like '%kingdom%'
Where continent is not NULL
Group by continent
Order by TotalDeathCount DESC


-- GLOBAL NUMBERS (all countries are grouped by date (aggregated on a per day basis)

SELECT date, 
	SUM(new_cases) as total_cases, 
	SUM(new_deaths) as total_deaths, 
	ISNULL(Sum(cast(new_deaths as float)) / NULLIF(Sum(cast(new_cases as float)), 0), 0)*100 AS DeathPercentage
From  [dbo].[CovidDeaths]
-- Where location like '%kingdom%'
Where continent is not NULL
Group by date
Order by 1,2


-- Working...
-- SUM(cast(new_deaths/cast(new_cases as float) as float))*100 as DeathPercentage
-- SUM(cast(new_deaths as float))/SUM(cast(new_cases as float))*100 as DeathPercentage
-- SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage


-- Global total without date
SELECT
	SUM(new_cases) as total_cases, 
	SUM(new_deaths) as total_deaths, 
	ISNULL(Sum(cast(new_deaths as float)) / NULLIF(Sum(cast(new_cases as float)), 0), 0)*100 AS DeathPercentage
From  [dbo].[CovidDeaths]
-- Where location like '%kingdom%'
Where continent is not NULL
-- Group by date
Order by 1,2

-- Observations:
-- 765,237,638 total cases worldwide
-- 6,928,131 total deaths
-- 0.9 % death rate


--JOINING THE TWO TABLES

-- Looking at Total Population vs Vaccinations (this query example would not be able to perform calculation hence the error on alias RollingPeopleVaccinated)

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.date) as RollingPeopleVaccinated
, RollingPeopleVaccinated/population
FROM [dbo].[CovidDeaths] dea
Join [dbo].[CovidVaccinations] vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not NULL
ORDER BY 2, 3


-- USE CTE (similar to last query but allowed to perform calculations here as it was not possible above. The CTE creates a new common table expression of the two joined tables)

WITH PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.date) as RollingPeopleVaccinated
--, RollingPeopleVaccinated/population*100
FROM [dbo].[CovidDeaths] dea
Join [dbo].[CovidVaccinations] vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not NULL
-- ORDER BY 2, 3
)
SELECT *, cast(RollingPeopleVaccinated/cast(Population as float) as float)*100
FROM PopvsVac
ORDER BY 2,3

-- Working...
-- (RollingPeopleVaccinated/Population)*100
-- cast(RollingPeopleVaccinated/cast(Population as float) as float)*100

-- Observations
-- The highest percentage of people vaccinated can go over 200%. I believe that this is not accounting for people that have been vaccinated more than once, given that the aggregate SUM function utilises the new_vaccinations column)
-- in the future to normalise the numbers, it would be best to limit it to a date range where people were getting vaccinations e.g. when vaccinations were required to be able to enter a location or do a certain activity




-- TEMP TABLE

DROP TABLE IF exists #PercentPopulationVaccinated -- used when needing to run temp table multiple times to change things
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.date) as RollingPeopleVaccinated
--, RollingPeopleVaccinated/population*100
FROM [dbo].[CovidDeaths] dea
Join [dbo].[CovidVaccinations] vac
	ON dea.location = vac.location
	and dea.date = vac.date
-- WHERE dea.continent is not NULL
-- ORDER BY 2, 3

SELECT *, cast(RollingPeopleVaccinated/cast(Population as float) as float)*100
FROM #PercentPopulationVaccinated
ORDER BY 2,3



-- Creating View to store data for later visualisations

Create View PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.date) as RollingPeopleVaccinated
--, RollingPeopleVaccinated/population*100
FROM [dbo].[CovidDeaths] dea
Join [dbo].[CovidVaccinations] vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not NULL
-- ORDER BY 2, 3


SELECT *
FROM PercentPopulationVaccinated

