#### data_outcomesの変数名 ####

data_outcomes_rename <- data_outcomes %>% 
  rename(studentID = "生徒ID", 
         score = "学力スコア")

#### data_stuの変数名 ####
names_data_stu <- names(data_stu)
data_stu_rename <- data_stu %>% 
  rename(studentID = "生徒ID",
         schoolID = "小学校NUMBER",
         tem_teacher_dummy = "非常勤講師",
         age = "年齢",
         gender = "性別",
         score_order_2 = "成績位置(2グループ)",
         score_order_4 = "成績位置(4グループ)",
         score_order_pct = "成績位置(パーセンタイル)"
         )

#### data_schの変数名 ####
data_sch_rename <- data_sch %>% 
  rename(schoolID = "小学校NUMBER",
         treatment = "能力別学級",
         locate_category = "立地")



