setwd("/Users/yul/Google 드라이브/USC/2018 Fall/ISE529 Data Analytics/R")
d1=read.csv("7.1 task.csv",header = T)
names(d1) = c("x","y")
head(d1)
plot(y~x,d1,pch=19,xlab="experience",ylab = "success")
table(d1$y)

# fit a simple logistics regression
m1 = glm(y~x,binomial,d1)
yhat = m1$fitted.values
yhat = predict(m1,type="response") # same result as before
yhat
res = m1$residuals # Do not use m1$residuals since it is different to the following result.
res2 = resid(m1 ,type="response")
d2 = data.frame(d1,yhat,res2)
head(d2)

# interpret b1
coef(m1)
# odds increase by exp(0.1614859) = 1.175
exp(coef(m1)[2])
# odds increase by 17.5% with each additional month of experience
# odds of successfully completing the task.
# CIs for betas
confint(m1,level=0.9)
# CI for odds ratio
exp(confint(m1,level=0.95))
# odds increases between 5% and 36.9% with each month of additional experience.

# predict probability of success of a programmer with 22 months experience
newval = data.frame(x=22)
newval
predict(m1,newval,type="response")

# plot
head(d1)
range(d1$x)
summary(d1$x)
xx = seq(4,32,len=200)
head(xx)
newval = data.frame(x=xx) # the same header of x
head(newval)
yy = predict(m1,newval, type="response") # y-coordinates of the logistic curve
lines(xx,yy) # the Logistic curve, when curve is steep -> it is a good model.
text(y~x,d1,labels=rownames(d1),pos=1,offset=0.25,cex=0.4)
head(d1)

# LOESS fit (dash curve on the plot) : non parametric quadratic model
m2 = loess(y~x,d1,span = 1)
y1 = predict(m2, newval)
head(y1)
lines(xx,y1,lty=2,col="red") # when we see the plot both agrees -> the model is acceptable
grid()

# error rate
# if predicted probabilities > 0.5, then predict Y = 1
head(yhat)
n = length(yhat)
ypred = rep("0",n)
ypred[yhat>0.5]="1"
table(ypred,d1$y) # row is predicted value and column is actual value.
table(ypred,d1$y)/n # proportion
d3 = data.frame(d1,ypred)
head(d3)
# prediction errors in the following rows
d4 = d3[d3$y!=ypred,]
d4
points(y~x,d4,col="red",cex=0.4)

# validation approach - 70% train set
set.seed(1)
train = sample(1:n,0.7*n)
length(train)
dtrain = d1[train,]
dtest = d1[-train,]

m3 = glm(y~x,binomial,dtrain) # the dataset shd be on the last argument or family=binomial
fitdtest = predict(m3,dtest,type="response")
n = nrow(dtest)n
ypred = rep("0",n)
ypred[fitdtest>0.5]="1"
table(ypred,dtest$y)
# You can see that one obs is misclassified from the test set