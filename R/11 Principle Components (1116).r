d0 = read.table("/Users/yul/Google 드라이브/USC/2018 Fall/ISE529 Data Analytics/R/11. 10largest.txt")
head(d0)
names(d0) = c("sales","profit","assets")
d1 = d0[,c(1,2)]
pr1 = prcomp(d1)
names(pr1)

pr1$center # column mean value
# rotation matrix = eigenvector matrix
pr1$rotation 
# eigenvalues
pr1$sdev^2
eigen(var(d1))

d1x = pr1$x
d1x
round(var(d1x),4) # the covariance between PC1 and PC2 are 0

pr3 = prcomp(d1,scale=T)
d3x = pr3$x
d3x
round(var(d3x),4)
sum(diag(var(d3x))) # when scaled, equal to the number of variables

#========PC vs LS=============

mx = 70; sdx = 3 ; my = 162 ; sdy = 14; rho = -0.80
# find the covariance x and y
cova = rho*sdx*sdy
# create covariance matrix
aux = c(sdx^2,cova,cova,sdy^2)
sigma = matrix(aux,nrow=2)
sigma
cov2cor(sigma) # in r, covariance to correlation

library(MASS)
# generate bivariate normal obs
set.seed(5)
n=250
mu = c(mx,my)
d0 = mvrnorm(n,mu,sigma)
class(d0)
d0 = data.frame(d0)
head(d0)
x = d0$X1; y = d0$X2

# find the least squares line
plot(y~x,pch=19,cex=0.6, xlim=c(20,120),ylim=c(110,210)); grid()
m1 = lm(y~x); abline(m1) # OLS (vertical OLS) - maybe not right

# Principal Components
pc1 = prcomp(d0)
d1=pc1$x
rot = pc1$rotation
rot

# 1st PC axis, largest variance
pc1$sdev^2
slope1 = rot[2,1]/rot[1,1] # not on exam, explaining
int1 = my - mx*slope1

# 2nd PC axis, largest variance
slope2 = rot[2,2]/rot[1,2] # not on exam, explaining
int2 = my - mx*slope2

# plot PC1 axis : Orthogonal least squares
abline(int1,slope1,col="red",lty=2,lwd=2)

# =================

d1 = USArrests
dim(d1)
head(d1)

# compare eigenvalue and variances
summary(d1)
# covariance matrix
var(d1)
sum(diag(var(d1))) # total variance 

eigen(var(d1))
sum(eigen(var(d1))$values)
# sum of eigenvalues of cov matrix = sum variance of data set

# find principal components scaling the data
m1 = prcomp(d1,scale = T)
m1$center
m1$scale
# eigenvector = loading vectors in the rotation matrix
m1$rotation

# transform data on PC axis
d2 = m1$x
head(d2)
dim(d2)

# covariance matrix of transformed data
var(d2)
round(var(d2),5) # not correlated
# this is Big Lambda diagonal matrix (eigenvalues on the main diagonal)
sum(diag(var(d2))) # bc it is scaled same as the n. of variables

# eigenvectors to define the PC variables
m1$rotation
# scores are PC1, PC2, defined as follows
# PC1 = 0.536 Murder + 0.58 Assault + 0.28 UrbanPop + 0.543 Rape
# PC1 is a weighted average of crime rates
# PC2 = 0.4 Murder - 0.87 UrbanPop if you choose to ignore two terms
# PC2 is a weighted average of UrbanPop and Murder

# eigenvectros span a new p-dimensional space
# scores are the transformed variable in this space
head(d2)

# biplots
biplot(m1,scale=0,cex=0.6)
# mirror image (main diagonal line)
m1$rotation = -m1$rotation
m1$x = -m1$x
biplot(m1,scale=0,cex=0.6); grid()

# obtaining murder axis
rot = m1$rotation
slope1 = rot[1,2]/rot[1,1]
abline(0,slope1)

# interpret PCs

# states are the observations
# states with large values in PC1 have high crime rates
# PC1 weights (co1) in rotation matrix are 0.53,0.58,0.54
# California, Nevada, Florida vs North Dakota, Vermont

# states with large values in PC2 have large Urban areas
# PC2 largest weight (col 2) in rotation matrix is 0.8728
# California vs Mississippi

