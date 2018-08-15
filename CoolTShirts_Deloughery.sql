/*** CoolTShirts.com ***/

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
		pv.utm_campaign
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
LIMIT 10;

/*** Task 1a ***/
SELECT COUNT (DISTINCT utm_campaign) AS 'Unique Campaigns'
FROM page_visits;

/*** Task 1b ***/
SELECT COUNT (DISTINCT utm_source) AS 'Unique Sources'
FROM page_visits;

/*** Task 1c ***/
SELECT DISTINCT utm_campaign AS Campaign, 
		utm_source AS Source
FROM page_visits
ORDER BY 2;

/*** Task 2 ***/
SELECT DISTINCT page_name AS "Page Name"
FROM page_visits;

/*** Task 3 ***/
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) AS first_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT pv.utm_campaign AS Campaign,
COUNT(ft.first_touch_at) AS "Number of First Touches"
FROM first_touch AS ft
JOIN page_visits AS pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
GROUP BY pv.utm_campaign
ORDER BY 2 DESC;

/*** Task 4 ***/
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) AS last_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT pv.utm_campaign AS Campaign,
COUNT(lt.last_touch_at) AS "Number of Last Touches"
FROM last_touch AS lt
JOIN page_visits AS pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY pv.utm_campaign
ORDER BY 2 DESC;

/*** Task 5 ***/
SELECT COUNT(*) 
FROM page_visits
WHERE page_name = '4 - purchase';

/*** Task 5 (Alternate code) ***/
SELECT COUNT(DISTINCT user_id) AS 'Distinct Users Who Made a Purchase'
FROM page_visits
WHERE page_name = '4 - purchase';

/*** Task 6 ***/
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id)
SELECT pv.utm_campaign AS Campaign,
			 COUNT(lt.last_touch_at) AS "Number of Last Touches on Purchase Page"
FROM last_touch AS lt
JOIN page_visits AS pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY pv.utm_campaign
ORDER BY 2 DESC;

/*** Task 3 (Alternate code) ***/
WITH first_touch AS (
	SELECT user_id,
		MIN(timestamp) AS first_touch_at
	FROM page_visits
	GROUP by user_id),
ft_attr AS (
	SELECT ft.user_id,
				 ft.first_touch_at,
				 pv.utm_source,
				 pv.utm_campaign
	FROM first_touch AS ft
	JOIN page_visits AS pv
		ON ft.user_id = pv.user_id
		AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_source,
			 ft_attr.utm_campaign,
       COUNT(*)
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

/*** Task 4 (Alternate code) ***/
WITH last_touch AS (
	SELECT user_id,
		MAX(timestamp) AS last_touch_at
	FROM page_visits
	GROUP by user_id),
lt_attr AS (
	SELECT lt.user_id,
				 lt.last_touch_at,
				 pv.utm_source,
				 pv.utm_campaign
	FROM last_touch AS lt
	JOIN page_visits AS pv
		ON lt.user_id = pv.user_id
		AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source,
			 lt_attr.utm_campaign,
       COUNT(*)
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;