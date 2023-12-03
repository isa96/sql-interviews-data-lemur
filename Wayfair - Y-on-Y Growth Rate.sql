WITH cte_prev_year_spend AS (
  SELECT
    EXTRACT(YEAR FROM transaction_date)
    , product_id
    , spend as curr_year_spend
    , LAG(spend) OVER(
        PARTITION BY product_id
        ORDER BY EXTRACT(YEAR FROM transaction_date)
      ) AS prev_year_spend
  FROM
    user_transactions
)
SELECT
  *
  , ROUND(
      ((curr_year_spend - prev_year_spend) / prev_year_spend) * 100
      , 2
    ) AS yoy_rate
FROM
  cte_prev_year_spend