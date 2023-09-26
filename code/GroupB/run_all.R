# Libraries
library(tidyverse)
library(estimatr)
library(modelsummary)
library(gtsummary)
library(gt)
library(magick)
library(webshot)

# Ensure phantomjs is installed
webshot::install_phantomjs()

# Read data
source("./code/read_data.R")

# Data cleaning
source("./code/data_cleaning.R")

# Descriptive statistics
source("./code/descriptional.R")

# Analysis
source("./code/analysis.R")
