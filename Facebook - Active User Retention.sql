WITH cte_count_events AS (
  SELECT
    user_id
    , EXTRACT(MONTH FROM event_date) AS month
    , COUNT(event_type) AS cnt_event
  FROM 
    user_actions
  GROUP BY
    2, 1
)
, cte_previous_month AS (
  SELECT
    *
    , LAG(cnt_event, 1) OVER(
        PARTITION BY user_id
        ORDER BY month
    ) AS prev_cnt_event
  FROM
    cte_count_events
  WHERE
    cnt_event > 0
)
, cte_active_users AS (
  SELECT
    month
    , COUNT(user_id)
  FROM
    cte_previous_month
  WHERE
    prev_cnt_event > 0
  GROUP BY
    1
)
SELECT
  *
FROM
  cte_active_users
WHERE
  month = 7
