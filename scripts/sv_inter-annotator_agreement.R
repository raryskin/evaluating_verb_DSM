library(tidyverse)
library(here)
setwd(here())

sv_ratings <- read_csv(here("data","SimVerb-3500-ratings.txt"),
                       show_col_types = F)
colnames(sv_ratings) <- "combined_data"

sampling_df <- data.frame()

for (ii in 1:nrow(sv_ratings)){
  sv_row = sv_ratings[ii,]$combined_data
  split_row = str_split(sv_row, "\t", simplify = T)
  split_row
  word1 <- split_row[1]
  word2 <- split_row[2]
  
  split_row <- split_row[-1]
  split_row <- split_row[-1]
  split_row <- as.numeric(split_row)
  
  avg_score <- mean(split_row)
  
  # word1, word2, pair, avg_score, avg_sampled_score
  
  sampled_scores <- c()
  for (jj in 1:200){
    sub_sample <- sample(split_row, size = 5)
    sampled_scores <- append(sampled_scores, mean(sub_sample))
  }
  avg_sample_score <- mean(sampled_scores)
  
  sampling_df <- sampling_df |> 
    rbind(data.frame(word1, word2, avg_score, avg_sample_score))
}

ggplot(sampling_df, aes(x = avg_score, y = avg_sample_score))+
  geom_point(shape = 21, fill = "lightblue")+
  theme_bw()+
  xlab("Average of full set")+
  ylab("Average of 5 sample (200 repetitions)")+
  ggtitle("Comparison between 10+ and 5 ratings")+
  geom_smooth(method = "lm")+
  labs(caption = cor.test(sampling_df$avg_score, 
                          sampling_df$avg_sample_score)$estimate)

cor.test(sampling_df$avg_score, 
         sampling_df$avg_sample_score)
