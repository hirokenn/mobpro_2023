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
# 推計結果をlistにしておくとmodelsummaryに入れやすい
# lm_robustはas.formula()が無いと文字列を式として判断してくれない
results <- list(
  "Model (a)" = lm_robust(formula = as.formula(base_model), data = df, clusters = sch_id),
  "Model (b)" = lm_robust(formula = as.formula(with_covariates_model), data = df, clusters = sch_id),
  "Model (c)" = lm_robust(formula = as.formula(with_cross_term_model), data = df, clusters = sch_id)
)

# make regression table --------------------------------------------------------
# modelsummaryの表に何を入れるかなど指定できる
coef_map <- c("tracking" = "処置効果", 
              "tracking:bottom_half" = "事前の成績位置(下位50%) × 能力別学級")

gof_map <- tribble(
  ~raw,        ~clean,   ~fmt,
  "nobs",      "観測数", 0,
  "r.squared", "決定係数", 3
)

control_status <- tribble(
  ~term,             ~共変量なし, ~共変量あり, ~交差項あり,
  "コントロール変数", "なし",          "あり",      "あり"
)

# attr()でオブジェクトに属性を付与できる
# この場合は挿入する列の位置に関する属性を付与
attr(control_status, "position") <- 5

# modelsummaryの書き方の詳細はドキュメントを参照
# https://modelsummary.com/articles/modelsummary.html
result_summary <- modelsummary(results,
                               stars = TRUE,  # 有意水準の星がつく
                               coef_map = coef_map,  # 表示する係数を決める
                               gof_map = gof_map,  # 表示するモデルの評価指標を指定
                               add_rows = control_status,  # 指定の列を挿入
                               output = paste0(dir_figure, "/regression_result.png"))

