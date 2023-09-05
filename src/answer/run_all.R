p_load::p_load(tidyverse, modelsummary, gt)

dir_distributed_data <- "./data/distributed"
dir_cleaned_data <- "./data/clean"
dir_figure <- "./fig"


# data cleaning
source("./src/answer/cleaning.R")

# summarize data
source("./src/answer/summarization.R")