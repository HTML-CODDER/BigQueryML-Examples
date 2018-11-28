-- Version 1

CREATE OR REPLACE MODEL
  `autotel_demo.free_cars_model` --model save path
OPTIONS
  ( model_type='linear_reg', -- As of Nov 2018 you can choose between linear regression and logistic regression
    ls_init_learn_rate=.015,
    l1_reg=0.1,
    l2_reg=0.1,
    data_split_method='seq',
    data_split_col='split_col',
    min_rel_progress=0.001,

    max_iterations=30 -- by default, uses early stopping!
    ) AS
SELECT
    LN(1 + free_cars) label, -- by naming this field "label" we make it target field
    timestamp split_col
    -- independent variables:
    ,age5to14
    ,age15to19
    ,age20to29
    ,age30to34
    ,age35to49
    ,age50to64
    ,total_kingrtn
    ,total_hotels
    ,hour
FROM
  `autotel_demo.autotel_dataset_v1` as dataset
  WHERE dataset.TIMESTAMP < TIMESTAMP '2018-11-11' -- splitting by year ensures that we don't leak test data to training set


-- Version 2
CREATE OR REPLACE MODEL
  `autotel_demo.free_cars_model_v2` --model save path
OPTIONS
  ( model_type='linear_reg', -- As of Aug 2018 you can choose between linear regression and logistic regression
    data_split_method='seq',
    data_split_col='split_col',
    min_rel_progress=0.001,
    max_iterations=30 -- by default, uses early stopping!
    ) AS
SELECT
    free_cars label, -- by naming this field "label" we make it target field
    timestamp split_col
    -- independent variables:
    , age20to29
    , age30to34
    , age35to49
    , age50to64
    , total_kingrtn
    , total_hotels
    , hour
    , is_workday
FROM
  `autotel_demo.autotel_dataset_v2` as dataset
