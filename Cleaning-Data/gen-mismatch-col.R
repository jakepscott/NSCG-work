# Load Libraries ----------------------------------------------------------
library(haven)
library(here)
library(tidyverse)
library(glue)
source(here("functions/Mismatch-Function.r"))

# Load Data ---------------------------------------------------------------
NSCG_2003 <- vroom::vroom(here("NSCG_Data/NSCG_2003_raw.csv"),
                          col_select = c(orig_dataset_id,"Job"=NOCPR, 
                                         "Major"=NDGRMED, WTSURVY)) %>% 
  mutate(dataset = "NSCG_2003")

NSCG_2010 <- vroom::vroom(here("NSCG_Data/NSCG_2010_raw.csv"),
                          col_select = c(orig_dataset_id,"Job"=N2OCPR, 
                                         "Major"=NDGRMED, WTSURVY)) %>% 
  mutate(dataset = "NSCG_2010") 

NSCG_2013 <- vroom::vroom(here("NSCG_Data/NSCG_2013_raw.csv"),
                          col_select = c(orig_dataset_id,"Job"=N2OCPR, 
                                         "Major"=NDGRMED, WTSURVY)) %>% 
  mutate(dataset = "NSCG_2013")

NSCG_2015 <- vroom::vroom(here("NSCG_Data/NSCG_2015_raw.csv"),
                          col_select = c(orig_dataset_id,"Job"=N2OCPR, 
                                         "Major"=NDGRMED, WTSURVY)) %>% 
  mutate(dataset = "NSCG_2015")

NSCG_2017 <- vroom::vroom(here("NSCG_Data/NSCG_2017_raw.csv"),
                          col_select = c(orig_dataset_id,"Job"=N2OCPR, 
                                         "Major"=NDGRMED, WTSURVY)) %>% 
  mutate(dataset = "NSCG_2017")

NSCG_2019 <- vroom::vroom(here("NSCG_Data/NSCG_2019_raw.csv"),
                          col_select = c(orig_dataset_id,"Job"=N3OCPR, 
                                         "Major"=N2DGRMED, WTSURVY)) %>% 
  mutate(dataset = "NSCG_2019")

# Get Mismatch for Each year ----------------------------------------------
NSCG_2003 <- mismatch_function(data = NSCG_2003,
                               grouping_variable = Job,
                               counting_variable = Major,
                               cutoff = 75, 
                               weight = WTSURVY,
                               keep_nests = F)
write_csv(NSCG_2003, here("NSCG_Data/Match_2003.csv"))

NSCG_2010 <- mismatch_function(data = NSCG_2010,
                               grouping_variable = Job,
                               counting_variable = Major,
                               cutoff = 75, 
                               weight = WTSURVY,
                               keep_nests = F)

write_csv(NSCG_2010, here("NSCG_Data/Match_2010.csv"))

NSCG_2013 <- mismatch_function(data = NSCG_2013,
                               grouping_variable = Job,
                               counting_variable = Major,
                               cutoff = 75, 
                               weight = WTSURVY,
                               keep_nests = F)
write_csv(NSCG_2013, here("NSCG_Data/Match_2013.csv"))

NSCG_2015 <- mismatch_function(data = NSCG_2015,
                               grouping_variable = Job,
                               counting_variable = Major,
                               cutoff = 75, 
                               weight = WTSURVY,
                               keep_nests = F)
write_csv(NSCG_2015, here("NSCG_Data/Match_2015.csv"))

NSCG_2017 <- mismatch_function(data = NSCG_2017,
                               grouping_variable = Job,
                               counting_variable = Major,
                               cutoff = 75, 
                               weight = WTSURVY,
                               keep_nests = F)
write_csv(NSCG_2017, here("NSCG_Data/Match_2017.csv"))

NSCG_2019 <- mismatch_function(data = NSCG_2019,
                               grouping_variable = Job,
                               counting_variable = Major,
                               cutoff = 75, 
                               weight = WTSURVY,
                               keep_nests = F)

write_csv(NSCG_2019, here("NSCG_Data/Match_2019.csv"))
