use investigating_metric_spike;

select * from events;


-- A.Weekly User Engagement:
-- Objective: Measure the activeness of users on a weekly basis.
-- Your Task: Write an SQL query to calculate the weekly user engagement.
SELECT * FROM email_events;
SELECT 
WEEK(STR_TO_DATE(occurred_at, '%d-%m-%Y %H:%i')) AS Weeks,
COUNT(DISTINCT user_id) AS Engaged_user
FROM email_events
WHERE action = "sent_weekly_digest"
GROUP BY Weeks
ORDER BY Weeks;

-- Note:
--  EXTRACT(WEEK FROM STR_TO_DATE(occurred_at, '%d-%m-%Y %H:%i')) AS Weeks.alter
-- Above code can also be used to get the same result.
-- EXTRACT(WEEK FROM ...) is a general-purpose function that can extract various date parts
-- (e.g., year, month, day) from a date.
-- By specifying WEEK, you instruct it to extract the week number from the date.
-- But in our question set, they only asked for the weeks, that's why we use
-- WEEK(), which is specifically designed to extract only the week number from a date.

-- B. User Growth Analysis:
-- Objective: Analyze the growth of users over time for a product.
-- Your Task: Write an SQL query to calculate the user growth for the product.    
 SELECT 
    YEAR(STR_TO_DATE(created_at, '%d-%m-%Y %H:%i')) AS Year,
    MONTH(STR_TO_DATE(created_at, '%d-%m-%Y %H:%i')) AS Month,
	WEEK(STR_TO_DATE(created_at, '%d-%m-%Y %H:%i')) AS Week,
    COUNT(DISTINCT user_id) AS New_Users,
    SUM(COUNT(DISTINCT user_id)) OVER 
    (ORDER BY Year(STR_TO_DATE(created_at, '%d-%m-%Y %H:%i')) 
     ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Sum_of_newly_joined_users
FROM 
    users
GROUP BY 
    Year,Month,Week 
ORDER BY 
    Year;
-- Note:- 
-- In some places, the number of newly joined users has decreased,
-- From the above table, we can see that the number of freshly joined users has decreased 
-- from 101 to 66 between weeks 2 and 3, from 107 to 76 between weeks 3 and 4, from 128 to 105 
-- between weeks 3 and 4, from 106 to 84 between weeks 3 and 4, and from 106 to 84 between weeks 3 and 4.
-- In all other cases, the number of newly joined users has increased from the previous week.
-- Now companies can find out the specific area where they lose their customers, and work accordingly.

-- C. Weekly Retention Analysis:
-- Objective: Analyze the retention of users on a weekly basis after signing up for a product.
-- Your Task: Write an SQL query to calculate the weekly retention of users based on their sign-up cohort.

SELECT * FROM events;
SELECT 
	WEEK(STR_TO_DATE(occurred_at, '%d-%m-%Y %H:%i')) AS Week,
    COUNT(DISTINCT user_id) AS Total_users
FROM events
	WHERE event_type = 'signup_flow' AND event_name = 'complete_signup'
GROUP BY Week
ORDER BY Week;
-- Note:-
-- From Week 17 to Week 32, we observe fluctuations in user retention, with a steady increase in total users, 
-- peaking around Week 30, followed by a noticeable decline through Week 32. This pattern indicates that user
-- engagement may drop off after Week 30. To improve retention, we can analyze factors contributing to these 
-- drop-off points and implement targeted strategies to sustain engagement. By identifying specific points 
-- where users disengage, we can enhance the user experience and develop effective retention tactics to 
-- maintain a steady user base.

-- D. Weekly Engagement Per Device:
-- Objective: Measure the activeness of users on a weekly basis per device.
-- Your Task: Write an SQL query to calculate the weekly engagement per device.
SELECT 
device,
WEEK(STR_TO_DATE(occurred_at, '%d-%m-%Y %H:%i')) AS Week,
COUNT(DISTINCT user_id) AS Number_of_users
FROM events
WHERE event_type = 'engagement'
GROUP BY device, Week
ORDER BY Week;
-- Note:
-- We are tracking weekly user activity by device to assess engagement levels.
-- The data shows that user engagement varies across different devices, with some devices consistently
-- having higher engagement than others. To improve engagement, we can analyze factors affecting these
-- variations, focusing on device compatibility and optimizing the user experience.
-- Additionally, monitoring trends for devices with lower engagement will help us identify specific challenges,
-- allowing us to develop targeted strategies to enhance engagement on these devices.

-- E. Email Engagement Analysis:
-- Objective: Analyze how users are engaging with the email service.
-- Your Task: Write an SQL query to calculate the email engagement metrics.
SELECT 
DATE_FORMAT(STR_TO_DATE(occurred_at, '%d-%m-%Y %H:%i'), '%Y-%m') AS Month,
COUNT(CASE WHEN action = 'sent_weekly_digest' THEN 1 END) AS Emails_Sent,
COUNT(DISTINCT CASE WHEN action = 'email_open' THEN user_id END) AS Unique_Openers,
COUNT(CASE WHEN action = 'email_clickthrough' THEN 1 END) AS Total_Clicks,
COUNT(DISTINCT CASE WHEN action = 'email_clickthrough' THEN user_id END) AS Unique_Clickers,
    CASE 
        WHEN COUNT(DISTINCT CASE WHEN action = 'email_open' THEN user_id END) > 0 
        THEN ROUND(COUNT(DISTINCT CASE WHEN action = 'email_clickthrough' THEN user_id END) / 
                   COUNT(DISTINCT CASE WHEN action = 'email_open' THEN user_id END) * 100, 2) 
        ELSE 0 
    END AS Click_Through_Rate
FROM 
    email_events
GROUP BY 
    Month
ORDER BY 
    Month;
-- Note:
-- The engagement data for the weekly digest emails between May and August 2014 shows positive trends 
-- with some fluctuations:
-- Emails Sent: Monthly email volume increased from 11,730 in May to 16,480 in August, 
-- suggesting a growing user base or enhanced outreach.
-- Unique Openers: Unique openers also rose, from 2,681 in May to 3,879 in August, 
-- reflecting increased engagement and interest among users.
-- Clicks and Clickers: Both total clicks and unique clickers peaked in July but dropped in August, 
-- with clicks decreasing from 2,721 to 1,992, and unique clickers from 2,267 to 1,804.
-- Click-Through Rate (CTR): The CTR remained strong, above 60% in most months, peaking at 65.58% in July. 
-- However, August showed a notable decrease to 46.51%, suggesting possible user fatigue or content relevance
-- issues.


  
  
  
  




