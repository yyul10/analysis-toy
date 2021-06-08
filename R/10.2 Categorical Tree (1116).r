library(tree)
library(ISLR)

d0 = Carseats
str(d0)
n = nrow(d0)

# Create categorical response
high = ifelse(d0$Sales<=8,"No","Yes")
d1 = data.frame(high,d0)
head(d1)

# Tree with 2 predictors - full dataset
tree0 = tree(high~Price+Advertising,d1)

# Scatterplot on predictors space
plot(Advertising~Price,d1,pch=19,cex=0.6,col="red")
partition.tree(tree0,add=T,col="blue")
# The region is yhat. 

# Plot the tree
plot(tree0)
text(tree0, pch=0.75)

# Flipping the plot
plot(Price~Advertising,d1,pch=19,cex=0.6,col="red")
partition.tree(tree0,add=T,col="blue")


# Full model 
tree1 = tree(high~.-Sales,data=d1)
summary(tree1)
# misclassification
ypred = predict(tree1,d1,type="class")
table(ypred,d1$high)
# there are 13+23 misclassified observations
# error rate is 36/400 = 0.09

names(tree1)
head(tree1$frame)
dim(tree1$frame)

plot(tree1)
text(tree1,cex=0.6,pretty=0)
str(d0)

# training and test sets
set.seed(2)
train = sample(n,200)
d1.test = d1[-train,] # test set with the response
y.test = high[-train]

# training model
tree2 = tree(high~.-Sales,d1,subset=train)
summary(tree2)
# Misclassification error rate: 0.105 = 21 / 200  <- Training error rate
plot(tree2)
text(tree2,cex=0.6,pretty=0)

# test error rate
pred2 = predict(tree2,d1.test,type="class")
table(pred2,y.test)
test.rate = (27+30)/200
test.rate
# 0.285

# Cross Validation on the (mis)classification error rate
set.seed(3)
tree3 = cv.tree(tree2,FUN = prune.misclass) # to compare misclassifications
names(tree3)
tree3$size 
tree3$dev # number of misclassification
round(tree3$k,2)

# size value are number of terminal nodes
# dev is number of observation misclassified (the CV error rate)
# K is alpha = complexity parameter
# tree with 9 terminal nodes has lowest deviance (CV error rate)

# plot number of misclassification versus K
par(mfrow=c(1,2))
plot(tree3$dev~tree3$size,type="l"); grid()
plot(tree3$dev~tree3$k,type="l"); grid()
# smalles number of misclassifications with 9 terminal nodes with k=1.75

# Prune training tree to 9 terminal nodes
prune9 = prune.misclass(tree2,best = 9)
par(mfrow=c(1,1))
plot(prune9)
text(prune9,cex=0.75,pretty = 0)
title("CV optimized tree with 9 regions")

# test error rate of the pruned tree
yhat9 = predict(prune9,d1.test,type="class")
table(yhat9,y.test)
aux = prop.table(table(yhat9,y.test))
sum(diag(aux))
# accuracy rate os 77%
