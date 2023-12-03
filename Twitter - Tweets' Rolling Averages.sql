WITH cte_count_tweets AS (
  SELECT
    user_id
    , tweet_date
    , COUNT(tweet_id) AS cnt_tweet
  FROM 
    tweets
  GROUP BY
    2, 1
  ORDER BY
    1
    , 2 DESC
)
, cte_calc_avg AS (
  SELECT
    user_id
    , tweet_date
    , cnt_tweet
    , AVG(cnt_tweet) OVER(
          PARTITION BY user_id
          ORDER BY tweet_date
          ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS rolling_avg_3days
  FROM
    cte_count_tweets
)
SELECT
  user_id
  , tweet_date
  , ROUND(rolling_avg_3days, 2) AS rolling_avg_3days
FROM
  cte_calc_avg