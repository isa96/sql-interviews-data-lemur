WITH cte_issued_date AS (
  SELECT
    card_name
    , MAKE_DATE(issue_year, issue_month, 1) AS issued_date
    , issued_amount
  FROM
    monthly_cards_issued
  ORDER BY 
    1, 2
)
, cte_min_issued_date AS (
  SELECT
    *
    , MIN(issued_date) OVER(
        PARTITION BY card_name
      ) AS min_issued_date  
  FROM
    cte_issued_date
)
SELECT
  card_name
  , issued_amount
FROM
  cte_min_issued_date
WHERE
  issued_date = min_issued_date
ORDER BY
  2 DESC