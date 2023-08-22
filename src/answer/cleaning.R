library(pacman)
p_load(tidyverse)

dir_distributed_data <- "./output"
dir_cleaned_data <- "./tmp"

df_short <- read_csv2(file = paste0(dir_distributed_data, "/プログラム終了時データ（配布用）.csv")) %>% 
  rename(id = 生徒ID,
         sch_id = 小学校ごとの識別番号, 
         tracking = 能力別学級,
         etpteacher = 非常勤講師のクラスに割り当てられた学生,
         age = テスト時の生徒の年齢,
         gender = 性別,
         percentile = 最初の分布における生徒のパーセンタイル,
         score_short = プログラム終了時学力スコア)

df_long <- read_csv(file = paste0(dir_distributed_data, "/プログラム終了後一年時データ（配布用）.csv"), locale = locale(encoding = "shift-jis")) %>% 
  rename(id = 生徒ID,
         score_long = プログラム終了後1年時点の学力スコア)
  
df_short_cleaned <- df_short %>% 
  mutate(gender = case_when(gender == "女子" ~ 1,
                            gender == "男子" ~ 0,
                            TRUE ~ NA)) %>% 
  mutate(id = str_remove(id, "番")) %>% 
  mutate(bottomhalf = case_when(percentile == -1 ~ NA,
                                percentile > 50 ~ 0,
                                TRUE ~ 1))

df_long_cleaned <- df_long %>% 
  mutate(id = as.character(id)) %>% 
  mutate(score_long = if_else(score_long %in% c(NA, NaN, Inf, "999", "*") , NA, score_long)) %>% 
  mutate(score_long = as.numeric(score_long))

df <- left_join(df_short_cleaned, df_long_cleaned, by = "id")

saveRDS(df, paste0(dir_cleaned_data, "/df.rds"))
