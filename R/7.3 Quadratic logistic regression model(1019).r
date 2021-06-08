setwd("/Users/yul/Google 드라이브/USC/2018 Fall/ISE529 Data Analytics/R")
d0 = read.csv("7.3 ipo.csv",header = T)
head(d0)
table(d0$funding)
hist(d0$fvalue) # the data has skewness
d1 = d0[,c(1,2)]
names(d1) = c("y","x")
head(d1)
d1$x = log(d1$x)
hist(d1$x) # logarithm always helps when there's a skewness

# Simple logistic regression
m1 = glm(y~x,binomial,d1)
summary(m1) 
summary(d1$x)

# plot
xx = seq(14,19.27,length=200)
plot(y~x,d1,pch=19,cex=0.5,xlab="log(face value)")
newval = data.frame(x=xx) # x is label, xx is the contents.
yy = predict(m1,newval,type="response")
lines(xx,yy)
grid()

# loess
loess1 = loess(y~x,d1)
y1 = predict(loess1,data.frame(x=xx))
lines(xx,y1,lty=2,col="red")

# second order logistic model
fit2 = glm(y~poly(x,2),binomial,d1)
summary(fit2)

newval = data.frame(x=xx,x2=xx^2)
head(newval)
yy = predict(fit2,newval,type="response")
lines(xx,yy) # agrees with the non-parametric regression, AIC smaller

str(summary()) # to find factors after $ sign
summary(fit2)$aic # 594.2652
summary(m1)$aic # 647.1321

# third order logistic model
fit3 = glm(y~poly(x,3),binomial,d1)
summary(fit3)$aic # 594.5162 : 2nd to 3rd is not a great improvements.

# K-fold Cross Validation for Logistic Regression
library(boot)
set.seed(17)
mspe = rep(0,5)
for(i in 1:5)
{
  models = glm(y~poly(x,i),binomial,d1)
  mspe[i] = cv.glm(d1,models)$delta[1]
}
mspe
which.min(mspe)

