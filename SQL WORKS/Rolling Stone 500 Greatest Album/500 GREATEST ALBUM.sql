# LETS ADD A COLUMN CALLED DECADES
Alter table albumlist
Add Decades varchar(30) null;

select *
from albumlist;

#UPDATE THE TABLE WITH BY ADDING DATA TO THE DECADES COLUMN
UPDATE albumlist
set Decades = (select case when Year >= 1955 and Year <1960 Then '50s' 
							when Year >= 1960 and Year < 1970 Then '60s'
                            when Year >= 1970 and Year < 1980 Then '70s'
                            when Year >= 1980 and Year < 1990 Then '80s'
                            when Year >= 1990 and Year < 2000 Then '90s'
                            when Year >= 2000 and Year < 2010 Then '00s'
                            when Year >= 2010 and Year < 2020 Then '10s'
						end
				where Decades is  null);
                
# MOST POPULAR ARTIST BY NUMBER OF ALBUM THAT MADE THE LIST
SELECT
	Artist,
    count(Artist) as `Artist Count`
FROM albumlist
GROUP BY Artist
ORDER BY `Artist Count` desc;

# MOST POPULAR GENRE
SELECT
	Genre,
    count(Genre) as `Genre Count`
FROM albumlist
GROUP BY Genre
ORDER BY `Count Genre` desc;

# MOST POPULAR SUB-GENRE
SELECT
	`Sub-Genre`,
    count(Genre) as `Sub-Genre Count`
FROM albumlist
GROUP BY Genre
ORDER BY `Sub-Genre Count` desc;

# NUMBER OF ALBUM RELEASED PER DECADE
SELECT
	Decades,
    count(Album) as `Album Count`
FROM albumlist
GROUP BY Decades
ORDER BY `Album Count` desc;
    
# MOST POPULAR GENRE AND SUB-GENRE OF EACH DECADE
WITH CTE_GENRE AS (
	select Decades, Genre, count(Genre) as Genre_Count , `Sub-Genre`, count(`Sub-Genre`) as Sub_Genre_count
	from albumlist 
	group by Decades,`Sub-Genre`)
SELECT
	Decades,
    Genre as `Popular Genre`,
    `Sub-Genre` as `Popular Sub-Genre`
FROM CTE_GENRE
GROUP BY Decades
ORDER BY Decades desc;

# ARTISTS AND THEIR MAJOR GENRES
SELECT
	Artist,
    Genre
FROM albumlist
GROUP BY Artist
ORDER BY Artist asc;

# ARTIST WHOM APPEARED IN ATLEAST THREE DECADES
SELECT 
	Artist,
    count(distinct Decades) as `Decade Count`
FROM albumlist
GROUP BY Artist
HAVING `Decade Count` > 2;
    



