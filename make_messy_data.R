library(pacman)
p_load(tidyverse)

# set directory
dir_clean_data <- "./data/clean"
dir_output <- "./data/destributed"

# read data
df_short_clean <- read_csv(paste0(dir_clean_data, "/df_short2.csv"))

set.seed(0)
random_row_number <- sample(nrow(df_short_clean), nrow(df_short_clean) * 0.1)

# treatment status
df_treatment_status <- df_short_clean %>% 
  distinct(schoolid, tracking, district) %>% 
  rename(小学校NUMBER = schoolid,
         能力別学級 = tracking,
         立地 = district)

write.csv(df_treatment_status,
           file = paste0(dir_output, "/df_treatment_status.csv"),
           fileEncoding = "UTF-8")

# student_characteristics
df_student_characteristics <- df_short_clean %>% 
  select(pupilid, schoolid, etpteacher, agetest, girl) %>% 
  mutate(gender = case_when(girl == 0 ~ "男子",
                            girl == 1 ~ "女子",
                            TRUE ~ "unknown")) %>% 
  mutate(id = as.character(pupilid)) %>% 
  mutate(id = if_else(row_number() %in% random_row_number, paste0(id, "番"), id)) %>% 
  select(生徒ID = id,
         小学校NUMBER = schoolid,
         非常勤講師 = etpteacher,
         年齢 = agetest,
         性別 = girl)

write.csv(df_student_characteristics,
          file = paste0(dir_output, "/df_student_characteristics.csv"),
          fileEncoding = "cp932")
  
# outcomes
df_outcomes <- df_short_clean %>% 
  select(bottomhalf, bottomquarter, secondquarter, thirdquarter, topquarter, percentile, totalscore) %>% 
  mutate(quartile = case_when(bottomquarter == 1 ~ 0,
                              secondquarter == 1 ~ 1,
                              thirdquarter == 1 ~ 2,
                              topquarter == 1 ~ 3,
                              TRUE ~ NA)) %>% 
  mutate(percentile = if_else(is.na(percentile),
                             sample(c(NA, NaN, Inf, "999", "*"), nrow(.), replace = TRUE),
                             as.character(percentile))) %>% 
  mutate(quartile = if_else(is.na(quartile), "###", as.character(quartile))) %>% 
  select(四分位 = quartile,
         パーセンタイル = percentile,
         学力スコア = totalscore)
  
write.csv(df_outcomes,
          file = paste0(dir_output, "/df_outcomes.csv"),
          fileEncoding = "cp932")
