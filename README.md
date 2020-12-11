# Web Traffic Time Series Forecasting

This repository contains materials for the MSCA 31009 Time Series Analysis and Forecasting Team Project at the University of Chicago.


## Description

We decided to work on one of the most burning time series problem of today’s day and era, “predicting web traffic” :globe_with_meridians: . We believe that this forecasting can help website servers a great deal in effectively handling outages. The technique we implemented can be extended to diverse applications in financial markets, weather forecasts, audio and video processing. Not just that, understanding your website’s traffic trajectory can open up business opportunities too!

## Data

The training dataset consists of approximately 145k time series. Each of these time series represent a number of daily views of a different Wikipedia article, starting from July, 1st, 2015 up until December 31st, 2016. 

You can find the data [here](https://www.kaggle.com/c/web-traffic-time-series-forecasting/data).

## Structure of the repository

- Scripts Folder: This folder contains the R and python codes for models and EDA.

- Presentation: This contains the final presentation


## Structure of the code
We have used several time series in our codes. Though, for majority of them the theme has been around RIO olympics dataset because they played a key contribution in the overall total views but we have also included a few other datasets. 

1. **LSTM**: This code contains how you can model web traffic views using LSTM 
2. **ARFIMA**: This code contains how you can model web traffic views using ARFIMA, ARIMA and ETS model.
3. **ARIMA**: This code contains how you can model web traffic views using Naive, ARIMA, ETS, and TBATS model for Weighted average cost of capital wikipedia page. This also includes cross validation.
4. **SPECTRAL ANALYSIS**: This code contains spectral analysis for legal high wikipedia page.
5. **INTERVENTION ANALYSIS**: This code contains intevention analysis for rio olympics wikipedia page.
6. **FREQUENCY7**: This code contains ARIMA, sARIMA, TBATS and Dynamic Harmonic Regression model for rio olympics wikipedia page.
7. **DOWNSAMPLING**: This code contains Downsampled data from daily to weekly for rio olympics wikipedia page.
8. **ARIMA-MEAN-REPLACEMENT**: This code contains ARIMA and ETS for 3C ZH wikipedia page where spikes have been replaced with mean values.


## Team: 

![](https://i.ibb.co/pvbdpQJ/Screen-Shot-2020-12-07-at-9-02-34-PM.png)

**Professor**: Dr. Shaddy Abado

- [Aakash Pahuja](https://www.linkedin.com/in/aakash-pahuja16/):  [aakash1@UCHICAGO.EDU](mailto:aakash1@UCHICAGO.EDU)

- [Devanshi Verma](https://www.linkedin.com/in/devanshiverma/): [devanshi@uchicago.edu](mailto:devanshi@uchicago.edu)

- [Prafulla Ranjan Das](https://www.linkedin.com/in/prafullardash/): [prafulladash@uchicago.edu](mailto:prafulladash@uchicago.edu)

- [Surendiran Rangaraj](https://www.linkedin.com/in/surendiran-rangaraj-29463119/): [surendiran@UCHICAGO.EDU](mailto:surendiran@UCHICAGO.EDU)

Please do not hesitate to contact us, if you have any questions.
