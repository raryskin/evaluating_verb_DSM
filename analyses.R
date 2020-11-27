library(ez) 
library(dplyr) 
library(ggplot2)

df <- read.csv("./simverb_11-27.csv")
hist(df$sv_score,xlab="Human-rated similarity scores (0-10)",ylab="Frequency")

#CF-paragram
hist(df$one_minus_cf,xlab="CF-Paragram cos distance",ylab="Frequency")
cor(df$sv_score,df$one_minus_cf)
cor.test(df$sv_score,df$one_minus_cf)
cfp_lm <- lm(sv_score~one_minus_cf, data=df)
summary(cfp_lm)
plot(df$sv_score,df$one_minus_cf)
abline(cfp_lm)

#WordNet Wu-Palmer similarity
hist(df$wn_wup,xlab="WordNet Wu-Palmer similarity scores (0-1)",ylab="Frequency")
cor(df$sv_score,df$wn_wup)
cor.test(df$sv_score,df$wn_wup)
wn_wup_lm <- lm(sv_score~wn_wup, data=df)
summary(wn_wup_lm)
plot(df$sv_score,df$wn_wup)
abline(wn_wup_lm)
