-- V1
SELECT
      IFNULL(features.age5to14, 0) age5to14
      ,IFNULL(features.age15to19, 0) age15to19
      ,IFNULL(features.age20to29, 0) age20to29
      ,IFNULL(features.age30to34, 0) age30to34
      ,IFNULL(features.age35to49, 0) age35to49
      ,IFNULL(features.age50to64, 0) age50to64
      ,IFNULL(features.total_kingrtn, 0) total_kingrtn
      ,IFNULL(features.total_hotels, 0) total_hotels
      ,features.neighborhood_name
      ,t.year
      ,t.month
      ,t.day
      ,t.hour
      ,t.minute
      ,t.free_cars
      ,t.timestamp
FROM (WITH data AS (
                      WITH car_locs AS (SELECT * FROM `doit_intl_autotel_public.car_locations`),
                           ta_dis AS ( SELECT  *  FROM `doit_intl_autotel_public.neighborhood_features`  )
      SELECT car_locs.*, ta_dis.neighborhood_name neighborhood_name FROM car_locs
      JOIN ta_dis
        ON  ST_WITHIN(ST_GEOGPOINT(car_locs.longitude, car_locs.latitude),
            ST_GeogFromText(ta_dis.area_polygon)) )
      SELECT  EXTRACT(MINUTE  FROM t.timestamp) minute
              ,EXTRACT(HOUR  FROM t.timestamp) hour
              ,EXTRACT(DAY FROM t.timestamp) day
              ,EXTRACT(MONTH  FROM  t.timestamp) month
              ,EXTRACT(YEAR FROM t.timestamp) year
              ,neighborhood_name
              ,SUM(total_cars) free_cars
              ,ANY_VALUE(timestamp) timestamp
FROM data AS t
GROUP BY 1,2,3,4,5,6
ORDER BY free_cars DESC) as t JOIN doit_intl_autotel_public.neighborhood_features as features ON
features.neighborhood_name =  t.neighborhood_name
      
 -- V2     
 SELECT
      IFNULL(features.age20to29, 0) age20to29
      ,IFNULL(features.age30to34, 0) age30to34
      ,IFNULL(features.age35to49, 0) age35to49
      ,IFNULL(features.age50to64, 0) age50to64
      ,IFNULL(features.total_kingrtn, 0) total_kingrtn
      ,IFNULL(features.total_hotels, 0) total_hotels
      ,features.neighborhood_name
      ,t.year
      ,t.month
      ,t.day
      ,(POW(t.hour, 0) * 3.676)
            + (POW(t.hour, 1) * -0.07694247469680397)
            + (POW(t.hour, 2) * 0.1435622153947894)
            + (POW(t.hour, 3) * -0.04846806856580721)
            + (POW(t.hour, 4) *  0.00663549708662955)
            + (POW(t.hour, 5) * -0.0004410047486667748)
            + (POW(t.hour, 6) * 1.4172471036096757e-05)
            + (POW(t.hour, 7) * -1.7651328628658057e-07)  hour
      ,t.minute
      ,CASE 
            WHEN (EXTRACT (DAYOFWEEK FROM t.timestamp) IN (5,6)) THEN 0
            ELSE 1
      END is_workday
      ,t.free_cars
      ,t.timestamp
FROM (WITH data AS (
                      WITH car_locs AS (SELECT * FROM `doit_intl_autotel_public.car_locations`),
                           ta_dis AS ( SELECT  *  FROM `doit_intl_autotel_public.neighborhood_features`  )
      SELECT car_locs.*, ta_dis.neighborhood_name neighborhood_name FROM car_locs
      JOIN ta_dis
        ON  ST_WITHIN(ST_GEOGPOINT(car_locs.longitude, car_locs.latitude),
            ST_GeogFromText(ta_dis.area_polygon)) )
      SELECT  EXTRACT(MINUTE  FROM t.timestamp) minute
              ,EXTRACT(HOUR  FROM t.timestamp) hour
              ,EXTRACT(DAY FROM t.timestamp) day
              ,EXTRACT(MONTH  FROM  t.timestamp) month
              ,EXTRACT(YEAR FROM t.timestamp) year
              ,neighborhood_name
              ,SUM(total_cars) free_cars
              ,ANY_VALUE(timestamp) timestamp
FROM data AS t
GROUP BY 1,2,3,4,5,6
ORDER BY free_cars DESC) as t JOIN doit_intl_autotel_public.neighborhood_features as features ON
features.neighborhood_name =  t.neighborhood_name
