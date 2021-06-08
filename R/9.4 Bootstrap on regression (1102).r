
library(ISLR)
library(boot)

m1 = lm(mpg~horsepower,Auto)
coef(m1)

# function estimate b0 and b1
bfunction1 = function(data,index) coef(lm(mpg~horsepower,data=data, subset=index))


# index is the set of rows to be used to fit the model

# fit a model with all rows
bfunction1(Auto,1:392) # the same result

# bootstrap for the regression coefficients
set.seed(1)
boot(Auto,bfunction1,1000)

# Compare to the full model
m2 = lm(mpg~horsepower,data=Auto)
summary(m2)
confint(m2) # 다른 std err가 정의되어있지 않은 방법론은 bootstrap에 의존해야함.

b2 = boot(Auto,bfunction1,1000)
boot.ci(b2,type="basic",index=1) # intercept
boot.ci(b2,type="basic",index=2) # 1st slope
boot.ci(b2,type="basic") # only the intercept

# bootstrap predictions
newdata = data.frame(horsepower=140)
bfunction2 = function(data,index) 
{mod = lm(mpg~horsepower,data=data, subset=index) 
predict(mod,newdata)}

bfunction2(Auto,1:392)

set.seed(1)
boot(Auto,bfunction2,1000)

b1 = boot(Auto,bfunction2,1000)
boot.ci(b1,type="basic")

predict(m2,newdata,interval = "conf")
# Not much difference