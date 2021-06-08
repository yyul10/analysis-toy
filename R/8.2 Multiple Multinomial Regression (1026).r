library(car)
set.seed(101)
head(Womenlf)
str(Womenlf)
library(nnet)
d0 = Womenlf
levels(d0$partic)
d0$partic = factor(d0$partic,levels = c("not.work","parttime","fulltime"))
d0 = d0[,-4]
m1 = multinom(partic~.,d0)
summary(m1)

summary(d0)

Predictors = expand.grid(hincome=1:45,children=c("absent","present")) # to create table
summary(Predictors)
head(Predictors)
tail(Predictors)
p.fit = predict(m1,newdata=Predictors,type="probs")
d1 = data.frame(Predictors,p.fit)
head(d0) # 3 columns for the response (actual data)
head(d1) # 5 columns with the probabilities

# plots
par(mfrow=c(1,2)) # parameter
xaxis = 1:45
plot(xaxis,d1[1:45,3],type="l",ylim=c(0,1),xlab="Husband Income",ylab="fitted probability",main="Children Absent") 
# first 45 rows = absent => not.work
lines(xaxis,d1[1:45,4],lty=2) # part-time
lines(xaxis,d1[1:45,5],lty=3) # full-time
grid()
legend("topright",lty=1:3,cex=0.2,legend=c("not working","part time","full time"))

plot(xaxis,d1[46:90,3],type="l",ylim=c(0,1),xlab="Husband Income",ylab="fitted probability",main="Children Present") 
# last 45 rows = present => not.work
lines(xaxis,d1[46:90,4],lty=2) # part-time
lines(xaxis,d1[46:90,5],lty=3) # full-time
grid()

Anova(m1) # library(car)

# nnet의 서머리는 p값을 출력해주지 않기 때문에
summary(m1,Wald=T)


-----Wheat 예제

wheat=read.csv("8.2 Wheat.csv",header = T)
str(wheat)
levels(wheat$type)

# Multinomial Regression Model
library(nnet)
m1 = multinom(type~.,wheat)
summary(m1)

# fitted equations
# log(pi-scab/pi-healthy) = 30.54650 -0.6481277 class -21.59715 density -0.01590741 hardness + 1.0691139 size -0.2896482 weight + 0.10956505 moisture
# log(pi-sprout/pi-healthy) = 19.16857 -0.2247384 class -15.11667 density -0.02102047 hardness + 0.8756135 size -0.0473169 weight -0.04299695 moisture

# test for predictors 

summary(m1)
sumfit = summary(m1)
teststat = sumfit$coefficients/sumfit$standard.errors
pvalue = 2*(1-pnorm(q = abs(teststat)))
teststat
pvalue
round(pvalue,3)
# There is no evidence that wheat class, size, and moisture have different effects on kernel condition
# There is evidence that hardness has some effect on kernel Sprout only
# There is evidence that weight has some effect on kernel Scab only

# Instead of calculating p-value with hand, we can use library(car) -> Anova()
# Effects across all kernel conditions
library(Car)
Anova(m1)
# density, hardness and weight have some effect on wheat kernel condition

# CIs on betas
confbeta = confint(m1)
confbeta

# predict probabilities 
pihat = predict(m1, newdata = wheat,type="probs")
dim(pihat)
head(pihat)

# Odds ratios for a c=1 unit stdev increase in each predictor
summary(wheat)
sdwheat = apply(wheat[,-c(1,7)],2,sd)
sdwheat

betahat2 = coefficients(m1)[1,2:7]
betahat2
betahat3 = coefficients(m1)[2,2:7]
betahat3
# add sd for class
cvalue = c(class=1,sdwheat)

# Odds ratios (Scab vs healthy)
exp(cvalue*betahat2)
1/exp(cvalue*betahat2)

# Odds change by 0.059 for a 0.13 increase in density, holding other vars constant
# Odds change by 17.04 for a 0.13 decrease in density, holding other vars constant
# Odds change by 9.90 for a 7.92 decrease in weight, holding other vars constant

# Odds ratio (Sprout vs healthy)
exp(cvalue*betahat3)
1/exp(cvalue*betahat3)
# Odds change by 7.28 for a 0.13 decrease in density, ...
# Odds change by 1.45 for a 7.92 decrease in weight, ...

# Multinomial model with density only
m2 = multinom(type~density,wheat)
summary(m2)

# predict probabilities
pihat = predict(m2,newval=wheat,type="probs")
head(pihat)
betahat = coef(m2)

b11 = betahat[1,1]
b12 = betahat[1,2]
b21 = betahat[2,1]
b22 = betahat[2,2]


# plot
colors=c("black","red","blue")
labels=c("Healthy","Sprout","Scab")

f1 = function(x){1/(1+exp(b11+b12*x)+exp(b21+b22*x))}
curve(f1,0.7,1.7,ylab="")
grid()

f2 = function(x){exp(b11+b12*x)/(1+exp(b11+b12*x)+exp(b21+b22*x))}
curve(f2,0.7,1.7,ylab="",col="red",add=T)

f3 = function(x){exp(b21+b22*x)/(1+exp(b11+b12*x)+exp(b21+b22*x))}
curve(f3,0.7,1.7,ylab="",col="blue",add=T)

legend(1.5,0.8,legend=labels,col=colors,lwd=c(2,2,2))

# 추가

# error rate
aux = prop.table(table())
1-sum(diag(sum))

# model with 2 continuous predictors
# predict probabilities
pi.hat = predict(m3,newdata=wheat,type="probs")
head(pi.hat)

# predict types
pi.hat = data.frame(pi.hat)
aux = apply(pi.hat,1,which.max)
names(pi.hat)

aux2 = names(pi.hat)[aux]
head(aux2)

yhat = aux2
class(yhat)

ypred = as.numeric(as.factor(yhat))
head(ypred)

# plot observe types
colors = c("black","green","red")
labels = c("Healthy","Sprout","Scab")
linewidth = rep(2,3)
plot(density~weight,wheat,col=d3$y,pch=19)

# 2-in-1 plot
par(mfrow=c(1,2))
plot(density~weight,wheat,col=d3$y,pch=19,main="observed")
gird()
plot(density~weight,wheat,col=ypred,pch=19,main="predicted",ylab="")
legend("topright",legend=labels,bty="n",text.col = colors,cex = 0.7)
grid()

# plot observed
plot(density~weight,wheat,col=d3$y,pch=19)
legend("topright",legend=labels,text.col = colors,lwd=lindwidth)
grid()

# prediction
points(density~weight,wheat,col=ypred,pch=21,cex=1.5) # empty circle

# => kNN is better classifier

