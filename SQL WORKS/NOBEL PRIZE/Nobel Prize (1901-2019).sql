SELECT * 
FROM nobel_prize.nobel;

# DATA CLEANING AND PREPARATION
Alter table nobel
Add `Laureate Type` varchar(20);

Update nobel
set `Laureate Type` = (select if(Share = 1,'Individual','Shared')
						where `Laureate Type` is Null);

Update nobel
set `Death Country` = Null
where `Death Country` = '#N/A';

Update nobel
set `Country of University` = 'United States of America'
where `Country of University` = 'USA' ;

Update nobel
set `Country of University` = 'Russia'
where `City of University` = 'Moscow';

Alter table nobel
Add Generation varchar(50) after Gender;

Update nobel
set Generation = (select case
							when Age between 10 and 25 then 'Gen Z'
                            when Age between 26 and 41 then 'Millenial'
                            when Age between 42 and 57 then 'Gen X'
                            when Age between 58 and 67 then 'Boomers II'
                            when Age between 68 and 76 then 'Boomers I'
                            when Age between 77 and 94 then 'Post War'
                            when Age between 95 and 100 then 'WW II'
						end
					where Generation is null);

 Alter table nobel
 Add `Month Birth` varchar(30);
 
 Update nobel 
 set `Month Birth` = (select case 
			when `Birth Month` = 'Jan' then 'January'
			when `Birth Month` = 'Feb' then 'February'
			when `Birth Month` = 'Mar' then 'March'
			when `Birth Month` = 'Apr' then 'April'
			when `Birth Month` = 'May' then 'May'
			when `Birth Month` = 'Jun' then 'June'
			when `Birth Month` = 'Jul' then 'July'
			when `Birth Month` = 'Aug' then 'August'
			when `Birth Month` = 'Sep' then 'September'
			when `Birth Month` = 'Oct' then 'October'
			when `Birth Month` = 'Nov' then 'November'
			when `Birth Month` = 'Dec' then 'December'
		end
	where `Month Birth` is null); 
    

Alter table nobel
Drop column `Birth Month`;

Alter table nobel
change `Month Birth` `Birth Month` varchar(30);

Alter table nobel
change `Winning Age` Age int;

Alter table nobel
Drop column Age;

Alter table nobel
Drop column Share;

# LAUREATES WITH MORE THAN ONE MEDAL
select
	Fullname,
	count(Fullname)
from nobel
group by Fullname
having count(Fullname) > 1;

# CONTINENT AND COUNT OF LAUREATES
select 
	Continent,
    count(*) as `Nos of Laureates`
from nobel
group by Continent
order by `Nos of Laureates` desc;

# COUNTRY AND COUNT OF LAUREATES
select 
	`Birth Country`,
    Continent,
    count(*) as `Nos of Laureates`
from nobel
group by `Birth Country`
order by `Nos of Laureates` desc
limit 10;

# COUNTRIES THAT HAVE WON ALL NOBEL CATEGORY MEDAL
select 
	`Birth Country`,
    Continent,
    count(distinct Category) `Featured Category`
from nobel
group by `Birth Country`
having `Featured Category` = 6;

# COUNTRIES WITH NO MALE LAUREATE
with CTE as (select
				`Birth Country` Country,
				count(case when Gender = 'female' then 1 end) as Female,
				count(case when Gender = 'male' then 1 end) as Male
				from nobel
				group by Country 
				having Female >= 1 and Male = 0)
select
	 Country,
     Female `Female Count`
from CTE
group by Country
order by Female desc;

# COUNTRIES WITH NO FEMALE LAUREATE
with CTE as (select
				`Birth Country` Country,
				count(case when Gender = 'female' then 1 end) as Female,
				count(case when Gender = 'male' then 1 end) as Male
				from nobel
				group by Country 
				having Female = 0 and Male >= 1)
select
	 Country,
     Male `Male Count`
from CTE
group by Country
order by Male desc;

# DOMINATING CATEGORY
select 
	Category,
    count(*)  Count
from nobel
group by Category
order by Count desc;

# GENERATION WITH MOST LAUREATES
select
	Generation,
    count(*) Count
from nobel 
group by Generation 
order by Count desc;

# GENERATION COUNT PER CATEGORY
select 
	Generation,
    count(case when Category = 'physics' then 1 end) Physics,
	count(case when Category = 'chemistry' then 1 end) Chemistry,
	count(case when Category = 'medicine' then 1 end) Medicine,
	count(case when Category = 'literature' then 1 end) Literature,
	count(case when Category = 'economics' then 1 end) Economics,
	count(case when Category = 'peace' then 1 end) Peace
from nobel
group by Generation;

# SHARE AND INDIVIDUAL AWARD
select
	`Laureate Type`,
	count(*)
from nobel
group by `Laureate Type`;

# UNIVERSITY WITH HIGHEST COUNT OF LAUREATES
select
	`Name of University`,
    `City of University`,
    `Country of University`,
    count(*) `Nos of Laureates`
from nobel
group by `Name of University`
order by `Nos of Laureates` desc;

# COUNTRY WITH MOST COUNT OF UNIVERSITY
select
	`Country of University` Country,
    count(*) Count
from nobel  
group by Country
having Count <> 230
order by Count desc;

# UNIVERSITIES THAT HAVE FEATURED IN ATLEAST THREE DISTINCT CATEGORIES
select
	`Name of University`,
    `Country of University`,
    count(distinct Category) `Featured Category`
from nobel
group by `Name of University`
having `Featured Category` >= 3
order by `Featured Category` desc,`Country of University`;

# OLDEST AND YOUNGEST LAUREATES
select 
	Year,
    Fullname,
	Age,
    `Birth Country`,
    Category
from nobel
where Age = (select max(Age) from nobel)
union
select 
	Year,
    Fullname,
	Age,
    `Birth Country`,
    Category
from nobel
where Age = (select min(Age) from nobel);

# OLDEST LAUREATES IN EACH CATEGORY
select 
	A.Category,
    Year,
    Fullname,
	Age,
    `Birth Country`
from nobel A
inner join (select Category, max(Age) max_age from nobel group by Category) B
on A.Age = B.max_age and A.Category = B.Category
group by A.Category; 

# YOUNGEST LAUREATES IN EACH CATEGORY
select 
	A.Category,
    Year,
    Fullname,
	Age,
    `Birth Country`
from nobel A
join (select Category, min(Age) min_age from nobel group by Category) C 
on A.Age = C.min_age and A.Category = C.Category
group by A.Category;

# MOST SHARED CATEGORY
select 
	Category,
    count(case when `Laureate Type` = 'Shared' then 1 end) Shared,
    count(case when `Laureate Type` = 'Individual' then 1 end) Individual
from nobel
group by Category
order by Shared desc;

# FIRST TIME WINNERS PER CONTINENT
select 
	A.Continent,
    A.Year,
    Fullname,
	Age,
    `Birth Country` Country,
    Category
from nobel A
join (select Continent, min(Year) min_Year from nobel group by Continent) B
on A.Continent = B.Continent and A.Year = B.min_Year;

# FIRST TIME WINNERS PER CATEGORY
select
	A.Category,
    A.Year,
    Fullname,
    Age,
    `Birth Country` Country
from nobel A
join (select Category, min(Year) min_year from nobel group by Category) B
on A.Category = B.Category and A.Year = B.min_year;

# GENDER GAP IN EACH COUNTRY
select
	`Birth Country` Country,
    count(case when Gender = 'male' then '1' end) Male,
    count(case when Gender = 'female' then '1' end) Female
from nobel
group by Country
order by Male desc,Female;

# GENDER GAP PER CONTINENT
select 	
	Continent,
    count(case when Gender = 'male' then '1' end) Male,
    count(case when Gender = 'female' then '1' end) Female
from nobel
group by Continent
order by Male desc,Female;

# GENDER GAP PER CATEGORY
select 	
	Category,
    count(case when Gender = 'male' then '1' end) Male,
    count(case when Gender = 'female' then '1' end) Female
from nobel
group by Category
order by Male desc,Female;

# LIKELY PLACE OF DEATH
select 
	`Death Country` Country,
    count(*) `Mortality Count`
from nobel 
where `Death Country` is not null
group by Country
order by `Mortality Count` desc;

# WILL BIRTH MONTH DETERMINE A LAUREATE (NOT REALISTIC)
select
	`Birth Month`,
    count(*) Count
from nobel
group by `Birth Month`
order by Count desc;

# WOMEN OF PEACE 
select *
from nobel
where Gender = 'female' and 
		Category = 'peace';


        

							
    


