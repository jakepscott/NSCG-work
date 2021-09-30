library(haven)
library(here)
library(tidyverse)
library(survey)
library(magrittr)
NSCG_2017_M2 <- read_rds(here("NSCG_Data/NSCG_2017_raw.rds")) %>% 
  as_tibble() %>% 
  dplyr::select("Job"=N2OCPR, "Major"=NDGRMED, WTSURVY)   

###****************************************************************************************************
##Majors by Job- so looking at what Fields of Study are common for given occupations
###****************************************************************************************************

tictoc::tic()
majors_by_job_M2_raw <-  NSCG_2017_M2 %>%
  as_tibble() %>% 
  group_by(Job) %>% 
  nest()


count_function <- function(data, variable_to_count, weight = WTSURVY){
  data %>% 
    count({{variable_to_count}}, wt = {{weight}}, sort = T) %>% 
    mutate(percent = n/sum(n)*100) %>% 
    mutate(cum_per = cumsum(percent))
}

majors_by_job_M2 <- majors_by_job_M2_raw %>% 
  mutate(count_table = map(data, count_function, variable_to_count = Major))

top_function <- function(data, variable_to_select, cutoff = 75){
  data %>% 
    #If we don't deal with row numbers, this will call every row where
    # the first job or major is >75% as a mimatch. So like accountants have
    # like 80% of people as accounting majors. bUt since this cuts out anything where
    # cum percent >75, it says all accountants are mismatched
    filter(row_number() < 2 | cum_per <= cutoff) %>% 
    select({{variable_to_select}})
}

majors_by_job_M2 <- majors_by_job_M2 %>% 
  mutate(top_majors = map(count_table, top_function, Major, 75))

check_function <- function(top_majors_or_jobs, major_or_job, variable){
  tops <- top_majors_or_jobs %>% 
    pull({{variable}}) %>% 
    as.vector()
  
  major_or_job %in% tops
}

match_M2 <- NSCG_2017_M2 %>%
  #head(10) %>% 
  as_tibble() %>%
  #filter(Job != 999989) %>% 
  mutate(Job = as.numeric(Job)) %>% 
  left_join(majors_by_job_M2) %>% 
  rowwise() %>% 
  mutate(match = ifelse(Major %in% top_majors$Major, "Match", "Mismatch")) %>% 
  ungroup()
tictoc::toc()

# 
# match_M2 %>%
#   count(match, wt = WTSURVY) %>%
#   mutate(percent = n/sum(n)*100)
# 
