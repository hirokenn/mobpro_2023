
# import_data -------------------------------------------------------------

school_characteristics <-
  read_csv("./data/distributed/school_characteristics.csv", locale = locale(encoding = "utf8"))


school_characteristics_cleaned <-
  school_characteristics %>%
  rename(school_ID = "小学校NUMBER",
         treatment_dummy = "能力別学級",
         BUNGOMA_dummy = "立地") %>% 
  mutate(BUNGOMA_dummy = case_when(BUNGOMA_dummy == "BUNGOMA" ~ 1,
                   BUNGOMA_dummy != "BUNGOMA" ~ 0))


# save_data ---------------------------------------------------------------

write_csv(school_characteristics_cleaned, file = "./data/clean/school_characteristics")
