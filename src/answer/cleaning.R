library(pacman)
p_load(tidyverse)

dir_distributed_data <- "./data/distributed"
dir_cleaned_data <- "./data/cleaned"

# read distributed data---------------------------------------------------------
# student characteristics
df_student_characteristics <- read_csv(file = paste0(dir_distributed_data, "/student_characteristics.csv"),
                                       skip = 0,
                                       locale = locale(encoding = "shift-jis")) %>% 
  rename(stu_id = 生徒ID,
         sch_id = 小学校NUMBER,
         etpteacher = 非常勤講師,
         age = 年齢,
         gender = 性別)

# treatment status
df_treatment_status <- read_csv(file = paste0(dir_distributed_data, "/treatment_status.csv"),
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
         quartile = 四分位,
         percentile = パーセンタイル,
         score = 学力スコア)

# concatenate all data----------------------------------------------------------
df_student_characteristics <- df_student_characteristics %>% 
  mutate(stu_id = str_remove(stu_id, "番"), 
         stu_id = as.numeric(stu_id))

df_concatenated <- df_student_characteristics %>% 
  left_join(df_treatment_status, by = "sch_id") %>% 
  left_join(df_outcomes, by = "stu_id")

# clean data--------------------------------------------------------------------
# deficiency handling
deficiency_pattern <- c("unknown", NA, NaN, Inf, "999", "*", "###")

df_cleaned <- df_concatenated %>% 
  mutate(across(c(gender, percentile, quartile), ~if_else(. %in% deficiency_pattern, NA, .))) %>% 
  mutate(percentile = as.numeric(percentile))

# make dummy variables
df_numeric <- df_cleaned %>% 
  mutate(is_girl = if_else(gender == "女子", 1, 0),
         in_bungoma = if_else(district == "BUNGOMA", 1, 0),
         bottomhalf = if_else(quartile <= 1, 1, 0),
         bottomquarter = if_else(quartile == 0, 1, 0),
         secondquarter = if_else(quartile == 1, 1,0),
         thirdquarter = if_else(quartile == 2, 1, 0)) %>%
  select(-gender, -district, -quartile)

# scale score
df <- df_numeric %>% 
  mutate(std_score = drop(scale(score)))

# output cleaned data-----------------------------------------------------------
saveRDS(df, paste0(dir_cleaned_data, "/df.rds"))
