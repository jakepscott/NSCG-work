load_data <- function(){

  #Initialize output output list
  data <- list()
  
  #List top jobs by major and top majors by job
  Jobs_by_Major <- read_csv(here("Evolution-of-Jobs-and-Majors/Data/Jobs-by-Major-and-Year.csv")) %>% 
    mutate(data = "Jobs_by_Major")
  
  Majors_by_Job <- read_csv(here("Evolution-of-Jobs-and-Majors/Data/Majors-by-Job-and-Year.csv")) %>% 
    mutate(data = "Majors_by_Job")
  
  #Load the codes and labels for jobs and majors
  data$Job_key <- read_csv(here("NSCG_Data/Job-Labels.csv"))
  data$Major_key <- read_csv(here("NSCG_Data/Major-Labels.csv"))
  
  #Join major and job labels to the data
  data$Jobs_by_Major <- Jobs_by_Major %>% 
    left_join(data$Job_key ) %>% 
    left_join(data$Major_key)
  
  data$Majors_by_Job <- Majors_by_Job %>% 
    left_join(data$Job_key) %>% 
    left_join(data$Major_key)
  
  #Get list of majors and jobs
  data$majors <- data$Major_key %>% 
    arrange(Major_Label) %>% 
    pull(Major_Label)
  
  data$jobs <- data$Job_key %>% 
    arrange(Job_Label) %>% 
    pull(Job_Label)
  
  return(data)
  
}
