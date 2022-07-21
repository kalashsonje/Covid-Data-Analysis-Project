-- For Tableu Verification

-- 1

Select SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
where continent is not null
--Group by date
order by 1,2


-- 2

Select Location, SUM(cast(new_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
-- where location= 'India'
where continent is null
and location not in ('World', 'European Union', 'International')
Group by Location
order by TotalDeathCount desc



-- 3

Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as PercentagePopulationInfected
From [Portfolio Project]..CovidDeaths
-- where location= 'India'
where continent is not null
Group by Location, Population
order by PercentagePopulationInfected desc


-- 4

Select Location, Population, date, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as PercentagePopulationInfected
From [Portfolio Project]..CovidDeaths
-- where location= 'India'
where continent is not null
Group by Location, Population, date
order by PercentagePopulationInfected desc