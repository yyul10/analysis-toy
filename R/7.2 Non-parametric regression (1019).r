setwd("/Users/yul/Google 드라이브/USC/2018 Fall/ISE529 Data Analytics/R")
d0 = read.table("7.2 jaws.txt",header = T)
head(d0)
par(mfrow=(c(2,2)))
plot(bone~age,d0,pch=16)

# lowess - piece-wise curve
d1 = lowess(d0$age,d0$bone)
class(d1)
d1 = data.frame(d1)
head(d1)
lines(y~x,d1,col="red") # method 1 : maybe overfitting than polynomial(?)
text(45,20,"lowess",pos=2)

# loess
m2 = loess(bone~age,d0)
xv = 0:50
head(xv)
newval = data.frame(age=xv)
yv = predict(m2, newval)

plot(bone~age,d0,pch=16) # 2nd plot
lines(xv,yv,col="red") # method 2
text(45,20,"loess",pos=2)

# gam (p294) 
library(mgcv)
attach(d0) # don't need to use header name d0$
m3 = gam(bone~s(age))   # m3 is a gam model
yv = predict(m2, newval)

plot(bone~age,d0,pch=16) # 3rd plot
lines(xv,yv,col="red")
text(45,20,"gam",pos=2)

# polynomial
m4 = lm(bone~poly(age,3,raw=T))
yv = predict(m4,newval)

plot(bone~age,d0,pch=16) # 4th plot
lines(xv,yv,col="red")
text(45,20,"polynomial",pos=2)