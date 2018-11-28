SELECT
  predicted_label
  ,free_cars
  ,ABS(free_cars-predicted_label) ERR
 , neighborhood_name
 ,timestamp
 FROM ML.PREDICT(MODEL `gad-playground-212407.autotel_demo.free_cars_model`,

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
  `autotel_demo.autotel_dataset_v1` as dataset
  WHERE dataset.TIMESTAMP > TIMESTAMP '2018-10-11'))

  
