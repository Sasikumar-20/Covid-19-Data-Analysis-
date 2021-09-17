USE Portfolioproject;

--1. We have created the database called PORTFOLIOPROJECT and imported the data into our database :- 

SELECT * FROM PORTFOLIOPROJECT..COVIDDEATHS
where continent is not null
ORDER BY 3,4;

--2. Selecting particular fields to get some useful insights :-

SELECT LOCATION, DATE, TOTAL_CASES, NEW_CASES, TOTAL_DEATHS, POPULATION
FROM PORTFOLIOPROJECT..COVIDDEATHS
ORDER BY 1,2;

--3. Here we are going to find the death percentage :-

SELECT LOCATION, DATE, TOTAL_CASES, TOTAL_DEATHS, (TOTAL_DEATHS/TOTAL_CASES) * 100 AS 'DEATH_PERCENTAGE'
FROM PORTFOLIOPROJECT..COVIDDEATHS
WHERE LOCATION LIKE '%INDIA%' and continent is not null
ORDER BY 1,2;

--4. Finding Affected people percentage :-

SELECT LOCATION, DATE, TOTAL_CASES, population, (TOTAL_CASES/population) * 100 AS 'AFFECTED_PERCENTAGE'
FROM PORTFOLIOPROJECT..COVIDDEATHS
WHERE LOCATION LIKE '%INDIA%' and continent is not null
ORDER BY 1,2;

--5. Using GROUP BY Clause and AGGREGATE FUNCTIONS to get some useful information :-

SELECT LOCATION, population,MAX(TOTAL_CASES) AS 'HIGHESTINFECTION', MAX((TOTAL_CASES/population)) * 100 AS 'HIGHEST_AFFECTED_PERCENTAGE'
FROM PORTFOLIOPROJECT..COVIDDEATHS
--WHERE LOCATION LIKE '%INDIA%'
GROUP BY LOCATION, POPULATION
ORDER BY HIGHEST_AFFECTED_PERCENTAGE DESC;

--6. Finding Maximum deathcount on location wise :-

Select Location, MAX (cast(total_deaths as int)) as 'maxdeathcount'
from portfolioproject..coviddeaths
where continent is not null
group by location
order by maxdeathcount desc;

--7. Finding Maximum deathcount on continent wise :-

Select continent, MAX (cast(total_deaths as int)) as 'maxdeathcount'
from portfolioproject..coviddeaths
where continent is not null
group by continent
order by maxdeathcount desc

--8. Worldwide count grouped by date :-

Select date, SUM(new_cases) as 'totalcases', SUM(cast(new_deaths as int)) as totaldeaths, SUM(cast(new_deaths as int))/Sum(new_cases)*100 as 'Deathpercent'
From portfolioproject..coviddeaths             
where continent is not null
group by date
order by 1,2;


----VACCINATION TABLE

select * from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccination vac
on dea.location = vac.location
and dea.date = vac.date

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location
order by dea.location, dea.date) as 'rollingpeoplevaccinated'
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


--Use cte

with Popvsvac (continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location
order by dea.location, dea.date) as 'rollingpeoplevaccinated'
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select * ,(rollingpeoplevaccinated/population)*100 from popvsvac;



--Creating View :-

create view percentpopulationvaccinaed as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location
order by dea.location, dea.date) as 'rollingpeoplevaccinated'
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select * from percentpopulationvaccinaed;


create view continentwisedeathcount
as
Select continent, MAX (cast(total_deaths as int)) as 'maxdeathcount'
from portfolioproject..coviddeaths
where continent is not null
group by continent
--order by maxdeathcount desc

select * from continentwisedeathcount;


create view locationwisemaxdeath
as
Select Location, MAX (cast(total_deaths as int)) as 'maxdeathcount'
from portfolioproject..coviddeaths
where continent is not null
group by location
--order by maxdeathcount desc

select * from locationwisemaxdeath;