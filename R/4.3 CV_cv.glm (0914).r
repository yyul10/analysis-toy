I> library(ISLR) #dataset
> library(boot) #cv.glm()
> 
> d0 = Auto
> plot(mpg~horsepower,d0)
> head(d0)
  mpg cylinders displacement horsepower weight acceleration year origin
1  18         8          307        130   3504         12.0   70      1
2  15         8          350        165   3693         11.5   70      1
3  18         8          318        150   3436         11.0   70      1
4  16         8          304        150   3433         12.0   70      1
5  17         8          302        140   3449         10.5   70      1
6  15         8          429        198   4341         10.0   70      1
                       name
1 chevrolet chevelle malibu
2         buick skylark 320
3        plymouth satellite
4             amc rebel sst
5               ford torino
6          ford galaxie 500
> 
> # validation approach
> sample(1:10,size=6)
[1]  9  1  8 10  5  3
> set.seed(1)
> sample(1:10,size=6)
[1] 3 4 5 7 2 8
> dim(d0)
[1] 392   9
> train = sample(1:392,196)
> m1 = lm(mpg~horsepower,d0,subset=train)
> mpg = d0$mpg
> res1=(mpg-predict(m1,d0))[-train]^2
> head(res1)
          1           2           3           4           5           6 
 1.05799880  4.11818337  5.91987204  0.18755717  0.08865863 59.92440140 
> mspe1 = mean(res1)
> mspe1
[1] 23.90854
> 
> #nonlinear
> m2 = lm(mpg~poly(horsepower,2),d0,subset=train)
> res2 = (mpg-predict(m2,d0))[-train]^2
> mspe2 = mean(res2)
> mspe2
[1] 17.6236
> #better than linear
> m3 = lm(mpg~poly(horsepower,3),d0,subset=train)
> res3 = (mpg-predict(m3,d0))[-train]^2
> mspe3=mean(res3)
> mspe3
[1] 17.65324
> #worse than 2-poly
> ##LOOCV with cv.glm()
> 
> 
> m1 = lm(mpg~horsepower,d0)
> coef(m1)
(Intercept)  horsepower 
 39.9358610  -0.1578447 
> glm1 = glm(mpg~horsepower,data = d0) # need to write 'data'
> glm1

Call:  glm(formula = mpg ~ horsepower, data = d0)

Coefficients:
(Intercept)   horsepower  
    39.9359      -0.1578  

Degrees of Freedom: 391 Total (i.e. Null);  390 Residual
Null Deviance:	    23820 
Residual Deviance: 9386 	AIC: 2363
> coef(glm1)
(Intercept)  horsepower 
 39.9358610  -0.1578447 
> # glm is general version, poisson, logistic regression
> # MSPE from glm1
> mspe1 = cv.glm(d0,glm1)
> summary(mspe1)
      Length Class  Mode   
call    3    -none- call   
K       1    -none- numeric
delta   2    -none- numeric
seed  626    -none- numeric
> mspe1$delta
[1] 24.23151 24.23114
> # this is CV1
> # two -> bias correction
> 
> # MSPE for polynomial model
> mspe1 = rep(0,6)
> mspe1
[1] 0 0 0 0 0 0
> for(i in 1:6)
+ {
+     models = glm(mpg~poly(horsepower,i),data=d0)
+     mspe1[i] = cv.glm(d0,models)$delta[1]
+ }
> 
> mspe1
[1] 24.23151 19.24821 19.33498 19.42443 19.03321 18.97864
> plot(mspe1,type="l")