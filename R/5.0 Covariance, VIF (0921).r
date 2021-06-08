> library(MASS)
> d0 = Cars93
> d1 = subset(d0, select = c(MPG.city,Cylinders,Horsepower,RPM,Passengers,Width))
> str(d1)
'data.frame':	93 obs. of  6 variables:
 $ MPG.city  : int  25 18 20 19 22 22 19 16 19 16 ...
 $ Cylinders : Factor w/ 6 levels "3","4","5","6",..: 2 4 4 4 2 2 4 4 4 5 ...
 $ Horsepower: int  140 200 172 172 208 110 170 180 170 200 ...
 $ RPM       : int  6300 5500 5500 5500 5700 5200 4800 4000 4800 4100 ...
 $ Passengers: int  5 5 5 6 4 6 6 6 5 6 ...
 $ Width     : int  68 71 67 70 69 69 74 78 73 73 ...
> d1$Cylinders = as.numeric(d1$Cylinders)
> str(d1)
'data.frame':	93 obs. of  6 variables:
 $ MPG.city  : int  25 18 20 19 22 22 19 16 19 16 ...
 $ Cylinders : num  2 4 4 4 2 2 4 4 4 5 ...
 $ Horsepower: int  140 200 172 172 208 110 170 180 170 200 ...
 $ RPM       : int  6300 5500 5500 5500 5700 5200 4800 4000 4800 4100 ...
 $ Passengers: int  5 5 5 6 4 6 6 6 5 6 ...
 $ Width     : int  68 71 67 70 69 69 74 78 73 73 ...
> cor(d1)
             MPG.city  Cylinders   Horsepower         RPM   Passengers      Width
MPG.city    1.0000000 -0.7159745 -0.672636151  0.36304513 -0.416855859 -0.7205344
Cylinders  -0.7159745  1.0000000  0.798169593 -0.32424505  0.235510420  0.7731293
Horsepower -0.6726362  0.7981696  1.000000000  0.03668821  0.009263668  0.6444134
RPM         0.3630451 -0.3242451  0.036688212  1.00000000 -0.467137627 -0.5397211
Passengers -0.4168559  0.2355104  0.009263668 -0.46713763  1.000000000  0.4899786
Width      -0.7205344  0.7731293  0.644413421 -0.53972113  0.489978637  1.0000000
> # Select Predictors
> library(leaps)
> models = regsubsets(MPG.city~.,d1)
> summary(models)
Subset selection object
Call: regsubsets.formula(MPG.city ~ ., d1)
5 Variables  (and intercept)
           Forced in Forced out
Cylinders      FALSE      FALSE
Horsepower     FALSE      FALSE
RPM            FALSE      FALSE
Passengers     FALSE      FALSE
Width          FALSE      FALSE
1 subsets of each size up to 5
Selection Algorithm: exhaustive
         Cylinders Horsepower RPM Passengers Width
1  ( 1 ) " "       " "        " " " "        "*"  
2  ( 1 ) " "       "*"        " " "*"        " "  
3  ( 1 ) " "       "*"        "*" "*"        " "  
4  ( 1 ) "*"       "*"        "*" "*"        " "  
5  ( 1 ) "*"       "*"        "*" "*"        "*"  
> summary(models)$adjr2
[1] 0.5138860 0.6126458 0.6590680 0.6576678 0.6537342
> # Build the model with Cylinders and Width
> m1 = lm(MPG.city~.,d1)
> library(car)
> vif(m1)
 Cylinders Horsepower        RPM Passengers      Width 
  4.458918   5.146875   2.426449   1.670997   5.067659 
> d3 = subset(d1,select = c(MPG.city,Cylinders,Width)) 
> cor(d3)
            MPG.city  Cylinders      Width
MPG.city   1.0000000 -0.7159745 -0.7205344
Cylinders -0.7159745  1.0000000  0.7731293
Width     -0.7205344  0.7731293  1.0000000
> # Hence drop VIF>10 