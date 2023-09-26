

# import data -------------------------------------------------------------

outcomes <-
  read_csv("./data/distributed/outcomes.csv", locale = locale(encoding = "shift-jis"))

write_csv(outcomes, file = "./data/clean/outcomes_pre")

outcomes_cleaned <-
  outcomes %>%
  rename(student_ID = "生徒ID",
         score = "学力スコア") %>%
  mutate(scaled_score = scale(score, center = TRUE, scale = TRUE)) %>%
  mutate(scaled_score = as.vector(scaled_score)) %>%
  mutate(student_ID = as.character(student_ID)) # 生徒ID 列を文字列に変換

# save_data ---------------------------------------------------------------

write_csv(outcomes_cleaned, file = "./data/clean/outcomes")
