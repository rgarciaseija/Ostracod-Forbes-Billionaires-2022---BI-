--CREATING A BACKUP TABLE--
CREATE TABLE TitanicBackup as(
select *
from Titanic)

--DATA DESCRIPTION--
exec sp_columns Titanic;

--DATA CLEANING--
--Converting the Pclass to First,Second and Third Class--
Update Titanic
set Pclass = (select case
					when Pclass = 1 then 'First class'
					when Pclass = 2 then 'Second class'
					when Pclass = 3 then 'Third class'
				end
			where Pclass in (1,2,3));

--Converting the Embarked--
Update Titanic
set Embarked = (select case
					when Embarked = 'C' then 'Cherbourg'
					when Embarked = 'S' then 'Southampton'
					when Embarked = 'Q' then 'Queensville'
						end
				where Embarked in ('Q','C','S'));

--Splitting the Names of the Passengers for Re-arrangement--
Alter Table Titanic
Add Name_1 varchar(50);

Update Titanic
set Name_1 = (select parsename(replace(Name,',','.'),1)
				where Name_1 is Null);

Alter Table Titanic
Add Name_2 varchar(50);

Update Titanic 
Set Name_2 = (select parsename(replace(Name,',','.'),2)
				where Name_2 is Null);
Alter table Titanic
Add Name_3 varchar(50);

Update Titanic
set Name_3 = (select parsename(replace(Name,',','.'),3)
				where Name_3 is Null);

--Re-arranging the Passengers Names--
Alter Table Titanic
Add Passengers varchar(50);

Update Titanic
set Passengers = (select concat(Name_2,'.',' ',Name_3,' ',Name_1)
					where Passengers is Null);

--Categorizing the Age of Passengers into Generation--
Alter Table Titanic
Add Generation varchar(50);

Update Titanic
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

--Replacing the 0 and 1 in survived column with Survival and Dead respectively--
Update Titanic 
set Survived = (select case
					when Survived = 0 then 'Died'
					when Survived = 1 then 'Survived'
						end
				where Survived in ('0','1'));

--Rounding T-Fare to 2 Decimal Places--
--Update Titanic
--set Fare = (select round(Fare,2)
--				from Titanic);

--Changing Columns Data Type--
Alter Table Titanic
Alter column Age float;

Alter Table Titanic
Alter column Fare float;

Alter Table Titanic
Alter column PassengerId int;

Alter Table Titanic
Alter column Passengers varchar(50);

Alter Table Titanic
Alter column Sibsp int;


--Renaming Column Names--
Alter Table Titanic
Alter column Pclass Passenger_class varchar(50),
Alter column SibSp Siblings_Onboard varchar (50),
Alter column Embarked Port varchar(50);

--Dropping Unwanted Column--
Alter table Titanic
Drop column [Column 12],[Column 13],
Name_1,Name_2,Name_3;
Alter Table Titanic
Drop column Name;

--INSIGHTS--
--Total Passengers on Board--
select count(Passengers) Total_Passengers
from Titanic;

--Passengers by Class--
select Pclass, count(Passengers) Survivals
from Titanic
group by Pclass;

--Average Age of the Passengers--
select round(avg(Age),2)
from Titanic;

--Passengers with Siblings Onboard--
select Passengers
from Titanic
where SibSp <> 0;

--Passengers with more than 3 Siblings onboard--
select Passengers,Survived as Life_Status
from Titanic
where SibSp > 3;

--Death Rate based on --
select Survived as Life_Status,
		count(case when Sibsp > 0 then 1 end )as Family,
		count(case when Sibsp = 0 then 1 end ) as Single
from Titanic
group by Survived;

--Average Age by Pclass--
select Pclass as Passengers_class, round(avg(Age),2) Average_Age
from Titanic
group by Pclass;

--Average T-fare by Pclass--
select Pclass as Passengers_class, round(avg(Fare),2) Average_fare
from Titanic
group by Pclass;

--Average Fare--
select round(avg(Fare),2)
from Titanic;

--Survivals vs Dead--
select count(case when Survived = 'Died' then 1 end) as Died,
		count( case when Survived = 'Survived' then 1 end) as Survivals
from Titanic

-- Count of Passengers by Gender--
select count(case when Sex = 'Male' then 1 end) as Male,
		count(case when Sex = 'Female' then 1 end) as Female
from Titanic;

--count of Survivals and Deads by Gender--
select Sex as Gender,
		count(case when Survived = 'Died' then 1 end) as Dead, 
		count(case when Survived = 'Survived' then 1 end)as Survivals
from Titanic
group by Sex 

--Survival and Death Count by Pclass--
select Pclass as Passenger_Class, 
		count(case when Survived = 'Died' then 1 end) as Dead, 
		count(case when Survived = 'Survived' then 1 end) as Survivals
from Titanic
group by Pclass;

--Gender by Port Embarked--
select Embarked as Port,
		count(case when sex = 'Female' then 1 end) Female,
		count(case when sex = 'Male' then 1 end) Male
from Titanic
group by Embarked;

--T-Fare by Port Embarked--
select Embarked Port,
		round(avg(fare),2) Avg_Fare
from Titanic
group by Embarked;

--Average T-Fare by Generation--
select Generation,round(avg(Fare),2) Average_Fare
from Titanic 
group by Generation
order by Average_Fare desc;

--Death and Survival by Port Embarked
select Embarked as Port,
		count(case when Survived = 'Died' then 1 end) Dead,
		count(case when Survived = 'Survived' then 1 end) Survival
from Titanic
group by Embarked;

--Generation of Passengers Onboard--
select Generation, count(Generation) Count
from Titanic
group by Generation
order by Count desc;

--Survivals and Dead count by Generation--
select Generation,
		count(case when Survived = 'Survived' then 1 end) as Survived,
		count(case when Survived = 'Died' then 1 end) as Dead
from Titanic
group by Generation;

--Generation by Pclass--
select Generation,
		count(case when Pclass = 'First class' then 1 end) as "First Class",
		count(case when Pclass = 'Second class' then 1 end) as "Second Class",
		count(case when Pclass = 'Third class' then 1 end ) as "Third Class"
from Titanic
group by Generation;

--Passengers and 
select distinct Survived
from Titanic
select *
from Titanic

