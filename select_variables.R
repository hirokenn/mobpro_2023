library(tidyverse)
library(readxl)

DDK2011 <- 
  read_excel("data/raw/DDK2011.xlsx", na = c(".", " "))

DDK2011 <- 
  DDK2011 %>% 
  select(pupilid, schoolid, district, tracking, etpteacher, agetest, girl, 
         ends_with("half"), ends_with("quarter"), percentile, totalscore#,
         #r2_attrition, r2_age, r2_totalscore
         )

# DDK2011 %>% 
#   mutate(totalscore_normal = scale(totalscore))
# lm(totalscore_normal ~ tracking, data = DDK2011)

df_short <- 
  DDK2011 %>% 
  select(-starts_with("r2"))

# df_long <- 
#   DDK2011 %>% 
#   select(pupilid, starts_with("r2"))

write_csv(df_short, "data/clean/df_short2.csv")


