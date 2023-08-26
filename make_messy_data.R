library(pacman)
p_load(tidyverse)

# set directory
dir_clean_data <- "./data/clean"
dir_output <- "./data/output"

# read data
df_short_clean <- read_csv(paste0(dir_clean_data, "/df_short.csv"))
df_long_clean <- read_csv(paste0(dir_clean_data, "/df_long.csv"))

# set random rows
set.seed(0)
random_row_number <- sample(nrow(df_short_clean), nrow(df_short_clean) * 0.1)

df_short_messy <- df_short_clean %>% 
  mutate(gender = case_when(girl == 0 ~ "男子",
                            girl == 1 ~ "女子",
                            TRUE ~ "unknown")) %>% 
  mutate(id = as.character(pupilid)) %>% 
  mutate(id = if_else(row_number() %in% random_row_number, paste0(id, "番"), id)) %>% 
  mutate(percentile = if_else(is.na(percentile), -1, percentile))

df_long_messy <- df_long_clean %>% 
  mutate(random_na = if_else(is.na(r2_totalscore),
                             sample(c(NA, NaN, Inf, "999", "*"), nrow(.), replace = TRUE),
                             as.character(r2_totalscore)))

df_short_distribution <- df_short_messy %>% 
  select(生徒ID = id,
         小学校ごとの識別番号 = schoolid,
         能力別学級 = tracking,
         非常勤講師のクラスに割り当てられた学生 = etpteacher,
         テスト時の生徒の年齢 = agetest,
         性別 = gender,
         最初の分布における生徒のパーセンタイル = percentile,
         プログラム終了時学力スコア = totalscore)

df_long_distribution <- df_long_messy %>% 
  select(生徒ID = pupilid,
         プログラム終了後1年時点の学力スコア = random_na)

write.csv2(df_short_distribution,
           file = paste0(dir_output, "/プログラム終了時データ（配布用）.csv"),
           row.names = FALSE,
           fileEncoding = "UTF-8")

write.csv(df_long_distribution,
          file = paste0(dir_output, "/プログラム終了後一年時データ（配布用）.csv"),
          row.names = FALSE,
          fileEncoding = "cp932")
