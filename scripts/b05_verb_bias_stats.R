library(here)
setwd(here())
library(tidyverse)
theme_set(theme_bw() + theme(text = element_text(size = 14)))
library(ggdist)
library(reshape2)
library(patchwork)

r.biases <- read_csv(here("data",
                          "ryskin_biases.csv"),
                     show_col_type = F)

ngram_df <- read_tsv(here("data_output",
                          "verb_bias_split.tsv"),
                     show_col_type = F)

ngdf.2000 <- ngram_df |> 
  select(-c(starts_with("y18"), 
            starts_with("y17"), 
            starts_with("y19"),
            year_count))

# ngdf.2000 <- ngdf.2000 |> 
#   rowwise() |> 
#   mutate(y20.mean = mean(c(y2000, y2001, y2002, 
#                            y2003, y2004, y2005, 
#                            y2006, y2007, y2008), 
#                          na.rm = T)) |> 
#   filter(bias == "modifier" | bias == "instrument")

ngdf.sample <- ngdf.2000 |> 
  filter(verb == "spot") |> 
  filter(bias == "modifier" | bias == "instrument") |> 
  pivot_longer(starts_with("y20"),
               names_to = "year",
               values_to = "count")


ngram_df <- ngram_df |> 
  select(-c("year_count")) |> 
  pivot_longer(cols = starts_with("y"), 
               names_to = "year", 
               values_to = "count")

ngram_df <- ngram_df |> 
  mutate(year_int = as.numeric(str_sub(year, 2, 5)))

for (v in unique(ngram_df$verb)){
  print(v)
  
  da_g1 <- ngram_df |> 
    filter(verb == v) |> 
    filter(year_int >= 1900) |> 
    ggplot(aes(x = year_int, y = count, 
               color = bias, group = bias))+
    geom_line()+
    geom_point(aes(shape = bias))+
    ylab("Frequency")+
    scale_color_manual(name = "Bias",
                       values = c("modifier" = "navy",
                                  "instrument" = "red4",
                                  "neither" = "lightblue",
                                  "no_with" = "orange"))+
    scale_shape_manual(name = "Bias",
                       values = c("modifier" = 4,
                                  "instrument" = 15,
                                  "neither" = 16,
                                  "no_with" = 17))+
    xlab("Year")+
    scale_x_continuous(breaks = seq(1900, 2010, 10))+
    ggtitle(paste("Verb:",v))
  
  ggsave(plot = da_g1,
         path = here("graphs"),
         filename = paste0(v,"_bias_raw_freq.png"),
         dpi = 300,
         units = "in",
         width = 10, height = 5)

  
  da_g3 <- ngram_df |> 
    filter(verb == v) |> 
    filter(year_int >= 1900) |> 
    ggplot(aes(x = year_int, y = count, 
               fill = bias))+
    geom_bar(stat = "identity", position = "fill", width = 1)+
    ylab("Proportion")+
    scale_fill_manual(name = "Bias",
                      values = c("modifier" = "navy",
                                 "instrument" = "red4",
                                 "neither" = "lightblue",
                                 "no_with" = "orange"))+
    xlab("Year")+
    scale_x_continuous(breaks = seq(1900, 2010, 10))+
    ggtitle(paste("Verb:",v))
  
  ggsave(plot = da_g3,
         path = here("graphs"),
         filename = paste0(v,"_bias_bar_prop.png"),
         dpi = 300,
         units = "in",
         width = 10, height = 5)
  
  
  
}