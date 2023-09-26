# Selected columns for descriptive statistics
selected_columns <- c(
  "score", "is_parttime_teacher", "age", "grade", "is_boy",
  "is_superior50", "is_grade_under25", "is_grade_25_50", "is_grade_50_75", "is_grade_top25",
  "is_class_level", "is_bungoma"
)

# Define continuous variables
continuous_vars <- c(
  "is_parttime_teacher", "is_boy", "is_superior50", "is_grade_under25",
  "is_grade_25_50", "is_grade_50_75", "is_grade_top25", "is_class_level", "is_bungoma"
)

descriptive_stats_table <- df_merged %>%
  select(all_of(selected_columns)) %>%
  tbl_summary(
    type = setNames(rep("continuous", length(continuous_vars)), continuous_vars),
    missing = "no",
    statistic = list(all_continuous() ~ "{mean} ({sd})")
  )

filename <- "output/summary_table.html"
descriptive_stats_table %>%
  as_gt() %>%
  gtsave(filename = filename)

webshot(filename, file = "output/summary_table.png")
