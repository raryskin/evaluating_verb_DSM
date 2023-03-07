library(here)
setwd(here())
library(tidyverse)
theme_set(theme_bw() + theme(text = element_text(size = 14)))
library(ggdist)
library(reshape2)
library(patchwork)
library(ggpubr)

r.biases <- read_csv(here("data",
                          "ryskin_biases.csv"),
                     show_col_type = F)

ngram_df <- read_tsv(here("data_output",
                          "verb_bias_split.tsv"),
                     show_col_type = F)

## 2000 ----
ngdf.instrument <- ngram_df |> 
  select(c(starts_with("y20"), verb, bias)) |> 
  filter(bias == "instrument") |> 
  pivot_longer(starts_with("y20"),
               names_to = "year",
               values_to = "count")

ngdf.modifier <- ngram_df |> 
  select(c(starts_with("y20"), verb, bias)) |> 
  filter(bias == "modifier") |> 
  pivot_longer(starts_with("y20"),
               names_to = "year",
               values_to = "count")

ngdf.summarized <- ngdf.instrument |> 
  inner_join(ngdf.modifier, by = c("verb", "year")) |> 
  mutate(instrument.prop = (count.x)/(count.x + count.y)*100) |> 
  group_by(verb) |> 
  summarize(mean.ins.prop = mean(instrument.prop, na.rm = T)) |> 
  mutate(decade = "2000")

## 1990 ----
ngdf.instrument <- ngram_df |> 
  select(c(starts_with("y199"), verb, bias)) |> 
  filter(bias == "instrument") |> 
  pivot_longer(starts_with("y199"),
               names_to = "year",
               values_to = "count")

ngdf.modifier <- ngram_df |> 
  select(c(starts_with("y199"), verb, bias)) |> 
  filter(bias == "modifier") |> 
  pivot_longer(starts_with("y199"),
               names_to = "year",
               values_to = "count")

ngdf.temp <- ngdf.instrument |> 
  inner_join(ngdf.modifier, by = c("verb", "year")) |> 
  mutate(instrument.prop = (count.x)/(count.x + count.y)*100) |> 
  group_by(verb) |> 
  summarize(mean.ins.prop = mean(instrument.prop, na.rm = T))|> 
  mutate(decade = "1990")

ngdf.summarized <- ngdf.summarized |> 
  rbind(ngdf.temp)

## 1980 ----
ngdf.instrument <- ngram_df |> 
  select(c(starts_with("y198"), verb, bias)) |> 
  filter(bias == "instrument") |> 
  pivot_longer(starts_with("y198"),
               names_to = "year",
               values_to = "count")

ngdf.modifier <- ngram_df |> 
  select(c(starts_with("y198"), verb, bias)) |> 
  filter(bias == "modifier") |> 
  pivot_longer(starts_with("y198"),
               names_to = "year",
               values_to = "count")

ngdf.temp <- ngdf.instrument |> 
  inner_join(ngdf.modifier, by = c("verb", "year")) |> 
  mutate(instrument.prop = (count.x)/(count.x + count.y)*100) |> 
  group_by(verb) |> 
  summarize(mean.ins.prop = mean(instrument.prop, na.rm = T))|> 
  mutate(decade = "1980")

ngdf.summarized <- ngdf.summarized |> 
  rbind(ngdf.temp)

## 1970 ----
ngdf.instrument <- ngram_df |> 
  select(c(starts_with("y197"), verb, bias)) |> 
  filter(bias == "instrument") |> 
  pivot_longer(starts_with("y197"),
               names_to = "year",
               values_to = "count")

ngdf.modifier <- ngram_df |> 
  select(c(starts_with("y197"), verb, bias)) |> 
  filter(bias == "modifier") |> 
  pivot_longer(starts_with("y197"),
               names_to = "year",
               values_to = "count")

ngdf.temp <- ngdf.instrument |> 
  inner_join(ngdf.modifier, by = c("verb", "year")) |> 
  mutate(instrument.prop = (count.x)/(count.x + count.y)*100) |> 
  group_by(verb) |> 
  summarize(mean.ins.prop = mean(instrument.prop, na.rm = T))|> 
  mutate(decade = "1970")

ngdf.summarized <- ngdf.summarized |> 
  rbind(ngdf.temp)

## 1960 ----
ngdf.instrument <- ngram_df |> 
  select(c(starts_with("y196"), verb, bias)) |> 
  filter(bias == "instrument") |> 
  pivot_longer(starts_with("y196"),
               names_to = "year",
               values_to = "count")

ngdf.modifier <- ngram_df |> 
  select(c(starts_with("y196"), verb, bias)) |> 
  filter(bias == "modifier") |> 
  pivot_longer(starts_with("y196"),
               names_to = "year",
               values_to = "count")

ngdf.temp <- ngdf.instrument |> 
  inner_join(ngdf.modifier, by = c("verb", "year")) |> 
  mutate(instrument.prop = (count.x)/(count.x + count.y)*100) |> 
  group_by(verb) |> 
  summarize(mean.ins.prop = mean(instrument.prop, na.rm = T))|> 
  mutate(decade = "1960")

ngdf.summarized <- ngdf.summarized |> 
  rbind(ngdf.temp)

## 1950 ----
ngdf.instrument <- ngram_df |> 
  select(c(starts_with("y195"), verb, bias)) |> 
  filter(bias == "instrument") |> 
  pivot_longer(starts_with("y195"),
               names_to = "year",
               values_to = "count")

ngdf.modifier <- ngram_df |> 
  select(c(starts_with("y195"), verb, bias)) |> 
  filter(bias == "modifier") |> 
  pivot_longer(starts_with("y195"),
               names_to = "year",
               values_to = "count")

ngdf.temp <- ngdf.instrument |> 
  inner_join(ngdf.modifier, by = c("verb", "year")) |> 
  mutate(instrument.prop = (count.x)/(count.x + count.y)*100) |> 
  group_by(verb) |> 
  summarize(mean.ins.prop = mean(instrument.prop, na.rm = T))|> 
  mutate(decade = "1950")

ngdf.summarized <- ngdf.summarized |> 
  rbind(ngdf.temp)
  

r.biases <- r.biases |> 
  select(-verb) |> 
  rename(verb = verb.cleaned) |> 
  inner_join(ngdf.summarized, by = "verb")

ggplot(r.biases, aes(x = instrument.bias, y = mean.ins.prop))+
  geom_text(aes(label = verb))+
  geom_abline(slope = 1, intercept = 0, linetype = "dashed")+
  xlab("Ryskin paper")+
  ylab("N-grams corpus")+
  geom_smooth(method = "lm")+
  facet_wrap(~decade)+
  stat_cor()+
  ggtitle("Proportion of instrument bias")


r.biases |> 
  group_by(verb, category, instrument.bias) |> 
  summarize(mean.since.1950 = mean(mean.ins.prop)) |> 
  ggplot(aes(x = instrument.bias, y = mean.since.1950))+
  geom_text(aes(label = verb))+
  geom_abline(slope = 1, intercept = 0, linetype = "dashed")+
  xlab("Ryskin paper")+
  ylab("N-grams corpus")+
  geom_smooth(method = "lm")+
  stat_cor()+
  ggtitle("Proportion of instrument bias",
          subtitle = "Mean since 1950")


# 
# cor(r.biases$instrument.bias, r.biases$mean.ins.prop, method = "spearman")
# 
# 
# 
# 
# ngram_df <- ngram_df |> 
#   select(-c("year_count")) |> 
#   pivot_longer(cols = starts_with("y"), 
#                names_to = "year", 
#                values_to = "count")
# 
# ngram_df <- ngram_df |> 
#   mutate(year_int = as.numeric(str_sub(year, 2, 5)))
# 
# for (v in unique(ngram_df$verb)){
#   print(v)
#   
#   da_g1 <- ngram_df |> 
#     filter(verb == v) |> 
#     filter(year_int >= 1900) |> 
#     ggplot(aes(x = year_int, y = count, 
#                color = bias, group = bias))+
#     geom_line()+
#     geom_point(aes(shape = bias))+
#     ylab("Frequency")+
#     scale_color_manual(name = "Bias",
#                        values = c("modifier" = "navy",
#                                   "instrument" = "red4",
#                                   "neither" = "lightblue",
#                                   "no_with" = "orange"))+
#     scale_shape_manual(name = "Bias",
#                        values = c("modifier" = 4,
#                                   "instrument" = 15,
#                                   "neither" = 16,
#                                   "no_with" = 17))+
#     xlab("Year")+
#     scale_x_continuous(breaks = seq(1900, 2010, 10))+
#     ggtitle(paste("Verb:",v))
#   
#   ggsave(plot = da_g1,
#          path = here("graphs"),
#          filename = paste0(v,"_bias_raw_freq.png"),
#          dpi = 300,
#          units = "in",
#          width = 10, height = 5)
# 
#   
#   da_g3 <- ngram_df |> 
#     filter(verb == v) |> 
#     filter(year_int >= 1900) |> 
#     ggplot(aes(x = year_int, y = count, 
#                fill = bias))+
#     geom_bar(stat = "identity", position = "fill", width = 1)+
#     ylab("Proportion")+
#     scale_fill_manual(name = "Bias",
#                       values = c("modifier" = "navy",
#                                  "instrument" = "red4",
#                                  "neither" = "lightblue",
#                                  "no_with" = "orange"))+
#     xlab("Year")+
#     scale_x_continuous(breaks = seq(1900, 2010, 10))+
#     ggtitle(paste("Verb:",v))
#   
#   ggsave(plot = da_g3,
#          path = here("graphs"),
#          filename = paste0(v,"_bias_bar_prop.png"),
#          dpi = 300,
#          units = "in",
#          width = 10, height = 5)
#   
#   
#   
# }