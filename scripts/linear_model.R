library(here)
setwd(here())
library(tidyverse)
library(patchwork)
library(caret)
library(broom)

theme_set(theme_minimal() + theme(text =  element_text(size = 14)))

simverb <- read_csv(here("data_output",
                            "simverb_processed.csv"), 
                       show_col_type = F)

ggplot(simverb, aes(x = shared_frames, y = sv_score))+
  geom_point(shape = 21, fill = "lightblue")+
  xlab("# Shared frames between pair")+
  ylab("Mean annotator rating")

ggplot(simverb, aes(x = cf_scaled_sim, y = sv_score))+
  geom_point(shape = 21, fill = "darkblue")+
  xlab("CF paragram similarity (scaled 0-10)")+
  ylab("Mean annotator rating")

ggplot(simverb, aes(x = as.factor(relation_index), y = sv_score))+
  geom_point(shape = 21, fill = "darkgreen")+
  xlab("Type of relation")+
  ylab("Mean annotator rating")+
  scale_x_discrete(labels = c('ANTONYMS', 'COHYPONYMS', 'HYPER/HYPONYMS', 'NONE', 'SYNONYMS'))

## Linear mod portion ----

ctrl <- trainControl(method = "cv", number = 5)

full_model <- train(sv_score ~ relation_index + shared_frames + cf_scaled_sim,
                    data = simverb,
                    method = "lm",
                    trControl = ctrl)

# tidy(full_model$finalModel)
# glance(full_model$finalModel)

ablate_relation <- train(sv_score ~ shared_frames + cf_scaled_sim,
                    data = simverb,
                    method = "lm",
                    trControl = ctrl)

# tidy(ablate_relation$finalModel)
# glance(ablate_relation$finalModel)

ablate_frames <- train(sv_score ~ relation_index + cf_scaled_sim,
                    data = simverb,
                    method = "lm",
                    trControl = ctrl)

# tidy(ablate_frames$finalModel)
# glance(ablate_frames$finalModel)


ablate_both <- train(sv_score ~ cf_scaled_sim,
                       data = simverb,
                       method = "lm",
                       trControl = ctrl)

temp_df <- data.frame(full_model$results, "model_type" = c("full"))
temp_df <- temp_df |> 
  rbind(data.frame(ablate_relation$results, "model_type" = "ablate_relation"))|> 
  rbind(data.frame(ablate_frames$results, "model_type" = "ablate_frames"))|> 
  rbind(data.frame(ablate_both$results, "model_type" = "ablate_both"))

a <- ggplot(temp_df, aes(x = model_type, y = Rsquared))+
  geom_bar(stat = "identity", fill = "lightblue", color = "black")+
  geom_errorbar(aes(ymin = Rsquared - RsquaredSD, ymax = Rsquared + RsquaredSD),
                width = 0.1)+
  theme(axis.text.x = element_text(angle = 25))+
  ggtitle("Rsquared")

b <- ggplot(temp_df, aes(x = model_type, y = RMSE))+
  geom_bar(stat = "identity", fill = "lightgreen", color = "black")+
  geom_errorbar(aes(ymin = RMSE - RMSESD, ymax = RMSE + RMSESD),
                width = 0.1)+
  theme(axis.text.x = element_text(angle = 25))+
  ggtitle("RMSE")

c<- ggplot(temp_df, aes(x = model_type, y = MAE))+
  geom_bar(stat = "identity", fill = "chocolate", color = "black")+
  geom_errorbar(aes(ymin = MAE - MAESD, ymax = MAE + MAESD),
                width = 0.1)+
  theme(axis.text.x = element_text(angle = 25))+
  ggtitle("MAE")

a + b + c
