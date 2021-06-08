> d0 = read.table("/Users/yul/Google 드라이브/USC/2018 Fall/ISE529 Data Analytics/R examples/example2b.txt",header = T)
> d0
  x1    x2     y
1  S -0.10 19.19
2  S  2.53 22.74
3  S  4.86 23.91
4  M  0.26  7.07
5  M  2.55  7.93
6  M  4.87  8.93
7  L  0.08 20.63
8  L  2.62 23.46
9  L  5.09 25.75
> str(d0)
'data.frame':	9 obs. of  3 variables:
 $ x1: Factor w/ 3 levels "L","M","S": 3 3 3 2 2 2 1 1 1
 $ x2: num  -0.1 2.53 4.86 0.26 2.55 4.87 0.08 2.62 5.09
 $ y : num  19.19 22.74 23.91 7.07 7.93 ...
> d1 = d0
> d1$x1 = rep(c(0,1,2), each=3)
> str(d1)
'data.frame':	9 obs. of  3 variables:
 $ x1: num  0 0 0 1 1 1 2 2 2
 $ x2: num  -0.1 2.53 4.86 0.26 2.55 4.87 0.08 2.62 5.09
 $ y : num  19.19 22.74 23.91 7.07 7.93 ...
> m1 = lm(y~.,d1)
> 
> summary(m1)

Call:
lm(formula = y ~ ., data = d1)

Residuals:
    Min      1Q  Median      3Q     Max 
-10.623  -8.902   4.196   5.053   5.607 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)  
(Intercept)  15.1678     5.6816   2.670    0.037 *
x1            0.6019     3.4742   0.173    0.868  
x2            0.7769     1.4275   0.544    0.606  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 8.505 on 6 degrees of freedom
Multiple R-squared:  0.05259,	Adjusted R-squared:  -0.2632 
F-statistic: 0.1665 on 2 and 6 DF,  p-value: 0.8504

> m2 = lm(y~.,d0)
> summary(m2)

Call:
lm(formula = y ~ ., data = d0)

Residuals:
       1        2        3        4        5        6        7        8        9 
-0.69345  0.71178 -0.01834  0.96899 -0.03851 -0.93048 -0.59765  0.16097  0.43668 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  21.1624     0.5937  35.645 3.27e-07 ***
x1M         -15.2734     0.6701 -22.792 3.02e-06 ***
x1S          -1.1974     0.6705  -1.786  0.13418    
x2            0.8155     0.1378   5.920  0.00196 ** 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.8207 on 5 degrees of freedom
Multiple R-squared:  0.9926,	Adjusted R-squared:  0.9882 
F-statistic:   225 on 3 and 5 DF,  p-value: 9.416e-06

> 
> # Base model is size with Large, the estimates are additional coefficients
> # E[Y] = 21.1624 + 0.8155 * x2       fitted equation for large size
> # E[Y] = (21.1624-15.2734) + 0.8155 * x2        fitted line for medium size
> # E[Y] = (21.1624-1.1974) + 0.8155 * x2        fitted line for small size
>
> # by hand
>
> d3 =d0
> d3$x11 = rep(c(0,1,0), each = 3)
> d3$x11
[1] 0 0 0 1 1 1 0 0 0
> d3
  x1    x2     y x11
1  S -0.10 19.19   0
2  S  2.53 22.74   0
3  S  4.86 23.91   0
4  M  0.26  7.07   1
5  M  2.55  7.93   1
6  M  4.87  8.93   1
7  L  0.08 20.63   0
8  L  2.62 23.46   0
9  L  5.09 25.75   0
> d3$x12 = rep(c(0,0,1), each = 3)
> d3
  x1    x2     y x11 x12
1  S -0.10 19.19   0   0
2  S  2.53 22.74   0   0
3  S  4.86 23.91   0   0
4  M  0.26  7.07   1   0
5  M  2.55  7.93   1   0
6  M  4.87  8.93   1   0
7  L  0.08 20.63   0   1
8  L  2.62 23.46   0   1
9  L  5.09 25.75   0   1
> # 3 level : 00 -> S, 10 -> M, 01 -> L
> d3$x1=NULL
> d3
     x2     y x11 x12
1 -0.10 19.19   0   0
2  2.53 22.74   0   0
3  4.86 23.91   0   0
4  0.26  7.07   1   0
5  2.55  7.93   1   0
6  4.87  8.93   1   0
7  0.08 20.63   0   1
8  2.62 23.46   0   1
9  5.09 25.75   0   1
> d3 = d3[,c(3,4,1,2)]
> 
> d3
  x11 x12    x2     y
1   0   0 -0.10 19.19
2   0   0  2.53 22.74
3   0   0  4.86 23.91
4   1   0  0.26  7.07
5   1   0  2.55  7.93
6   1   0  4.87  8.93
7   0   1  0.08 20.63
8   0   1  2.62 23.46
9   0   1  5.09 25.75
> m3 = lm(y~.,d3)
> summary(m3)

Call:
lm(formula = y ~ ., data = d3)

Residuals:
       1        2        3        4        5        6        7        8        9 
-0.69345  0.71178 -0.01834  0.96899 -0.03851 -0.93048 -0.59765  0.16097  0.43668 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  19.9650     0.5802  34.413 3.90e-07 ***
x11         -14.0760     0.6703 -20.998 4.54e-06 ***
x12           1.1974     0.6705   1.786  0.13418    
x2            0.8155     0.1378   5.920  0.00196 ** 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.8207 on 5 degrees of freedom
Multiple R-squared:  0.9926,	Adjusted R-squared:  0.9882 
F-statistic:   225 on 3 and 5 DF,  p-value: 9.416e-06

> summary(m2)

Call:
lm(formula = y ~ ., data = d0)

Residuals:
       1        2        3        4        5        6        7        8        9 
-0.69345  0.71178 -0.01834  0.96899 -0.03851 -0.93048 -0.59765  0.16097  0.43668 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  21.1624     0.5937  35.645 3.27e-07 ***
x1M         -15.2734     0.6701 -22.792 3.02e-06 ***
x1S          -1.1974     0.6705  -1.786  0.13418    
x2            0.8155     0.1378   5.920  0.00196 ** 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.8207 on 5 degrees of freedom
Multiple R-squared:  0.9926,	Adjusted R-squared:  0.9882 
F-statistic:   225 on 3 and 5 DF,  p-value: 9.416e-06

> m2$fitted
        1         2         3         4         5         6         7         8 
19.883447 22.028217 23.928336  6.101012  7.968512  9.860476 21.227654 23.299028 
        9 
25.313318 
> m3$fitted
        1         2         3         4         5         6         7         8 
19.883447 22.028217 23.928336  6.101012  7.968512  9.860476 21.227654 23.299028 
        9 
25.313318 
> # m2$fitted=m3$fitted
> # R will do the categorical regression when the predictor is defined as Factor

----------------------------------------
> d0 = read.csv("/Users/yul/Google 드라이브/USC/2018 Fall/ISE529 Data Analytics/R examples/2. Xm16-02.csv", header = T)
> head(d0)
  Price Odometer Color
1  14.6     37.4     1
2  14.1     44.8     1
3  14.0     45.8     3
4  15.6     30.9     3
5  15.6     31.7     2
6  14.7     34.0     2
> str(d0)
'data.frame':	100 obs. of  3 variables:
 $ Price   : num  14.6 14.1 14 15.6 15.6 14.7 14.5 15.7 15.1 14.8 ...
 $ Odometer: num  37.4 44.8 45.8 30.9 31.7 34 45.9 19.1 40.1 40.2 ...
 $ Color   : int  1 1 3 3 2 2 1 3 1 1 ...
> d0$Color = as.factor(d0$Color)
> str(d0)
'data.frame':	100 obs. of  3 variables:
 $ Price   : num  14.6 14.1 14 15.6 15.6 14.7 14.5 15.7 15.1 14.8 ...
 $ Odometer: num  37.4 44.8 45.8 30.9 31.7 34 45.9 19.1 40.1 40.2 ...
 $ Color   : Factor w/ 3 levels "1","2","3": 1 1 3 3 2 2 1 3 1 1 ...
> # 1 is white, 2 is silver, 3 is other color
> levels(d0$Color)
[1] "1" "2" "3"
> # level 1 is base model
> # set "3" the base level
> d0$Color = relevel(d0$Color,ref = "3")
> levels(d0$Color)
[1] "3" "1" "2"
> m1 = lm(Price~.,d0)
> coef(m1)
(Intercept)    Odometer      Color1      Color2 
16.83724755 -0.05912294  0.09113080  0.33036793 
> # fitted equation for the base model
> 
> # E[Price] = 16.83724755 - -0.05912294 Odometer
> # fitted equation for the white cars (level 1)
> # E[Price] = 16.83724755 + 0.0911308 -0.05912294 Odometer
> # fitted equation for the silver cars (level 2)
> # E[Price] = 16.83724755 + 0.33036793 -0.05912294 Odometer
> summary(m1)

Call:
lm(formula = Price ~ ., data = d0)

Residuals:
    Min      1Q  Median      3Q     Max 
-0.7047 -0.2022 -0.0133  0.1961  0.6450 

Coefficients:
             Estimate Std. Error t value Pr(>|t|)    
(Intercept) 16.837248   0.197105  85.423  < 2e-16 ***
Odometer    -0.059123   0.005065 -11.672  < 2e-16 ***
Color1       0.091131   0.072892   1.250 0.214257    
Color2       0.330368   0.081650   4.046 0.000105 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.3043 on 96 degrees of freedom
Multiple R-squared:  0.7008,	Adjusted R-squared:  0.6914 
F-statistic: 74.95 on 3 and 96 DF,  p-value: < 2.2e-16

> # Test H0 : beta(Color 1) = 0
> # p-value is 0.214257, not small
> # do not reject H0
> # intercept for White cars same as for other color cars
> # thus, price of white cars same as price of other color cars
> int = coef(m1)[1]
> slope = coef(m1)[2]
> b2 = coef(m1)[3]
> b3 = coef(m1)[4]
> 
> # plot
> plot(Price~Odometer,d0,col=Color)
> xb = c(0,50)
> yb = c(12,18)
> plot(Price~Odometer,d0,col=Color,pch=19,cex=0.6,xlim=xb,ylim=yb)
> abline(int,slope,col=1)
> abline(int+b2,slope,col=2)
> abline(int+b3,slope,col=3)
> # 1st and 2nd line difference is not significant
> # conclude that red and black are the same 
> label = c("Other Colors","White","Silver")
> legend("topright",legend=label,lty=c(1,1,1),col=c(1,2,3),cex=0.8)
> 
> # Combine levels
> levels(d53$Color) = c("WC","WC","S")
> levels(d53$Color)
[1] "WC" "S" 
> m53_ = lm(Price~.,d53)
> summary(m53_)

Call:
lm(formula = Price ~ ., data = d53)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.70499 -0.22916 -0.01177  0.19633  0.68565 

Coefficients:
             Estimate Std. Error t value Pr(>|t|)    
(Intercept) 16.877395   0.195036  86.535  < 2e-16 ***
Odometer    -0.058910   0.005077 -11.603  < 2e-16 ***
ColorS       0.283422   0.072713   3.898 0.000179 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.3051 on 97 degrees of freedom
Multiple R-squared:  0.6959,  Adjusted R-squared:  0.6897 
F-statistic:   111 on 2 and 97 DF,  p-value: < 2.2e-16
>
> # E[Price] = (16.83724755+0.28342190) - 0.05891037*(Odometer reading)
> # Silver cars cost 283.42190  more, on average
----------------------------------------
> library(MASS)
> d0 = Cars93
> names(d0)
 [1] "Manufacturer"       "Model"              "Type"              
 [4] "Min.Price"          "Price"              "Max.Price"         
 [7] "MPG.city"           "MPG.highway"        "AirBags"           
[10] "DriveTrain"         "Cylinders"          "EngineSize"        
[13] "Horsepower"         "RPM"                "Rev.per.mile"      
[16] "Man.trans.avail"    "Fuel.tank.capacity" "Passengers"        
[19] "Length"             "Wheelbase"          "Width"             
[22] "Turn.circle"        "Rear.seat.room"     "Luggage.room"      
[25] "Weight"             "Origin"             "Make"              

> table(d0$AirBags)

Driver & Passenger        Driver only               None 
                16                 43                 34 
> d1 = d0[,c(5,7,9)]
> head(d1)
  Price MPG.city            AirBags
1  15.9       25               None
2  33.9       18 Driver & Passenger
3  29.1       20        Driver only
4  37.7       19 Driver & Passenger
5  30.0       22        Driver only
6  15.7       22        Driver only
> str(d1)
'data.frame':	93 obs. of  3 variables:
 $ Price   : num  15.9 33.9 29.1 37.7 30 15.7 20.8 23.7 26.3 34.7 ...
 $ MPG.city: int  25 18 20 19 22 22 19 16 19 16 ...
 $ AirBags : Factor w/ 3 levels "Driver & Passenger",..: 3 1 2 1 2 2 2 2 2 2 ...
> levels (d1$AirBags)
[1] "Driver & Passenger" "Driver only"        "None"              
> levels(d1$AirBags) = c("dp",'d','0')
> levels (d1$AirBags)
[1] "dp" "d"  "0" 
> # model
> m1 = lm(Price~MPG.city*AirBags,d1)
> # * is to indicate interations
> summary(m1)

Call:
lm(formula = Price ~ MPG.city * AirBags, data = d1)

Residuals:
    Min      1Q  Median      3Q     Max 
-14.925  -3.200  -0.615   2.539  31.875 

Coefficients:
                  Estimate Std. Error t value Pr(>|t|)    
(Intercept)        85.9565    14.3376   5.995 4.51e-08 ***
MPG.city           -2.9438     0.7282  -4.043 0.000114 ***
AirBagsd          -42.7046    15.0074  -2.846 0.005527 ** 
AirBags0          -60.5693    14.9876  -4.041 0.000114 ***
MPG.city:AirBagsd   1.9253     0.7551   2.550 0.012532 *  
MPG.city:AirBags0   2.4476     0.7481   3.272 0.001533 ** 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 6.51 on 87 degrees of freedom
Multiple R-squared:  0.5704,	Adjusted R-squared:  0.5457 
F-statistic:  23.1 on 5 and 87 DF,  p-value: 1.085e-14

> # Airbags DP is the base level (it does not show up in the Coeff table)
> # AirbagsD is the additional intercept if car has Driver only bag 
> # Airbags0 is the additional intercept if car has no airbags
> # MPG.city:AirBagsD is the additional slope if car has driver only bag
>
> # chage the base level
> d1$AirBags=relevel(d1$AirBags,"d")
> levels(d1$AirBags)
[1] "d"  "dp" "0" 
> d1$AirBags=relevel(d1$AirBags,"0")
> levels(d1$AirBags)
[1] "0"  "d"  "dp"
> 
> # refit
> m2 = lm(Price~MPG.city*AirBags,d1)
> summary(m2)

Call:
lm(formula = Price ~ MPG.city * AirBags, data = d1)

Residuals:
    Min      1Q  Median      3Q     Max 
-14.925  -3.200  -0.615   2.539  31.875 

Coefficients:
                   Estimate Std. Error t value Pr(>|t|)    
(Intercept)         25.3873     4.3658   5.815 9.83e-08 ***
MPG.city            -0.4961     0.1714  -2.894 0.004809 ** 
AirBagsd            17.8647     6.2221   2.871 0.005135 ** 
AirBagsdp           60.5693    14.9876   4.041 0.000114 ***
MPG.city:AirBagsd   -0.5224     0.2633  -1.984 0.050366 .  
MPG.city:AirBagsdp  -2.4476     0.7481  -3.272 0.001533 ** 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 6.51 on 87 degrees of freedom
Multiple R-squared:  0.5704,	Adjusted R-squared:  0.5457 
F-statistic:  23.1 on 5 and 87 DF,  p-value: 1.085e-14

> 
> # fiited equations
> # No airbags E[Y] = 25.3873 - 0.4961 * MPG
> # Drivers E[Y] = (25.3873+17.8647) + (-0.4961-0.5224) * MPG
> # Drivers and Passengers E[Y] =  (25.3873+60.5693) + (-0.4961-2.4476) * MPG