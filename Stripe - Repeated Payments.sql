WITH cte_prev_transaction AS (
  SELECT
    * 
    , LAG(credit_card_id) OVER(
        PARTITION BY merchant_id
        ORDER BY transaction_timestamp
      ) AS prev_credit_card_id
    , LAG(transaction_timestamp) OVER(
        PARTITION BY (merchant_id, credit_card_id)
        ORDER BY transaction_timestamp
      ) AS prev_transaction_timestamp
  FROM 
    transactions
)
, cte_minute_diff AS (
  SELECT
    *
    , ROUND(
        EXTRACT(
            EPOCH FROM 
            (transaction_timestamp - prev_transaction_timestamp)
        ) / 60
      ) AS minute_diff
  FROM
    cte_prev_transaction
)
SELECT
  COUNT(DISTINCT(merchant_id, credit_card_id)) AS payment_count
FROM
  cte_minute_diff
WHERE
  credit_card_id = prev_credit_card_id
  AND minute_diff <= 10