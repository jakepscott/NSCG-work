library(haven)
library(readr)
library(tidyverse)
library(here)
library(glue)

# 2019 --------------------------------------------------------------------
NSCG_2019_raw <- read_sas(here("Raw-Data/epcg19.sas7bdat"))
NSCG_2019_raw <- NSCG_2019_raw %>% 
  mutate(orig_dataset_id = glue("{row_number()}_2019"))

saveRDS(NSCG_2019_raw, file = here("NSCG_Data/NSCG_2019_raw.rds"))
write_csv(NSCG_2019_raw, file = here("NSCG_Data/NSCG_2019_raw.csv"))


# 2017 --------------------------------------------------------------------
NSCG_2017_raw <- vroom::vroom(here("Raw-Data/NSCG_2017.csv"))
NSCG_2017_raw <- NSCG_2017_raw %>% 
  mutate(orig_dataset_id = glue("{row_number()}_2017"))

saveRDS(NSCG_2017_raw, file = here("NSCG_Data/NSCG_2017_raw.rds"))
write_csv(NSCG_2017_raw, file = here("NSCG_Data/NSCG_2017_raw.csv"))

# 2015 --------------------------------------------------------------------
NSCG_2015_raw <- read_dta(here("Raw-Data/NSCG2015_Public.dta"))
NSCG_2015_raw <- NSCG_2015_raw %>% 
  mutate(orig_dataset_id = glue("{row_number()}_2015"))

saveRDS(NSCG_2015_raw, file = here("NSCG_Data/NSCG_2015_raw.rds"))
write_csv(NSCG_2015_raw, file = here("NSCG_Data/NSCG_2015_raw.csv"))

# 2013 --------------------------------------------------------------------
NSCG_2013_raw <- read_sas(here("Raw-Data/epcg13.sas7bdat"))
NSCG_2013_raw <- NSCG_2013_raw %>% 
  mutate(orig_dataset_id = glue("{row_number()}_2013"))

saveRDS(NSCG_2013_raw, file = here("NSCG_Data/NSCG_2013_raw.rds"))
write_csv(NSCG_2013_raw, file = here("NSCG_Data/NSCG_2013_raw.csv"))

# 2010 --------------------------------------------------------------------
NSCG_2010_raw <- read_sas(here("Raw-Data/epcg10.sas7bdat"))
NSCG_2010_raw <- NSCG_2010_raw %>% 
  mutate(orig_dataset_id = glue("{row_number()}_2010"))

saveRDS(NSCG_2010_raw, file = here("NSCG_Data/NSCG_2010_raw.rds"))
write_csv(NSCG_2010_raw, file = here("NSCG_Data/NSCG_2010_raw.csv"))

# 2003 --------------------------------------------------------------------
NSCG_2003_raw <- read_sas(here("Raw-Data/ecg03.sas7bdat"))
NSCG_2003_raw <- NSCG_2003_raw %>% 
  mutate(orig_dataset_id = glue("{row_number()}_2003"))

saveRDS(NSCG_2003_raw, file = here("NSCG_Data/NSCG_2003_raw.rds"))
write_csv(NSCG_2003_raw, file = here("NSCG_Data/NSCG_2003_raw.csv"))
