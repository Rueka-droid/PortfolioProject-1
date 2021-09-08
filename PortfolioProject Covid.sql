Select*
From PortfolioProject..CovidDeaths
order by 3,4

--Select*
--From PortfolioProject..CovidVacines
--order by 3,4

--Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths , population
From PortfolioProject..CovidDeaths
order by 1,2

--Looking at total cases vs total deaths

Select Location, date, total_cases, total_deaths , (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
order by 1,2

--Looking at the total cases vs population
--Shows what percentage of population got covid

Select Location, date, population, total_cases , (total_cases/population)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
order by 1,2

--Looking at countries with highest infection rate compared to population

Select Location, population,MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by Location,Population
order by PercentPopulationInfected desc

--Showing continents with the highest death counts

Select continent,MAX(cast(total_deaths as int)) as totaldeathcount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null	
Group by continent
order by totaldeathcount desc

--Global Numbers

Select date, SUM(new_cases)as total_cases,SUM(cast(new_deaths as int))as total_deaths,SUM(cast(New_deaths as int))/SUM(New_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null	
Group by DATE
order by 1,2

--Looking at total population vs vaccinations

Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location,dea.date)as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacines vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--USE CTE

--With PopvsVac (Continent,Location,Date,Population,New_Vaccinations,RollingPeopleVaccinated)
--as
--(
--Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
--,SUM(CONVERT(int,vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location,dea.date)as RollingPeopleVaccinated
--From PortfolioProject..CovidDeaths dea
--Join PortfolioProject..CovidVacines vac
--On dea.location = vac.location
--and dea.date = vac.date
--where dea.continent is not null
--order by 2,3
--)
--Select *,(RollingPeopleVaccinated/Population)*100
--From PopvsVac

--TEMP TABLE

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,

)
 Insert into #PercentPopulationVaccinated
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location,dea.date)as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacines vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

Select *,(RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

--Creating view to store data for later visualaizations

Create View PercentPopulationVaccinated as 
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location,dea.date)as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacines vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
