# read distributed data --------------------------------------------------------
# student characteristics
df_student_characteristics <- read_csv(file = paste0(dir_distributed_data, "/student_characteristics.csv"),
                                       skip = 0,  # 指定した列をスキップする（この場合はなくても変わらない）
                                       locale = locale(encoding = "shift-jis")) 

# treatment status
df_treatment_status <- read_csv(file = paste0(dir_distributed_data, "/school_characteristics.csv"),
                                skip = 0,
                                locale = locale(encoding = "UTF-8"))

# outcomes
df_outcomes <- read_csv(file = paste0(dir_distributed_data, "/outcomes.csv"),
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
  mutate(student_id = str_remove(student_id, "番"),  # mutateで複数列を作成する場合はカンマで繋げられる
         student_id = as.numeric(student_id))

# missing values
missing_pattern <- c("unknown", NA, "999", "*", "###")

df_student_characteristics <-
  df_student_characteristics %>% 
  mutate(across(c(gender, half, quarter, percentile), 
                ~if_else(.x %in% missing_pattern, NA_character_, .x))) %>% 
  mutate(percentile = as.numeric(percentile))

# make dummy variables
df_numeric <- df_cleaned %>% 
  mutate(is_girl = if_else(gender == "女子", 1, 0),
         in_bungoma = if_else(district == "BUNGOMA", 1, 0),
         in_butere = if_else(district == "BUTERE/M", 1, 0),
         bottom_half = if_else(half == "下位50%", 1, 0),
         top_half = if_else(half == "上位50%", 1, 0),
         bottom_quarter = if_else(quartile == "下位25%", 1, 0),
         second_quarter = if_else(quartile == "下位25-50%", 1,0),
         third_quarter = if_else(quartile == "上位25-50%", 1, 0),
         top_quarter = if_else(quartile == "上位25%", 1, 0))


# scale score
df <- df_numeric %>% 
  mutate(std_score = drop(scale(score)))  # scale関数の返り値はmatrixなのでdrop関数でベクトルに直す


# concatenate all data ---------------------------------------------------------


df_concatenated <- df_student_characteristics %>% 
  left_join(df_treatment_status, by = "sch_id") %>%  # キー列を複数指定するときはby = c("a", "b")
  left_join(df_outcomes, by = "stu_id")


# output cleaned data ----------------------------------------------------------
saveRDS(df_treatment_status, paste0(dir_cleaned_data, "/df_school.rds"))
saveRDS(df, paste0(dir_cleaned_data, "/df.rds"))
