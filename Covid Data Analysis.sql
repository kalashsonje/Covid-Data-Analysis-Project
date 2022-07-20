Select *
From [Portfolio Project]..CovidDeaths
where continent is not null
order by 3,4;

--Select *
--From [Portfolio Project]..CovidVaccinations
--order by 3,4;

Select Location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project]..CovidDeaths
where continent is not null
order by 1,2


-- Looking at Total Cases vs Total Deaths

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
From [Portfolio Project]..CovidDeaths
where location= 'India'
and continent is not null
order by 1,2

--Looking at Total cases vs Population

Select Location, date, Population, total_cases, (total_cases/Population)*100 as PercentagePopulationInfected
From [Portfolio Project]..CovidDeaths
--where location= 'India'
where continent is not null
order by 1,2

-- Looking at Countries with Highest Infection rate

Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as PercentagePopulationInfected
From [Portfolio Project]..CovidDeaths
-- where location= 'India'
where continent is not null
Group by Location, Population
order by PercentagePopulationInfected desc


-- Total Death tolls by Continent

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
-- where location= 'India'
where continent is null
Group by Location
order by TotalDeathCount desc

-- Global Numbers


Select date, SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
where continent is not null
Group by date
order by date


-- Now let us join the CovidDeaths and CovidVaccination tables

Select *
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
  on dea.location= vac.location
  and dea.date = vac.date

  -- Looking for Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations, vac.total_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
  on dea.location= vac.location
  and dea.date = vac.date
where dea.continent is not null
order by 2,3



-- Use CTE

With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
 --(RollingPeopleVaccinated/Population)*100
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
  on dea.location= vac.location
  and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

Select *, (RollingPeopleVaccinated/Population)*100 as PercentPopulationVaccinated
From PopvsVac


-- Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT into #PercentPopulationVaccinated

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
 --(RollingPeopleVaccinated/Population)*100
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
  on dea.location= vac.location
  and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating view to store data for later Visualisation

Create View PercentPupulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
 --(RollingPeopleVaccinated/Population)*100
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
  on dea.location= vac.location
  and dea.date = vac.date
where dea.continent is not null
--order by 2,3