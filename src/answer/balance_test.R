df <- readRDS(paste0(dir_cleand_data, "/df.rds"))
df_school <- readRDS(paste0(dir_clean_data, "/df_school.rds"))

# aggregate data ---------------------------------------------------------------
df_aggregated <- df %>% 
  group_by(sch_id) %>% 
  reframe(girls_ratio = mean(is_girl, na.rm = TRUE),
          age_mean = mean(age, na.rm = TRUE)) %>% 
  left_join(df_school, by = "sch_id") %>% 
  mutate(is_bungoma = if_else(district == "BUNGOMA", 1, 0))

# t-test -----------------------------------------------------------------------
my_t_test <- function(variable){
  # conduct t-test
  formula <- as.formula(paste0(variable, " ~ tracking"))
  result <- t.test(formula = formula, data = df_aggregated)
  
  # extract estimated values
  mean_group1 <- result$estimate[1]
  mean_group2 <- result$estimate[2]
  difference <- mean_group1 - mean_group2
  
  se <- result$stderr
  p.value <- result$p.value
  
  # make result tibble
  result_table <- tribble(
    ~"変数名", ~"介入群",   ~"対照群",   ~"差(介入群 - 対照群)", ~"標準誤差", ~"P値",
    variable,  mean_group1, mean_group2, difference,             se,          p.value
  )
  
  return(result_table)
}

t_test <- c("girls_ratio", "age_mean", "is_bungoma") %>% 
  map_dfr(my_t_test) %>% 
  mutate(変数名 = c("児童の女子比率",
                    "児童の平均年齢",
                    "学校の所在地(BUNGOMAにあれば1)"))

# format result ----------------------------------------------------------------
t_test_table <- t_test %>% 
  kable() %>% 
  kable_styling(fixed_thead = T) %>% 
  save_kable(paste0(dir_figure, "/t_test.png"))
