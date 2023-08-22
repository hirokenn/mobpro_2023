library(pacman)
p_load(tidyverse)

dir_data <- "./output"
dir_data_cleaned <- "./tmp" 

df_short_clean <- read_csv("./clean/df_short.csv")
df_long_clean <- read_csv("./clean/df_long.csv")

df_long <- left_join(df_short_clean, df_long_clean, by = "pupilid") %>% 
  select(- std_mark, - totalscore) %>% 
  mutate(std_score = scale(r2_totalscore))

df_short <- df_short_clean %>% 
  mutate(std_score = scale(totalscore))

saveRDS(df_short, file = paste0(dir_data, "/df_short.rds"))
saveRDS(df_long, file = paste0(dir_data, "/df_long.rds"))

