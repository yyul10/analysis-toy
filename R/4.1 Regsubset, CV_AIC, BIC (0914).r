> library("MASS", lib.loc="/Library/Frameworks/R.framework/Versions/3.5/Resources/library") #dataset, stepAIC()
> library(leaps) #regsubsets()
> d0=Cars93
> 
> d1=subset(d0, select = c(MPG.city,Cylinders,EngineSize,Horsepower,RPM,Passengers,Weight))
> d1$Cylinders = as.numeric(d1$Cylinders)
> 
> # best sets of predictors
> models = regsubsets(MPG.city~.,d1)
> summary(models)
Subset selection object
Call: regsubsets.formula(MPG.city ~ ., d1)
6 Variables  (and intercept)
           Forced in Forced out
Cylinders      FALSE      FALSE
EngineSize     FALSE      FALSE
Horsepower     FALSE      FALSE
RPM            FALSE      FALSE
Passengers     FALSE      FALSE
Weight         FALSE      FALSE
1 subsets of each size up to 6
Selection Algorithm: exhaustive
         Cylinders EngineSize Horsepower RPM Passengers Weight
1  ( 1 ) " "       " "        " "        " " " "        "*"   
2  ( 1 ) "*"       " "        " "        " " " "        "*"   
3  ( 1 ) "*"       "*"        " "        " " " "        "*"   
4  ( 1 ) " "       "*"        "*"        "*" " "        "*"   
5  ( 1 ) "*"       "*"        "*"        "*" " "        "*"   
6  ( 1 ) "*"       "*"        "*"        "*" "*"        "*"   
> # best predictor is Weight, worst predictor is Passengers
> 
> summary(models)$adjr2
[1] 0.7077055 0.7133132 0.7123930 0.7166129 0.7157038 0.7126693
> a = summary(models)$adjr2
> which.max(a)
[1] 4
> # best model is in row4
> # best model with EngineSize, Horsepower, RPM and Weight
> 
> m0 = lm(MPG.city~EngineSize+Horsepower+RPM+Weight,d1)
> 
> newval = data.frame(Cylinders = 4, EngineSize = 2.3, Horsepower = 200, RPM = 5500, Passengers = 4, Weight = 2950)

> predict(m0,newval)
       1 
21.06858 

> # function predict.regsubsets()
> predict.regsubsets = function(object, newdata, id, ...)
{
    form <- as.formula(object$call[[2]])
    mat <- model.matrix(form, newdata)
    coefi = coef(object, id = id)
    xvars <- names(coefi)
    mat[, xvars]%*%coefi
}
> 
> summary(models)
Subset selection object
Call: regsubsets.formula(MPG.city ~ ., d1)
6 Variables  (and intercept)
           Forced in Forced out
Cylinders      FALSE      FALSE
EngineSize     FALSE      FALSE
Horsepower     FALSE      FALSE
RPM            FALSE      FALSE
Passengers     FALSE      FALSE
Weight         FALSE      FALSE
1 subsets of each size up to 6
Selection Algorithm: exhaustive
         Cylinders EngineSize Horsepower RPM Passengers Weight
1  ( 1 ) " "       " "        " "        " " " "        "*"   
2  ( 1 ) "*"       " "        " "        " " " "        "*"   
3  ( 1 ) "*"       "*"        " "        " " " "        "*"   
4  ( 1 ) " "       "*"        "*"        "*" " "        "*"   
5  ( 1 ) "*"       "*"        "*"        "*" " "        "*"   
6  ( 1 ) "*"       "*"        "*"        "*" "*"        "*"   
> predict.regsubsets(models,newval,id=4)
 Show Traceback
 
 Rerun with Debug
 Error in eval(predvars, data, env) : object 'MPG.city' not found 
> newval
  Cylinders EngineSize Horsepower  RPM Passengers Weight
1         4        2.3        200 5500          4   2950
> # add MPG.city
> newval = data.frame(Cylinders = 4, EngineSize = 2.3, Horsepower = 200, RPM = 5500, Passengers = 4, Weight = 2950,MPG.city=100)
> newval
  Cylinders EngineSize Horsepower  RPM Passengers Weight MPG.city
1         4        2.3        200 5500          4   2950      100
> predict.regsubsets(models,newval,id=4)
         [,1]
[1,] 21.06858
> newval = data.frame(Cylinders = 4, EngineSize = 2.3, Horsepower = 200, RPM = 5500, Passengers = 4, Weight = 2950,MPG.city=10000)
> predict.regsubsets(models,newval,id=4)
         [,1]
[1,] 21.06858
> 
> # Validation Approach (training and test sets)
> set.seed(12)
> 
> dim(d1)
[1] 93  7
> 
> n = nrow(d1)
> train=sample(1:n,47)
> # these are the train row numbers.
> 
> d1train=d1[train,]
> d1test=d1[-train,]
> dim(d1train)
[1] 47  7
> dim(d1test)
[1] 46  7
> # full model
> m1=lm(MPG.city~.,d1train)
> yhat1 = predict(m1,d1test)
> #mspe
> 
> y=d1test$MPG.city

> head(yhat1)
       4        6        8       11       12       14 
19.19513 24.03127 16.50532 15.34018 26.24144 20.13774 
> head(y)
[1] 19 22 16 16 25 19
> #mspe
> 
> mean((y-yhat1)^2)
[1] 9.736857
> 
> # Best adjR2 model
> m2 = lm(MPG.city~EngineSize+Horsepower+RPM+Weight,d1train)

> mean((y-yhat2)^2)
[1] 9.389211

> # regsubsets validation approach. p.249
> 
> models = regsubsets(MPG.city~.,d1train)
> yhat2 = predict(m2,d1test)

> mspe = rep(0,6)
> for (i in 1:6)
+ {
+     yhat = predict.regsubsets(models,d1test,id=i) # id is number of variables.
+     mspe[i]=mean((y-yhat)^2)
+ }
> mspe
[1] 9.122425 9.122425 9.122425 9.122425 9.122425 9.122425

#AIC 
> step1 = stepAIC(m1)
Start:  AIC=108.92
MPG.city ~ Cylinders + EngineSize + Horsepower + RPM + Passengers + 
    Weight

             Df Sum of Sq    RSS    AIC
- Passengers  1     3.536 357.70 107.39
- Cylinders   1    12.869 367.03 108.60
<none>                    354.16 108.92
- EngineSize  1    18.159 372.32 109.27
- Horsepower  1    19.163 373.33 109.40
- RPM         1    24.266 378.43 110.04
- Weight      1    34.570 388.73 111.30

Step:  AIC=107.39
MPG.city ~ Cylinders + EngineSize + Horsepower + RPM + Weight

             Df Sum of Sq    RSS    AIC
- Cylinders   1    14.306 372.01 107.23
<none>                    357.70 107.39
- EngineSize  1    16.054 373.75 107.45
- Horsepower  1    17.509 375.21 107.64
- RPM         1    21.480 379.18 108.13
- Weight      1   139.888 497.59 120.90

Step:  AIC=107.23
MPG.city ~ EngineSize + Horsepower + RPM + Weight

             Df Sum of Sq    RSS    AIC
- EngineSize  1    15.475 387.48 107.15
<none>                    372.01 107.23
- RPM         1    33.953 405.96 109.34
- Horsepower  1    52.039 424.04 111.39
- Weight      1   144.600 516.61 120.67

Step:  AIC=107.15
MPG.city ~ Horsepower + RPM + Weight

             Df Sum of Sq    RSS    AIC
<none>                    387.48 107.15
- RPM         1    18.587 406.07 107.35
- Horsepower  1    39.047 426.53 109.66
- Weight      1   131.519 519.00 118.88

> # BIC는 참고
>
> step2 = stepAIC(m32,k=log(nrow(dtrain31)))
Start:  AIC=121.87
MPG.city ~ Cylinders + EngineSize + Horsepower + RPM + Passengers + 
    Weight

             Df Sum of Sq    RSS    AIC
- Passengers  1     3.536 357.70 118.49
- Cylinders   1    12.869 367.03 119.70
- EngineSize  1    18.159 372.32 120.37
- Horsepower  1    19.163 373.33 120.50
- RPM         1    24.266 378.43 121.14
<none>                    354.16 121.87
- Weight      1    34.570 388.73 122.40

Step:  AIC=118.49
MPG.city ~ Cylinders + EngineSize + Horsepower + RPM + Weight

             Df Sum of Sq    RSS    AIC
- Cylinders   1    14.306 372.01 116.48
- EngineSize  1    16.054 373.75 116.70
- Horsepower  1    17.509 375.21 116.89
- RPM         1    21.480 379.18 117.38
<none>                    357.70 118.49
- Weight      1   139.888 497.59 130.15

Step:  AIC=116.48
MPG.city ~ EngineSize + Horsepower + RPM + Weight

             Df Sum of Sq    RSS    AIC
- EngineSize  1    15.475 387.48 114.55
<none>                    372.01 116.48
- RPM         1    33.953 405.96 116.74
- Horsepower  1    52.039 424.04 118.79
- Weight      1   144.600 516.61 128.07

Step:  AIC=114.55
MPG.city ~ Horsepower + RPM + Weight

             Df Sum of Sq    RSS    AIC
- RPM         1    18.587 406.07 112.90
<none>                    387.48 114.55
- Horsepower  1    39.047 426.53 115.21
- Weight      1   131.519 519.00 124.43

Step:  AIC=112.9
MPG.city ~ Horsepower + Weight

             Df Sum of Sq    RSS    AIC
- Horsepower  1     21.48 427.54 111.47
<none>                    406.07 112.90
- Weight      1    319.99 726.05 136.36

Step:  AIC=111.47
MPG.city ~ Weight

         Df Sum of Sq     RSS    AIC
<none>                 427.54 111.47
- Weight  1    752.07 1179.62 155.32
> m33 = lm(MPG.city~Weight,dtrain31)
> yhat33 = predict(m33, dtest31)
> mean((dtest31$MPG.city-yhat33)^2)
[1] 9.122425
> yhat32 = predict(m32,dtest31)
> mean((dtest31$MPG.city-yhat32)^2)
[1] 9.736857
> # BIC is better

