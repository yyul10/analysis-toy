library(MASS)
library(boot) # boot(), boot.ci()

d0 = Boston
str(d0)
y = d0$medv

# Classical estimate standard error for the mean
n = nrow(d0)
mean(y)
sd(y)/sqrt(n) # sd for the estimate

aux = t.test(y,conf.level = 0.95)
aux
t.test(y,conf.level = 0.95)$conf
t.test(y,conf.level = 0.95)$conf[1:2]

# bootstrap estimate and bootstrap standard error for the mean

# b function is for bootstrap statistics
bfunction = function(data,index) mean(data[index]) # index are the rows used
bfunction(y,1:n)
bfunction(y,1:n/2)

# B = 1000 bootstrap samples of size n
set.seed(1)
aux = boot(y,bfunction,1000) 
str(aux)

# aux$t the B resampling statistics
# mean(aux$t) bootstrap estimates (not reported)
# sd(aux$t) the standard deviation of all bootstrap samples (reported)

boot(y,bfunction,1000)
# resampling statistics
head(aux$t)

# bootstap mean, sd, bias
mean(aux$t)
sd(aux$t)
mean(aux$t)-mean(y) # bias

# CI on the mean 
b1 = boot(y,bfunction,1000)
boot.ci(b1,conf = 0.95,type="basic") # type basic standard way to compute CI

# bootstrap on the median
median(y)

bfunction2 = function(data,index) median(data[index])
bfunction2(y,1:n)

set.seed(1)
boot(y,bfunction2,1000)
aux = boot(y,bfunction2,1000)
mean(aux$t) # bootstrap median
sd(aux$t) # bootstrap sd
mean(aux$t) - median(y) # bias
aux # this one is the same

# CI on the median
b2 = boot(y,bfunction2,1000)
boot.ci(b2, type="basic")

# bootstrap for 10% quantile
quantile(y,probs=c(0.1)) # =quantile(y,0.1)

bfunction3 = function(data,index) quantile(data[index],probs=c(0.1))

set.seed(1)
boot(y,bfunction3,1000)

b3 = boot(y,bfunction3,1000)
boot.ci(b3, type="basic")
