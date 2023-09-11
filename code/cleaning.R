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
  mutate(student_id = str_remove(student_id, "番"))  # mutateで複数列を作成する場合はカンマで繋げられる

# missing values
missing_pattern <- c("unknown", NA, "999", "*", "###")

df_student_characteristics <-
  df_student_characteristics %>% 
  mutate(across(c(gender, half, quarter, percentile), 
                ~if_else(.x %in% missing_pattern, NA_character_, .x))) %>% 
  mutate(percentile = as.numeric(percentile))


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
  mutate(std_score = drop(scale(score)))  


# output cleaned data ----------------------------------------------------------
saveRDS(df, paste0(dir_cleaned_data, "/df_clean.rds"))
