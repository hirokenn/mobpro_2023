data_describe <- data_cleaned %>% 
  select(treatment, 
         score_std, 
         female,
         age, 
         is_tem_teacher = tem_teacher_dummy,
         is_Bungoma,
         is_score_upper = score_upper_d,
         score_upper_25,
         score_upper_50,
         score_bottom_50,
         score_bottom_25,
         score_order_pct)


summary_statistics <- tbl_summary(data_describe,
            statistic = list(all_continuous() ~ "{mean} ({sd})"))
summary_statistics  %>%  
  as_flex_table( ) %>% 
  save_as_pptx(path = "output/summary_statistics.pptx")


            