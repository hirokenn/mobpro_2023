# read distributed data --------------------------------------------------------
# student characteristics
df_student_characteristics <- read_csv(file = paste0(dir_distributed_data, "/student_characteristics.csv"),
                                       skip = 0,  # 指定した列をスキップする（この場合はなくても変わらない）
                                       locale = locale(encoding = "shift-jis")) %>% 
  rename(stu_id = 生徒ID,
         sch_id = 小学校NUMBER,
         etp_teacher = 非常勤講師,
         age = 年齢,
         gender = 性別,
         half = "成績位置(2グループ)",  # ダブルクオーテーションで括ると括弧も文字列として読み込んでくれる
         quartile = "成績位置(4グループ)",
         percentile = "成績位置(パーセンタイル)")

# treatment status
df_treatment_status <- read_csv(file = paste0(dir_distributed_data, "/school_characteristics.csv"),
                                 skip = 0,
                                 locale = locale(encoding = "UTF-8")) %>% 
  rename(sch_id = 小学校NUMBER,
         tracking = 能力別学級,
         district = 立地)
  
# outcomes
df_outcomes <- read_csv(file = paste0(dir_distributed_data, "/outcomes.csv"),
                        skip = 0,
                        locale = locale(encoding = "shift-jis")) %>% 
  rename(stu_id = 生徒ID,
         score = 学力スコア)

# concatenate all data ---------------------------------------------------------
df_student_characteristics <- df_student_characteristics %>% 
  mutate(stu_id = str_remove(stu_id, "番"),  # mutateで複数列を作成する場合はカンマで繋げられる
         stu_id = as.numeric(stu_id))

df_concatenated <- df_student_characteristics %>% 
  left_join(df_treatment_status, by = "sch_id") %>%  # キー列を複数指定するときはby = c("a", "b")
  left_join(df_outcomes, by = "stu_id")

# clean data -------------------------------------------------------------------
# deficiency handling
deficiency_pattern <- c("unknown", NA, "999", "*", "###")

# 同じ処理を複数列に適用したい場合はmutate(across())を用いる
# %in%はベクトルの要素の一致するものが含まれるかどうかを判別するする論理演算子
# .は%>%の時は前の関数の返り値、mutateでは指定した列を表す。
# チルダ式内では与えた引数を.xで表す。つまりこの時はc(gender, percentile, quartile)が.x
df_cleaned <- df_concatenated %>% 
  mutate(across(c(gender, percentile, quartile), ~if_else(.x %in% deficiency_pattern, NA, .x))) %>% 
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

# output cleaned data ----------------------------------------------------------
saveRDS(df_treatment_status, paste0(dir_cleaned_data, "/df_school.rds"))
saveRDS(df, paste0(dir_cleaned_data, "/df.rds"))
