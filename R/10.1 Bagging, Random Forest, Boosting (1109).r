install.packages("tree")
install.packages("randomForest")

library(MASS)
library(tree)

d0 = Boston
str(d0) 

# tree with 2 predictors, full data set (No train and test set)
tree0 = tree(medv~lstat+rm,d0)

# Scatterplot on predictor space
par(mfrow=c(2,1))
plot(lstat~rm,d0, pch=19, cex=0.6, col="red")
# regions on the predictor space
partition.tree(tree0,add=T,col="blue")
plot(tree0)
text(tree0, cex=0.75)

# inequalities at split is for the left arm
# 16950 is house price prediction for rm < 6.94 and 14.4 < lstat < 19.83

# all predictors - train set
set.seed(1)
n = nrow(d0)
train = sample(n,n/2)
n
# 253 train rows
dtrain = d0[train,]
dtest = d0[-train,]
tree1 = tree(medv~.,d0,subset = train)
summary(tree1)

# lstat, rm, dis are the best predictors
# rss is 3099
# tree with 8 terminal nodes and with 253 - 8 = 245 degrees of freedom.

plot(tree1)
text(tree1, cex=0.75)
names(tree1)
tree1$frame

# 22.67 is mean response (medv) in training set
# dev = deviance (squared distance to the mean to that region)
# <leaf> rows are terminal nodes
#        sum of deviance of terminal nodes are 3099
#        sum of deviance decreases with large number of splits
# y val of terminal nodes are the means of regions
# left most column is the order of spliting
# 1st row splits into rows 2 and 3
# second row splits into rows 4 and 5
# n is the number of observations in the node

# Pruning tree to 5 terminal nodes
p1 = prune.tree(tree1, best=5)
p1$frame
summary(p1)

# residual mean deviance 18.45, is larger than 12.65 of non-pruned tree
plot(p1)
text(p1)
# regions 
plot(rm~lstat,d0, pch=19, cex=0.6, col="red")
partition.tree(p1,add=T,col="blue")
# what if wrong order?
plot(lstat~rm,d0, pch=19, cex=0.6, col="red")
partition.tree(p1,add=T,col="blue")
# most important predictor must go on X axis -> lstat.

# Cross-Validation - the best number of terminal nodes.
cv.boston = cv.tree(tree1)
plot(cv.boston)
# size is the number of terminal regions

# test error rate
y.test = d0[-train,"medv"]
newval = d0[-train,]
yhat = predict(tree1,newval)

mspe = mean((yhat-y.test)^2)
mspe
sqrt(mspe)
# the predictions are within $5005 of the true median home price

# plot yhat vs y
plot(yhat~y.test,pch=19,cex=0.5,ylim=c(10,50))
abline(0,1)
grid()
# identify houses with large residuals
res = abs(y.test - yhat)
a = rownames(as.matrix(yhat)) # as.matrix is required
head(a)
length(a)
class(a)
text(yhat~y.test,labels=ifelse(res>10,a,""),pos=1,offset=0.25,cex=0.4)

# ========Bagging========
# all 13 predictors (mtry = p)
library(randomForest)
set.seed(1)
bag1 = randomForest(medv~., d0, subset = train, mtry=13, importance=T)
bag1
# 11.16 is train MSE
summary(bag1)

# number of times observation was 'out of bag'
table(bag1$oob.times)

head(bag1$predicted)
head(bag1$y)
head(d0[train,"medv"])

# test set performance
y.test = d0[-train, "medv"] # y values in the test set
yhat.bag = predict(bag1,newdata=d0[-train,])
# mspe
mean((yhat.bag-y.test)^2)

# almost half mspe of CV best model
# limit the number of trees to 25
set.seed(1)
bag2 = randomForest(medv~.,d0,subset = train,mtry=13,ntree=25)
yhat.bag = predict(bag2,newdata=d0[-train,])
mean((yhat.bag-y.test)^2)
# still very good performance

# =======random forest=======
# random forest(mtry<13)
set.seed(1)
forest1 = randomForest(medv~.,d0,subset = train,mtry=6,importance=T)
forest1

# test set performance 
yhat.rf = predict(forest1,newdata=d0[-train,])
mean((yhat.rf-y.test)^2)
# better than bagging

importance(forest1)
# IncMSE is the average increase in MSE when predictor is excluded from the model
# IncNodePurity  is the average increase in rss from splits using this predictor

# two best predictors are lstat and rm
varImpPlot(forest1,main="")

# =======Boosting=======
install.packages("gbm")
library(gbm)
set.seed(1)

boost1 = gbm(medv~.,d0[train,],distribution = "gaussian",n.trees = 5000, interaction.depth = 4) # usually many numbers of trees
# for categorical response, use distribution bernoulli
# we limit the depth of each boosted tree to 4 splits
# interaction depth = d

names(boost1)
boost1$shrinkage 
# lambda default value is 0.1
# importance of predictors 
summary(boost1)

# test MSPE
y.test = d0[-train,"medv"]
yhat.boost = predict(boost1,newdata = d0[-train,],n.trees=5000)
mean((yhat.boost-y.test)^2)

# Competitive with random forest mspe

# lambda = 0.2
set.seed(1)
boost2 = gbm(medv~.,d0[train,],distribution = "gaussian",n.trees = 5000, interaction.depth = 4, shrinkage = 0.2, verbose=F) # verbose : reduce the output
yhat.boost2 = predict(boost2,newdata = d0[-train,],n.trees=5000)
mean((yhat.boost2-y.test)^2)