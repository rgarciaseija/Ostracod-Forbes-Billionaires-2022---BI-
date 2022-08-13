SELECT A.* , B.Country `Company Country`
FROM data_science_job_salary.ds_salaries A
JOIN `c.code` B
ON A.`Company Location`= B.`ISO-2`;

# DATA CLEANING
Update ds_salaries
set `Experience Level` = (select case 
								when `Experience Level` = 'MI' then 'Intermediate'
                                when `Experience Level` = 'SE' then 'Expert'
                                when `Experience Level` = 'EN' then 'Junior'
                                when `Experience Level` = 'EX' then 'Executive'
                                end
                                where `Experience Level` in ('MI','SE','EN','EX'));

Update ds_salaries
set `Employment Type` = (select case
								when `Employment Type` = 'FT' then 'Full-Time'
                                when `Employment Type` = 'CT' then 'Contract'
                                when `Employment Type` = 'PT' then 'Part-Time'
                                when `Employment Type` = 'FL' then 'Freelance'
                                end
                                where `Employment Type` in ('FT','CT','PT','FL'));
                                
Update ds_salaries
set `Company Size` = (select case
							when `Company Size` = 'L' then 'Large'
                            when `Company Size` = 'M' then 'Medium'
                            when `Company Size` = 'S' then 'Small'
                            end 
                            where `Company Size` in ('L','M','S'));
                            
Alter table ds_salaries
Modify column `Remote Ratio` varchar(10);

Update ds_salaries
set `Remote Ratio` = (select case
							when `Remote Ratio` = '0' then 'Onsite'
                            when `Remote Ratio` = '50' then 'Hybrid'
                            when `Remote Ratio` = '100' then 'Remote'
                            end
                            where `Remote Ratio` in ('0','50','100'));
                            
Alter table ds_salaries
change `Remote Ratio` `Job Type` varchar(10);

Alter table ds_salaries
Drop column Residence;


							