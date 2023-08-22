library(pacman)
p_load(modelsummary)

dir_data_cleaned <- "./output" 

df_long <- readRDS(paste0(dir_data_cleaned, "/df_long.rds"))
df_short <- readRDS(paste0(dir_data_cleaned, "/df_short.rds"))

reg_short_simple <- lm(formula = "std_score ~ tracking", data = df_short)
reg_short_multi <- lm(formula = "std_score ~ tracking + agetest + etpteacher + girl + topquarter + secondquarter + thirdquarter", data = df_short)
reg_short_cross <- lm(formula = "std_score ~ tracking*bottomhalf + etpteacher + agetest + girl + topquarter + secondquarter + thirdquarter", data = df_short)

reg_long_simple <- lm(formula = "std_score ~ tracking", data = df_long)
reg_long_multi <- lm(formula = "std_score ~ tracking + agetest + etpteacher + girl  + topquarter + secondquarter + thirdquarter", data = df_long)
reg_long_cross <- lm(formula = "std_score ~ tracking*bottomhalf + etpteacher + agetest + girl + topquarter + secondquarter + thirdquarter", data = df_long)

list(
  "共変量なし" = reg_short_simple,
  "共変量あり" = reg_short_multi,
  "交差項" = reg_short_cross
) %>% 
  modelsummary(stars = TRUE, vcov = ~schoolid, title = "短期間")

list(
  "共変量なし" = reg_long_simple,
  "共変量あり" = reg_long_multi,
  "交差項" = reg_long_cross
) %>% 
  modelsummary(stars = TRUE, vcov = ~schoolid, title = "長期間")

