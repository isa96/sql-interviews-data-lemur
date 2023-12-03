WITH cte_join_tables AS (
  SELECT
    a.artist_name
    , g.song_id
    , g.rank
  FROM
    artists a
  JOIN
    songs s
    ON
      a.artist_id = s.artist_id
  JOIN
    global_song_rank g
    ON
      s.song_id = g.song_id
  WHERE
    g.rank <= 10
)
, cte_cnt_song_appeareances AS (
  SELECT
    artist_name
    , COUNT(*) AS cnt_song_appeareances
  FROM
    cte_join_tables
  GROUP BY
    1
  ORDER BY
    2 DESC
)
, cte_rank_artist AS (
  SELECT
    *
    , DENSE_RANK() OVER(
        ORDER BY cnt_song_appeareances DESC
      ) AS artist_rank
  FROM
    cte_cnt_song_appeareances
)
SELECT
  artist_name
  , artist_rank
FROM
  cte_rank_artist
WHERE
  artist_rank <= 5