# WindTurbineOutputPrediction
This repository contains the Python and R Jupyter notebooks I used to work on H2O's Open Tour NYC Hackathon on July 19 and 20, 2016, and afterwards. See blog post at [http://lucdemortier.github.io/articles/17/WindPower](http://lucdemortier.github.io/articles/17/WindPower) for a description of the results.

## Contents
- [1_data_preparation.ipynb](https://github.com/LucDemortier/WindTurbineOutputPrediction/blob/master/1_data_preparation.ipynb): Reads hackathon input csv files (for training and testing), creates data frames, and pickles them for Python notebooks or feathers them for R notebooks.
- [2_exploratory_visuals.ipynb](https://github.com/LucDemortier/WindTurbineOutputPrediction/blob/master/2_exploratory_visuals.ipynb): Generates various plots to explore the data prior to modeling.
- [3_random_forest_regressor.ipynb](https://github.com/LucDemortier/WindTurbineOutputPrediction/blob/master/3_random_forest_regressor.ipynb): A random forest regression model which models all ten turbines as a single turbine with a "zone id" setting.
- [4_random_forest_regressor.ipynb](https://github.com/LucDemortier/WindTurbineOutputPrediction/blob/master/4_random_forest_regressor.ipynb): A random forest regression model which separately models each of the ten turbines, using wind velocity measurements from all zones.
- [5_xgboost_regressor.ipynb](https://github.com/LucDemortier/WindTurbineOutputPrediction/blob/master/5_xgboost_regressor.ipynb): An XGBoost regression model.
- [6_xgboost_classifier_plus_regressor.ipynb](https://github.com/LucDemortier/WindTurbineOutputPrediction/blob/master/6_xgboost_classifier_plus_regressor.ipynb): A combination of an XGBoost classifier and regressor. The classifier predicts which turbine outputs are zero, the regressor predicts the values of the non-zero outputs.
- [7_gamlss_R.ipynb](https://github.com/LucDemortier/WindTurbineOutputPrediction/blob/master/7_gamlss_R.ipynb): A generalized linear model. This notebook runs an R kernel and uses the R package GAMLSS.
- [8_check_solution.ipynb](https://github.com/LucDemortier/WindTurbineOutputPrediction/blob/master/8_check_solution.ipynb): Uses csv files with predictions created by the other notebooks to compute the RMSE for the hackathon's public and private leaderboards.
- [summarynoprint.R](https://github.com/LucDemortier/WindTurbineOutputPrediction/blob/master/summarynoprint.R) and [wp_withdata.R](https://github.com/LucDemortier/WindTurbineOutputPrediction/blob/master/wp_withdata.R) are routines from the GAMLSS package that I had to modify slightly for the R notebook.

## Problem Statement
Given daily 24-hours-at-a-time wind forecasts, predict the nominal wind turbine output for 10 turbines. The provided data are the turbine number, timestamp of the forecast, and forecasted [zonal and meridional wind vectors](https://en.wikipedia.org/wiki/Zonal_and_meridional) at 10 meters and 100 meters above ground. The wind data were taken in 2012 and 2013. The training data consist of the first 19 months, and the test set of the following five months (the last month only has ten records). The public leaderboard is based on the first two months of the test dataset (Aug-2013 and Sep-2013), while the rest of the test dataset is used for the private leaderboard.

**Note:**
- The public-private split is based on time period.
- The evaluation metric is [Root Mean Squared Error (RMSE)](https://www.analyticsvidhya.com/blog/2016/02/7-important-model-evaluation-error-metrics/).

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

The full data set (including the target variable values for the test subset used for the public and private leaderboards) is available from [Dr. Tao Hong's Energy Forecasting website](http://blog.drhongtao.com/2016/07/datasets-for-energy-forecasting.html), under "GEFCom2014".
