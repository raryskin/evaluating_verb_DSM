library(ez) 
library(dplyr) 
library(ggplot2)

df <- read.csv("./simverb_11-27.csv")
hist(df$sv_score,xlab="Human-rated similarity scores (0-10)",ylab="Frequency")

#CF-paragram
hist(df$one_minus_cf,xlab="CF-Paragram cos distance",ylab="Frequency",main="Histogram of Counter Fitted Paragram cosine distance")
cor(df$one_minus_cf,df$sv_score)
cor.test(df$one_minus_cf,df$sv_score)
cfp_lm <- lm(one_minus_cf~sv_score, data=df)
lm(one_minus_cf~sv_score, data=df)
summary(cfp_lm)
plot(df$sv_score,df$one_minus_cf,xlab="SimVerb Human rankings",ylab="CF Paragram cos distance",main="Correlation between SimVerb rankings and CF-Paragram cos distance")
abline(lm(df$one_minus_cf~df$sv_score),col="red")
#High correlation between the two measures (0.616), t = 46.187, df = 3487, p-value < 2.2e-16
#Slope = 0.05527, intercept = 0.03720

#WordNet Wu-Palmer similarity
hist(df$wn_wup,xlab="WordNet Wu-Palmer similarity scores (0-1)",ylab="Frequency")
cor(df$wn_wup,df$sv_score)
cor.test(df$wn_wup,df$sv_score)
wn_wup_lm <- lm(wn_wup~sv_score, data=df)
lm(wn_wup~sv_score, data=df)
summary(wn_wup_lm)
plot(df$sv_score,df$wn_wup,xlab="SimVerb Human rankings",ylab="WordNet Wu-Palmer sim", main="Correlation between SimVerb rankings and WordNet Wu-Palmer similarity")
abline(lm(wn_wup~sv_score, data=df),col="red")
#Low correlation between the two measures (0.2743), t = 16.846, df = 3487, p-value < 2.2e-16
#Slope = 0.01515, intercept = 0.15195