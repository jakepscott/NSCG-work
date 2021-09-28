mismatch_function <- function(data,
                              grouping_variable, 
                              counting_variable,
                              cutoff,
                              weight,
                              inclusive=F){

# Nest based on grouping variable -----------------------------------------
  nested <- data %>%
    group_by({{grouping_variable}}) %>% 
    nest()
  

# Make function to count most common instances of counting_variable -------
  count_function <- function(data, variable_to_count, weight = WTSURVY){
    data %>% 
      count({{variable_to_count}}, wt = {{weight}}, sort = T) %>% 
      mutate(percent = n/sum(n)*100) %>% 
      mutate(cum_per = cumsum(percent))
  }
  
  #Count top instances of counting_variable by grouping_variable
  nested <- nested %>% 
    mutate(count_table = map(data, count_function, variable_to_count = {{counting_variable}}))
  

# Grab top cutoff worth of counting_variable by grouping_variable ---------
  top_function <- function(data, variable_to_select, cutoff = 75){
    data %>% 
      #If we don't deal with row numbers, this will call every row where
      # the first job or major is >75% as a mimatch. So like accountants have
      # like 80% of people as accounting majors. bUt since this cuts out anything where
      # cum percent >75, it says all accountants are mismatched
      filter(row_number() < 2 | cum_per <= cutoff) %>% 
      select({{variable_to_select}})
  }
  
  #Grab the most common instances of counting_variable by grouping_variable
  nested <- nested %>% 
    mutate(top = map(count_table, top_function, {{counting_variable}}, {{cutoff}}))
  

# Make function that checks whether given count_var is on of most  --------
  check_function <- function(top_majors_or_jobs, major_or_job, variable){
    tops <- top_majors_or_jobs %>% 
      pull({{variable}}) %>% 
      as.vector()
    
    major_or_job %in% tops
  }
  
  output <- data %>%
    as_tibble() %>%
    #filter(Job != 999989) %>% 
    #mutate(Job = as.numeric(Job)) %>% 
    left_join(nested) %>% 
    rowwise() %>% 
    mutate(match = ifelse({{counting_variable}} %in% (top %>% pull({{counting_variable}})), "Match", "Mismatch")) %>% 
    ungroup()
  
  return(output)
}

# library(haven)
# library(here)
# library(tidyverse)
# library(survey)
# library(magrittr)
# NSCG_2017_M2 <- read_rds(here("NSCG_Data/NSCG_2017_raw.rds")) %>% 
#   as_tibble() %>% 
#   dplyr::select("Job"=N2OCPR, "Major"=NDGRMED, WTSURVY)   


data <- mismatch_function(NSCG_2017_M2,
                  grouping_variable = Job,
                  counting_variable = Major,
                  cutoff = 75, 
                  weight = WTSURVY)


data %>% 
  count(match, wt = WTSURVY) %>% 
  mutate(percent = n/sum(n))
