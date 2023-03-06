select * from PortfolioProject..CovidDeaths
order by 3,4

select * from PortfolioProject..CovidVaccinations
order by 3,4

--selecting the data for exploration


select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths 
order by 1,2

--Looking at total cases Vs total Deaths in UnitedStates 
-- Can also look at the percentage of death if one person contracts covid in their country

select location, date, total_cases, new_cases, total_deaths, population, (total_deaths/total_cases)*100 as DeathRate
from PortfolioProject..CovidDeaths 
where location like '%states%'
order by 1,2

--Looking at percentage of people infected/contracted covid

select location, date, total_cases, population,(total_cases/population)*100 as Infectedpercentage
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2

--Looking at the infection ratein highly populated countries
-- shows the high infected rates which is the proportion of total cases to that of the population in each country.
select location, population, MAX(total_cases) as MaximumInfectedpeople, Max((total_cases/population))*100 as MaximumInfectedpercentage
from PortfolioProject..CovidDeaths
-- if unitedstates is theonly countryu want to look for where location like '%states%'
Group by location, population
order by MaximumInfectedpercentage desc

--showing highest death count for the population

select location, population, MAX(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject..CovidDeaths
where continent is NOT NULL
group by location, population
order by HighestDeathCount DESC

--Looking at the death rate in continents

select continent, MAX(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject..CovidDeaths
where continent is NOT NULL
group by continent 
order by HighestDeathCount DESC

--Global outlook

select date, sum(new_cases) as Totalnewcasesoneachday
from PortfolioProject..CovidDeaths
group by date
order by Totalnewcasesoneachday desc

select date, sum(new_cases) as Totalnewcasesoneachday
from PortfolioProject..CovidDeaths
group by date
order by 1,2 

--Mortality rates on each day worldwide

select date, sum(new_cases) as totalcases, sum(cast(new_deaths as int)) as totaldeaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as Deathpercentage
from PortfolioProject..CovidDeaths
WHERE continent is not null
group by date
order by Deathpercentage desc

select sum(new_cases) as totalcases, sum(cast(new_deaths as int)) as totaldeaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as Deathpercentage
from PortfolioProject..CovidDeaths
WHERE continent is not null

--Looking at total population Vs Total vaccinations

select * from PortfolioProject..CovidDeaths as Dea
join PortfolioProject..CovidVaccinations as Vac
on Dea.continent = Vac.continent and Dea.date = Vac.date

select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations from PortfolioProject..CovidDeaths as Dea
join PortfolioProject..CovidVaccinations as Vac
on Dea.continent = Vac.continent and Dea.date = Vac.date
order by 1,2,3

select Dea.continent, Dea.location, Dea.date, Dea.population,Vac.new_vaccinations, sum(convert(int,Vac.new_vaccinations)) over (partition by Dea.location order by Dea.location,Dea.date)as New_vaccinations
from PortfolioProject..CovidDeaths as Dea
join PortfolioProject..CovidVaccinations as Vac
on Dea.continent = Vac.continent and Dea.date = Vac.date
where Dea.continent is NOT NULL
order by 2,3

--Using CTE table/Temp tables

with PopVsVac(Continent, Location, date, population,new_vaccinations, RollingVaccinations)
as
(
select Dea.continent, Dea.location, Dea.date, Dea.population,Vac.new_vaccinations, sum(convert(int,Vac.new_vaccinations)) over (partition by Dea.location order by Dea.location,Dea.date)as RollingVaccinations
from PortfolioProject..CovidDeaths as Dea
join PortfolioProject..CovidVaccinations as Vac
on Dea.continent = Vac.continent and Dea.date = Vac.date
where Dea.continent is NOT NULL
--ordr by 2,3
)
select * , (RollingVaccinations/population)*100 as Vaccinatedpercentage from PopVsVac

--TEMP TABLE

create table #PopulationVsVaccination(
continent nvarchar(255),location nvarchar(255),date datetime, population numeric, new_vaccinations numeric,RollingVaccinations numeric)

insert into #PopulationVsVaccination
select Dea.continent, Dea.location, Dea.date, Dea.population,Vac.new_vaccinations, sum(convert(int,Vac.new_vaccinations)) over (partition by Dea.location order by Dea.location,Dea.date)as RollingVaccinations
from PortfolioProject..CovidDeaths as Dea
join PortfolioProject..CovidVaccinations as Vac
on Dea.continent = Vac.continent and Dea.date = Vac.date
where Dea.continent is NOT NULL
--ordr by 2,3

select * , (RollingVaccinations/population)*100 as Vaccinatedpercentage from #PopulationVsVaccination

DROP table if exists #PopulationVsVaccination
create table #PopulationVsVaccination(
continent nvarchar(255),location nvarchar(255),date datetime, population numeric, new_vaccinations numeric,RollingVaccinations numeric)

insert into #PopulationVsVaccination
select Dea.continent, Dea.location, Dea.date, Dea.population,Vac.new_vaccinations, sum(convert(int,Vac.new_vaccinations)) over (partition by Dea.location order by Dea.location,Dea.date)as RollingVaccinations
from PortfolioProject..CovidDeaths as Dea
join PortfolioProject..CovidVaccinations as Vac
on Dea.continent = Vac.continent and Dea.date = Vac.date
--where Dea.continent is NOT NULL
--ordr by 2,3

select * , (RollingVaccinations/population)*100 as Vaccinatedpercentage from #PopulationVsVaccination

--Creating a view to store data

create view PopulationVsVaccination as
select Dea.continent, Dea.location, Dea.date, Dea.population,Vac.new_vaccinations, sum(convert(int,Vac.new_vaccinations)) over (partition by Dea.location order by Dea.location,Dea.date)as RollingVaccinations
from PortfolioProject..CovidDeaths as Dea
join PortfolioProject..CovidVaccinations as Vac
on Dea.continent = Vac.continent and Dea.date = Vac.date
where Dea.continent is NOT NULL
--order by 2,3

select top 1000[continent],
[location],[date],[population],[new_vaccinations],[RollingVaccinations]from PortfolioProject..PopulationVsVaccination