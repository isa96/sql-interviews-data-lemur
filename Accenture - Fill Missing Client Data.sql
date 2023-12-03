WITH cte_category_group AS (
  SELECT
    * 
    , COUNT(category) OVER(
        ORDER BY product_id
      ) AS category_group
  FROM
    products
)
SELECT
  product_id
  , FIRST_VALUE(category) OVER(
      PARTITION BY category_group
      ORDER BY product_id
    ) AS category,name
FROM
  cte_category_group