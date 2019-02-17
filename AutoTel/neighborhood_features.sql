WITH
  t1 AS (WITH htl_neig AS(SELECT hotels.*, neig.neighborhood_name
                          FROM `doit_intl_autotel_public.data_hotels` hotels
                          JOIN `doit_intl_autotel_public.tel_aviv_neighborhood` neig
                          ON ST_WITHIN(ST_GeogFromText(hotels.coordinates),
                                       ST_GeogFromText(neig.area_polygon)))
         SELECT neighborhood_name, COUNT(*) total_hotels
         FROM htl_neig
         GROUP BY  1),
  t2 AS (WITH kgtn_neig AS(SELECT kinder.*, neig.neighborhood_name
                           FROM `doit_intl_autotel_public.data_kindergarten` kinder
                           JOIN `doit_intl_autotel_public.tel_aviv_neighborhood` neig
                           ON ST_WITHIN(ST_GeogFromText(kinder.coordinates),
                                        ST_GeogFromText(neig.area_polygon)))
          SELECT neighborhood_name, COUNT(*) total_kingrtn
          FROM kgtn_neig
          GROUP BY 1),
  t3 AS (WITH demog_data AS(SELECT demog.*, neig.neighborhood_name
                            FROM `doit_intl_autotel_public.data_demographic` demog
                            JOIN `doit_intl_autotel_public.tel_aviv_neighborhood` neig
                            ON    ST_INTERSECTS(ST_GeogFromText(demog.polygon),
                                                ST_GeogFromText(neig.area_polygon)))
          SELECT
            neighborhood_name
            ,ROUND(100* SUM(g5to9+g10to14) / SUM(sum_pop), 1) age5to14
            ,ROUND(100*SUM (g15to19 ) / SUM(sum_pop), 1) age15to19
            ,ROUND(100*SUM( g20to24 + g25to29 ) / SUM(sum_pop), 1) age20to29
            ,ROUND(100*SUM( g30to34) / SUM(sum_pop), 1) age30to34
            ,ROUND(100*SUM( g35to39 + g40to44 + g45to49 ) / SUM(sum_pop), 1) age35to49
            ,ROUND(100*SUM( g50to54+ g55to59+ g60to64 ) / SUM(sum_pop), 1) age50to64
          FROM demog_data GROUP BY neighborhood_name)
SELECT
  age5to14
  ,age15to19
  ,age20to29
  ,age30to34
  ,age35to49
  ,age50to64
  ,total_kingrtn
  ,total_hotels
  ,t4.neighborhood_name
  ,t4.area_polygon
FROM `doit_intl_autotel_public.tel_aviv_neighborhood` AS t4
LEFT JOIN t1
  ON t1.neighborhood_name = t4.neighborhood_name
LEFT JOIN t2
  ON t2.neighborhood_name = t4.neighborhood_name
LEFT JOIN t3
  ON t3.neighborhood_name = t4.neighborhood_name
