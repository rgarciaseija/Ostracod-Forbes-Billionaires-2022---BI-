SELECT * 
FROM sales.`supermarket sales`;
 
# CITY AND GENDER COUNT
select
	City,
    count(case when Gender = 'Male' then '1'end) as Male,
	count(case when Gender = 'Female' then '1'end) as Female
from `supermarket sales`
group by City;

# MOST SPENDING GENDER
select
	Gender,
	count(Gender) as Count,
    format(sum(Total),'C') as Revenue
from `supermarket sales`
group by Gender;

# MOST SPENDING CUSTOMER TYPE
select
	`Customer Type`,
    count(`Customer Type`) as Count,
    format(sum(Total),'C') as Revenue
from `supermarket sales`
group by `Customer Type`;

# MOST PREFERED PAYMENT METHOD
select
	Payment,
    count(Payment) as Count,
    format(sum(Total),'C') as Revenue
from `supermarket sales`
group by Payment;

# MOST PREFERED PAYMENT METHOD PER GENDER
select
	Gender,
    count(case when Payment = 'Ewallet' then '1' end) as Ewallet,
    count(case when Payment = 'Credit card' then '2' end) as `Credit card`,
    count(case when Payment = 'Cash' then '1' end) as Cash
from `supermarket sales`
group by Gender;

# MOST PREFERED PAYMENT METHOD PER CITY
select
	City,
	count(case when Payment = 'Ewallet' then '1' end) as Ewallet,
    count(case when Payment = 'Credit card' then '2' end) as `Credit card`,
    count(case when Payment = 'Cash' then '1' end) as Cash
from `supermarket sales`
group by City;

# BEST SELLING PRODUCT LINE
select
	`Product line`,
    sum(Quantity) as Quantity,
    format(sum(Total),'C') as Revenue
from `supermarket sales`
group by `Product line`
order by `Product line` asc;

#  BEST PRODUCT-LINE PER GENDER
select
	`Product line`,
	count(case when Gender = 'Male' then '1'end) as Male,
	count(case when Gender = 'Female' then '1'end) as Female
from `supermarket sales`
group by `Product line`
order by `Product line` asc;  

# BEST PRODUCT-LINE PER CITY
select
	`Product line`,
	count(case when City = 'Yangon' then '1'end) as `Yangon City`,
	count(case when City = 'Naypyitaw' then '1'end) as `Naypyitaw City`,
	count(case when City = 'Mandalay' then '1'end) as `Mandalay City`
from `supermarket sales`
group by `Product line`
order by `Product line` asc;

# PRODUCT-LINE AND PREFERED PAYMENT METHOD
select
	`Product line`,
	count(case when Payment = 'Ewallet' then '1' end) as Ewallet,
    count(case when Payment = 'Credit card' then '2' end) as `Credit card`,
    count(case when Payment = 'Cash' then '1' end) as Cash
from `supermarket sales`
group by `Product line`
order by `Product line` asc;

# BEST SELLING TIME, FIRST LETS ADD A COLUMN CALLED PERIOD
Alter table `supermarket sales`
Add Period varchar(30) null;

# UPDATING THE PERIOD COLUMN    
Update `supermarket sales`
set Period = (select case when Time >= '10' and Time < 12 then 'Morning'
						  when Time >= '12' and Time < 18 then 'Afternoon'
                          when Time >= '18' then 'Evening'
					end
				where Period is null);
Alter table `supermarket sales` 
Drop column Period;
select
	Period,
    count(Period) as Count,
    format(sum(Total),'C') as Revenue
from `supermarket sales`
group by Period;

# MOST PREFERED SHOPPING PERIOD FOR EACH GENDER
select
	Period,
	count(case when Gender = 'Male' then '1'end) as Male,
	count(case when Gender = 'Female' then '1'end) as Female
from `supermarket sales`
group by Period;

# MOST PREFERED PAYMENT METHOD PER PERIOD
select
	Period,
	count(case when Payment = 'Ewallet' then '1' end) as Ewallet,
    count(case when Payment = 'Credit card' then '2' end) as `Credit card`,
    count(case when Payment = 'Cash' then '1' end) as Cash
from `supermarket sales`
group by Period;

# MOST PREFERED SALES PERIOD PER CITY
select
	Period,
	count(case when City = 'Yangon' then '1'end) as `Yangon City`,
	count(case when City = 'Naypyitaw' then '1'end) as `Naypyitaw City`,
	count(case when City = 'Mandalay' then '1'end) as `Mandalay City`
from `supermarket sales`
group by Period;

# HOW MUCH DOES EACH CITY MAKE PER PERIOD
select
	Period,
	count(case when City = 'Yangon' then '1'end) as `Yangon City`,
	count(case when City = 'Naypyitaw' then '1'end) as `Naypyitaw City`,
	count(case when City = 'Mandalay' then '1'end) as `Mandalay City`
from `supermarket sales`;

# PRODUCTS WHOSE TOTAL REVENUE > AVG REVENUE OF ALL PRODUCT-LINE
select
	`Product line`,
	format(Total_Revenue,'C') as `Total Revenue`,
    format(Avg_Revenue,'C') as `Avg Revenue`
from	(select X.`Product line`, sum(Total) as Total_Revenue
		from `supermarket sales` X
		group by X.`Product line`)A
join	(select avg(Total_Revenue) as Avg_Revenue
		 from (select X.`Product line`, sum(Total) as Total_Revenue
		from `supermarket sales` X
		group by X.`Product line`)Y)B
on A.Total_Revenue > B.Avg_Revenue;

# CITY WHOSE TOTAL REVENUE > AVG REVENUE OF ALL PRODUCT-LINE
select
	City,
    format(Total_Revenue,'C') as `Total Revenue`,
    format(Avg_Revenue, 'C') as `Avg Revenue`
from	(select X.City, sum(Total) as Total_Revenue
		 from `supermarket sales` X
         group by X.City)A
join	(select avg(Total_Revenue) as Avg_Revenue
		 from (select X.City, sum(Total) as Total_Revenue
		 from `supermarket sales` X
         group by X.City)Y)B
on A.Total_Revenue > B.Avg_Revenue;

# PRODUCT-LINE QUANTITY SOLD AND REVENUE IN EACH CITY
select 
	`Product line`, 
    City, 
    sum(Quantity) as Quantity ,
    format(round(sum(Total),2),'C') as Revenue
from `supermarket sales` 
group by `Product line`, City
order by `Product line` asc;

# REVENUE FROM EACH PAYMENT METHOD PER PERIOD
select
	Period,
    Payment,
    format(round(sum(Total),2),'C') as Revenue
from `supermarket sales`
group by Period, Payment
order by Period;
    
select
	`Customer type`,
    `Product line`,
    `Unit price`
from `supermarket sales`
group by `Customer type`,`Product line`
order by `Customer type`asc
    