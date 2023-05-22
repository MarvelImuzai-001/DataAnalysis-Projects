create database Portfolioproject;
use portfolioproject;

select * from coviddeaths
where continent is not null
order by 3,4;

select * from covidvaccinations;

/* select data that we are going to be usibg */

select location, date, total_cases, new_cases, total_deaths, population
from coviddeaths
order by 1,2;

/* looking at the total cases vs total deaths */
/* shows likelihood of dying if you contract covid in your */
select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from coviddeaths
where location like 'ghana'
order by 1,2;

/* Looking at total cases vs population */
-- shows what population has covid in ghana--
select location, date, total_cases, new_cases, population, (total_deaths/population)*100 as Deathpercentage
from coviddeaths
where location like 'ghana'
order by location,date;

-- looking at countries with highest infection rate compared to population
select location,population,max(total_cases)as highestinfectioncount, max((total_cases/population))*100 as percentpopulationinfected
from coviddeaths
-- where location like 'ghana'
group by location,population
order by percentpopulationinfected desc;

-- showing countries with the highest death count per population
select location, max(cast(total_deaths as UNSIGNED)) as totaldeathcount
from coviddeaths
where continent is not null 
group by location
order by totaldeathcount desc;

describe coviddeaths;

-- les break it down by continent 
select continent, max(cast(total_deaths as UNSIGNED)) as totaldeathcount
from coviddeaths
where continent is not null 
group by continent
order by totaldeathcount desc;

-- les break it down by location
select location, max(cast(total_deaths as UNSIGNED)) as totaldeathcount
from coviddeaths
where location is not null 
group by location
order by totaldeathcount desc;

-- showing the continent with the highest death counts
select continent, max(cast(total_deaths as UNSIGNED)) as totaldeathcount
from coviddeaths
where continent is not null 
group by continent
order by totaldeathcount desc;

-- Global numbers
select date, sum(new_cases) as total_cases, sum(cast(new_deaths as unsigned))as total_deaths, sum(cast(new_deaths as unsigned))/sum(new_cases)*100 as deathpercentage
from coviddeaths
where continent is not null
group by date
order by 1,2;


set sql_safe_updates=0;

UPDATE coviddeaths
SET date = DATE_FORMAT(STR_TO_DATE(date, '%d/%m/%Y'), '%d-%m-%Y')
WHERE date LIKE '%/%';

-- Global numbers
select sum(new_cases) as total_cases, sum(cast(new_deaths as unsigned))as total_deaths, sum(cast(new_deaths as unsigned))/sum(new_cases)*100 as deathpercentage
from coviddeaths
where continent is not null
-- group by date
order by 1,2;

select * from covidvaccinations;

UPDATE covidvaccinations
SET date = DATE_FORMAT(STR_TO_DATE(date, '%d/%m/%Y'), '%d-%m-%Y')
WHERE date LIKE '%/%';

-- looking at total population vs vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as unsigned)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
 from coviddeaths  dea
join covidvaccinations  vac
	on dea.location = vac.location
    and dea.date = vac.date
    where dea.continent is not null
    order by 2,3;
    
UPDATE covidvaccinations SET date = DATE(STR_TO_DATE(date, '%d-%m-%Y %H:%i:%s UTC'))
WHERE date IS NOT NULL AND date != '';

-- use CTE
with popvsvac (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as unsigned)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
 from coviddeaths  dea
join covidvaccinations  vac
	on dea.location = vac.location
    and dea.date = vac.date
    where dea.continent is not null
    -- order by 2,3
    )
    select *, (rollingpeoplevaccinated/population) * 100 
    from popvsvac

-- temp table






