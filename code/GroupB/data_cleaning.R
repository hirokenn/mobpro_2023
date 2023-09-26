# clean df_student
## grade -- remove 999, *
## grade_group --- remove ###
## grade_group2 --- remove ###
## is_boy --- remove unknown
## studentId --- remove "番"

# Clean df_student
df_student <- df_student %>%
  mutate(
    grade = replace(grade, grade %in% c("999", "*"), NA),
    grade_group4 = replace(grade_group4, grade_group4 == "###", NA),
    grade_group2 = replace(grade_group2, grade_group2 == "###", NA),
    sex = replace(sex, sex == "unknown", NA),
    studentId = str_replace_all(studentId, "番", ""),
    is_boy = if_else(sex == "男子", 1, if_else(is.na(sex), NA, 0)),
    is_superior50 = if_else(grade_group2 == "上位50%", 1, if_else(is.na(grade_group2), NA, 0)),
    is_grade_under25 = if_else(grade_group4 == "下位25%", 1, if_else(is.na(grade_group4), NA, 0)),
    is_grade_25_50 = if_else(grade_group4 == "下位25-50%", 1, if_else(is.na(grade_group4), NA, 0)),
    is_grade_50_75 = if_else(grade_group4 == "上位25-50%", 1, if_else(is.na(grade_group4), NA, 0)),
    is_grade_top25 = if_else(grade_group4 == "上位25%", 1, if_else(is.na(grade_group4), NA, 0)),
    grade = as.numeric(grade),
    studentId = as.numeric(studentId)
  )

# Clean df_school
df_school <- df_school %>%
  mutate(is_bungoma = if_else(location == "BUNGOMA", 1, 0))

# Standardize df_outcomes
df_outcomes <- df_outcomes %>%
  mutate(score = (score - mean(score)) / sd(score))

# Merge data
df_merged <- df_outcomes %>%
  left_join(df_student, by = "studentId") %>%
  left_join(df_school, by = "schoolId")

write_csv(df_merged, "data/clean/GroupB/df_merged.csv")
