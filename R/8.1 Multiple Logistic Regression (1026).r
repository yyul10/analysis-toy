install.packages("HSAUR")
library(HSAUR)
str(plasma)
table(plasma$ESR) # 26 healthy 6 unhealthy

# model with 1 predictor
m1 = glm(ESR~fibrinogen, family = binomial, plasma)
summary(m1)

# interpret b1
# an increase of one unit in fibrinogen increases the log-odds ratio in favor of ESR>20 
# by an estimated 1.8271

# 95% confidence interval
confint(m1)
# small data set, low accuracy -> wide interval

# interpret exp(b1)
coef(m1)["fibrinogen"]
exp(coef(m1)["fibrinogen"]) 
# very large change in the odds-ratio when fibrinogen increases by 1 unit

# confidence interval
exp(confint(m1,"fibrinogen"))

# -----------------------
# two predictors (fibrinogen and globulin)
m2 = glm(ESR~.,binomial,plasma)
summary(m2)$aic # 28.97111
summary(m1)$aic # 28.84036
# AIC did not decrease by adding the second predictor globulin
# test if m2 is better than m1
# H0 = m1 is the best model, if the p-value is small we will favor m2

anova(m1,m2,test="Chisq")
# p-value is not small enough to reject H0, so model 1 is better.

# predict(estimate) the probability of ESR > 20
prob = predict(m2,type="response")
d2 = data.frame(plasma,prob)
head(d2)

# Bubbleplot
plot(globulin~fibrinogen,plasma,xlim=c(2,6),ylim=c(25,55),pch=".",cex=2)
symbols(d2$fibrinogen,d2$globulin,circles = prob)
# x로는 경향성이 보이지만 y축으로는 원이 커지는 경향성을 알 수 없다.

