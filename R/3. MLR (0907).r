
> library(MASS)
> d0 = Cars93
> d1=subset(d0,select=c(MPG.city,Cylinders,EngineSize,Horsepower,RPM,Passengers,Weight))
> d1$Cylinders = as.numeric(d1$Cylinders)
> cor(d1)
             MPG.city  Cylinders EngineSize   Horsepower         RPM   Passengers
MPG.city    1.0000000 -0.7159745 -0.7100032 -0.672636151  0.36304513 -0.416855859
Cylinders  -0.7159745  1.0000000  0.7969007  0.798169593 -0.32424505  0.235510420
EngineSize -0.7100032  0.7969007  1.0000000  0.732119730 -0.54789781  0.372721168
Horsepower -0.6726362  0.7981696  0.7321197  1.000000000  0.03668821  0.009263668
RPM         0.3630451 -0.3242451 -0.5478978  0.036688212  1.00000000 -0.467137627
Passengers -0.4168559  0.2355104  0.3727212  0.009263668 -0.46713763  1.000000000
Weight     -0.8431385  0.7801128  0.8450753  0.738797516 -0.42793147  0.553272980
               Weight
MPG.city   -0.8431385
Cylinders   0.7801128
EngineSize  0.8450753
Horsepower  0.7387975
RPM        -0.4279315
Passengers  0.5532730
Weight      1.0000000
> #full model
> 
> m1=lm(MPG.city~.,data=d1)
> 
> coef(m1)
 (Intercept)    Cylinders   EngineSize   Horsepower          RPM   Passengers 
35.505593976 -0.450626941  1.554965579 -0.032923383  0.001825616 -0.153179626 
      Weight 
-0.006539854 
>
> # To check the regression assumptions and identify
> checking.plots(m31)
> # Expected City Mileage decreases by 0.45 for each additional Cylinder, if all other predictors are held constant.
> install.packages("leaps")
trying URL 'https://cran.rstudio.com/bin/macosx/el-capitan/contrib/3.5/leaps_3.0.tgz'
Content type 'application/x-gzip' length 101301 bytes (98 KB)
==================================================
downloaded 98 KB

tar: Failed to set default locale

The downloaded binary packages are in
	/var/folders/83/f7w6nv5x6mj0719khh9c8pb80000gn/T//Rtmps1zQrv/downloaded_packages
> library(leaps)
> ls()
[1] "d0" "d1" "m1"
> summary(m1)

Call:
lm(formula = MPG.city ~ ., data = d1)

Residuals:
    Min      1Q  Median      3Q     Max 
-5.7955 -1.6856 -0.0867  1.0913 13.6316 

Coefficients:
             Estimate Std. Error t value Pr(>|t|)    
(Intercept) 35.505594   6.923905   5.128 1.78e-06 ***
Cylinders   -0.450627   0.550976  -0.818 0.415691    
EngineSize   1.554966   0.869727   1.788 0.077318 .  
Horsepower  -0.032923   0.022027  -1.495 0.138655    
RPM          0.001826   0.001116   1.636 0.105554    
Passengers  -0.153180   0.537609  -0.285 0.776385    
Weight      -0.006540   0.001647  -3.970 0.000148 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 3.012 on 86 degrees of freedom
Multiple R-squared:  0.7314,	Adjusted R-squared:  0.7127 
F-statistic: 39.03 on 6 and 86 DF,  p-value: < 2.2e-16

> # full model explains 73.14% of City Mileage variability
> # sigma is estimated by S=3.012
> newval=data.frame(Cylinders=4,EngineSize=2,Horsepower=200,RPM=5000,Passengers=4,Weight=2950)
> newval
  Cylinders EngineSize Horsepower  RPM Passengers Weight
1         4          2        200 5000          4   2950
> predict(m1,newval,interval="conf",level=0.9)
       fit      lwr      upr
1 19.45113 16.64155 22.26071
> 
> newval=data.frame(Cylinders=4,EngineSize=2.3,Horsepower=200,RPM=5000,Passengers=4,Weight=2950)
> predict(m1,newval,interval="conf",level=0.9)
       fit      lwr      upr
1 19.91762 17.45651 22.37873
> # prediction interval on City Mileage of a new car.
> predict(m1,newval,interval="pred",level=0.95)
       fit      lwr     upr
1 19.91762 13.24534 26.5899
> 
> # Best set of predictors (USE library leaps)
> library(leaps) 
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
> # now use adjusted R^2
> summary(models)$adjr2
[1] 0.7077055 0.7133132 0.7123930 0.7166129 0.7157038 0.7126693
> a=summary(models)$adjr2
> which.max(a)
[1] 4
> #best model in in row 4
> #MSPE
> # full models
> n = nrow(d1)
> n
[1] 93
> set.seed(12)
> 
> train = sample(1:n,47)
> 
> head(train)
[1]  7 76 86 25 16  3
> dtrain = d1[train,]
> dtest = d1[-train,]
> dim(dtrain)
[1] 47  7
> 
> dim(dtest)
[1] 46  7
> # MSPE
> # Full model
> m1 = lm(MPG.city~.,dtrain)
> head(dtrain)
   MPG.city Cylinders EngineSize Horsepower  RPM Passengers Weight
7        19         4        3.8        170 4800          6   3470
76       19         4        3.4        200 5000          5   3450
86       22         2        2.2        130 5400          5   3030
25       22         2        2.5        100 4800          6   2970
16       18         4        3.8        170 4800          7   3715
3        20         4        2.8        172 5500          5   3375
> yhat1 = predict(m1,dtest)
> ytest1 = dtest$MPG.city
> mean((yhat1-ytest1)^2)
[1] 9.736857
> # best model
> d2 = subset(d1, select = c(MPG.city,EngineSize,Horsepower,RPM,Weight))
> d2train = d2[train,]
> 
> d2test = d2[-train,]
> m2 = lm(MPG.city~.,d2train)
> # test best model
> yhat2 = predict(m2,d2test)
> ytest2 = d2test$MPG.city
> mean((yhat2-ytest2)^2)
[1] 9.389211
> plot(yhat2~ytest2)
> #y=x line
> abline(0,1)
> grid()
> plot(yhat2~ytest2,pch=20,cex=0.5,ylim=c(10,50),xlim=c(10,50))
> abline(0,1,col="red")
> grid()
> # label the dot
> text(yhat2~ytest2,labels=rownames(d2test),cex=0.6,pos=1,offset=0.25)
> d0[39,]
   Manufacturer Model  Type Min.Price Price Max.Price MPG.city MPG.highway
39          Geo Metro Small       6.7   8.4        10       46          50
   AirBags DriveTrain Cylinders EngineSize Horsepower  RPM Rev.per.mile
39    None      Front         3          1         55 5700         3755
   Man.trans.avail Fuel.tank.capacity Passengers Length Wheelbase Width
39             Yes               10.6          4    151        93    63
   Turn.circle Rear.seat.room Luggage.room Weight  Origin      Make
39          34           27.5           10   1695 non-USA Geo Metro