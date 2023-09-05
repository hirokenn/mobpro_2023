df_summary <- readRDS(paste0(dir_cleand_data, "/df.rds")) %>% 
  select("学力スコア" = score,
         "学力スコア(標準化)" = std_score,
         "能力別学級ダミー" = tracking,
         "性別(女子)" = is_girl,
         "年齢" = age,
         "非常勤講師ダミー" = etp_teacher,
         "学校所在地(BUNGOMA)" = in_bungoma,
         "学校所在地(BUTERE/M)" = in_butere,
         "成績位置(上位50%)" = top_half,
         "成績位置(下位50%)" = bottom_half,
         "成績位置(上位25%)" = top_quarter,
         "成績位置(上位25-50%)" = second_quarter,
         "成績位置(下位25-50%)" = third_quarter,
         "成績位置(下位25%)" = bottom_quarter,
         "成績位置(パーセンタイル)" = percentile
         ) %>% 
  as.data.frame()
  
summary <- datasummary(All(df_summary) ~ (N + Mean + SD), 
                       data = df_summary,
                       na.rm = TRUE,
                       fmt = 3,
                       output = "gt")

gtsave(summary, filename = paste0(dir_figure, "/summary.png"))