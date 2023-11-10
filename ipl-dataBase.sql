-- question 1 :: Number of matches played per year for all the years in IPL.

select * from matches;
select season ,count(season) from matches
group by season
order by season asc


-- question 2 :: Number of matches won per team per year in IPL.

0
select * from matches;
select season ,winner, count(winner) as count from matches
group by season , winner
order by season , winner asc

-- question 3 ::Extra runs conceded per team in the year 2016

select winner, SUM(extra_runs)
from matches 
inner join 
deliveries on matches.id = deliveries.match_id
where matches.season = '2016'
group by winner
order by sum asc;

-- question4::Top 10 economical bowlers in the year 2015

select bowler, 
sum(total_runs - penalty_runs - legbye_runs - bye_runs) * 6.0  / count(case
	 when noball_runs = 0 and wide_runs =0
	 then 1
	 else null
	 end ) as fairDeliveries
from deliveries
inner join matches
on matches.id = deliveries.match_id
where season = '2015'
group by bowler
order by fairdeliveries 
limit 10


-- question 5 :: Find the number of times each team won the toss and also won the match

select * from matches;
select winner , count(winner) from matches 
where toss_winner = winner 
group by winner
order by count(winner) asc


-- question 6 :: Find a player who has won the highest number of Player of the Match awards for each season

select season , player_of_match , sub.total 
from
(select season , player_of_match , count(player_of_match) as total,
row_number() over(partition by season order by count(player_of_match) desc) as ranking
from matches
group by season , player_of_match
order by season , total desc
) as sub
where ranking =1
group by season , player_of_match, total;

-- question 7 :: Find the strike rate of a batsman for each season

select season , 
sum(batsman_runs)*100.0/count(case when wide_runs = 0 then 1 else 0 end ) 
as strikeRate
from deliveries as d
join matches as m
on m.id = d.match_id and batsman = 'DA Warner'
group by season 
order by season 


-- question 8 :: Find the highest number of times one player has been dismissed by another player

select bowler , player_dismissed , count(player_dismissed) as pd
from deliveries
where dismissal_kind <> 'run out'
group by bowler ,player_dismissed
order by pd desc
limit 1

-- question 9 :: Find the bowler with the best economy in super overs

select bowler , round(sum(total_runs - legbye_runs - penalty_runs - bye_runs )* 6.0/sum(case when wide_runs = 0 and noball_runs=0 then 1 else 0 end),2) as economy  
from deliveries 
where is_super_over = 1
group by bowler 
order by economy 


