WITH cte_search_series AS (
  SELECT
    searches
    , GENERATE_SERIES(1, num_users) AS search_series
  FROM 
    search_frequency
  ORDER BY
    searches
)
SELECT
  PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY searches) AS median
FROM
  cte_search_series