# set up -----------------------------------------------------------------------
pacman::p_load(tidyverse, modelsummary, kableExtra)

dir_distributed_data <- "./data/distributed"
dir_cleaned_data <- "./data/clean"
dir_source <- "./src/answer"
dir_figure <- "./fig"

# run scripts ------------------------------------------------------------------
# data cleaning
source(paste0(dir_source, "/cleaning.R"))

# summarize data
source(paste0(dir_source, "/summarization.R"))

# balance test
source(paste0(dir_source, "/balance_test.R"))

# regression analysis
source(paste0(dir_source, "/estimation.R"))
