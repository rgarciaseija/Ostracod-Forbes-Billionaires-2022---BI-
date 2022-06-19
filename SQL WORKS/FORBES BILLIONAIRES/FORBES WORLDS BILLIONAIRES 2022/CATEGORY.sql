#CATEGORY WITH MOST COUNTS OF BILLIONAIRES
SELECT 
	`Category`,
	count(Case When Gender = 'M' Then 'Male'
            end) as `Male Count`,
    count(Case When Gender = 'F' Then 'Female'
			end) as `Female Count`,
	count(Case When Gender ='' Then 'Friends or Family'
			end) as `Friends or Family Count`,
	count(`Name`) as `Nos of Billionaires`,
    count(distinct(`Country of Citizenship`)) as `Nos of Country`,
	count(case when country = `Country of Citizenship` then 'Home Made'
			end) as `Home Made`,
	count(case when country <> `Country of Citizenship` then 'Abroad Made'
			end) as `Abroad Made`,
	    count(case
			when `Self Made` = 'TRUE' then 'Self Made'
            end) as `Self Made`,
	count(Case
			when `Self Made` = 'FALSE' then 'Not Self Made'
            end) as `Not Self Made`,
    format((sum(`Final Worth`*10e5)), 'C') as ` Total Net Worth(USD)`,
    format((round(avg(`Final Worth`*10e5),2)),'C') as `Average Net Worth(USD)`
FROM forbes.`forbes list`
Group by `Category`
Order by sum(`Final Worth`) desc;

#CATEGORY WHOSE TOTAL NETWORTH > AVERAGE NETWORTH OF ALL CATEGORIES
select  Category, 
		format(Net_worth,'C') as `Net Worth(USD)`, 
        format(Average_Net_Worth,'C') as `Average Net Worth(USD)`
from	(select X.Category, sum(`final worth`*10e5) as Net_Worth
		from forbes.`forbes list` X
        group by X.Category) A
join	(select avg(Net_Worth) as Average_Net_Worth
		from( select X.Category, sum(`final worth`*10e5) as Net_Worth
				from forbes.`forbes list` X
				group by X.Category) Y) B
	on A.Net_Worth > B.Average_Net_Worth
Order By 'Net Worth(USD)' desc;

#DOMINANT AGE RANGE PER CATEGORY
Select
	Category,
    count(Case when Age < 20 Then '<20 Years' end) as `<20 Years`,
	count(case when Age >= 20 and Age < 31 Then '20 - 30 Years'end) as `20-30 Years`,
	count(case when Age >= 30 and Age < 41 Then '30 - 40 Years'end) as `30-40 Years`,
	count(case when Age >= 40 and Age < 51 Then '40 - 50 Years'end) as `40-50 Years`,
	count(case when Age >= 50 and Age < 61 Then '50 - 60 Years'end) as `50-60 Years`,
	count(case when Age >= 60 and Age < 71 Then '60 - 70 Years'end) as `60-70 Years`,
	count(case when Age >= 70 and Age < 81 Then '70 - 80 Years'end) as `70-80 Years`,
	count(case when Age >= 80 and Age < 91 Then '80 - 90 Years'end) as `80-90 Years`,
	count(case when Age >= 90  Then '90+ Years'end) as `90+ Years`,
    format(sum(`Final Worth`*10e5),'C') as `Net Worth(USD)`,
    format(Avg(`Final Worth`*10e5),'C') as `Average Net Worth(USD)`
From forbes.`forbes list`
Where Age > 0
Group By Category;

#OLDEST BILLIONAIRES IN EACH CATEGORY
select 
	A.Category,
    `Name`,
    Age,
    `Country of Citizenship`,
    format(`Final Worth`*10e5,'C') as `Net Worth(USD)`
from forbes.`forbes list` A 
inner join
(select Category, max(age) as max_age from forbes.`forbes list` group by Category) B
on A.Category = B.Category and A.Age = B.max_age
Group by A.Category;

#YOUNGEST BILLIONAIRES IN EACH CATEGORY
select 
	A.Category,
    `Name`,
    Age,
    `Country of Citizenship`,
    format(`Final Worth`*10e5,'C') as `Net Worth(USD)`
from forbes.`forbes list` A 
inner join
(select Category, min(age) as min_age from forbes.`forbes list` where Age > 0 group by Category) B
on A.Category = B.Category and A.Age = B.min_age
Group by A.Category;

#TOP BILLIONAIRES IN EACH CATEGORY
Select
	`Rank`,
	`Category`,
    `Name`,
    Gender,
    `Country of Citizenship`,
    format((max(`Final Worth`*10e5)),'C') as `Net Worth(USD)`
From forbes.`forbes list` 
Group by `Category`;

#EACH CATEGORY AND ITS PHILANTHROPY SCORE
Select 
	`Category`,
    `Name` as `Philanthropist`,
    count(`Name`) as `Philanthropist Count`,
	max(`Philanthropy Score`) as `Philanthropic Rating`,
    sum(`Philanthropy Score`) as `Total Philanthropic Score`
From forbes.`forbes list`
Where `Philanthropy Score` >= 1
Group By `Category`
Order By max(`Philanthropy Score`) desc;

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



    


    