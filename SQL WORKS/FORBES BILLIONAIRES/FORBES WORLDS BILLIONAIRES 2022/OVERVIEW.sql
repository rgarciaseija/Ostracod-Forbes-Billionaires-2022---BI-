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

#BILLIONAIRE WHOSE NETWORTH ARE 20x > AVERAGE NETWORTH ALL THE BILLIONAIRES
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
Where A.`Final Worth` * 10e5 > B.`Average Net Worth` * 20 ;

#AGE RANGE COUNT
Select (Case 
			when Age < 20 Then '<20 Years'
			when Age >= 20 and Age < 31 Then '20 - 30 Years'
            when Age >= 30 and Age < 41 Then '30 - 40 Years'
            when Age >= 40 and Age < 51 Then '40 - 50 Years'
            when Age >= 50 and Age < 61 Then '50 - 60 Years'
            when Age >= 60 and Age < 71 Then '60 - 70 Years'
            when Age >= 70 and Age < 81 Then '70 - 80 Years'
            when Age >= 80 and Age < 91 Then '80 - 90 Years'
            when Age >= 90  Then '90+ Years'
		End) as `Age Range`,
count(Case 
			when Age > 0 and Age < 20 Then '<20 Years'
			when Age >= 20 and Age < 31 Then '20 - 30 Years'
            when Age >= 30 and Age < 41 Then '30 - 40 Years'
            when Age >= 40 and Age < 51 Then '40 - 50 Years'
            when Age >= 50 and Age < 61 Then '50 - 60 Years'
            when Age >= 60 and Age < 71 Then '60 - 70 Years'
            when Age >= 70 and Age < 81 Then '70 - 80 Years'
            when Age >= 80 and Age < 91 Then '80 - 90 Years'
            when Age >= 90  Then '90+ Years'
		End) as `Age Count`,
    count(case 
			when Gender = 'M' Then 'Male'end) as `Male Count`,
	count(case 
			when Gender = 'F' Then 'Female'end) as `Female Count`,
    count(case
			when `Self Made` = 'TRUE' then 'Self Made'
            end) as `Self Made`,
	count(Case
			when `Self Made` = 'FALSE' then 'Not Self Made'
            end) as `Not Self Made`,
	count(case when country = `Country of Citizenship` then 'Home Made'
			end) as `Home Made`,
	count(case when country <> `Country of Citizenship` then 'Abroad Made'
			end) as `Abroad Made`,
	count(distinct Category) as `Category Count`,
    format((sum(`Final Worth`*10e5)),'C') as `Total Net Worth(USD)`
From forbes.`forbes list`
Where Age > 0 
Group By `Age Range`;

#DOMINANT AGE RANGE PER COUNTRY
Select
	`Country of Citizenship`,
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
Group By `Country of Citizenship`;

#OLD AND YOUNGEST BILLIONAIRE
Select
    `Name`,
    Age,
	Gender,
    `Country of Citizenship` as Country,
    Category,
    Format ((`Final Worth`*10e5),'C', 'usd') as `Net Worth(USD)`
From forbes.`forbes list`
Where Age = (Select max(Age) From forbes.`forbes list`)
Union
Select
    `Name`,
    Age,
	Gender,
	`Country of Citizenship` as Country,
    Category,
    Format ((`Final Worth`*10e5),'C', 'usd') as `Net Worth(USD)`
From forbes.`forbes list`
Where Age = (Select min(Age) From forbes.`forbes list` where Age > 0);

#BILLIONAIRES WHO MADE THEIR FORTURNE ABROAD
SELECT
		`Name`,
		Age,
        Gender,
        Country as `Country of Fortune`,
		`Country of Citizenship`,
        Category,
        format((`Final Worth` * 10e5),'C') as `Net Worth(USD)`
FROM forbes.`forbes list`
Where Country <> `Country of Citizenship`;

#BILLIONAIRES WHO MADE FORTUNES ON HOME SOIL
SELECT
		`Name`,
		Age,
        Gender,
        Country as `Country of Fortune`,
		`Country of Citizenship`,
        Category,
        format((`Final Worth` * 10e5),'C') as `Net Worth(USD)`
FROM forbes.`forbes list`
Where Country = `Country of Citizenship`;

#HOME MADE BILLIONAIRES NET WORTH PER COUNTRY
SELECT
	`Country of citizenship`,
    count(case when country = `Country of Citizenship` then 'Home Made'
			end) as `Home Made`,
	format(SUM(`Final Worth`*10e5),'C') as `Home Made Net Worth(USD)`
FROM forbes.`forbes list`
Group by `Country of Citizenship`
Order By `Home Made` desc;

#ABROAD MADE BILLIONAIRES NET WORTH PER COUNTRY
SELECT
	`Country of citizenship`,
    	count(case when country <> `Country of Citizenship` then 'Abroad Made'
			end) as `Abroad Made`,
	format(sum(`Final Worth`*10e5),'C') as `Abroad Made Net Worth(USD)`
From forbes.`forbes list` 
Where Country <> `Country of Citizenship`
Group By `Country of Citizenship`
Order By `Abroad Made` desc;

#GENDER GAP
Select (Case 
			when Gender = "M" Then 'Male'
			when Gender = "F" Then 'Female'
            Else 'Family or Friends'
		End) as `Gender`,
    count(Gender) as `Gender Count`,
	count(case
			when `Self Made` = 'TRUE' then 'Self Made'
            end) as `Self Made`,
	count(Case
			when `Self Made` = 'FALSE' then 'Not Self Made'
            end) as `Not Self Made`,
	count(case when country = `Country of Citizenship` then 'Home Made'
			end) as `Home Made`,
	count(case when country <> `Country of Citizenship` then 'Abroad Made'
			end) as `Abroad Made`,
	count(distinct Category) as `Category Count`,
    format((sum(`Final Worth`*10e5)),'C') as `Total Net Worth(USD)`
From forbes.`forbes list`
Group by Gender;

#COUNTRIES WITH LESS THAN 2 BILLIONAIRES
Select 
	`Country of Citizenship` as Country,
    `Name`,
    Age,
    Category,
    format(`Final Worth`*10e5,'C') as `Net Worth(USD)`
From forbes.`forbes list`
Group by `Country of Citizenship`
Having count(`Name`) = 1;

#COUNTRIES AND THEIR COUNTS OF BILLIONAIRES
Select 
	`Country of Citizenship` as Country,
    count(`Name`) as `Nos of Billionaires`,
      count(case when `Self Made` = 'TRUE' then 'Self Made'
		end) as `Self Made`,
	count(case when `Self Made` = 'FALSE' then 'Not Self Made'
		end) as `Not Self Made`,
	count(case when country = `Country of Citizenship` then 'Home Made'
			end) as `Home Made`,
	count(case when country <> `Country of Citizenship` then 'Abroad Made'
			end) as `Abroad Made`,
	count(Case 
			when Gender = "M" Then 'Male'
            end) as `Male`,
	count(Case 
			when Gender = "F" Then 'Female'
		End) as `Female`,
	max(`Philanthropy Score`) as `Philanthropy Score`,
    count(distinct Category) as `Category Count`,
    format((sum(`Final Worth`*10e5)), 
            'C') as `Total Net Worth(USD)`,
    format((round(avg(`Final Worth`*10e5),2)),
			'C') as `Average Net Worth(USD)`,
    round(Avg(Age))as `Average Age`
From forbes.`forbes list`
Group by `Country of Citizenship`
Order By count(`Name`) desc;

#FORBES RICHEST BILLIONAIRE IN EACH COUNTRY
Select
	`Country of Citizenship` as Country,
    `Name`,
    Age,
    Category,
    Format ((max(`Final Worth`*10e5)),'C', 'usd') as `Net Worth(USD)`
From forbes.`forbes list`
Group By `Country of Citizenship`
Order By `Country of Citizenship` asc;

