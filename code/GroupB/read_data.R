# import data
df_student <- read_csv("./data/distributed/student_characteristics.csv",
    locale = locale(encoding = "shift-jis"), show_col_types = FALSE,
    col_names = c("studentId", "schoolId", "is_parttime_teacher", "age", "sex", "grade_group2", "grade_group4", "grade"), skip = 1
)
df_outcomes <- read_csv("./data/distributed/outcomes.csv",
    locale = locale(encoding = "shift-jis"), show_col_types = FALSE,
    col_names = c("studentId", "score"), skip = 1
)
df_school <- read_csv("./data/distributed/school_characteristics.csv",
    show_col_types = FALSE,
    col_names = c("schoolId", "is_class_level", "location"), skip = 1
)
