--Select the Covid Death data

SELECT *
FROM PortfolioProject1.dbo.CovidDeaths
where continent is not null

SELECT population, location, date, total_cases, new_cases, total_deaths
FROM PortfolioProject1.dbo.CovidDeaths
where continent is not null


-- Total cases vs total deaths  - percenatge, based on location
SELECT 
    location, 
    date, 
    total_cases, 
    total_deaths, 
    CASE 
        WHEN CAST(total_cases AS FLOAT) = 0 THEN NULL
        ELSE (CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT))*100
    END AS DeathRatio
FROM 
    PortfolioProject1.dbo.CovidDeaths
where continent is not null
ORDER BY 
    location, date;


--what percentage of population got covid in canada?

SELECT 
    location, 
    date, 
	population,
    total_cases, 
      CASE 
        WHEN CAST(total_cases AS FLOAT) = 0 THEN NULL
        ELSE (CAST(total_cases AS FLOAT) / CAST(population AS FLOAT))*100
    END AS DeathRatio
FROM 
    PortfolioProject1.dbo.CovidDeaths
--WHERE LOCATION LIKE '%CANADA%'\
ORDER BY 
    location, date;



--Countries with higher DEATH rate VS POPULATION

SELECT continent, location, MAX(CAST(total_DEATHS AS int)) AS TOTALDEATHs
FROM PortfolioProject1.dbo.CovidDeaths
where continent is not null
GROUP BY continent, location
ORDER BY TOTALDEATHS DESC;

--based on continent
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject1.dbo.CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS

SELECT 
    SUM(CAST(new_cases AS INT)) AS total_cases, 
    SUM(CAST(CASE 
                WHEN ISNUMERIC(new_deaths) = 1 THEN new_deaths 
                ELSE '0' 
            END AS INT)) AS total_deaths, 
    (SUM(CAST(CASE 
                WHEN ISNUMERIC(new_deaths) = 1 THEN new_deaths 
                ELSE '0' 
            END AS INT)) * 1.0) / SUM(CAST(new_cases AS INT)) * 100 AS DeathPercentage
FROM 
    PortfolioProject1.dbo.CovidDeaths
WHERE 
    continent IS NOT NULL
-- GROUP BY date
ORDER BY 1, 2;


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has received at least one Covid Vaccine

SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    SUM(CAST(CASE 
                WHEN ISNUMERIC(vac.new_vaccinations) = 1 THEN vac.new_vaccinations 
                ELSE '0' 
            END AS INT)) 
        OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated,
    (SUM(CAST(CASE 
                WHEN ISNUMERIC(vac.new_vaccinations) = 1 THEN vac.new_vaccinations 
                ELSE '0' 
            END AS INT)) 
        OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) * 1.0 / dea.population) * 100 AS VaccinationPercentage
FROM 
    PortfolioProject1.dbo.CovidDeaths dea
JOIN 
    PortfolioProject1.dbo.CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL
ORDER BY 
    dea.location, dea.date;

--Cheking columns
SELECT TOP 10 dea.location, dea.date
FROM PortfolioProject1.dbo.CovidDeaths dea;

SELECT TOP 10 vac.location, vac.date
FROM PortfolioProject1.dbo.CovidVaccinations vac;



-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject1.dbo.CovidDeaths dea
Join PortfolioProject1.dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


--SELECT * 
--FROM PortfolioProject1.dbo.CovidVaccinations
--order by 3,4