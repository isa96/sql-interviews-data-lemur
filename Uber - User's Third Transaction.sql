WITH cte_rank AS (
  SELECT
    user_id
    , spend
    , transaction_date
    , RANK() OVER(
        PARTITION BY user_id
        ORDER BY DATE(transaction_date)
      ) AS transaction_rank
  FROM
    transactions
)
SELECT
  user_id
  , spend
  , transaction_date
FROM
  cte_rank
WHERE
  transaction_rank = 3