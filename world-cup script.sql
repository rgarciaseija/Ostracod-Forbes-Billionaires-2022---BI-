SELECT 
	row_number() OVER (ORDER BY Year) as `Row ID`,
	Year,
    Stage,
   `Home Team Name`,
   `Home Team Goals`,
   `Away Team Goals`,
   `Away Team Name`,
	`Home Team Goals` + `Away Team Goals` AS `Total Match Goal`,
    
/*LET'S CHECK MATCHES WHERE BOTH TEAMS SCORED*/  
CASE 
	WHEN `Home Team Goals` and `Away Team Goals` <> 0 THEN "YES"
    ELSE "NO"
END AS `Both Team Scored`,
/*90 MINUTES MATCH RESULT/WINNER*/
CASE
	WHEN `Home Team Goals` > `Away Team Goals` THEN `Home Team Name`
	WHEN `Away Team Goals` > `Home Team Goals` THEN `Away Team Name` 
    ELSE "Draw"
END AS `90 Mins Match Result`,

/*MATCH OVER/UNDER GOALS RESULT WITHIN 90 MINUTES TIME FRAME*/
CASE
	WHEN (`Home Team Goals` + `Away Team Goals`) = 0 THEN "UNDER 0.5"
	WHEN (`Home Team Goals` + `Away Team Goals`) > 0 and (`Home Team Goals` + `Away Team Goals`) < 2 THEN "OVER 0.5"
	WHEN (`Home Team Goals` + `Away Team Goals`) > 1 and (`Home Team Goals` + `Away Team Goals`) < 3 THEN "OVER 1.5"
    WHEN (`Home Team Goals` + `Away Team Goals`) > 2 and (`Home Team Goals` + `Away Team Goals`) < 4 THEN "OVER 2.5"
    WHEN (`Home Team Goals` + `Away Team Goals`) > 3 and (`Home Team Goals` + `Away Team Goals`) < 5 THEN "OVER 3.5"
    WHEN (`Home Team Goals` + `Away Team Goals`) > 4 and (`Home Team Goals` + `Away Team Goals`) < 6 THEN "OVER 4.5"
    WHEN (`Home Team Goals` + `Away Team Goals`) > 5 and (`Home Team Goals` + `Away Team Goals`) < 7 THEN "OVER 5.5"
    ELSE "OVER 6.5+"
END AS `Over Match Goals`,

/*HOME TEAM OVER/UNDER GOALS*/
CASE
	WHEN `Home Team Goals` = 0 THEN "UNDER 0.5"
	WHEN `Home Team Goals` > 0 and `Home Team Goals` < 2 THEN "OVER 0.5"
    WHEN `Home Team Goals` > 1 and `Home Team Goals` < 3 THEN "OVER 1.5"
    WHEN `Home Team Goals` > 2 and `Home Team Goals` < 4 THEN "OVER 2.5"
    WHEN `Home Team Goals` > 3 and `Home Team Goals` < 5 THEN "OVER 3.5"
    WHEN `Home Team Goals` > 4 and `Home Team Goals` < 6 THEN "OVER 4.5"
    WHEN `Home Team Goals` > 5 and `Home Team Goals` < 7 THEN "OVER 5.5"
    ELSE "OVER 6.5+"
END AS `Home Over Goals`,

/*AWAY TEAM OVER/UNDER GOALS*/
CASE
	 WHEN `Away Team Goals` = 0 THEN "UNDER 0.5"
	 WHEN `Away Team Goals` > 0 and `Away Team Goals` < 2 THEN "OVER 0.5"
	 WHEN `Away Team Goals` > 1 and `Away Team Goals` < 3 THEN "OVER 1.5"
     WHEN `Away Team Goals` > 2 and `Away Team Goals` < 4 THEN "OVER 2.5"
     WHEN `Away Team Goals` > 3 and `Away Team Goals` < 5 THEN "OVER 3.5"
	 WHEN `Away Team Goals` > 4 and `Away Team Goals` < 6 THEN "OVER 4.5"
     WHEN `Away Team Goals` > 5 and `Away Team Goals` < 7 THEN "OVER 5.5"
	 ELSE "OVER 6.5+"
END AS `Away Over Goals`
FROM `worldcup-1930-2018` 


	




