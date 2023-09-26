result_nocontrol <- feols(score_std ~ treatment,
                          data = data_cleaned,
                          cluster = "schoolID")
result_control <- feols(score_std ~ treatment + age + female + tem_teacher_dummy + score_upper_d + score_order_4 + score_order_pct,
                        data = data_cleaned,
                        cluster = "schoolID")
result_hetero <- feols(score_std ~ treatment + treatment:score_upper_d + age + female + tem_teacher_dummy + score_upper_d + score_order_4 + score_order_pct,
                        data = data_cleaned,
                        cluster = "schoolID")
modelsummary <- list("model A" = result_nocontrol, 
                     "model B" = result_control,
                     "model C" = result_hetero) %>% 
  modelsummary(stars = TRUE,
               output = "flextable")
modelsummary  %>%  
  save_as_pptx(path = "output/modelsummary.pptx")



  