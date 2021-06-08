setwd("/Users/yul/Google 드라이브/USC/2018 Fall/ISE529 Data Analytics/R")
d1 = read.csv("12.1 segment.csv",header = T)
head(d1)
tail(d1)
summary(d1)

# k-means requires numeric predictors
# convert 2-level factors to binary variables
d2 = d1
d2$gender = ifelse(d2$gender=="Male",0,1)
d2$ownHome = ifelse(d2$ownHome=="ownNo",0,1)
d2$subscribe = ifelse(d2$subscribe=="subNo",0,1)
# 0 for base levels

str(d2)
summary(d2)

# -------K-MEANS-------
# create 4 groups
set.seed(96743)
m1 = kmeans(d2,centers = 4)
m1
# Clustering vector is m1$cluster
m1$cluster
head(m1$cluster)
# Sum of squares are m1$totss, m1$withinss, m1$betweenss, m1$tot.withinss
m1$withinss
sum(m1$withinss)
m1$tot.withinss # the same as sum(m1$withinss)
# total variance in the dataset that is explained by the clustering
m1$betweenss/m1$totss # R-squared
# variance not explained by the clustering
m1$tot.withinss/m1$totss

# From cluster means table
# cluster 1 and 2 by age, income
# gender about the same across all clusters
# clusters 1 and 4 different number of children
# components of m1
summary(m1)
# use $ sign to extract components
table(m1$cluster)
# cluster 4 highly populated
# univariate segmentation
boxplot(d2$income~m1$cluster)
boxplot(d2$income/1000~m1$cluster, ylab="Income in 000s",xlab="Cluster")
# how good is clustering in terms of age?
boxplot(d2$age~m1$cluster) # Not good
table(m1$cluster,d2$kids)
# groups 1 and 4 different by number of kids
table(m1$cluster,d1$subscribe)
# 1,3 few subscribers (absolute terms)
prop.table(table(m1$cluster,d1$subscribe),margin = 1)
# only group 3 has few subscribers (relative terms)

table(m1$cluster,d1$gender)
# all gender balanced

table(m1$cluster,d1$ownHome)
# cluster 1 with much more owners than no-owners

library(cluster)
clusplot(d1,m1$cluster,color=T,shade=T,labels=4,lines = 0,main="K-Means",cex = 0.5)
clusplot(d2,m1$cluster,color=T,shade=T,labels=4,lines = 0,main="K-Means",cex = 0.5)

#--------Hierarchichal---------
x = matrix(1:12,nrow = 3,ncol = 4, byrow = T)
x
dist(x,diag = T) # diag=T is needed.
sqrt((9-1)^2+(10-2)^2+(11-3)^2+(12-4)^2)
a = daisy(x)
b = as.matrix(a)
b
# daisy is the same as euclidean distance
# daisy uses gower whenever non-numeric cols are 
a = daisy(x, metric = "gower")
b = as.matrix(a)
b
# columns are standardized by substracting the min val, and dividing each
# entry by the range of the column. 
# Rescaled column has the range [0,1]

fun = function (x) {max(x)-min(x)}
mini = apply(x,2,min)
rang = apply(x,2,fun)
x2 = scale(x,center = mini,scale = rang)
x2
# distance from obs 3 to obs1 is 1.0
# distance form obs2 to obs2 is 0.5

dim(d1)
# dissimilarities
d3 = daisy(d1)
length(d3) == 300*299/2
d4 = as.matrix(d3)
dim(d4)
d4[1:5,1:5]
# largest and smallest dissimilarities.
max(d4)
diag(d4)=rep(1,300)
d4[1:5,1:5]
min(d4)

# dendrogram

seg.hc = hclust(d3, method="complete") # the dataset is matrix found with daisy function
str(seg.hc)
# seg.hc is not a dendrogram
plot(seg.hc,cex=0.4,xlab="");grid()

# cut at dissimilarity h = 0.5
cut1 = cut(as.dendrogram(seg.hc),h=0.5)
str(cut1)
# upper portion
cut1up = cut1$upper
str(cut1up)
plot(cut1up);grid()

# lower portion
cut1low = cut1$lower
str(cut1low)
plot(cut1low[[1]]) # instead of using $ sign since there's no containers.
grid()
# some similarities
d1[c(101,107),]
d1[c(278,294),]
# dissimilarities
d1[c(173,141),]

# dendrogram distances
? cophenetic # It can be argued that a dendrogram is an appropriate summary of some data if the correlation between the original distances and the cophenetic distances is high. 
d5 = cophenetic(seg.hc)
length(d5)
head(d5)

# cf.daisy distances
head(d3)
cor(d5,d3)
plot(d5,d3, pch=19, cex=0.25, xlab = "dendrogram distance", ylab="daisy distance")

# cut to create K=4 groups
plot(seg.hc,cex=0.3, xlab="",main=""); grid()
cut4 = rect.hclust(seg.hc,k=4,border = "red")
str(cut4)
# each component has the row numbers of each group
# group1 has rows 1,2,3,6,7,8,11 ....
# to get a vector of group/cluster assignments 
seg.hc.segment = cutree(seg.hc,k=4)
head(seg.hc.segment)
table(seg.hc.segment)

# Cluster means
aggregate(d1,by=list(seg.hc.segment),mean)
# to avoid NAs
cmeans = function(data,groups) {aggregate(data,list(groups),function(x) mean(as.numeric(x)))}
cmeans(d1,seg.hc.segment)
levels(d1$gender)
levels(d1$subscribe)

# groups 1,2 different from 3 and 4 by subscription
# among non-subscribers, groups 1,2 different by gender
# among subsceribers, group 3,4 different by ownership

clusplot(d1,seg.hc.segment,color=T,shade = T,labels = 4,lines = 0, main="",cex=0.5,xlim=c(-4,4))
