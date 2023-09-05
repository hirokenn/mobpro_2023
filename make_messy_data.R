library(pacman)
p_load(tidyverse)

# set directory
dir_clean_data <- "./data/clean"
dir_output <- "./data/distributed"

# read data
df_short_clean <- read_csv(paste0(dir_clean_data, "/df_short2.csv"))

set.seed(0)
random_row_number <- sample(nrow(df_short_clean), nrow(df_short_clean) * 0.1)


# school characteristics --------------------------------------------------

df_school_characteristics <- df_short_clean %>% 
  distinct(schoolid, tracking, district) %>% 
  rename(小学校NUMBER = schoolid,
         能力別学級 = tracking,
         立地 = district)

write.csv(df_school_characteristics,
          file = paste0(dir_output, "/school_characteristics.csv"),
          row.names = FALSE, 
          fileEncoding = "UTF-8")


# student_characteristics -------------------------------------------------

df_student_characteristics <- df_short_clean %>% 
  select(pupilid, schoolid, etpteacher, agetest, girl, 
         bottomhalf, bottomquarter, secondquarter, thirdquarter, topquarter, percentile) %>% 
  mutate(gender = case_when(girl == 0 ~ "男子",
                            girl == 1 ~ "女子",
                            TRUE ~ "unknown")) %>% 
  mutate(id = as.character(pupilid)) %>% 
  mutate(id = if_else(row_number() %in% random_row_number, paste0(id, "番"), id)) %>% 
  mutate(half = case_when(is.na(percentile) ~ NA,
                          bottomhalf == 1 ~ "下位50%",
                          bottomhalf == 0 ~ "上位50%")) %>% 
  mutate(quarter = case_when(is.na(percentile) ~ NA,
                             bottomquarter == 1 ~ "下位25%",
                             secondquarter == 1 ~ "下位25-50%",
                             thirdquarter == 1 ~ "上位25-50%",
                             TRUE ~ "上位25%")) %>% 
  mutate(percentile = if_else(is.na(percentile),
                              sample(c(NA, "999", "*"), nrow(.), replace = TRUE),
                              as.character(percentile))) %>% 
  mutate(half = if_else(is.na(half),
                           "###",
                           as.character(half)),
         quarter = if_else(is.na(quarter),
                            "###",
                            as.character(quarter))) %>% 
  select(生徒ID = id,
         小学校NUMBER = schoolid,
         非常勤講師 = etpteacher,
         年齢 = agetest,
         性別 = gender,
         "成績位置(2グループ)" = half,
         "成績位置(4グループ)" = quarter,
         "成績位置(パーセンタイル)" = percentile)

write.csv(df_student_characteristics,
          file = paste0(dir_output, "/student_characteristics.csv"),
          row.names = FALSE, 
          fileEncoding = "cp932")
  

# outcomes ----------------------------------------------------------------

df_outcomes <- df_short_clean %>% 
  select(pupilid, totalscore) %>% 
  select(生徒ID = pupilid,
         学力スコア = totalscore)
  
write.csv(df_outcomes,
          file = paste0(dir_output, "/outcomes.csv"),
          row.names = FALSE, 
          fileEncoding = "cp932")
