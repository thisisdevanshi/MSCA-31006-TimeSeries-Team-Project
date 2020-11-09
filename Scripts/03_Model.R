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

#importing the data and considering just one page
train_1 <- read.csv("~/Desktop/UChicago/Quarters/03-Quarters/Data/TS/web-traffic-time-series-forecasting/train_1.csv", header = TRUE, row.names = 1,sep = ",",nrows = 9290,skip =0)
#Tech <- data.frame(train_1[c("Google_zh.wikipedia.org_all-access_spider","Apple_II_zh.wikipedia.org_all-access_spider","Facebook_zh.wikipedia.org_all-access_spider","YouTube_zh.wikipedia.org_all-access_spider","Android_zh.wikipedia.org_all-access_spider"),])
Google <- data.matrix(train_1[c("Google_zh.wikipedia.org_all-access_spider"),])
View(Google)

#the data is from 2015 July 01 to 2015 August 19

#dropping the colnames and creating a time series object
dimnames(Google)<-NULL
Google<-array(Google)
head(Google)
length(Google)

#finding outliers - Using hampels test
minMaxThreshold <- 3 * c(-1, 1) * 1.48 * mad(Google, na.rm = TRUE) + median(Google, na.rm = TRUE)  
cat("The minimum values is",minMaxThreshold[1],"and the maximum value is",minMaxThreshold[2])


#making the values NA which are beyond the threshold
Google[Google<minMaxThreshold[1]]<-NA
Google[Google>minMaxThreshold[2]]<-NA

#creating a time series object
Google_ts<-ts(Google,frequency = 365,start = c(2015, 7, 1))
Google_ts

autoplot(Google_ts,ylab="Google daily traffic",xlab="Day")


#missing value treatment
if(anyNA(Google_ts)){
  Google_ts <- na.interp(Google_ts)
}

autoplot(Google_ts,ylab="Google daily traffic",xlab="Day")

#splitting data into test and train
Google_train<-window(Google_ts,start=c(2015,7),end=c(2016,181))
Google_test<-window(Google_ts,start=c(2016,182),end=c(2016,191))
tsdisplay(Google_train)
tsdisplay(Google_test)

#requirement for transformation
BoxCox.lambda(Google_train)

#no transformation required

autoplot(Google_train)
ggAcf(Google_train)
ggPacf(Google_train)


#ACF and PACF values show us that the time series isn't stationary as the trend isn't dying down
# There's is no trend, looks a little seasonal, and it doesn't look stationary i.e. the mean isn't
#constant for any set of data

#testing stationary
kpss.test(Google_train)

#Therefore, it is non stationary and we need to difference it
Google_train_diff <- diff(Google_train)
kpss.test(Google_train_diff)
tsdisplay(Google_train_diff)

#By just looking at the graph we can see that ACF is cut at 1 and PACF is expon. decreasing
#therefore it is AR=1

#forecast horizon
h<-10

#naive forecasts
Model_Mean <- meanf(Google_train_diff, h) 
Model_Naive <- naive(Google_train_diff, h) 
Model_SNaive <- snaive(Google_train_diff,h)
Model_Drift <- rwf(Google_train_diff, h, drift=TRUE)

#Naive forecast
autoplot(diff(Google_train_diff)) +
  autolayer(Model_SNaive$mean, series="Seasonal naïve") +
  autolayer(Model_Mean$mean, series="Mean") +
  autolayer(Model_Naive$mean, series="Naïve") +
  autolayer(Model_Drift$mean, series="Drift") +
  ggtitle("Forecasts for daily Google Wikepedia Page") +
  xlab("Days") + ylab("Google traffic")

#Actually here the naive and drift and naive are overlapping which implies there hasn't been much
#of a change



#Out of sample metrics-test
accuracy(Model_Mean,diff(Google_test))
accuracy(Model_Naive,diff(Google_test))
accuracy(Model_SNaive,diff(Google_test))
accuracy(Model_Drift,diff(Google_test))

#no clue why the rmse is decreasing for test

#Building an ARIMA model
auto.arima(Google_train,seasonal = TRUE,lambda = 'auto')
m1<-Arima(Google_train,lambda = 'auto',order=c(0,1,2))
forecast(m1,h=10)


autoplot(forecast(m1,h=10))

#checking the forecast
accuracy(forecast(m1,h=10),diff(Google_test))

