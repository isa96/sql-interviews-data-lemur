WITH cte_caller_country AS (
  SELECT
    c.caller_id
    , c.receiver_id
    , country_id AS caller_country
  FROM 
    phone_info i
  LEFT JOIN
    phone_calls c
  ON
    i.caller_id = c.caller_id
    -- OR i.caller_id = c.receiver_id
  WHERE
    c.caller_id IS NOT NULL
    AND c.receiver_id IS NOT NULL
)
, cte_receiver_country AS (
  SELECT
    c.caller_id
    , c.caller_country
    , c.receiver_id
    , i.country_id AS receiver_country
  FROM
    cte_caller_country c
  JOIN
    phone_info i
  ON
    c.receiver_id = i.caller_id
)
, cte_is_international_calls AS (
  SELECT
    *
    , CASE
        WHEN caller_country != receiver_country
        THEN 1 ELSE 0
      END AS is_international_call
  FROM
    cte_receiver_country
)
SELECT
  ROUND(
      100.0 * COUNT(is_international_call = 1 OR NULL) / COUNT(*)
      , 1
    ) AS international_calls_pct
FROM
  cte_is_international_calls