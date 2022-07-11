library(here)
setwd(here())
library(tidyverse)
library(patchwork)

theme_set(theme_minimal() + theme(text =  element_text(size = 14)))

simverb <- read_csv(here("data_output",
                            "simverb_processed.csv"), 
                       show_col_type = F)

ggplot(simverb, aes(x = shared_frames, y = sd_rating))+
  geom_point(shape = 21, fill = "lightblue")+
  xlab("# Shared frames between pair")+
  ylab("StDev of annotator rating")+
  geom_smooth(method = "lm")

ggplot(simverb, aes(x = shared_frames, y = sv_score))+
  geom_point(shape = 21, fill = "lightblue")+
  xlab("# Shared frames between pair")+
  ylab("Mean annotator rating")+
  geom_smooth(method = "lm")

ggplot(simverb, aes(x = relation_index, y = sd_rating))+
  geom_point(shape = 21, fill = "lightblue")+
  xlab("Pair relation (hypernym, etc.)")+
  ylab("StDev of annotator rating")+
  geom_smooth(method = "lm")


simverb <- simverb |> 
  mutate(sense_ratio = w1_num_v_senses/w2_num_v_senses)

ggplot(simverb, aes(x = sense_ratio, y = sd_rating))+
  geom_point(shape = 21, fill = "lightblue")+
  xlab("Verb sense ratio")+
  ylab("StDev of annotator rating")+
  geom_smooth(method = "lm")
