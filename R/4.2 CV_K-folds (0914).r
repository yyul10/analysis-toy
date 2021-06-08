> # K-Fold Cross Validation
> 
> library(PASWR2) #dataset
Loading required package: lattice
Loading required package: ggplot2
RStudio Community is a great place to get help:
https://community.rstudio.com/c/tidyverse.
> library(leaps) #regsubsets()
> d0 = HSWRESTLER
> ig = c(22,27,32,35,60) #ignore rows
> d1=d0[-ig,1:7]
> 
> head(d1)
  age    ht    wt abs triceps subscap hwfat
1  18 65.75 133.6   8       6    10.5 10.71
2  15 65.50 129.0  10       8     9.0  8.53
3  17 64.00 120.8   6       6     8.0  6.78
4  17 72.00 145.0  11      10    10.0  9.32
5  17 69.50 299.2  54      42    37.0 41.89
6  14 66.00 190.6  40      25    26.0 34.03
> k=5 #folds
> set.seed(5)
> 
> # create folds
> 
> nrow(d1)
[1] 73
> x = rep(1:5)
> x
[1] 1 2 3 4 5
> x = rep(1:5,each=14)
> x
 [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3
[36] 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 4 4 4 5 5 5 5 5 5 5 5 5 5 5 5 5 5
> x = sample(x)
> x
 [1] 2 4 5 2 1 4 3 4 5 5 2 3 2 3 5 1 2 5 5 4 4 3 1 4 5 2 5 3 1 3 2 1 4 1 1
[36] 3 4 4 1 5 2 5 2 4 3 1 5 3 3 2 1 3 5 4 2 5 1 5 3 2 4 2 1 3 2 1 3 4 1 4
> # Shuffled
> 
> x2 = sample(1:5,3)
> x2
[1] 5 3 1
> folds = c(x,x2)
> folds
 [1] 2 4 5 2 1 4 3 4 5 5 2 3 2 3 5 1 2 5 5 4 4 3 1 4 5 2 5 3 1 3 2 1 4 1 1
[36] 3 4 4 1 5 2 5 2 4 3 1 5 3 3 2 1 3 5 4 2 5 1 5 3 2 4 2 1 3 2 1 3 4 1 4
[71] 5 3 1
> table(folds)
folds
 1  2  3  4  5 
15 14 15 14 15 
> plot(folds)

# in general select the folds as follows
> m = floor(n/k)
> x = rep(1:k,each=m)
> x = sample(x)
> m2 = n-length(x) x2 = sample(1:k,m2) folds = c(x,x2) table(folds)
> 
> ================================
> mspe = matrix(0,k,6) # 5 by 6 matrix
> head(d1)
  age    ht    wt abs triceps subscap hwfat
1  18 65.75 133.6   8       6    10.5 10.71
2  15 65.50 129.0  10       8     9.0  8.53
3  17 64.00 120.8   6       6     8.0  6.78
4  17 72.00 145.0  11      10    10.0  9.32
5  17 69.50 299.2  54      42    37.0 41.89
6  14 66.00 190.6  40      25    26.0 34.03
> head(mspe)
     [,1] [,2] [,3] [,4] [,5] [,6]
[1,]    0    0    0    0    0    0
[2,]    0    0    0    0    0    0
[3,]    0    0    0    0    0    0
[4,]    0    0    0    0    0    0
[5,]    0    0    0    0    0    0
> # mspe(j,i) = MSPE of the best model with i predictors ignoring the jth fold.
> 
> # fold1
> y = d1[folds == 1, ]
> y
   age    ht    wt abs triceps subscap hwfat
5   17 69.50 299.2  54    42.0      37 41.89
16  17 71.50 181.6   9    10.0      10  8.27
24  15 68.25 133.6  11    10.5       9  9.49
31  15 68.75 201.4  37    27.0      31 31.71
36  15 63.25 152.6  21    13.0       9 17.83
38  14 67.25 124.2  10    10.0       8 13.87
39  16 69.00 209.8  41    35.0      36 33.53
43  14 67.00 128.6   9    11.0       9  7.69
50  15 68.50 224.0  41    30.0      34 27.01
55  18 69.00 146.4   9    10.0       8 10.40
62  17 68.00 155.4   8     7.0       8 11.79
68  18 67.00 161.4   7     6.0       7  9.81
71  17 69.00 174.2  10     7.0       8  6.33
74  16 69.00 140.2   7     6.0       6  6.86
78  15 66.00 258.6  45    37.0      43 33.75
> dim(d0)
[1] 78  9
> # the raw data is d0 hence there's 78th row
> predict.regsubsets <- function(object, newdata, id, ...)
+ {
+     form <- as.formula(object$call[[2]])
+     mat <- model.matrix(form, newdata)
+     coefi = coef(object, id = id)
+     xvars <- names(coefi)
+     mat[, xvars]%*%coefi
+ }
> for (j in 1:k)
+ {
+     y = d1$hwfat[folds==j] # y values in the jth folds
+     d2 = d1[folds!=j,] # training set ignores the jth fold
+     models = regsubsets(hwfat~.,d2)
+     for(i in 1:6)
+     {
+         newdata = d1[folds ==j,] # test set
+         yhat = predict.regsubsets(models,newdata,id=i) # predict the jth fold (vector)
+         mspe[j,i] = mean((y-yhat)^2)
+     }
+     
+ }
> mspe
          [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
[1,]  9.418801  6.018222  6.544758  7.201831  7.284653  7.468159
[2,]  8.982257  6.694449  6.561723  7.666092  7.777638  7.706906
[3,]  6.942410  4.751430  6.340462  6.686701  6.881903  6.871311
[4,]  7.091732  7.775369  7.631415  7.538602  7.692280  7.673438
[5,] 12.534920 10.070260 10.042608 10.732882 10.862931 10.785316
> # 8.982257 is the MSPE when predicting second fold using the best model with 1 predictor
>
> #CVk
> CVk=colMeans(mspe)
> CVk
[1] 8.994024 7.061946 7.424193 7.965222 8.099881 8.101026
> which.min(CVk)
[1] 2
> 
> modelsall = regsubsets(hwfat~.,d1)
> coef(modelsall,2)
(Intercept)         abs     triceps 
  1.9119410   0.3929936   0.4211225 
>
> # LOOCV
> 
> k = n
> mspe = matrix(0,k,6)
> dim(mspe)
[1] 93  6
> head(mspe)
     [,1] [,2] [,3] [,4] [,5] [,6]
[1,]    0    0    0    0    0    0
[2,]    0    0    0    0    0    0
[3,]    0    0    0    0    0    0
[4,]    0    0    0    0    0    0
[5,]    0    0    0    0    0    0
[6,]    0    0    0    0    0    0
> n = nrow(d1)
> k = n
> mspe = matrix(0,k,6)
> head(mspe)
     [,1] [,2] [,3] [,4] [,5] [,6]
[1,]    0    0    0    0    0    0
[2,]    0    0    0    0    0    0
[3,]    0    0    0    0    0    0
[4,]    0    0    0    0    0    0
[5,]    0    0    0    0    0    0
[6,]    0    0    0    0    0    0
> dim(mspe)
[1] 73  6
> for (j in 1:k)
+ {
+     y = d1$hwfat[j,] # y values in the jth
+     d2 = d1[-j,] # training set ignores the jth row
+     models = regsubsets(hwfat~.,d2)
+     for(i in 1:6)
+     {
+             newdata = d1[j,] # test set
+             yhat = predict.regsubsets(models,newdata,id=i) # predict the jth row
+             mspe[j,i] = mean((y-yhat)^2)
+     }
+      
+ }
> #the same result as 5-fold validation.
>
