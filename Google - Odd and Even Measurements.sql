WITH cte_rank_mt AS (
  SELECT
    DATE(measurement_time) AS measurement_day
    , measurement_id
    , measurement_value
    , RANK() OVER(
        PARTITION BY DATE(measurement_time)
        ORDER BY measurement_time
    ) AS rank_mt
  FROM
    measurements
)
, cte_separate_mt AS (
  SELECT 
    measurement_day
    , CASE
        WHEN rank_mt % 2 = 1 THEN measurement_value
        ELSE 0
      END AS odd_sum
    , CASE
        WHEN rank_mt % 2 = 0 THEN measurement_value
        ELSE 0
      END AS even_sum
  FROM
    cte_rank_mt
)
SELECT
  measurement_day
  , SUM(odd_sum) AS odd_sum
  , SUM(even_sum) AS even_sum
FROM
  cte_separate_mt
GROUP BY
  1
ORDER BY
  1;