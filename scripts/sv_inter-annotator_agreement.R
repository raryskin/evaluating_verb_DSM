library(tidyverse)
library(here)
setwd(here())

sv_ratings <- read_csv(here("data","SimVerb-3500-ratings.txt"),
                       show_col_types = F)
colnames(sv_ratings) <- "combined_data"


# 1) pull 5 ratings per pair 
# 2) compute average per pair 
# 3) compute correlation with the original ratings across all pairs 
# 4) repeat 200x 
# 5) compute average and SD of correlation values


get_average <- function(row_n){
  val_set = str_split(row_n, "\t", simplify = T)
  val_set <- val_set[-1]
  val_set <- val_set[-1]
  return(mean(as.numeric(val_set)))
}

get_sampled_average <- function(row_n){
  val_set = str_split(row_n, "\t", simplify = T)
  val_set <- val_set[-1]
  val_set <- val_set[-1]
  sub_sample <- sample(as.numeric(val_set), size = 5)
  return(mean(sub_sample))
}


sv_ratings = sv_ratings |> 
  rowwise() |> 
  mutate(word1 = str_split(combined_data, "\t", simplify = T)[1],
         word2 = str_split(combined_data, "\t", simplify = T)[2],
         avg = get_average(combined_data))

correlations <- c()
for (jj in 1:200) {
  temp_df <- sv_ratings |> 
    rowwise() |> 
    mutate(samp_avg = get_sampled_average(combined_data))
  
  correlations <- append(correlations, cor.test(temp_df$avg, temp_df$samp_avg)$estimate)
  rm(temp_df)
}

correlations |> 
  data.frame() |> 
  summarize(mean = mean(correlations),
            sd = sd(correlations))

hist(correlations)





# 
# 
# sampling_df <- data.frame()
# 
# for (ii in 1:nrow(sv_ratings)){
#   sv_row = sv_ratings[ii,]$combined_data
#   split_row = str_split(sv_row, "\t", simplify = T)
#   split_row
#   word1 <- split_row[1]
#   word2 <- split_row[2]
#   
#   split_row <- split_row[-1]
#   split_row <- split_row[-1]
#   split_row <- as.numeric(split_row)
#   
#   avg_score <- mean(split_row)
#   
#   # word1, word2, pair, avg_score, avg_sampled_score
#   
#   sampled_scores <- c()
#   for (jj in 1:200){
#     sub_sample <- sample(split_row, size = 5)
#     sampled_scores <- append(sampled_scores, mean(sub_sample))
#   }
#   avg_sample_score <- mean(sampled_scores)
#   
#   sampling_df <- sampling_df |> 
#     rbind(data.frame(word1, word2, avg_score, avg_sample_score))
# }
# 
# 
# ggplot(sampling_df, aes(x = avg_score, y = avg_sample_score))+
#   geom_point(shape = 21, fill = "lightblue")+
#   theme_bw()+
#   xlab("Average of full set")+
#   ylab("Average of 5 sample (200 repetitions)")+
#   ggtitle("Comparison between 10+ and 5 ratings")+
#   geom_smooth(method = "lm")+
#   labs(caption = cor.test(sampling_df$avg_score, 
#                           sampling_df$avg_sample_score)$estimate)
# 
# cor.test(sampling_df$avg_score, 
#          sampling_df$avg_sample_score)
