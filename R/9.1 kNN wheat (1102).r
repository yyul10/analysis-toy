install.packages("class")
setwd("/Users/yul/Google 드라이브/USC/2018 Fall/ISE529 Data Analytics/R")
# d3, y 는 전의 설정을 그대로

# knn
library(class)
wheat=read.csv("8.2 Wheat.csv",header = T)
x = wheat[,c(2,5)]
head(x)
set.seed(1)
x = scale(x)
head(x)
ypred = knn(x,x,y,3) # x is train and test set, response is y

table(ypred,y)
aux = prop.table(table(ypred,y))

# error rate
1-sum(diag(aux))

# plot
par(mfrow=c(1,2))
plot(density~weight,wheat,col=d3$y,pch=19,main="observed")
grid()
plot(density~weight,wheat,col=ypred,pch=19,main="knn predicted",ylab="")
grid()
legend("topright",legend = labels,bty="n",text.col = colors,cex=0.7)

