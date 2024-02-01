select *
from COVID..CovidDeaths$
order by 3,4

select *
from COVID..CovidDeaths$
order by 3,4

select location, date, total_cases, new_cases,total_deaths, population
from COVID..CovidDeaths$
order by 1,2

-- looking at total cases vs Total Deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from COVID..CovidDeaths$
where location like '%poland%'
order by 1,2

-- Looking at Total Cases vs population 
-- Shows what percentage of population got Covid

select location, date, total_cases, population, (total_cases/population)*100 as InfectedPPL
from COVID..CovidDeaths$
where location like '%saudi%'
order by 1,2

-- Looking at Countries with highest infection Rate compared to Population

select location, population , max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as HigestInfection
from COVID..CovidDeaths$
--where location like '%saudi%'
Group By location, population
order by HigestInfection desc

-- Showing Countries with Highest Death Count per population

select location, max(cast(total_deaths as int)) as HighestDeath
from COVID..CovidDeaths$
where continent is not null
Group By location
order by HighestDeath desc


-- let's break things down by contients

select location, max(cast(total_deaths as int)) as HighestDeath
from COVID..CovidDeaths$
where continent is null
Group By location
order by HighestDeath desc

-- Global Numbers

select sum(new_cases) as total_case, Sum(cast(new_deaths as int)) as Total_death,
	sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from COVID..CovidDeaths$
where continent is null
	--Group By location
order by 1,2


-- now we working with both tables together

Select dea.continent, dea.location, dea.date, dea.population,
	vac.new_vaccinations, sum(convert(int,vac.new_vaccinations))
	over (partition by dea.location order by dea.location, dea.date) as RollingPPLVaccinated
from COVID..CovidDeaths$ dea
join COVID..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- we want to calculate the amount of ppl vac compared to the population
--- for that we have to create CTE or TEMP table

with PopvsVac (continent, location, date, population, new_vaccinations, RollingPPLVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population,
	vac.new_vaccinations, sum(convert(int,vac.new_vaccinations))
	over (partition by dea.location order by dea.location, dea.date) as RollingPPLVaccinated
from COVID..CovidDeaths$ dea
join COVID..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPPLVaccinated/population)*100 as percentage
from PopvsVac


-- Temp table
drop table if exists #PercentPopulationVaccinteddd
create table #PercentPopulationVaccinteddd
(
continent varchar(255),
location varchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPPLVaccinated numeric,
percentage numeric
)

Insert into #PercentPopulationVaccinteddd
Select dea.continent, dea.location, dea.date, dea.population,
	vac.new_vaccinations, sum(convert(int,vac.new_vaccinations))
	over (partition by dea.location order by dea.location, dea.date) as RollingPPLVaccinated
from COVID..CovidDeaths$ dea
join COVID..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (RollingPPLVaccinated/population)*100 as percentage
from #PercentPopulationVaccinteddd

-- create view 
create view PercentPopulationVaccinteddd As
Select dea.continent, dea.location, dea.date, dea.population,
	vac.new_vaccinations, sum(convert(int,vac.new_vaccinations))
	over (partition by dea.location order by dea.location, dea.date) as RollingPPLVaccinated
from COVID..CovidDeaths$ dea
join COVID..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

-- now we can use our view for viewing later..
select *
from PercentPopulationVaccinteddd