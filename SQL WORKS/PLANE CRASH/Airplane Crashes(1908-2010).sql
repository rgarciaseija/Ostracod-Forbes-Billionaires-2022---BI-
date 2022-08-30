#CREATING A NEW TABLE AIRCRASH AS BACKUP  
create table aircrash 
SELECT * 
FROM plane_crash.airplane_crash;

select *
from airplane_crash;

# DESCRIPTION OF DATA TYPE
desc airplane_crash;

# DATA CLEANING AND PREPARATION

#CREATING A NEW COLUMN YEAR AND MONTH
Alter table airplane_crash
Add Year int after Date,
Add Month text after Year;

#POPULATING THE YEAR COLUMN
Update airplane_crash
set Year = (select substring_index(substring_index(Date,'/',3),'/',-1)
            where Year is Null);

#CREATING DECADE COLUMN
Alter table airplane_crash
Add column Decade varchar (15) after Year;

#POPULATING THE DECADE COLUMN
Update airplane_crash
set Decade = (select case when Year between 1900 and 1909 then '1900s'
						  when Year between 1910 and 1919 then '1910s'
                          when Year between 1920 and 1929 then '1920s'
                          when Year between 1930 and 1939 then '1930s'
                          when Year between 1940 and 1949 then '1940s'
                          when Year between 1950 and 1959 then '1950s'
                          when Year between 1960 and 1969 then '1960s'
                          when Year between 1970 and 1979 then '1970s'
                          when Year between 1980 and 1989 then '1980s'
                          when Year between 1990 and 1999 then '1990s'
                          when Year between 2000 and 2009 then '2000s'
                          when Year between 2010 and 2020 then '2010s'
					end
				where Decade is Null);
                
#POPULATING THE MONTH COLUMN
Update airplane_crash
set Month = (select substring_index(substring_index(Date,'/',1),'/',-1)
			where Month is Null);
            
#FORMATING MONTH VALUES TO MONTH NAMES
Update airplane_crash
set Month = (select case when Month = 1 then 'January'
						 when Month = 2 then 'February'
                         when Month = 3 then 'March'
                         when Month = 4 then 'April'
                         when Month = 5 then 'May'
                         when Month = 6 then 'June'
                         when Month = 7 then 'July'
                         when Month = 8 then 'August'
                         when Month = 9 then 'September'
                         when Month = 10 then 'October'
                         when Month = 11 then 'November'
                         when Month = 12 then 'December'
				end);

#COLUMN FOR SEASON
Alter table airplane_crash
Add column Season text after Month;

#POPULATING THE SEASON COLUMN
Update airplane_crash
set Season = (select case when Month in ('March','April','May') then 'Spring'
						  when Month in ('June','July','August') then 'Summer'
                          when Month in ('September','October','November') then 'Autumn'
                          else 'Winter'
					end
				where Season is Null);
                
#NEW COLUMN FOR CRASH LOCATION
Alter table airplane_crash
Add column Region varchar(60) after Location;

#POPULATING THE REGION COLUMN
Update airplane_crash
set Region = (select substring_index(substring_index(Location,',',2),',',-1)
				where Region is Null);

#REMOVING LEADING SPACES FROM THE LOCATION COLUMN
Update airplane_crash
set Location = (select Ltrim(Location));
 
Alter table airplane_crash
Add column Airways text after Operators;

Update airplane_crash
set Airways = (select substring_index(Operator,'-',1)
				where Airways is Null);

Update airplane_crash
set Airways = (select case when Airways = 'Military ' then 'Military Aircraft'
							when Airways = 'Private' then 'Private Aircraft'
                            when Airways <> 'Military ' or 'Private' then 'Commercial Aircraft'
						end);
                        
#CREATING COLUMN FOR NOS. OF SURVIVALS AND RATE OF SURVIVAL
Alter table airplane_crash
Add column Survival int after Ground,
Add column `Survival Rate` int after Survival;

Alter table airplane_crash
Change `Survival Rate` `Total Death` int;

#AGGREGATING THE NOS. OF SURVIVALS 
Update airplane_crash
set Survival = (select Aboard - Fatalities
				where Survival is Null);

#AGGRGEGATING NOS. OF CASUALTIES
Update airplane_crash
set `Total Death` = (select Fatalities + Ground
					where `Total Death` is Null);

Alter table airplane_crash
Add column Reason text after `Total Death`;

#POPULATING THE REASON COLUMN
Update airplane_crash
set Reason = (select case 
			when Summary like '%shot down%' then 'Shot Down'
			when Summary like '%lightning%' then 'Weather Related'
            when Summary like '%Engine Failure%' then 'Mechanical Fault'
            when Summary like '%Fuel%' then 'Fuel Related'
            when Summary like '%Propellers%' then 'Mechanical Fault'
            when Summary like '%Poor visibility%' then 'Weather Related'
            when Summary like '%Rain%' then 'Weather Related'
            when Summary like '%snow%' then 'Weather Related'
            when Summary like '%fog%' then 'Weather Related'
            when Summary like '%wind%' then 'Weather Related'
            when Summary like '%storm%' then 'Weather Related'
            when Summary like '%Pilot%' then 'Personnel'
            when Summary like '%Thunderstorm%' then 'Weather Related'
            when Summary like '%being hit%' then 'Shot Down'
            when Summary like '%fire%' then 'Shot Down'
            when Summary like '%hijacke%' then 'Hijacked'
            when Summary like '%engine%' then 'Mechanical Fault'
		end 
where Reason is Null);

#CREATING TAKE-OFF AND DESTINATION COLUMNS FOR THE FLIGHTS
Alter table airplane_crash
Add column `Take-off` text after Route,
Add column Destination text after `Take-off`;

#SPLITTING THE ROUTE INTO TAKE-OFF AND DESTINATION
Update airplane_crash
set `Take-off` = (select substring_index(Route,'-',1)
				where `Take-off` is Null);
                
Update airplane_crash
set Destination = (select substring_index(substring_index(Route,'-',2),'-',-1)
				where Destination is Null);

#REMOVING UNWANTED COLUMNS
Alter table airplane_crash
Drop column Time,
Drop column Operators,
Drop column `Flight #`,
Drop column Location,
Drop column Registration,
Drop column `cn/In`;

#RENAMING SOME COLUMNS
Alter table airplane_crash
Change Region Location text,
Change Reason `Possible Cause` text,
Change Aboard Onboard int,
Change Fatalities `Onboard Casualty` int,
Change Ground `Ground Casualty` int,
Change `Total Death` `Total Casualty` int;

#ASSIGNING SOME US STATES THEIR COUNTRY NAME
Update airplane_crash
set Location = 'United States of America'
where Location in ('Virginia','New Jersey','Ohio','Pennsylvania', 'Maryland', 'Indiana', 'Iowa',
          'Illinois','Wyoming', 'Minnisota', 'Wisconsin', 'Nevada', 'NY','California',
          'WY','New York','Oregon', 'Idaho', 'Connecticut','Nebraska', 'Minnesota', 'Kansas',
          'Texas', 'Tennessee', 'West Virginia', 'New Mexico', 'Washington', 'Massachusetts',
          'Utah', 'Ilinois','Florida', 'Michigan', 'Arkansas','Colorado', 'Georgia''Missouri',
          'Montana', 'Mississippi','Jersey', 'Cailifornia', 'Oklahoma','North Carolina',
          'Kentucky','Delaware','D.C.','Arazona','Arizona','South Dekota','New Hampshire','Hawaii',
          'Washingon','Massachusett','Washington DC','Tennesee','Deleware','Louisiana',
          'Massachutes', 'Louisana', 'New York (Idlewild)','Oklohoma','North Dakota','Rhode Island',
          'Maine','Wisconson','Calilfornia','Virginia','Virginia.','CA','Vermont',
          'HI','AK','IN','GA','Coloado','Airzona','Alabama', 'United States', 'Alaksa', 'Alaska', 'Alakska');


Update airplane_crash
set Location = 'Soviet Union'
where Location = 'USSR';

Update airplane_crash
set Location = 'Bulgaria'
where Location = 'Bulgeria';

Update airplane_crash
set Location = 'Russia'
where Location = 'Russian';

#COUNT OF AIRCRASH BY YEAR
select
	Year,
    count(*) Aircrash
from airplane_crash
group by Year 
order by Aircrash desc;

#COUNT OF CASAULTIES BY YEAR
select 
	Year,
    sum(`Total Casualty`) as Casualties
from airplane_crash
group by Year 
order by Casualties desc;

#COUNT OF AIRCRASH BY DECADE
select
	Decade,
    count(*) Aircrash
from airplane_crash
group by Decade
order by Aircrash desc;

#COUNT OF CASUALTIES BY DECADE
select 
	Decade,
    sum(`Total Casualty`) as Casualties
from airplane_crash
group by Decade 
order by Casualties desc;

#MOST DANGEROUS SEASON OF THE YEAR
select 
	Season,
    count(*) Aircrash
from airplane_crash
group by Season
order by Aircrash desc;

#MOST DANGEROUS FLIGHT-ROUTE
select
	Route,
    count(*) Aircrash
from airplane_crash
group by Route
having Route not in('','Training','Sightseeing','Test flight','Test')
order by Aircrash desc;

#MOST CRASHED AIRCRAFT TYPE
select 
	Type,
    count(*) Aircrash
from airplane_crash
group by Type
order by Aircrash desc;

#MOST CRASHED AIRWAYS AND CASUALTY RATE
select
	Airways,
    count(*) Aircrash,
	sum(Onboard) Passengers,
    sum(`Onboard Casualty`) `Onboard Casualty`,
    sum(`Ground Casualty`) `Ground Casualty`,
    round((sum(`Onboard Casualty`)/sum(Onboard))*100,2) as `Casualty Rate`
from airplane_crash
group by Airways
order by Aircrash desc;

#OPERATORS WITH MOST PLANE CRASH AND CASUALTY RATE
select
	Operator,
    count(*) Planecrash,
    sum(Onboard) Passengers,
    sum(`Onboard Casualty`) `Onboard Casualty`,
    sum(`Ground Casualty`) `Ground Casualty`,
    round((sum(`Onboard Casualty`)/sum(Onboard))*100,2) as `Casualty Rate`
from airplane_crash
group by Operator
order by Planecrash desc;

#COUNTRY(LOCATION) WITH MOST PLANE CRASH
select
	Location,
    count(*) Aircrash,
    sum(`Total Casualty`) Fatality
from airplane_crash
group by Location
order by Aircrash desc;

#AIRCRASH WITHOUT SURVIVAL
select
	Date,
    Onboard,
    Survival
from airplane_crash
where Survival = 0
order by Onboard desc;

#MAJOR KNOWN CAUSE OF CRASH
select 
	`Possible Cause` Factor,
    count(*) Count
from airplane_crash
group by Factor
Having Factor != 'Null'
order by Count desc;

#CHANCES OF SURVIVING AN AIRCRASH WHILE ON BOARD 
select
	round((sum(Survival)/sum(onboard))* 100,2) `Survival Rate`
from airplane_crash;

#CHANCES OF SURVIVAL BASED ON POSSIBLE KNOWN CAUSE OF CRASH
select
	`Possible cause` Factor,
	round((sum(Survival)/sum(onboard))* 100,2) `Survival Rate`
from airplane_crash
group by Factor
having Factor != 'null'
order by `Survival Rate` desc;

#CHANCES OF SURVIVAL BASED ON SEASON OF THE YEAR
select
	Season,
	round((sum(Survival)/sum(onboard))* 100,2) `Survival Rate`
from airplane_crash
group by Season
order by `Survival Rate` desc;

# HIGHEST AIRLINER PASSENGER FATALITY
select 
Date,
Season,
Location,
Operator,
`Onboard Casualty`,
`Possible Cause`,
Summary
from airplane_crash
where `Onboard Casualty` = (select max(`Onboard Casualty`) from airplane_crash);

# AIRPLANE CRASH WITH FATALITY TOLL OF 300 OR HIGHER
select 
Date,
Operator,
`Onboard Casualty`,
`Possible Cause`,
Summary
from airplane_crash
where `Onboard Casualty` >= 300
order by `Onboard casualty` desc;

