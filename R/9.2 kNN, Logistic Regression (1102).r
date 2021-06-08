library(ISLR)
library(class)

d0 = Caravan
dim(d0)
str(d0)

table(d0$Purchase)
prop.table(table(d0$Purchase))

# Only 6% people purchased the insurance

# Scale predictors
d1y = d0$Purchase
d1x = scale(d0[,-86]) # Scale but exclude the response
var(d1x[,1])
var(d1x[,6])

# test set is 1000 observations
test = 1:1000
test.y = d1y[test]
test.x = d1x[test,]
dim(test.x)

# train set
train.y = d1y[-test]
train.x = d1x[-test,]
dim(train.x)

# kNN
set.seed(1)
pred1 = knn(train.x,test.x,train.y,k=1)
table(pred1,test.y)
prop.table(table(pred1,test.y))

# error rate = 0.068+0.050 = 0.118
# error rate can be reduced to 0.06 by ALWAYS predicting "no"
# From which kNN predicted buying insurance, only 9 actually bought it.
# That is, an accuracy rate 9/(68+9) = 0.1168

table(test.y)
# we want accurate predictions for those 59 who bought insurance

# increase k
pred3 = knn(train.x,test.x,train.y,k=3)
table(pred3,test.y)

# The accuracy rate is 5/26 = 0.19, increased but not good

pred5 = knn(train.x,test.x,train.y,k=5)
table(pred5,test.y)
# The accuracy rate is 4/15 = 0.266, increased

# Compare with Logistic Regression (with knn)
glm1 = glm(Purchase~.,Caravan,family=binomial,subset = -test)
pi.hat = predict(glm1,Caravan[test,],type="response")
yhat = rep("No",1000)
yhat[pi.hat>0.5]="Yes"
table(yhat,test.y)
# Accuracy rate is 0

# However,
yhat = rep("No",1000)
yhat[pi.hat>0.3]="Yes"
table(yhat,test.y)
# Accurary rate is 8/(8+13) = 0.38

yhat = rep("No",1000)
yhat[pi.hat>0.25]="Yes"
table(yhat,test.y)
# Accuracy rate is 11/33 = 0.33 which is smaller

# 이와 같이 boundary는 CV로 정하는게 바람직, 이 예제에서는 바운더리를 0.3으로한 LR이 가장 효과적

