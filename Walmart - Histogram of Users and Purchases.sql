WITH cte_count_purchase AS (
  SELECT
    transaction_date
    , user_id
    , COUNT(*) AS purchase_count
  FROM 
    user_transactions
  GROUP BY
    2, 1
  ORDER BY
    1 DESC
  LIMIT
    3
)
SELECT
  *
FROM
  cte_count_purchase
ORDER BY
  transaction_date