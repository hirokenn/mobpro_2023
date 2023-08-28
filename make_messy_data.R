library(pacman)
p_load(tidyverse)

# set directory
dir_clean_data <- "./data/clean"
dir_output <- "./data/distributed"

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
          file = paste0(dir_output, "/treatment_status.csv"),
          row.names = FALSE, 
          fileEncoding = "UTF-8")

# student_characteristics
df_student_characteristics <- df_short_clean %>% 
  select(pupilid, schoolid, etpteacher, agetest, girl, bottomhalf, bottomquarter, secondquarter, thirdquarter, topquarter, percentile) %>% 
  mutate(gender = case_when(girl == 0 ~ "男子",
                            girl == 1 ~ "女子",
                            TRUE ~ "unknown")) %>% 
  mutate(id = as.character(pupilid)) %>% 
  mutate(id = if_else(row_number() %in% random_row_number, paste0(id, "番"), id)) %>% 
  mutate(quartile = case_when(is.na(percentile) ~ NA,
                              bottomquarter == 1 ~ 0,
                              secondquarter == 1 ~ 1,
                              thirdquarter == 1 ~ 2,
                              TRUE ~ 3)) %>% 
  mutate(percentile = if_else(is.na(percentile),
                              sample(c(NA, "999", "*"), nrow(.), replace = TRUE),
                              as.character(percentile))) %>% 
  mutate(quartile = if_else(is.na(quartile),
                            "###",
                            as.character(quartile))) %>% 
  select(生徒ID = id,
         小学校NUMBER = schoolid,
         非常勤講師 = etpteacher,
         年齢 = agetest,
         性別 = gender)

write.csv(df_student_characteristics,
          file = paste0(dir_output, "/student_characteristics.csv"),
          row.names = FALSE, 
          fileEncoding = "cp932")
  
# outcomes
df_outcomes <- df_short_clean %>% 
  select(pupilid, totalscore) %>% 
  select(生徒ID = pupilid,
         四分位 = quartile,
         パーセンタイル = percentile,
         学力スコア = totalscore)
  
write.csv(df_outcomes,
          file = paste0(dir_output, "/outcomes.csv"),
          row.names = FALSE, 
          fileEncoding = "cp932")
