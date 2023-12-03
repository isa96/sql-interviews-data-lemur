WITH cte_sum_spend AS (
  SELECT 
    category
    , product
    , SUM(spend) AS total_spend
  FROM
    product_spend
  WHERE
    EXTRACT(YEAR FROM transaction_date) = 2022
  GROUP BY
    2, 1
)
, cte_rank_product AS (
  SELECT
    *
    , RANK() OVER(
        PARTITION BY category
        ORDER BY total_spend DESC
      ) AS product_rank
  FROM
    cte_sum_spend
)
SELECT
  category
  , product
  , total_spend
FROM
  cte_rank_product
WHERE
  product_rank <= 2