#Loading required R libraries 
library(quantmod)
library(plyr)
library(dplyr)
library(data.table)
library(DMwR)
library(mice)
defaultW <- getOption("warn") 
options(warn = -1) 

#Load dataset using Quantmod
stocklist <- c("DJI","DPZ","GOOG","IBM","AMZN","AMD","GM","F","GE","BA")
getSymbols(stocklist, from='2020-03-01',to='2020-06-01')
# To assign it from yahoo instead of Google
#getSymbols(stocklist,src="yahoo", auto.assign=FALSE, from='2020-03-01',to='2020-06-01')
options("getSymbols.warning4.0"=FALSE)

#Merge the stock Details to form a portfolio
dji<-as.data.table(Ad(DJI))
dpz<-as.data.table(Ad(DPZ))
goog<-as.data.table(Ad(GOOG))
ibm<-as.data.table(Ad(IBM))
amzn<-as.data.table(Ad(AMZN))
amd<-as.data.table(Ad(AMD))
gm<-as.data.table(Ad(GM))
f<-as.data.table(Ad(F))
ge<-as.data.table(Ad(GE))
ba<-as.data.table(Ad(BA))
portfolio<-join_all(list(dji,dpz,goog,ibm,amzn,amd,gm,f,ge,ba), by='index', type='left')
colnames(portfolio)<-c("Date","DJI","DPZ","GOOG","IBM","AMZN","AMD","GM","F","GE","BA")
portfolio<-na.omit(portfolio)
head(portfolio)
tail(portfolio)


df <- subset(portfolio, select = -Date )
#To set Percentage Missingness for Patterns
myfreq <- c(0.05,0.05, 0.075, 0.075, 0.1,0.1, 0.125,0.125,0.15,0.15)
amputedf<-ampute(df,prop=0.5,freq=myfreq,mech="MAR")


#check Pattern
amputedf$pattern

#Check Weight
amputedf$weights

#Check Frequency
amputedf$freq

#Display Amputed Dataset
head(amputedf$amp)

knnImpute<-knnImputation(amputedf$amp, scale=T,k =3, meth = 'median')
#Add the date back again
knnImpute$Date<-portfolio$Date
#Re-Order Date as the first column
knnImpute<- knnImpute %>% select(Date,DJI,DPZ,GOOG,IBM,AMZN,AMD,GM,F,GE,BA)
head(knnImpute)

#Write results to CSV
write.table(knnImpute, file = "Impute.csv")


#Read Covid Data
dfcovid <- read.csv(file = 'data/Covid19_6June/covid_19_data.csv', header = TRUE)
dfcovid <- subset(dfcovid, select =c(Date,Confirmed,Deaths,Recovered))
dfcovid <- dfcovid %>% group_by(Date) %>% summarise_all(sum)
dfcovid$Date<-as.Date(dfcovid$Date)
dfcovid <- subset(dfcovid, Date >= as.Date("2020-03-01") & Date<= as.Date("2020-06-01"))
head(dfcovid)

#Merge Dataset of covid and Portfolio
dfcovidportfolio<-merge(knnImpute,dfcovid, by = c("Date"))
head(dfcovidportfolio)
tail(dfcovidportfolio)
