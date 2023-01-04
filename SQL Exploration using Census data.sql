select * from project ..Data1;

select * from project ..Data2;

-- number  of rows into our dataset

select count(*) as Total_rows from project..Data1;
select count(*) as Total_rows from project..Data2;

-- datset for jharkhand and bihar

select* from project..Data1 where [State ] in ('jharkhand' , 'bihar')

-- population of india

select  sum (Population) as Population  
from project..Data2 

-- avg growth

select [State ],avg(growth)*100  as avg_growth from project..Data1 group by [State ];

-- avg sex ratio

select [State ],round (avg(Sex_Ratio),0) as avg_sex_ratio from project..Data1 group by [State ] order by avg_sex_ratio desc;

-- avg literacy rate

select [State ],round (avg(Literacy),0) as literacy_rate from project..Data1 group by [State ] 
Having round(avg(literacy),0)>90 order by literacy_rate desc;

-- top 3 state showing highest growth ratio

select top 3  [State ],avg(growth)*100 as avg_growth from project..Data1 group by [State ] order by avg_growth desc 

-- bottom 3 state showing highest sex ratio

select top 3 [State ],round (avg(Sex_Ratio),0) as avg_sex_ratio from project..Data1 group by [State ] order by avg_sex_ratio asc;

-- top and bottom3 states in literacy state

drop table if exists #topstates ;
create table #topstates
( state nvarchar (255),
topstates float 

)
 insert into #topstates
 select [State ],round(avg(literacy),0) as avg_literacy_ratio from project..Data1
 group by [State ] order by avg_literacy_ratio desc;

 select top 3 * from #topstates order by #topstates.topstates desc; 

 drop table if exists #bottomstates ;
create table #bottomstates
( state nvarchar (255),
bottomstates float 

)
 insert into #bottomstates
 select [State ],round(avg(literacy),0) as avg_literacy_ratio from project..Data1
 group by [State ] order by avg_literacy_ratio desc;

 select top 3 * from #bottomstates order by #bottomstates.bottomstates asc; 

 -- union operator

  select* from (
   select top 3 * from #topstates order by #topstates.topstates desc  ) a

   union

   select* from (
   select top 3 * from #bottomstates order by #bottomstates.bottomstates asc ) b;

   -- states starting with  special letter 

   select distinct [State ] from project..Data1 where lower([State ])like 'a%' or lower([State ]) like 'b%'

   
    select distinct [State ] from project..Data1 where lower([State ])like 'a%' and lower([State ]) like '%m'

	-- joining both table

	-- total males and females


	select d.[State ] , sum(d.males)Total_males , sum(d.female) Total_female from
	(select c.district, c.[State ] ,round(c.population/(c.sex_ratio+1),0) males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) female from
	(select a. district ,a.[State ],a.sex_ratio/1000 sex_ratio,b.population from project..data1 a inner join project..data2 b on a.district=b.district)c)d
	group by d.[State ];

	-- total literacy rate


	select c.[State ] , sum(literate_people)Total_literacy_pop , sum(illiterate_people) Total_illiterate_pop from
	(select d.district, d.[State ] ,round(d.literacy_ratio*d.population,0)literate_people, round((1-d.literacy_ratio)*d.population,0) illiterate_people from
	(select a. district ,a.[State ],a.literacy/100 literacy_ratio,b.population from project..data1 a inner join project..data2 b on a.district=b.district)d)c
	group by c.[State ] ;

	-- population in previous census

	select sum(m.previous_census_population) previous_census_population, sum(m.current_census_population) current_census_population from
	(select c.[State ],sum(c.previous_census_population) previous_census_population,sum(c.current_census_population) current_census_population from
	(select d.district,d.[State ],round(d.population/(1+d.growth),0) previous_census_population,d.population current_census_population from
	(select a.district,a.[State ],a.growth growth,b.population from project..data1 a inner join project ..data2 b on a.District= b.district) d) c
	group by c.[State ])m

	-- population vs area
	select (g.total_area/g.previous_census_population) as previous_census_population_vs_area, (g.total_area/g.current_census_population) as
	current_census_population_vs_area from 

	(select q.*,r.total_area from 

	(select '1' as keyy,n.* from
	(select sum(m.previous_census_population) previous_census_population, sum(m.current_census_population) current_census_population from
	(select c.[State ],sum(c.previous_census_population) previous_census_population,sum(c.current_census_population) current_census_population from
	(select d.district,d.[State ],round(d.population/(1+d.growth),0) previous_census_population,d.population current_census_population from
	(select a.district,a.[State ],a.growth growth,b.population from project..data1 a inner join project ..data2 b on a.District= b.district) d) c
	group by c.[State ])m)  n) q inner join 

	(select '1' as keyy,z.* from 
	(select sum(area_km2) total_area from project..data2)z)r on q.keyy=r.keyy)g

	-- windows

	-- output top 3 districts from each state with higest literscy rate

	select a.* from

	(select district ,[State ],Literacy, rank() over (partition by state order by literacy desc ) rank from project..data1)a

	where a.rank in (1,2,3) order by [State ] 




  









