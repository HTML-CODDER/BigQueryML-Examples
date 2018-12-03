SELECT
ST_GeogFromText(neighs.area_polygon) WKT ,
data.*
from (select
DATE_TRUNC(cast (timestamp as DATE), DAY) day,
EXTRACT( HOUR FROM timestamp) hour,
AVG(predicted_label) prediction,
AVG(free_cars) free_cars,
neighborhood_name
 from `autotel_demo.free_cars_predictions_v1`  group by 1,2, neighborhood_name) as data
 JOIN autotel_demo.tel_aviv_neighborhood as neighs ON
 neighs.neighborhood_name = data.neighborhood_name
 WHERE hour=13 AND day = DATE '2018-11-24'
