library(pacman)
p_load(modelsummary)

dir_data_cleaned <- "./tmp" 

df <- readRDS(paste0(dir_data_cleaned, "/df.rds"))

