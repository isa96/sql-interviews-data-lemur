WITH cte_sum_type AS (
  SELECT
    ab.age_bucket
    , a.activity_type
    , SUM(a.time_spent) AS time_spent
  FROM
    activities a
  JOIN
    age_breakdown ab
  ON
    a.user_id = ab.user_id
  WHERE
    a.activity_type IN ('open', 'send')
  GROUP BY
    2, 1
  ORDER BY
    1, 2
)
, cte_sum_age AS (
  SELECT
    age_bucket
    , SUM(time_spent) AS time_spent
  FROM
    cte_sum_type
  GROUP BY
    1
  ORDER BY
    1
)
, cte_calc_percentage AS (
  SELECT
    st.age_bucket
    , CASE
        WHEN st.activity_type = 'send'
        THEN (st.time_spent / sa.time_spent) * 100.0
        ELSE 0
    END AS send_perc
    , CASE
        WHEN st.activity_type = 'open'
        THEN (st.time_spent / sa.time_spent) * 100.0
        ELSE 0
    END AS open_perc
  FROM
    cte_sum_type st
  JOIN
    cte_sum_age sa
  ON
    st.age_bucket = sa.age_bucket
)
SELECT
  age_bucket
  , ROUND(SUM(send_perc), 2) AS send_perc
  , ROUND(SUM(open_perc), 2) AS open_perc
FROM
  cte_calc_percentage
GROUP BY
  1
ORDER BY
  1