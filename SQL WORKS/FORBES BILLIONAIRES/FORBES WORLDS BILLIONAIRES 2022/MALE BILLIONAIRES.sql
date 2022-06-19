#TOP TEN BILLIONAIRES AND THEIR NETWORTH
Select
	`Name`,
    Gender,
    Country,
    `Category`,
    `Self Made`,
    format(`Final Worth` * 10e5,'C')  as `Net Worth(USD)`
From forbes.`forbes list`
Order by `Final Worth`  desc
limit 10;

#SELF MADE MALE BILLIONAIRES
select	
    `Name`,
    age,
    Gender,
    `Country of Citizenship`,
    Category,
    format(`Final Worth`*10e5,'C') as `Net Worth(USD)`
from forbes.`forbes list`
where `Self Made` = 'True' and Gender = 'M';

#BILLIONAIRE WHOSE NETWORTH ARE > AVERAGE NETWORTH ALL THE BILLIONAIRES
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
Where A.`Final Worth` * 10e5 > B.`Average Net Worth`AND Gender = 'M';

#OLDEST FEMALE BILLIONAIRES IN EACH CATEGORY
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
Where Gender = 'M'
Group by A.Category;

#YOUNGEST FEMALE BILLIONAIRES IN EACH CATEGORY
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
Where Gender = 'M'
Group by A.Category;



