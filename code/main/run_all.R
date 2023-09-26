# set up -----------------------------------------------------------------------
pacman::p_load(tidyverse, modelsummary, kableExtra, estimatr)

dir_cleaned_data <- here::here("data/clean/main")
dir_distributed_data <- here::here("data/distributed")
dir_source <- here::here("code/main")
dir_figure <- here::here("output")

# run scripts ------------------------------------------------------------------
# data cleaning
# source(paste0(dir_source, "/cleaning.R"))

# summarize data
source(paste0(dir_source, "/summarization.R"))

# balance test
source(paste0(dir_source, "/balance_test.R"))

# regression analysis
source(paste0(dir_source, "/estimation.R"))
