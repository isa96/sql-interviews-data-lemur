WITH cte_join_tables AS (
  SELECT
    e.email_id
    , text_id
    , signup_action
  FROM
    emails e
  JOIN
    texts t
    ON e.email_id = t.email_id
)
, cte_cnt_signup_actions AS (
  SELECT
    signup_action
    , CASE
        WHEN signup_action = 'Confirmed' THEN 1 ELSE 0
      END AS confirmed
    , CASE
        WHEN signup_action = 'Not Confirmed' THEN 1 ELSE 0
      END AS not_confirmed
  FROM
    cte_join_tables
)
SELECT
  ROUND(
    1.0 * COUNT(confirmed = 1 OR NULL) / COUNT(*), 2
  ) AS confirm_rate
FROM
  cte_cnt_signup_actions