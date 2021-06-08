> d0 = read.table("example2b.txt",header = T)
> str(d0)
'data.frame':	9 obs. of  3 variables:
 $ x1: Factor w/ 3 levels "L","M","S": 3 3 3 2 2 2 1 1 1
 $ x2: num  -0.1 2.53 4.86 0.26 2.55 4.87 0.08 2.62 5.09
 $ y : num  19.19 22.74 23.91 7.07 7.93 ...
> # 
Change to matrix 
> x = model.matrix(y~.,d0)
> x
  (Intercept) x1M x1S    x2
1           1   0   1 -0.10
2           1   0   1  2.53
3           1   0   1  4.86
4           1   1   0  0.26
5           1   1   0  2.55
6           1   1   0  4.87
7           1   0   0  0.08
8           1   0   0  2.62
9           1   0   0  5.09
attr(,"assign")
[1] 0 1 1 2
attr(,"contrasts")
attr(,"contrasts")$x1
[1] "contr.treatment"

> x = model.matrix(y~.,d0)[,-1]
> x
  x1M x1S    x2
1   0   1 -0.10
2   0   1  2.53
3   0   1  4.86
4   1   0  0.26
5   1   0  2.55
6   1   0  4.87
7   0   0  0.08
8   0   0  2.62
9   0   0  5.09
> library(ISLR)
> dim(Hitters)
[1] 322  20
> sum(is.na(Hitters$Salary))
[1] 59
> d0 = na.omit(Hitters)
> 
> dim(d0)
[1] 263  20
> n = nrow(d0)
> ls()
[1] "d0" "n"  "x" 
> x = model.matrix(Salary~.,d0[,-1])
> y = d0$Salary
> class(x)
[1] "matrix"

> x[1:6,11:19]
                  CRuns CRBI CWalks LeagueN DivisionW PutOuts Assists Errors
-Alan Ashby         321  414    375       1         1     632      43     10
-Alvin Davis        224  266    263       0         1     880      82     14
-Andre Dawson       828  838    354       1         0     200      11      3
-Andres Galarraga    48   46     33       1         0     805      40      4
-Alfredo Griffin    501  336    194       0         1     282     421     25
-Al Newman           30    9     24       1         0      76     127      7
                  NewLeagueN
-Alan Ashby                1
-Alvin Davis               0
-Andre Dawson              1
-Andres Galarraga          1
-Alfredo Griffin           0
-Al Newman                 0

> d0[1:6,11:19] # cf
                  CRuns CRBI CWalks League Division PutOuts Assists Errors Salary
-Alan Ashby         321  414    375      N        W     632      43     10  475.0
-Alvin Davis        224  266    263      A        W     880      82     14  480.0
-Andre Dawson       828  838    354      N        E     200      11      3  500.0
-Andres Galarraga    48   46     33      N        E     805      40      4   91.5
-Alfredo Griffin    501  336    194      A        W     282     421     25  750.0
-Al Newman           30    9     24      N        E      76     127      7   70.0

> # Ridge Regression
> library(glmnet)
Loading required package: Matrix
Loading required package: foreach
Loaded glmnet 2.0-16

> # lambda values from 10^10 to 10^-2
> a = seq(from = 10, to = -2, length=100)
> head(a)
[1] 10.000000  9.878788  9.757576  9.636364  9.515152  9.393939
> tail(a)
[1] -1.393939 -1.515152 -1.636364 -1.757576 -1.878788 -2.000000
> grid = 10^a
> plot(grid,ylim=c(0,20000))
> # it is not evenly distributed -> consider more on small values.
> 
> 
> # 100 ridge regression models (one for each lambda value)
> models = glmnet(x,y,alpha = 0,lambda=grid)
> summary(models)
          Length Class     Mode   
a0         100   -none-    numeric
beta      1900   dgCMatrix S4     
df         100   -none-    numeric
dim          2   -none-    numeric
lambda     100   -none-    numeric
dev.ratio  100   -none-    numeric
nulldev      1   -none-    numeric
npasses      1   -none-    numeric
jerr         1   -none-    numeric
offset       1   -none-    logical
call         5   -none-    call   
nobs         1   -none-    numeric
> models$lambda = grid
> # coef matrix
> dim(coef(models))
[1]  20 100
> # each column is a Ridge regression model. For example,
> coef(models)[,1]
  (Intercept)   (Intercept)          Hits         HmRun          Runs           RBI 
 5.359257e+02  0.000000e+00  1.974589e-07  7.956523e-07  3.339178e-07  3.527222e-07 
        Walks         Years        CAtBat         CHits        CHmRun         CRuns 
 4.151323e-07  1.697711e-06  4.673743e-09  1.720071e-08  1.297171e-07  3.450846e-08 
         CRBI        CWalks       LeagueN     DivisionW       PutOuts       Assists 
 3.561348e-08  3.767877e-08 -5.800264e-07 -7.807263e-06  2.180288e-08  3.561199e-09 
       Errors    NewLeagueN 
-1.660458e-08 -1.152288e-07 
> coef(models)[,2]
  (Intercept)   (Intercept)          Hits         HmRun          Runs           RBI 
 5.359257e+02  0.000000e+00  2.610289e-07  1.051805e-06  4.414196e-07  4.662779e-07 
        Walks         Years        CAtBat         CHits        CHmRun         CRuns 
 5.487803e-07  2.244274e-06  6.178412e-09  2.273832e-08  1.714783e-07  4.561814e-08 
         CRBI        CWalks       LeagueN     DivisionW       PutOuts       Assists 
 4.707892e-08  4.980911e-08 -7.667603e-07 -1.032074e-05  2.882212e-08  4.707696e-09 
       Errors    NewLeagueN 
-2.195028e-08 -1.523255e-07 
> 
> models$lambda[1]
[1] 1e+10
> models$lambda[2]
[1] 7564633276
> # compare reg models for two lambdas
> models$lambda[50]
[1] 11497.57
> models$lambda[60]
[1] 705.4802
> 
> options(digits=4)
> coef(models)[,50]
(Intercept) (Intercept)        Hits       HmRun        Runs         RBI       Walks 
 420.533629    0.000000    0.142162    0.535753    0.237192    0.245400    0.294765 
      Years      CAtBat       CHits      CHmRun       CRuns        CRBI      CWalks 
   1.106768    0.003146    0.011707    0.087923    0.023491    0.024240    0.025077 
    LeagueN   DivisionW     PutOuts     Assists      Errors  NewLeagueN 
   0.031810   -6.233614    0.016681    0.003067   -0.011195    0.272473 
> coef(models)[,60]
(Intercept) (Intercept)        Hits       HmRun        Runs         RBI       Walks 
   73.19639     0.00000     0.73353     1.30217     1.05007     0.93206     1.39062 
      Years      CAtBat       CHits      CHmRun       CRuns        CRBI      CWalks 
    2.52015     0.01096     0.04729     0.33787     0.09449     0.09827     0.07092 
    LeagueN   DivisionW     PutOuts     Assists      Errors  NewLeagueN 
   13.05069   -54.60597     0.12108     0.02495    -0.55778     8.59918 

> # smaller lambda, larger coefficients
> # note that lambda = 50 is not in the set of lambda values.
> predict(models,s=50,type = "coef")
20 x 1 sparse Matrix of class "dgCMatrix"
                     1
(Intercept)  2.319e+01
(Intercept)  .        
Hits         1.414e+00
HmRun       -1.260e+00
Runs         6.749e-01
RBI          4.842e-01
Walks        2.527e+00
Years       -5.879e+00
CAtBat       3.986e-03
CHits        1.043e-01
CHmRun       6.170e-01
CRuns        2.181e-01
CRBI         2.216e-01
CWalks      -1.337e-01
LeagueN      4.908e+01
DivisionW   -1.209e+02
PutOuts      2.442e-01
Assists      8.591e-02
Errors      -3.574e+00
NewLeagueN  -1.244e+01
> 
> # coef plots
> plot(models,xvar="lambda")
> grid()

> # each curve is a regression coefficients
> # xvar argument requests log lambda in the x-axis
> # left extreme is the OLS regression coefficients.
> predict(models,s=0,type = "coef") 
20 x 1 sparse Matrix of class "dgCMatrix"
                    1
(Intercept)   67.7722
(Intercept)    .     
Hits           2.2352
HmRun          4.1019
Runs          -2.0768
RBI           -1.9989
Walks          4.6897
Years          2.1862
CAtBat        -0.3280
CHits          0.7213
CHmRun        -0.2038
CRuns          1.0799
CRBI           0.8568
CWalks        -0.5326
LeagueN       85.9763
DivisionW   -129.9881
PutOuts        0.2555
Assists        0.2921
Errors        -5.0214
NewLeagueN   -48.5090
> # as lambda increases, coefficients shrink to zero.
> 
> 
> # MSPE
> set.seed(1)
> train = sample(1:n,n/2)
> test = (-train)
> y.test = y[test] #response
> # new model with train data set -> 100 ridge regressions 
> 
> models = glmnet(x[train,], y[train], alpha=0, lambda = grid, thresh = 1e-12)
> 
> # MSPE for lambda = 10^10
> yhat = predict(models,s=1e10,newx=x[test,])
> mean((y.test-yhat)^2)
[1] 193253
> # MSPE for lambda = 4
> yhat = predict(models,s=4,newx=x[test,])
> mean((y.test-yhat)^2)
[1] 107732
> # cf. square dollars
> # MSPE for lambda = 0
> yhat = predict(models,s=0,newx=x[test,])
> mean((y.test-yhat)^2)
[1] 122927
> 
> # 10-fold Cross Validation to select best lambda
> set.seed(1)
> cv.out = cv.glmnet(x[train,], y[train], alpha = 0, nfolds = 10) # 10-folds is default
> summary(cv.out)
           Length Class  Mode     
lambda     98     -none- numeric  
cvm        98     -none- numeric  
cvsd       98     -none- numeric  
cvup       98     -none- numeric  
cvlo       98     -none- numeric  
nzero      98     -none- numeric  
name        1     -none- character
glmnet.fit 12     elnet  list     
lambda.min  1     -none- numeric  
lambda.1se  1     -none- numeric  
> cv.out$lambda.min
[1] 255
> options(digits = 9)
> 
> cv.out$lambda.min
[1] 255.04349
> 
> # MSPE using best lambda
> # (now using test set)
> best_lambda = cv.out$lambda.min
> yhat = predict(models,s=best_lambda,newx = x[test,])
> 
> mean((y.test-yhat)^2)
[1] 96046.8985
> # Better than MSPe with OLS 
> # refit with full data set
> rmodel = glmnet(x,y,alpha = 0)
> predict(rmodel, type="coef",s=best_lambda)[1:20,]
   (Intercept)    (Intercept)           Hits          HmRun           Runs 
 17.1037467239   0.0000000000   0.9947329976   0.3915594722   1.1624957358 
           RBI          Walks          Years         CAtBat          CHits 
  0.9249977223   1.7594108261   0.6572437719   0.0113683718   0.0618454673 
        CHmRun          CRuns           CRBI         CWalks        LeagueN 
  0.4305743801   0.1229438124   0.1301345297   0.0396260459  24.6005803646 
     DivisionW        PutOuts        Assists         Errors     NewLeagueN 
-86.2128906895   0.1820875801   0.0416818350  -1.5442330222   8.4167951370 
> 
> # Ridge regression model requires all predictors
> 
> # <Lasso> Regression
> # 100 Lasso models
> 
> lmodels = glmnet(x[train,],y[train],alpha = 1,lambda = grid)
> # coef plot
> plot(lmodels,xvar="lambda")
> grid()
> 
> # 10-fold Cross Validation 
> set.seed(1)
> 
> cv.out2 = cv.glmnet(x[train,],y[train],alpha=1,nfolds = 10)
> 
> cv.out$lambda.min
[1] 255.04349
> # this is best lambda for lasso
> cv.out2$lambda.min
[1] 16.7801585
> # this is best lambda for lasso
> 
> # MSPE
> yhat = predict(lmodels,s=cv.out2$lambda.min,newx=x[test,])
> mean((y.test-yhat)^2)
[1] 100743.446
> # lasso model is also better than OLS
> # close to ridge regression MSPE
> # refit with the full dataset
> lasso.model = glmnet(x,y,alpha = 1,lambda=grid)
> lasso.coef = predict(lasso.model,type="coef",s=cv.out2$lambda.min)[1:20,]
> 
> lasso.coef
   (Intercept)    (Intercept)           Hits          HmRun           Runs 
  18.539484370    0.000000000    1.873538979    0.000000000    0.000000000 
           RBI          Walks          Years         CAtBat          CHits 
   0.000000000    2.217844394    0.000000000    0.000000000    0.000000000 
        CHmRun          CRuns           CRBI         CWalks        LeagueN 
   0.000000000    0.207125173    0.413013209    0.000000000    3.266667729 
     DivisionW        PutOuts        Assists         Errors     NewLeagueN 
-103.484545814    0.220428413    0.000000000    0.000000000    0.000000000 
> 
> # 12 coefs are zero
> # predictors in lasso models are
> lasso.coef[lasso.coef!=0]
   (Intercept)           Hits          Walks          CRuns           CRBI 
  18.539484370    1.873538979    2.217844394    0.207125173    0.413013209 
       LeagueN      DivisionW        PutOuts 
   3.266667729 -103.484545814    0.220428413 
> 
> # Lasso leads to better mspe than Multiple Regression and also simple model