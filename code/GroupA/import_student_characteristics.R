
# data_import -------------------------------------------------------------

student_characteristics <- 
  read_csv("./data/distributed/student_characteristics.csv", locale = locale(encoding = "shift-jis"))


# rename_variables --------------------------------------------------------

student_characteristics_cleaned <-
  student_characteristics %>%
  rename(student_ID = "生徒ID",
         school_ID = "小学校NUMBER",
         temporary = "非常勤講師",
         age = "年齢",
         female_dummy = "性別",
         grade_rank_2 = "成績位置(2グループ)",
         grade_rank_4 = "成績位置(4グループ)",
         grade_rank_percent = "成績位置(パーセンタイル)")


# transform_na ------------------------------------------------------------

student_characteristics_cleaned<-
  student_characteristics_cleaned %>% 
  mutate(student_ID = str_remove(student_ID, "番"),
         student_ID = case_when(nchar(student_ID) == 7 | nchar(student_ID) == 8 ~ student_ID,
                                nchar(student_ID) != 7 | nchar(student_ID) != 8 ~ NA),
         school_ID = case_when(nchar(school_ID) == 3 | nchar(school_ID) == 4 ~ school_ID,
                               nchar(school_ID) != 3 |nchar(school_ID) != 4 ~ NA),
         
         female_dummy = case_when(female_dummy == "女子"~ 1,
                                  female_dummy == "男子"~ 0,
                                  female_dummy == "unknown" ~ NA),
         
         upper50_dummy = case_when(grade_rank_2 == "###" ~ NA,
                                  grade_rank_2 == "上位50%" ~ 1,
                                  grade_rank_2 == "下位50%" ~ 0),
         
         bottom25_50dummy = case_when(grade_rank_4 == "###" ~ NA,
                                      grade_rank_4 == "下位25-50%"　~ 1,
                                      grade_rank_4 != "下位25-50%" ~ 0),
         
         bottom0_25dummy = case_when(grade_rank_4 == "###" ~ NA,
                                     grade_rank_4 == "下位25%"　~ 1,
                                     grade_rank_4 != "下位25%" ~ 0),
         
         upper25_50dummy = case_when(grade_rank_4 == "###" ~ NA,
                                     grade_rank_4 == "上位25-50%" ~ 1,
                                     grade_rank_4 != "上位25-50%" ~ 0),
         
         upper0_25dummy = case_when(grade_rank_4 == "###" ~ NA,
                                     grade_rank_4 == "上位25%" ~ 1,
                                     grade_rank_4 !=  "上位25%"~ 0),
         
         grade_rank_percent = case_when(grade_rank_percent == "999" ~ NA,
                                        TRUE ~ as.numeric(grade_rank_percent)))

# save_data ---------------------------------------------------------------

write_csv(student_characteristics_cleaned, file = "./data/clean/student_characteristics")
         
        
