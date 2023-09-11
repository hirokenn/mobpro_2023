df <- readRDS(paste0(dir_cleaned_data, "/df.rds"))

table_summary_stats <-
  df %>% 
  # select variables
  select(-ends_with("id"), -in_bungoma) %>% 
  select(any_of(jp_to_eng), 
         "女子" = is_girl,
         "成績位置(上位50%)" = half_top,
         "成績位置(下位50%)" = half_bottom,
         "成績位置(上位25%)" = quarter_top,
         "成績位置(上位25-50%)" = quarter_second,
         "成績位置(下位25-50%)" = quarter_third,
         "成績位置(下位25%)" = quarter_bottom) %>% 
  # create table
  tbl_summary(type = list(-"立地" ~ "continuous"),
              statistic  = list(all_continuous() ~ "{mean} ({sd})"),
              digits = list(all_continuous() ~ 2),
              missing = "no")

table_summary_stats %>% 
  as_flex_table() %>% 
  flextable::save_as_pptx(path = paste0(dir_output, "summary.pptx"))
