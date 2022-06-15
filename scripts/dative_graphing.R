library(here)
setwd(here())
library(tidyverse)
theme_set(theme_bw() + theme(text = element_text(size = 14)))
library(ggdist)
library(reshape2)
library(patchwork)

ngram_df <- read_tsv(here("data_output","dative_alternation_split.tsv"), show_col_type = F)

more_freq_verbs <- ngram_df |> 
  group_by(verb) |> 
  summarize(n = sum(total_count)) |> 
  filter(n > 2000)

ngram_df <- ngram_df |> 
  filter(verb %in% more_freq_verbs$verb)

ngram_df <- ngram_df |> 
  select(-c("year_count")) |> 
  pivot_longer(cols = starts_with("y"), 
               names_to = "year", 
               values_to = "count")

ngram_df <- ngram_df |> 
  mutate(year_int = as.numeric(str_sub(year, 2, 5)))

for (v in unique(ngram_df$verb)){
  print(v)
  
  da_g <- ngram_df |> 
    filter(verb == v) |> 
    filter(year_int >= 1900) |> 
    ggplot(aes(x = year_int, y = count, 
               color = alternation, group = alternation))+
    geom_line()+
    geom_point(aes(shape = alternation))+
    ylab("Frequency")+
    scale_color_manual(name = "Alternation",
                       values = c("dobj" = "navy",
                                  "dobj_pobj" = "red4",
                                  "iobj_dobj" = "lightblue",
                                  "other" = "orange"))+
    scale_shape_manual(name = "Alternation",
                       values = c("dobj" = 4,
                                  "dobj_pobj" = 15,
                                  "iobj_dobj" = 16,
                                  "other" = 17))+
    xlab("Year")+
    scale_x_continuous(breaks = seq(1900, 2010, 10))+
    ggtitle(paste("Verb:",v))
  
  ggsave(plot = da_g,
         path = here("graphs"),
         filename = paste0(v,"_dative_alternation.png"),
         dpi = 300,
         units = "in",
         width = 10, height = 5)
  
  da_g <- ngram_df |> 
    filter(verb == v) |> 
    filter(year_int >= 1900) |> 
    ggplot(aes(x = year_int, y = count, 
               color = alternation, group = alternation))+
    geom_line()+
    geom_point(aes(shape = alternation))+
    ylab("log(Frequency)")+
    scale_color_manual(name = "Alternation",
                       values = c("dobj" = "navy",
                                  "dobj_pobj" = "red4",
                                  "iobj_dobj" = "lightblue",
                                  "other" = "orange"))+
    scale_shape_manual(name = "Alternation",
                       values = c("dobj" = 4,
                                  "dobj_pobj" = 15,
                                  "iobj_dobj" = 16,
                                  "other" = 17))+
    xlab("Year")+
    scale_x_continuous(breaks = seq(1900, 2010, 10))+
    ggtitle(paste("Verb:",v))+
    scale_y_log10()
  
  ggsave(plot = da_g,
         path = here("graphs"),
         filename = paste0(v,"_dative_alternation_log.png"),
         dpi = 300,
         units = "in",
         width = 10, height = 5)
}

# v = "sneak"
# ngram_df |>
#   filter(verb == v) |>
#   filter(year_int >= 1900) |> 
#   ggplot(aes(x = year_int, y = count,
#              color = alternation, group = alternation))+
#   geom_line()+
#   geom_point(aes(shape = alternation))+
#   ylab("Frequency")+
#   scale_color_manual(name = "Alternation",
#                      values = c("dobj" = "navy",
#                                 "dobj_pobj" = "red4",
#                                 "iobj_dobj" = "lightblue",
#                                 "other" = "orange"))+
#   scale_shape_manual(name = "Alternation",
#                      values = c("dobj" = 4,
#                                 "dobj_pobj" = 15,
#                                 "iobj_dobj" = 16,
#                                 "other" = 17))+
#   xlab("Year")+
#   scale_x_continuous(breaks = seq(1900, 2010, 10))+
#   ggtitle(paste("Verb:",v))
