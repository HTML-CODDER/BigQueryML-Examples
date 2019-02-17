
-- v1
SELECT
  EXP(predicted_label) - 1 predicted_label
  ,free_cars
  ,ABS(free_cars-predicted_label) ERR
 , neighborhood_name
 ,timestamp
 FROM ML.PREDICT(MODEL `doit_intl_autotel_public.free_cars_model_v1`,

(SELECT
      age5to14
    , age15to19
    , age20to29
    , age30to34
    , age35to49
    , age50to64
    , total_kingrtn
    , total_hotels
    , hour
    , free_cars
    , neighborhood_name
    , timestamp
FROM
  `doit_intl_autotel_public.dataset_v1` as dataset
  WHERE dataset.TIMESTAMP > TIMESTAMP '2019-02-10'))

-- v2
SELECT
  EXP(predicted_label) - 1 predicted_label
  ,free_cars
  ,ABS(free_cars-predicted_label) ERR
 , neighborhood_name
 ,timestamp
 FROM ML.PREDICT(MODEL `doit_intl_autotel_public.free_cars_model_v2`,

(SELECT
      age20to29
    , age30to34
    , age35to49
    , age50to64
    , total_kingrtn
    , total_hotels
    , hour
    , is_workday
    , free_cars
    , neighborhood_name
    , timestamp
FROM
  `doit_intl_autotel_public.dataset_v2` as dataset
  WHERE dataset.TIMESTAMP > TIMESTAMP '2019-02-10'))
