WITH cte_join_table AS (
  SELECT
    t.transaction_id
    , t.product_id
    , p.product_name
  FROM
    transactions t
  JOIN  
    products p
  ON
    t.product_id = p.product_id
  ORDER BY
    1
)
, cte_product_pairs AS (
  SELECT --DISTINCT ON(t1.transaction_id)
  t1.transaction_id
    , t1.product_name product_1
    , t2.product_name product_2
  FROM
    cte_join_table t1
  JOIN
    cte_join_table t2
  ON
    t1.transaction_id = t2.transaction_id
    AND t1.product_id < t2.product_id
)
SELECT 
  COUNT(1) AS combo_num
FROM
  cte_product_pairs