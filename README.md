# WindTurbineOutputPrediction
This repository contains the IPython notebook I used for H2O's Open Tour NYC Hackathon on July 19 and 20, 2016.

## Problem Statement
Given daily 24-hours-at-a-time wind forecasts, predict the nominal wind turbine output for 10 turbines. The provided data are the turbine number, timestamp of the forecast, and forecasted [zonal and meridional wind vectors](https://en.wikipedia.org/wiki/Zonal_and_meridional) at 10 meters and 100 meters. The wind data were taken in 2012 and 2013. The training data consist of the first 19 months, and the test set of the following five months (the last month only has ten records). The public leaderboard is based on the first two months of the test dataset (Aug-2013 and Sep-2013), while the rest of the test dataset is used for the private leaderboard.

**Note:**
- You are expected to upload the solution in the format of "sample_submission.csv".
- The public-private split is based on time period.
- The evaluation metric is [Root Mean Square Error (RMSE)](https://www.analyticsvidhya.com/blog/2016/02/7-important-model-evaluation-error-metrics/).

**Data:**

| Variable  | Definition                             |
|-----------|----------------------------------------|
| ID        | Unique ID for each observation         |
| ZONEID    | ID of the zone / turbine               |
| TIMESTAMP | Time at time of taking the observation |
| U10       | Zonal Wind Vector at 10 m              |
| V10       | Meridional Wind Vector at 10 m         |
| U100      | Zonal Wind vector at 100 m             |
| V100      | Meridional Wind vector at 100 m        |
| TARGETVAR | Output of the wind turbine             |

To learn more about U and V wind vectors, click [here](https://www.eol.ucar.edu/content/wind-direction-quick-reference).

The full data set (including the target variable values for the test subset used for the public and private leaderboards) will be made available at some point from [Dr. Tao Hong's Energy Forecasting website](http://blog.drhongtao.com/2016/07/datasets-for-energy-forecasting.html), under "GEFCom2014".
