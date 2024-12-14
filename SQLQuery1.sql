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


Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject1.dbo.CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc






--SELECT * 
--FROM PortfolioProject1.dbo.CovidVaccinations
--order by 3,4