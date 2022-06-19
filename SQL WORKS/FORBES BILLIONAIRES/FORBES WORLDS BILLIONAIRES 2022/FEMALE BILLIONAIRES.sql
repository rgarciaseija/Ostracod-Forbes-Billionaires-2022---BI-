#FEMALE BILLIONAIRES AND THEIR NET WORTH
Select 
    `Name`,
    Age,
    `Country of Citizenship` as `Country`,
    Category,
    `Self Made`,
    format((`Final Worth` * 10e5),'C') as `Net Worth(USD)`
From forbes.`forbes list`
Where Gender = 'F'
Order By `final worth` desc;

#SELF MADE FEMALE BILLIONAIRES
select	
    `Name`,
    age,
    Gender,
    `Country of Citizenship`,
    Category,
    format(`Final Worth`*10e5,'C') as `Net Worth(USD)`
from forbes.`forbes list`
where `Self Made` = 'True' and Gender = 'F';

#FEMALE BILLIONAIRES WHOSE NETWORTH > AVERAGE NETWORTH ALL THE BILLIONAIRES
With Avg_net_worth (`Average Net Worth`) as 
				(select avg(`Final Worth`*10e5)  from forbes.`forbes list`)
select 
        `Name`,
        Age,
        Gender,
        `Country of Citizenship`,
        format(`Final Worth` * 10e5,'C') as `Net Worth(USD)`,
        format(B.`Average Net Worth`,'C') as `Average Net Worth`
from forbes.`forbes list` A, Avg_net_worth B
Where A.`Final Worth` * 10e5 > B.`Average Net Worth` and Gender ='F';

#OLDEST AND YOUNGEST FEMALE BILLIONAIRES
Select
    `Name`,
    Age,
	Gender,
    `Country of Citizenship` as Country,
    Category,
    Format ((`Final Worth`*10e5),'C', 'usd') as `Net Worth(USD)`
From forbes.`forbes list`
Where Age = (Select max(Age) From forbes.`forbes list` Where Gender = 'F') AND Gender = 'F'
Union
Select
    `Name`,
    Age,
	Gender,
	`Country of Citizenship` as Country,
    Category,
    Format ((`Final Worth`*10e5),'C', 'usd') as `Net Worth(USD)`
From forbes.`forbes list`
Where Age = (Select min(Age) From forbes.`forbes list` where Gender = 'F' and Age >0) AND Gender = 'F';

#FORBES TOP FEMALE BILLIONAIRES PER COUNTRY
Select
	`Country of Citizenship` as Country,
    `Name`,
    Age,
    Category,
    Format ((max(`Final Worth`*10e5)),'C', 'usd') as `Net Worth(USD)`
From forbes.`forbes list`
Where Gender = 'F'
Group By `Country of Citizenship`
Order By `Country of Citizenship` asc;

#SELF AND NON-SELF MADE FEMALE BILLIONAIRES AND THEIR NET WORTH
Select 	
    Case when `self made` = 'TRUE' then 'Self Made'
		 when `self made` = 'FALSE' then 'Non Self Made'
         end as `Made Women`,
	round(avg(age)) as `Average Age`,
	count(`Self Made`) as `Count`,
    format((sum(`Final Worth` * 10e5)),'C') as `Net Worth(USD)`
From forbes.`forbes list`
Where Gender = 'F'
Group By `Self Made`;

#TOP AND COUNT OF FEMALE BILLIONAIRES PER CATEGORY
Select 	
    Category,
    count(`Name`) as `Female Count`,
    count(Case when `self made` = 'TRUE' then 'Self Made'
		end) as `Self Made`,
	count(Case when `self made` = 'FALSE' then 'Non Self Made'
         end) as `Non Self Made`,
	`Name` as `Top Female Billionaire(TFB)`,
	format((max(`Final Worth` * 10e5)),'C') as `TFB Net Worth(USD)`,
    format((sum(`Final Worth` * 10e5)),'C') as `Category Net Worth(USD)`
From forbes.`forbes list`
Where Gender = 'F'
Group By Category
Order By `Female Count` desc;

#WOMEN IN TECH
Select 	
	`Name`,
    `Country of Citizenship` as Country,
    format((`final worth` * 10e5),'C') as `Net Worth(USD)`
From forbes.`forbes list`
Where Category = 'Technology' and Gender = 'F';

#WOMEN IN GAMBLING & CASINOS
Select 	
	`Name`,
    `Country of Citizenship` as Country,
    format((`final worth` * 10e5),'C') as `Net Worth(USD)`
From forbes.`forbes list`
Where Category = 'Gambling & Casinos' and Gender = 'F';

#OLDEST MALE BILLIONAIRES IN EACH CATEGORY
select 
	A.Category,
    `Name`,
    Age,
	Gender,
    `Country of Citizenship`,
    format(`Final Worth`*10e5,'C') as `Net Worth(USD)`
from forbes.`forbes list` A 
inner join
(select Category, max(age) as max_age from forbes.`forbes list` group by Category) B
on A.Category = B.Category and A.Age = B.max_age
Where Gender = 'F'
Group by A.Category;

#YOUNGEST MALE BILLIONAIRES IN EACH CATEGORY
select 
	A.Category,
    `Name`,
    Age,
    Gender,
    `Country of Citizenship`,
    format(`Final Worth`*10e5,'C') as `Net Worth(USD)`
from forbes.`forbes list` A 
inner join
(select Category, min(age) as min_age from forbes.`forbes list` where Age > 0 group by Category) B
on A.Category = B.Category and A.Age = B.min_age
Where Gender = 'F'
Group by A.Category;

