library(pacman)
p_load(tidyverse, modelsummary)

dir_cleand_data <- "./data/tmp"

df_summary <- readRDS(paste0(dir_cleand_data, "/df.rds")) %>% 
  mutate(tracking = if_else(tracking == 1, "treatment", "control"))

summary <- datasummary(std_score + etpteacher + age + girl + percentile + bottomhalf + bottomquarter + secondquarter + thirdquarter ~ tracking * (Mean + SD),
                       data = df_summary, na.rm = TRUE)
summary