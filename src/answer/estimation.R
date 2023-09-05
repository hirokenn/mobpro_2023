df <- readRDS(paste0(dir_cleaned_data, "/df.rds")) 

# define models ----------------------------------------------------------------
base_model <- "std_score ~ tracking"

with_covariates_model <- paste(base_model,
                               "age",
                               "is_girl",
                               "etp_teacher",
                               "bottom_half",
                               "bottom_quarter",
                               "second_quarter",
                               "third_quarter",
                               "percentile",
                               sep = " + ")

with_cross_term_model <- paste(with_covariates_model,
                               "tracking:bottom_half",
                               sep = " + ")

# regression analysis ----------------------------------------------------------
results <- list(
  "共変量なし" = lm_robust(formula = as.formula(base_model), data = df, clusters = sch_id),
  "共変量あり" = lm_robust(formula = as.formula(with_covariates_model), data = df, clusters = sch_id),
  "交差項あり" = lm_robust(formula = as.formula(with_cross_term_model), data = df, clusters = sch_id)
)

# make regression table --------------------------------------------------------
coef_map <- c("tracking" = "処置効果", 
              "tracking:bottom_half" = "事前の成績位置(下位50%) × 能力別学級")

gof_map <- tribble(
  ~raw,        ~clean,   ~fmt,
  "nobs",      "観測数", 0,
  "r.squared", "決定数", 2
)

control_status <- tribble(
  ~term,             ~共変量なし, ~共変量あり, ~交差項あり,
  "コントロール変数", "なし",          "あり",      "あり"
)
attr(control_status, "position") <- 5

result_summary <- modelsummary(results,
                               stars = TRUE,
                               add_rows = control_status,
                               coef_map = coef_map,
                               gof_map = gof_map,
                               output = paste0(dir_figure, "/regression_result.png"))

