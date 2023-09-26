data_stu_nacoding <- data_stu_rename %>%
  mutate(studentID = as.numeric(str_remove_all(studentID , "番")),
         gender = ifelse(gender == "unknown", NA, gender),
         score_order_2 = ifelse(score_order_2 == "###" , NA , score_order_2),
         score_order_4 = ifelse(score_order_4 == "###" , NA , score_order_4),
         score_order_pct = as.numeric(ifelse(score_order_pct %in% c("999","*") , NA , score_order_pct))
         )
