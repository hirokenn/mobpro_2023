data_all <- data_stu_nacoding %>% 
  left_join(data_outcomes_rename,
            by = "studentID") %>% 
  left_join(data_sch_rename,
            by = "schoolID")
