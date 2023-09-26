# regression analysis
model <- list(
  `a. base` = lm_robust(
    score ~ is_class_level,
    data = df_merged,
    clusters = schoolId,
    se_type = "CR2"
  ),
  b1 = lm_robust(
    score ~ is_class_level + age + is_boy + is_parttime_teacher + is_superior50,
    data = df_merged,
    clusters = schoolId,
    se_type = "CR2"
  ),
  b2 = lm_robust(
    score ~ is_class_level + age + is_boy + is_parttime_teacher +
      is_grade_under25 + is_grade_25_50 + is_grade_50_75,
    data = df_merged,
    clusters = schoolId,
    se_type = "CR2"
  ),
  b3 = lm_robust(
    score ~ is_class_level + age + is_boy + is_parttime_teacher + grade,
    data = df_merged,
    clusters = schoolId,
    se_type = "CR2"
  ),
  `c. class` = lm_robust(
    score ~ age + is_boy + is_parttime_teacher + is_class_level * is_superior50,
    data = df_merged,
    clusters = schoolId,
    se_type = "CR2"
  ),
  `c. age` = lm_robust(
    score ~ is_class_level + is_boy + is_parttime_teacher + age * is_superior50,
    data = df_merged,
    clusters = schoolId,
    se_type = "CR2"
  ),
  `c. is_boy` = lm_robust(
    score ~ is_class_level + age + is_parttime_teacher + is_boy * is_superior50,
    data = df_merged,
    clusters = schoolId,
    se_type = "CR2"
  ),
  `c. parttime` = lm_robust(
    score ~ is_class_level + age + is_boy + is_parttime_teacher * is_superior50,
    data = df_merged,
    clusters = schoolId,
    se_type = "CR2"
  )
)

# Create regression table
regression_table <- msummary(model, gof_omit = "RMSE|AIC|BIC", output = "output/regression_table.png", stars = TRUE)
