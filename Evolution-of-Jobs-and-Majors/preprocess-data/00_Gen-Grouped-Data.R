#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Load Libs ---------------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library(tidyverse)
library(here)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Load Data ---------------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#NSCG Data
data <- read_rds(here("NSCG_Data/NSCG_Master.rds"))

# Labels for Majors
Major_Labels <- read_csv(here("NSCG_Data/Major-Labels.csv")) %>% 
  mutate(Major = as.character(Major))

# Labels for Jobs
Job_Labels <- read_csv(here("NSCG_Data/Job-Labels.csv")) %>% 
  mutate(Principal_Job = as.character(Principal_Job))

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Clean Data --------------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Join in Job and Major Labels
full_data <- data %>% 
  left_join(Major_Labels) %>% 
  left_join(Job_Labels) %>% 
  select(Major, Principal_Job, Major_Label, Job_Label, Survey_Year, Survey_Weight)

# Get top jobs by major ---------------------------------------------------
# Group by survey year and major, and see what jobs are most common for each  
# major by year
Jobs_by_Major <- full_data %>% 
  group_by(Survey_Year,Major_Label) %>% 
  count(Job_Label, wt = Survey_Weight) %>% 
  arrange(Survey_Year,Major_Label, desc(n)) %>% 
  mutate(percent = n/sum(n)*100) %>% 
  ungroup()

write_csv(Jobs_by_Major,here("Evolution-of-Jobs-and-Majors/Data/Jobs-by-Major-and-Year.csv"))


# Get top majors by job ---------------------------------------------------
# Group by survey year and job, and see what majors are most common for each  
# job by year
Majors_by_Job <- full_data %>% 
  group_by(Survey_Year,Job_Label) %>% 
  count(Major_Label, wt = Survey_Weight) %>% 
  arrange(Survey_Year,Job_Label, desc(n)) %>% 
  mutate(percent = n/sum(n)*100) %>% 
  ungroup()

write_csv(Majors_by_Job,here("Evolution-of-Jobs-and-Majors/Data/Majors-by-Job-and-Year.csv"))


