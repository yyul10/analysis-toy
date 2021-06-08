> d0=read.csv("/Users/yul/Google 드라이브/USC/2018 Fall/ISE529 Data Analytics/Xm16-02.csv",header=T)
> head(d0)
  Price Odometer Color
1  14.6     37.4     1
2  14.1     44.8     1
3  14.0     45.8     3
4  15.6     30.9     3
5  15.6     31.7     2
6  14.7     34.0     2
> setwd("/Users/yul/Google 드라이브/USC/2018 Fall/ISE529 Data Analytics")
> View(d0)
> m1 = lm(Price~Odometer,d0)
> coef(m1)
(Intercept)    Odometer 
17.24872734 -0.06686089 
> 
> #E[Price]=17.24872734 -0.06686089 * (Odometer reading)
> 
> #scatterplot
> plot(Price~Odometer,d0, pch=20,cex=0.4)
> grid()
> abline(m1,col='red')
> #interpret slope b1
> #for each additional mile on the odometer reading
> #the car's price decreases by 0.067 dollars, on average
> 
> #standard error of the estimate S
> summary(m1)

Call:
lm(formula = Price ~ Odometer, data = d0)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.68679 -0.27263  0.00521  0.23210  0.70071 

Coefficients:
             Estimate Std. Error t value Pr(>|t|)    
(Intercept) 17.248727   0.182093   94.72   <2e-16 ***
Odometer    -0.066861   0.004975  -13.44   <2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.3265 on 98 degrees of freedom
Multiple R-squared:  0.6483,	Adjusted R-squared:  0.6447 
F-statistic: 180.6 on 1 and 98 DF,  p-value: < 2.2e-16

> #interpret S
> 
> #the average distance to the fitted line is 0.3265 dollars
> anova(m1)
Analysis of Variance Table

Response: Price
          Df Sum Sq Mean Sq F value    Pr(>F)    
Odometer   1 19.256 19.2556  180.64 < 2.2e-16 ***
Residuals 98 10.446  0.1066                      
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
> 

> MSE = 0.1066
> S = sqrt(MSE)
> S
[1] 0.3264966
> # S = Residual standard error
> # MSE is an estimate of the variance sigma^2
> 
> #QUESTION 2
> # T test for H0: beta1 = 0
> 
> # second row of Coeff Table shows p-value < 2e-16
> # reject H0, conclude that
> # there is a relationship between average price and odometer reading
> 
> 
> # Confidence Interval on beta1
> confint(m1,level=0.95)
                  2.5 %      97.5 %
(Intercept) 16.88737056 17.61008413
Odometer    -0.07673289 -0.05698888
> # zero is not in the interval -> reject H0
> # slope beta1 lies between -0.07673289, -0.05698888 with 95% confidence
> # On average, for each additional mile, the car's price decrease in amount between -0.07673289, -0.05698888 dollars
> 
> #QUESTION3
> # Coeff of the determination R-squared
> summary(m1)

Call:
lm(formula = Price ~ Odometer, data = d0)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.68679 -0.27263  0.00521  0.23210  0.70071 

Coefficients:
             Estimate Std. Error t value Pr(>|t|)    
(Intercept) 17.248727   0.182093   94.72   <2e-16 ***
Odometer    -0.066861   0.004975  -13.44   <2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.3265 on 98 degrees of freedom
Multiple R-squared:  0.6483,	Adjusted R-squared:  0.6447 
F-statistic: 180.6 on 1 and 98 DF,  p-value: < 2.2e-16

> # from coeff table, R^2 is 0.6483
> r = cor(d0$Price, d0$Odometer)
> r
[1] -0.805168
> r^2
[1] 0.6482955
> # above is only true for simple regression
> 
> # interpret R2
> # 64.83% of variation of car's price is explained by variation in odometer reading.

> #QUESTION4
> 
> newval = data.frame(Odometer = 40)
> predict(m1,newval)
       1 
14.57429 
> 
> # 14.5742 (000s) dollars
> 
> predict(m1,newval, interval="conf", level = 0.96)
       fit      lwr      upr
1 14.57429 14.49477 14.65382
> predict(m1,newval, interval="pred")
       fit      lwr      upr
1 14.57429 13.92196 15.22662
> #default is 0.95
> #pred is wider than conf, always
> 
> # prediction intervals always wider than confidence interval

> #QUESTION5
> 
> # Residual plots
> library(PASWR2)
> checking.plots(m1)
> 
> # test for normality
> # H0 : observations are normal
> 
> 
> sres=rstandard(m1)
> shapiro.test(sres)

	Shapiro-Wilk normality test

data:  sres
W = 0.9848, p-value = 0.307

> # do not reject H0
> # assumptions hold

> #QUESTION6
> plot(Price~Odometer,d0)
> axis= 19:50
> newval = data.frame(Odometer = axis)
> 
> d2 = predict(m1, newval, interval = "conf")
> 
> head(d2)
       fit      lwr      upr
1 15.97837 15.79837 16.15837
2 15.91151 15.74069 16.08233
3 15.84465 15.68292 16.00638
4 15.77779 15.62505 15.93053
5 15.71093 15.56707 15.85479
6 15.64407 15.50895 15.77919
 
> tail(d2)
        fit      lwr      upr
27 14.23999 14.13011 14.34986
28 14.17313 14.05513 14.29112
29 14.10627 13.97991 14.23262
30 14.03940 13.90448 14.17433
31 13.97254 13.82888 14.11621
32 13.90568 13.75314 14.05823

> d2 = predict(m1, newval, interval = "conf")
> d3 = predict(m1, newval, interval = "pred")
> plot(Price~Odometer,d0,pch=20, cex=0.5)
> grid()
> abline(m1,col="red")
> # CIs
> lines(axis,d2[,2],lty=2)
> lines(axis,d2[,3],lty=2)
> # PIs
> lines(axis,d3[,2],lty=3)
> lines(axis,d3[,3],lty=3)

# 여러 그림 한번에
> par(mfrow=c(2,1))
