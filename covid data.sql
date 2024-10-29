select*
from profolio..CovidDeaths
where continent is not null
order by 3,4


select*
from profolio..[Covid vaccination]
order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from PROFOLIO..CovidDeaths
order by 1,2


--looking at total cases vs total death
--shows the likelyhood of dying 

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deahpercentage
from PROFOLIO..CovidDeaths
where location like'%kenya%'
order by 1,2


--looking at the total cases vs population

select location,date,total_cases,population,(total_cases/population)*100 as deahpercentage
from PROFOLIO..CovidDeaths
where location like'%kenya%'
order by 1,2


--countries with highest infection rate


select location,population,MAX(total_cases)as highestinfectioncount,max((total_cases/population))*100 as percentpopulationunfected
from PROFOLIO..CovidDeaths
--where location like'%kenya%'
group by location,population
order by percentpopulationunfected desc


-- countries with the highest death count




select location,max(cast(total_deaths as int)) as totaldeathcount
from PROFOLIO..CovidDeaths
--where location like'%kenya%'
where continent is null
group by location
order by totaldeathcount desc





--global numbers



select sum(new_cases)as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from PROFOLIO..CovidDeaths
where continent is not null
--group by date
order by 1,2

---looking at total population vs vaccination


select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
from PROFOLIO..[Covid vaccination] vac
join PROFOLIO..CovidDeaths dea
on vac.location =dea.location
and vac.date =dea.date
where dea.continent is not null
order by 2,3


--use cte

with popvsvac(continent,location,date,population, new_vaccination,rollingpeoplevaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
from PROFOLIO..[Covid vaccination] vac
join PROFOLIO..CovidDeaths dea
on vac.location =dea.location
and vac.date =dea.date
where dea.continent is not null
--order by 2,3
)
select*,(rollingpeoplevaccinated/population)*100
from popvsvac



create view percentpopulationvaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
from PROFOLIO..[Covid vaccination] vac
join PROFOLIO..CovidDeaths dea
on vac.location =dea.location
and vac.date =dea.date
where dea.continent is not null
--order by 2,3




