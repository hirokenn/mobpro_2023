all_data <-
  student_characteristics_cleaned%>%
  left_join(school_characteristics_cleaned, by= "school_ID")%>%
  left_join(outcomes_cleaned, by = "student_ID")

# summary_data <-
#   all_data %>%
#   select(-student_ID)

# descriptive stats -------------------------------------------------------

des_summary<-
  all_data %>% 
  select(-student_ID,-grade_rank_2,-grade_rank_4) %>% 
  gtsummary::tbl_summary(
    type= list(c(age,score,scaled_score) ~ "continuous"),
    digits = list(c(grade_rank_percent) ~ 8,
                  c(score) ~ 8),
    statistic = list(c(age,scaled_score,score) ~ "{mean}±{sd}(median:{median}) [min:{min}, max:{max}]")
    )

des_summary_df <- as.data.frame(des_summary)
write.csv(des_summary_df, file = "output/summary_data.csv", fileEncoding = "shift-jis")


# estimate ----------------------------------------------------------------

model_A <- lm(scaled_score ~ treatment_dummy,all_data)
model_B <- lm(scaled_score ~ treatment_dummy + age +female_dummy + temporary 
                                  + upper50_dummy + bottom0_25dummy + bottom25_50dummy
                                  + upper0_25dummy + grade_rank_percent,all_data,cluster="school_ID")
model_C <- lm(scaled_score ~ treatment_dummy + age +female_dummy + temporary 
              + upper50_dummy + bottom0_25dummy + bottom25_50dummy
              + upper0_25dummy + grade_rank_percent + treatment_dummy*upper50_dummy,all_data,cluster="schoolID")

estimate_summary_list <- list()
estimate_summary_list[['result_uncontrol']] <- model_A
estimate_summary_list[['result_control']] <- model_B
estimate_summary_list[['result_heteroge']] <- model_C

estimate_summary <-
      modelsummary::msummary(estimate_summary_list, stars=TRUE)

estimate_summary_df <- as.data.frame(estimate_summary)
write.csv(estimate_summary_df, file = "output/estimate_summary_data.csv", fileEncoding = "shift-jis")
