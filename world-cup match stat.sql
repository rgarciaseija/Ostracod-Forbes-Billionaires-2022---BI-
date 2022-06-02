SELECT 
	Distinct W.Year,
	WC.`Country` as `Host Country`,
	WC.`QualifiedTeams` as `Qualified Team`,
/*Number of Matches Played*/
    count(W.`Home Team Name`) AS `Matches Played`,
/*Total Number of Goals Scored*/
    sum(W.`Home Team Goals` + W.`Away Team Goals`) AS `Goals Scored`,
/*Average Goals Scored per Game*/
	round(avg(W.`Home Team Goals` + W.`Away Team Goals`),2) AS `Average Goals per Match`,
    WC.Attendance
FROM `worldcup-1930-2018` W
JOIN `worldcups` WC
ON W.Year = WC.Year
GROUP BY Year