library(pacman)
p_load(gt, modelsummary)

dir_cleand_data <- "./tmp"

df <- readRDS(paste0(dir_cleand_data, "/df.rds")) %>% 
  as.data.frame()

summary <- datasummary(score_short + score_long + etpteacher + age + gender + percentile + bottomhalf ~ as.factor(tracking) * (Mean + SD),
                       data = df, na.rm = TRUE) %>% 
  tab_spanner(label = "能力別", columns = "o")
