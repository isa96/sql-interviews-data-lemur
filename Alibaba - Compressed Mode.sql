SELECT
  item_count
FROM
  items_per_order
WHERE
  order_occurrences = (
    SELECT
      MAX(order_occurrences) AS max_occurrences
    FROM
      items_per_order
  )