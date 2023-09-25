df <- readRDS(paste0(dir_cleaned_data, "/df.rds")) 

##### ここでの戦略 #####
# 3つのモデルを推定するが、行う処理は式が異なる以外全て同じである
# 結果表示のため推計結果は3つのモデルをまとめたリストになっていると都合が良い
# -> 初めから3つの式をリストとして扱い、mapで処理する

# define models ----------------------------------------------------------------

covariates <- 
  df %>% 
  select(age, is_girl, etp_teacher, 
         ends_with(c("_half", "_quarter")) & !starts_with("top_"), 
         percentile) %>% 
  names() %>% 
  paste(collapse = " + ")

list_models <- list()

list_models[["Model (a)"]] <- "std_score ~ tracking"

list_models[["Model (b)"]] <- paste0(list_models[["Model (a)"]], " + ", covariates)

list_models[["Model (c)"]] <- paste0(list_models[["Model (b)"]], " + tracking:bottom_half")

list_models <- list_models %>% map(as.formula)

# regression analysis ----------------------------------------------------------

list_results <-
  map(list_models, 
      \(model){lm_robust(formula = model,
                         data = df,
                         clusters = sch_id)})

# make regression table --------------------------------------------------------
# modelsummaryの表に何を入れるかなど指定できる
coef_map <- c("tracking" = "能力別学級", 
              "tracking:bottom_half" = "事前の成績位置(下位50%) × 能力別学級")

gof_map <- tribble(
  ~raw,        ~clean,   ~fmt,
  "nobs",      "観測数", 0,
  "adj.r.squared", "調整済み決定係数", 3
)

control_status <- tribble(
  ~term,             ~"Model (a)", ~"Model (b)", ~"Model (c)",
  "コントロール変数", "",          "X",      "X"
)

# attr()でオブジェクトに属性を付与できる
# この場合は挿入する列の位置に関する属性を付与
attr(control_status, "position") <- 5

# modelsummaryの書き方の詳細はドキュメントを参照
# https://modelsummary.com/articles/modelsummary.html

# in pptx
modelsummary(list_results,
             stars = TRUE,  
             coef_map = coef_map,  
             gof_map = gof_map,  
             add_rows = control_status,
             output = "flextable") %>%   
  flextable::save_as_pptx(path = paste0(dir_output, "results.pptx"))

# in docx
modelsummary(list_results,
             stars = TRUE,  
             coef_map = coef_map,  
             gof_map = gof_map,  
             add_rows = control_status,
             output = paste0(dir_output, "results.docx")) 
