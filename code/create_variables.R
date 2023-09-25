
# df_student_characteristics <- readRDS(paste0(dir_cleaned_data, "/df_student_characteristics.rds"))
# df_treatment_status <- readRDS(paste0(dir_cleaned_data, "/df_treatment_status.rds"))
# df_outcomes <- readRDS(paste0(dir_cleaned_data, "/df_outcomes.rds"))

# join data ---------------------------------------------------------------

df_concatenated <- df_student_characteristics %>% 
  left_join(df_treatment_status, by = "school_id") %>%  
  left_join(df_outcomes, by = "student_id")

# make variables ----------------------------------------------------------

# make dummy variables
df <- df_concatenated %>% 
  mutate(is_girl = if_else(gender == "女子", 1, 0),
         in_bungoma = if_else(district == "BUNGOMA", 1, 0)) %>% 
  fastDummies::dummy_cols(select_columns = c("half", "quarter"), ignore_na = T) %>% 
  rename_with(.cols = paste("half", c("上位50%", "下位50%"), sep = "_"), 
              .fn = ~{paste("half", c("top", "bottom"), sep = "_")}) %>% 
  rename_with(.cols = paste("quarter", c("上位25%", "上位25-50%", "下位25-50%", "下位25%"), sep = "_"), 
              .fn = ~{paste("quarter", c("top", "second", "third", "bottom"), sep = "_")}) %>% 
  select(-gender, -half, -quarter)


# scale score
df <- df %>% 
  # 元論文に従い、nontracking schoolのmeanで標準化
  mutate(std_score = drop(scale(score, center = mean(score[tracking == 0]))))  


# output cleaned data ----------------------------------------------------------
saveRDS(df, paste0(dir_cleaned_data, "/df_main.rds"))
