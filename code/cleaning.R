# read distributed data --------------------------------------------------------
# student characteristics
df_student_characteristics <- 
  read_csv(file = paste0(dir_distributed_data, "/student_characteristics.csv"),
           skip = 0,  # 指定した列をスキップする（この場合はなくても変わらない）
           locale = locale(encoding = "shift-jis")) 

# treatment status
df_treatment_status <- 
  read_csv(file = paste0(dir_distributed_data, "/school_characteristics.csv"),
           skip = 0,
           locale = locale(encoding = "UTF-8"))

# outcomes
df_outcomes <- 
  read_csv(file = paste0(dir_distributed_data, "/outcomes.csv"),
           col_types = "cd",
           skip = 0,
           locale = locale(encoding = "shift-jis"))



# rename variables --------------------------------------------------------

jp_to_eng <-
  c("生徒ID" = "student_id", 
    "学力スコア" = "score", 
    "小学校NUMBER" = "school_id",
    "能力別学級" = "tracking",
    "立地" = "district",
    "非常勤講師" = "etp_teacher",
    "年齢" = "age",
    "性別" = "gender",
    "成績位置(2グループ)" = "half",  
    "成績位置(4グループ)" = "quarter",
    "成績位置(パーセンタイル)" = "percentile") 

df_student_characteristics <- df_student_characteristics %>% 
  rename_with(.cols = any_of(names(jp_to_eng)), 
              .fn = ~ {jp_to_eng[.x]})

df_treatment_status <- df_treatment_status %>% 
  rename_with(.cols = any_of(names(jp_to_eng)), 
              .fn = ~ {jp_to_eng[.x]})

df_outcomes <- df_outcomes %>% 
  rename_with(.cols = any_of(names(jp_to_eng)), 
              .fn = ~ {jp_to_eng[.x]})


# clean data -------------------------------------------------------------------

# garbles
df_student_characteristics <- df_student_characteristics %>% 
  mutate(student_id = str_remove(student_id, "番")) 

# missing values
missing_pattern <- c("unknown", NA, "999", "*", "###")

df_student_characteristics <-
  df_student_characteristics %>% 
  mutate(across(c(gender, half, quarter, percentile), 
                ~if_else(.x %in% missing_pattern, NA_character_, .x))) %>% 
  mutate(percentile = as.numeric(percentile))

# save cleaned data -------------------------------------------------------

saveRDS(df_student_characteristics, paste0(dir_cleaned_data, "/df_student_characteristics.rds"))
saveRDS(df_treatment_status, paste0(dir_cleaned_data, "/df_treatment_status.rds"))
saveRDS(df_outcomes, paste0(dir_cleaned_data, "/df_outcomes.rds"))

