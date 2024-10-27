USE Job_Data_Analysis; 
SELECT * FROM job_data;
-- 1. Jobs Reviewed Over Time:
-- Objective: Calculate the number of jobs reviewed per hour for each day in November 2020.
-- Your Task: Write an SQL query to calculate the number of jobs reviewed per hour 
-- for each day in November 2020.
SELECT ds,sum(time_spent) AS Total_time_spent, 
COUNT(job_id) as Number_of_total_jobs,
ROUND((SUM(time_spent) / COUNT(job_id)), 1) AS Time_taken_for_each_job_in_secs,
CASE 
        WHEN SUM(time_spent) > 0 THEN (SUM(time_spent)/3600 )
        ELSE 
            0
    END AS Reviews_in_an_hour_on_each_day_of_November
FROM job_data
GROUP BY ds
ORDER BY Total_time_spent;
-- 2.	Throughput Analysis:
-- Objective: Calculate the 7-day rolling average of throughput (number of events per second).
-- Your Task: Write an SQL query to calculate the 7-day rolling average of throughput.
-- Additionally, explain whether you prefer using the daily metric or the 7-day rolling average 
-- for throughput, and why.
select round(count(event)/sum(time_spent), 2) as Throughput_weekly_basis
from job_data;
select ds as Date, round(count(event)/sum(time_spent), 2) as Throughput_daily_basis
from job_data 
group by ds
order by ds;
-- 3. Language Share Analysis:
-- Objective: Calculate the percentage share of each language in the last 30 days.
-- Your Task: Write an SQL query to calculate the percentage share of each language over 
-- the last 30 days.
select language, round(100*count(*)/total,2) as Percentage, sub.total from job_data
cross join(
select count(*) as total from job_data) as sub
group by language, sub.total;
-- 4. Duplicate Rows Detection:
-- Objective: Identify duplicate rows in the data.
-- Your Task: Write an SQL query to display duplicate rows from the job_data table.
with cte as(
select actor_id,ds,job_id,event,language,time_spent,org, row_number() 
over(partition by actor_id,ds,job_id,event,language,time_spent,org 
order by actor_id) as RN 
from job_data)
select * from cte where RN >1;
-- Approch two:- 
select actor_id, count(*) as Duplicates from job_data
group by actor_id having count(*)>1;





