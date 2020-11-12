#load libraries
# visualization
library('ggplot2') 

# data manipulation
library('dplyr')
library('readr')
library('imputeTS')


#time series
library('fpp')
library('forecast')
library('xts')
library('zoo')

#importing the data and considering just one page
train_1 <- read.csv("~/Desktop/UChicago/Quarters/03-Quarters/Data/TS/web-traffic-time-series-forecasting/train_1.csv", header = TRUE, row.names = 1,sep = ",",skip =0)
#Tech <- data.frame(train_1[c("Google_zh.wikipedia.org_all-access_spider","Apple_II_zh.wikipedia.org_all-access_spider","Facebook_zh.wikipedia.org_all-access_spider","YouTube_zh.wikipedia.org_all-access_spider","Android_zh.wikipedia.org_all-access_spider"),])
novela <- data.matrix(train_1[c("ASCII_zh.wikipedia.org_all-access_spider"),])

#the data is from 2015 July 01 to 2015 August 19

#dropping the colnames and creating a time series object
dimnames(novela)<-NULL
novela<-array(novela)
head(novela)
length(novela)
plot(novela,type='l')



#creating a time series object
#novela_ts<-ts(novela,frequency = 365.25,start = c(2015, 7, 1))
time_index <- seq(from = as.POSIXct("2015-07-01"), 
                  to = as.POSIXct("2016-12-31"), by = "day")
novela_ts <- xts(novela, order.by =time_index ,frequency = 365.25)
novela_ts

autoplot(novela_ts,ylab="1984 daily traffic",xlab="Day")


#splitting data into test and train
novela_train<-novela_ts['2015-07-01/2016-08-31']
novela_test<-novela_ts['2016-09-01/2016-12-31']
tsdisplay(novela_train)
tsdisplay(novela_test)

#requirement for transformation
BoxCox.lambda(novela_train)

autoplot(novela_train)
ggAcf(novela_train)
ggPacf(novela_train)


#ACF and PACF values show us that the time series isn't stationary as the trend isn't dying down
# There's is no trend, looks a little seasonal, and it doesn't look stationary i.e. the mean isn't
#constant for any set of data

#testing stationary
kpss.test(novela_train)

#Therefore, it is non stationary and we need to difference it
novela_train_diff <- diff(novela_train)
kpss.test(novela_train_diff)
tsdisplay(novela_train_diff)



#forecast horizon
h<-428
#naive forecasts
novela_train_new<-ts(novela_ts['2015-07-01/2016-08-31'])
novela_test_new<-ts(novela_ts['2016-09-01/2016-12-31'])
Model_Mean <- meanf(novela_train_new, h) 
Model_Naive <- naive(novela_train_new, h) 
Model_SNaive <- snaive(novela_train_new,h)
Model_Drift <- rwf(novela_train_new, h, drift=TRUE)

#Naive forecast
autoplot(diff(novela_train_new)) +
  autolayer(Model_SNaive$mean, series="Seasonal naïve") +
  autolayer(Model_Mean$mean, series="Mean") +
  autolayer(Model_Naive$mean, series="Naïve") +
  autolayer(Model_Drift$mean, series="Drift") +
  ggtitle("Forecasts for daily Google Wikepedia Page") +
  xlab("Days") + ylab("Google traffic")

#Actually here the naive and drift and naive are overlapping which implies there hasn't been much
#of a change

#Out of sample metrics-test
accuracy(Model_Mean,novela_test)
accuracy(Model_Naive,diff(novela_test))
accuracy(Model_SNaive,diff(novela_test))
accuracy(Model_Drift,diff(novela_test))

#no clue why the rmse is decreasing for test

#Building an ARIMA model
auto.arima(novela_train,seasonal = TRUE,lambda = 'auto')
m1<-Arima(novela_train,lambda = 'auto',order=c(2,1,3),include.drift = TRUE)
checkresiduals(m1)
forecast(m1,h=428)


autoplot(forecast(m1,h=428))

#checking the forecast
accuracy(forecast(m1,h=428),novela_test)

#better than the mean model
