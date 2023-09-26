data_cleaned <- data_all %>% 
  mutate(female = case_when(gender == "女子"~1,
                            gender == "男子"~0),
         score_upper_d = case_when(score_order_2 == "上位50%"~1,
                                   score_order_2 == "下位50%"~0),
         score_upper_25 = case_when(score_order_4 == "上位25%"~1,
                                    is.na(score_order_4) ~NA,
                                    T ~ 0),
         score_upper_50 = case_when(score_order_4 == "上位25-50%"~1,
                                    is.na(score_order_4) ~NA,
                                    T ~ 0),
         score_bottom_50 = case_when(score_order_4 == "下位25-50%"~1,
                                    is.na(score_order_4) ~NA,
                                    T ~ 0),
         score_bottom_25 = case_when(score_order_4 == "下位25%"~1,
                                     is.na(score_order_4) ~NA,
                                     T ~ 0),
         is_Bungoma = case_when(locate_category == "BUNGOMA"~1,
                                locate_category == "BUTERE/M"~0),
         score_std = (score - mean(score)) / sd(score))

saveRDS(data_cleaned, file = "data/clean/GroupCD/data_cleaned.RDS")
