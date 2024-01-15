select *
from PortfolioProject..CovidDeaths
order by 3,4

--select * 
--from PortfolioProject..CovidVaccinations
--order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2


#looking at Total Cases vs Total Deaths

select location, date, total_cases, total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from PortfolioProject..covidDeaths
where location like '%states%'
order by 1,2

# looking at the Total Cases vs Population 
# shows what percenetage of population got covid

select location, date, population,  total_cases, 
(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 as PercentPopulationInfected
from PortfolioProject..covidDeaths
--where location like '%states%'
order by 1,2


# looking at countries with Highest Infection Rate compared to Population

select location, population,  MAX(total_cases) as HighestInfectionCount, 
MAX((CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))) * 100 AS PercentPopulationInfected
from PortfolioProject..covidDeaths
--where location like '%states%'
Group By population, location
order by PercentPopulationInfected desc

# showing countries with Highest Death Count per Population

select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..covidDeaths
--where location like '%states%'
where continent is not null
Group By location
order by TotalDeathCount desc


# lets break things down by Continent

select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..covidDeaths
--where location like '%states%'
where continent is not null
Group By location
order by TotalDeathCount desc


# showing continents with Highest Death Count per Population 

select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..covidDeaths
--where location like '%states%'
Group By continent
order by TotalDeathCount desc


# global numbers 

select SUM(cast(new_cases as int)) as Total_cases, SUM(cast(new_deaths as int)) as Total_deaths,
SUM((CONVERT(float, new_deaths) / NULLIF(CONVERT(float, new_cases), 0)))* 100 AS Deathpercentage
from PortfolioProject..covidDeaths
--where location like '%states%'
where continent is not null
--Group By date
order by 1,2

# looking at Total Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
order by 2,3

USE CTE

With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) 
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac

TEMP_TABLE
Drop Table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date Datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated

# creating view to stre data for later visualizations
 
 create view PercentPopulationVaccinated as 
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from PercentPopulationVaccinated