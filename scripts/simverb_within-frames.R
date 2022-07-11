library(here)
setwd(here())
library(tidyverse)
library(patchwork)
library(janitor)
library(ggrepel)

theme_set(theme_minimal() + theme(text =  element_text(size = 14)))

simverb <- read_csv(here("data_output",
                            "simverb_within-frames.csv"), 
                       show_col_type = F)

simverb <- simverb |> 
  clean_names()

get_subdf <- function(dataset, string_Vector){
  share_summary <- dataset |> 
    group_by(.dots = string_Vector) |> 
    summarize(mean_sv_score = mean(sv_score))
  
  sh_df <- share_summary |>
    pivot_wider(names_from = all_of(string_Vector), values_from = mean_sv_score) |> 
    rename(shared = `TRUE`, not_shared = `FALSE`) |> 
    mutate(type = string_Vector)
  
  return(sh_df)
}



frames_to_check = make_clean_names(c('(SUBCAT ADL)','(SUBCAT MP)','ADJP','ADJP-PP','ADVP-PRED','Attribute Object Possessor-Attribute Factoring Alternation','Basic Intransitive','Basic Transitive','Benefactive Alternation','Characteristic Property of Instrument','Conative','Dative','FOR-TO-INF','HOW-S','HOW-TO-INF','ING-AC','ING-NP-OMIT','ING-SC/BE-ING','ING-SC/BE-ING-SC','Infinitival Copular Clause','Instrument Subject Alternation','Intransitive','Location Subject Alternation','Locative Inversion','Locative Preposition Drop','Locatum Subject Alternation','Material/Product Alternation Transitive','Middle Construction','NP','NP-ADJP','NP-ADJP-PP','NP-ADJP-PRED','NP-ADVP-PRED','NP-HOW-S','NP-HOW-TO-INF','NP-ING-SC','NP-NP','NP-NP-PP','NP-NP-PRED','NP-P-ING','NP-P-ING-AC','NP-P-ING-OC','NP-P-ING-SC','NP-PP','NP-PP-PP','NP-QUOT','NP-S','NP-TO-INF-OC','NP-TOBE','NP-VEN-NP-OMIT','NP-WH-S','NP-WH-TO-INF','NP-WHAT-S','NP-WHAT-TO-INF','None','P-ING-SC','P-NP-ING','P-NP-TO-INF','P-POSSING','P-WH-S','P-WH-TO-INF','P-WHAT-S','P-WHAT-TO-INF','PART-NP','POSSING','PP','PP-HOW-S','PP-HOW-TO-INF','PP-NP','PP-P-WH-S','PP-P-WH-TO-INF','PP-P-WHAT-S','PP-P-WHAT-TO-INF','PP-PP','PP-QUOT','PP-S','PP-THAT-S-SUBJUNCT','PP-TO-INF-OC','PP-WH-S','PP-WHAT-S','PRO-Arb Object Alternation','QUOT','Raw Material Subject','Reflexive of Appearance','S','S-SUBJUNCT','SEEM-S','Simple Reciprocal Intransitive','Simple Reciprocal Transitive','THAT-S','TO-INF-AC','TO-INF-SC','TO-INFN-SC','There-insertion','Together Reciprocal Alternation Intransitive','Together Reciprocal Alternation Transitive','Transitive','Understood Reciprocal Object','Unintentional Interpretation of Object','Unspecified Object','Unspecified Reflexive Object','WH-S','WH-TO-INF','WHAT-S','WHAT-TO-INF','With Preposition Drop'))

sh_df <- data.frame()

for (ii in 1:length(frames_to_check)){
  target_frame = frames_to_check[ii]
  
  share_summary <- simverb |> 
    group_by(.dots = target_frame) |> 
    summarize(mean_sv_score = mean(sv_score))
  
  # print(share_summary)
  if (nrow(share_summary) > 1){
    temp <- get_subdf(simverb, target_frame)
    
    sh_df <- sh_df |> 
      rbind(temp)
  }
  
  
}

zoom <- ggplot(sh_df, aes(x =shared, y = not_shared))+
  geom_point(shape = 21, fill = "lightblue")+
  # geom_label_repel(aes(x = shared, y = not_shared, label = type), 
                  # box.padding = 0.5, max.overlaps = Inf)+
  geom_abline(slope = 1, intercept = 0)+
  # xlim(0, 10)+
  # ylim(0, 10)+
  xlab("Shares a frame")+
  ylab("No frame shared")+
  labs(caption = "Same plot, zoomed in")
  # ggtitle("Average similarity score for pairs\nthat (do not) share a syntax frame")

zoom_out <- ggplot(sh_df, aes(x =shared, y = not_shared))+
  geom_point(shape = 21, fill = "lightblue")+
  # geom_label_repel(aes(x = shared, y = not_shared, label = type), 
  # box.padding = 0.5, max.overlaps = Inf)+
  geom_abline(slope = 1, intercept = 0)+
  xlim(0, 10)+
  ylim(0, 10)+
  xlab("Shares a frame")+
  ylab("No frame shared")+
  ggtitle("Average similarity scores between verb pairs")

zoom_out + zoom
