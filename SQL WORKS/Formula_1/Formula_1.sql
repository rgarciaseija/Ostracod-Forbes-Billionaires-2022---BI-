select *
from f1;

-- Data Description --
exec sp_columns f1;

--DATA CLEANING AND PREPARATION--

--Concatenating the Driver's Names into a single column--
Alter table f1
Add Driver varchar(100);
--Populating the Driver column--
Update f1 
set Driver = (select concat("Driver Surname",' ',"Driver Forename")
				where Driver is Null);

--Splitting the DOB Column into Birthday, BirthMonth and Birth Year--
Alter table f1
Add Birthday varchar(20), "Birth Month" varchar(20), "Birth Year" varchar(20);

Update f1 
set Birthday = (select parsename(replace(DOB,',','.'),3)
					where Birthday is Null);

Update f1 
set "Birth Month" = (select parsename(replace(DOB,',','.'),2)
					where "Birth Month" is Null);

Update f1 
set "Birth Year" = (select parsename(replace(DOB,',','.'),1)
					where "Birth Year" is Null);

--Eliminating the number in Birth Month--
Update f1 
set "Birth Month" = (parsename(replace("Birth Month",' ','.'),2));

--Changing Columns Data Type--
Alter table f1 
Alter column "Position Order" int;

Alter table f1 
Alter column Year int;

Alter table f1 
Alter column "Birth Year" int;

Alter Table f1
Alter column Points int;

Alter Table f1 
Alter Column "FastestLapSpeed" int;

Alter Table f1 
Alter column Round int;

Alter Table f1 
Add Position varchar(20);

--Creating and Populating Race Position--
Update f1 
set Position = (select case when "Position Order" = 1 then 'Winner'
							when "Position Order" = 2 then 'Runner-Up'
							when "Position Order" = 3 then 'Third-Place'
						end
					where Position is Null);

--Categorizing the Events into Decades--			
Alter Table f1 
Add Decade varchar(10);

Update f1 
set Decade = (select case 
			when Year between 1950 and 1959 then '1950s'
			when Year between 1960 and 1969 then '1960s'
			when Year between 1970 and 1979 then '1970s'
			when Year between 1980 and 1989 then '1980s'
			when Year between 1990 and 1999 then '1990s'
			when Year between 2000 and 2009 then '2000s'
			when Year between 2010 and 2019 then '2010s'
			when Year between 2020 and 2029 then '2020s'
		end
		where Decade is Null);

--Dropping Unwanted Columns--
Alter table f1 
Drop column "Driver Forename","Driver Surname",
	 "Code","Milliseconds",
	 "Rank","Time",
	 "FastestLapTime","FastestLap",
	 "Driver Number","Position";
Alter Table f1 
Drop column DOB,"Position Order";

--Total Race from 1992 - 2021--
With CTE as (select Year, count (distinct"Event Name") as Event
				from f1
				group by Year)
select sum("Event") as "Total Race"
from CTE;

--Count of Events Per Year--
select Year, Count(distinct "Event Name") as Event_Count
from f1 
group by Year
order by Year asc;

--Different Race Events--
select Distinct("Event Name") Events
from f1 ;

--Events and Top Winners--
select B.Event , Driver, Max_Wins
from (select X."Event Name" Event, X.Driver,count(Driver) Wins
	 from f1 X
	 where Position = 'Winner'
	 group by X.[Event Name],X.Driver)A
Join (select Event,max(wins) Max_Wins
	  from(select X."Event Name" Event, X.Driver, count(Driver) Wins
			 from f1 X
			 where Position = 'Winner'
			 group by X.[Event Name],X.Driver)Y
		group by Event)B
on A.Wins = B.Max_Wins and A.event = B.event
order by Max_Wins desc;

--Most Frequent Issues Encountered By Drivers During Racing--
select Status,count(Status) as Frequency
from F1 
group by Status 
order by Frequency desc;

--Most Difficult Circuit--
select "Circuit Name",
		sum(case when Status like '%Accident%' then 1 
				when Status like '%Collision%' then 1 
				when Status like '%Engine%' then 1 
				when Status like 'Spun off%' then 1
		end) as Accident_Count
from f1 
group by [Circuit Name]
order by Accident_Count desc

--Drivers Per Year--
select Year, count(distinct Driver) as Driver_Count
from f1 
group by Year 
order by Driver_Count desc;

--Count of Drivers per Event--
select "Event Name", count(distinct Driver) Driver_Count
from f1 
group by "Event Name"
order by Driver_Count desc;

--Total Nos of Drivers--
With CTE as (select Year, count(distinct Driver) as Driver_Count
			from f1 
			group by Year)
select sum(Driver_Count) Nos_of_Drivers
from CTE;

--Drivers By Nos of Wins--
select A.Driver,Race, Wins
from(select Driver, count(Driver) Wins 
	 from F1 
	 where Position = 'Winner' 
	 group by Driver)A
join(select Driver, count(Driver) Race
	 from F1 group by Driver)B
on A.Driver = B.Driver
order by Wins desc;

--Drivers and their Lap Speed--
select Driver,max(FastestLapSpeed) as [Fastest_Lap_Speed(Mph)]
from f1
group by Driver
order by [Fastest_Lap_Speed(Mph)] desc;

--Drivers and Nos of Finished Race--
select Driver, count(Driver) Race, count(case when Status ='finished' then '1' end) Finished_Race
from f1 
group by Driver
Order by Finished_Race desc;

--Top Drivers by Points--
select Driver, Sum(Points) Total_Points
from f1 
group by Driver
order by Total_Points desc;

--Drivers By Titles--
With CTE as (
select A.Year,Driver,Max_Points
from(select X.Year,X.Driver,sum(points) Total_Points
	 from f1 X
	 group by X.Year,X.Driver)A
Join (select Year,max(Total_Points) Max_Points
	  from(select X.Year,X.Driver,sum(points) Total_Points
			from f1 X
			group by X.Year,X.Driver)Y
	  group by Year)B
on A.Year = B.Year and A.Total_Points = B.Max_Points
)
select Driver,count(Driver)Title
from CTE 
group by Driver
order by Title desc;

--Drivers and their Chances of Making the Podium--
select A.Driver, Race, Podium
from(select Driver, count(Driver) as Podium
	 from f1 
	 where Position in ('Winner','Runner-Up','Third-Place')
	 group by Driver)A
join (select Driver,count(Driver) Race
	  from f1 
	  group by Driver)B
on A.Driver = B.Driver
order by Podium desc;

--Greatest Driver of Each Decade Based on Points--
With CTE as (
select A.Decade,Driver,Max_Point,Race
from(select X.Decade,X.Driver,count(Driver)Race,sum(Points)Points
		from f1 X
		group by X.Decade,X.Driver)A
join (select Decade,max(Points)Max_Point
	  from(select X.Decade,X.Driver,count(Driver)Race,sum(Points)Points
			from f1 X
			group by X.Decade,X.Driver)Y
	  group by Decade)B
on A.Decade = B.Decade and A.Points = B.Max_Point
)
select Decade,Driver,Race,Max_Point as Point
from CTE;

--Greatest Driver of Each Decade Based on Wins--
With CTE as (
select Z.Decade,Driver,Race,Max_Wins
from(select A.Decade,A.Driver,Race,Wins
	 from(select Decade,Driver,count(Position)Wins
		  from f1 
		  where Position = 'Winner'
		  group by Decade,Driver)A
	join(select Decade,Driver,count(Driver)Race
		 from f1 
		group by Decade,Driver)B
	on A.Driver = B.Driver and A.Decade = B.Decade)X
join(select Decade,max(Wins)Max_Wins
	 from(select A.Decade,A.Driver,Race,Wins
		  from(select Decade,Driver,count(Position)Wins
			   from f1 
		       where Position = 'Winner'
		       group by Decade,Driver)A
	join(select Decade,Driver,count(Driver)Race
		 from f1 
		group by Decade,Driver)B
	on A.Driver = B.Driver and A.Decade = B.Decade)X
	group by Decade)Z
on X.Decade = Z.Decade and X.Wins = Z.Max_Wins
)
select Decade,Driver,Race,Max_Wins
from CTE
order by Decade;

--Fastest Lap Speed--
select max(FastestLapSpeed) as "Fastest_Lap_Speed(mph)"
from f1

--Chances of Winning the Race based on Grid Positions--
select Grid ,
	   count(case when Position = 'Winner' then 1 end) as Wins,
	   count(case when Position = 'Runner-up' then 1 end) as "Runner-Up",
	   count(case when Position = 'Third-Place' then 1 end) as Third_Place
from f1 
group by Grid
order by Wins desc;

--Most Successful Teams by Win Rate--
select [Constructor Name],
	  "Constructor Nationality",
	  count(distinct Driver) as Driver,
	   count("Constructor Name") Race,
	   count(case when Position in ('Winner','Runner-Up','Third-Place')then 1 end) as Podium,
	   count(case when Position = 'Winner' then 1 end) as Wins
from f1
group by [Constructor Name],[Constructor Nationality]
order by Wins desc;

--Teams and Nos of Finished Race--
select [Constructor Name], count(Driver) Race, count(case when Status ='finished' then '1' end) Finished_Race
from f1 
group by [Constructor Name]
Order by Finished_Race desc;

--Most Successful Team by Title--
With CTE as (
select A.Year,[Constructor Name],Max_Points
from(select X.Year,X.[Constructor Name], sum(Points) Total_Points
	 from f1 X
     group by X.Year,X.[Constructor Name])A
Join(select Year,max(Total_Points) Max_Points
	 from(select X.Year,X.[Constructor Name], sum(Points) Total_Points
		  from f1 X
		  group by X.Year,X.[Constructor Name])Y
	 group by Year)B
on A.Year = B.Year and A.Total_Points = B.Max_Points
)
select [Constructor Name],count([Constructor Name]) Title
from CTE 
group by [Constructor Name]
order by Title desc;

--Teams and their Points--
select [Constructor Name], sum(Points) Total_Points
from f1 
group by [Constructor Name]
order by Total_Points desc;

--Fastest Vehicle--
select [Constructor Name],max(FastestLapSpeed)[Fastest_Lap_Speed(Mph)]
from f1 
group by [Constructor Name]
order by [Fastest_Lap_Speed(Mph)] desc;

select *
from f1 



				

