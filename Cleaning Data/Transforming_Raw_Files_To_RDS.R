library(haven)
library(readr)
library(tidyverse)
library(here)


# 2019 --------------------------------------------------------------------
NSCG_2019_raw <- read_sas(here("Cohort Data/epcg19.sas7bdat"))
saveRDS(NSCG_2019_raw, file = here("Data/NSCG_2019_raw.rds"))
write_csv(NSCG_2019_raw, file = here("Data/NSCG_2019_raw.csv"))


# 2017 --------------------------------------------------------------------
NSCG_2017_raw <- read.csv(here("cohort data/NSCG_2017.csv"))
saveRDS(NSCG_2017_raw, file = here("Data/NSCG_2017_raw.rds"))
write_csv(NSCG_2017_raw, file = here("Data/NSCG_2017_raw.csv"))

# 2015 --------------------------------------------------------------------
NSCG_2015_raw <- read_dta(here("Cohort Data/NSCG2015_Public.dta"))
saveRDS(NSCG_2015_raw, file = here("Data/NSCG_2015_raw.rds"))
write_csv(NSCG_2015_raw, file = here("Data/NSCG_2015_raw.csv"))

# 2013 --------------------------------------------------------------------
NSCG_2013_raw <- read_sas(here("Cohort Data/epcg13.sas7bdat"))
saveRDS(NSCG_2013_raw, file = here("Data/NSCG_2013_raw.rds"))
write_csv(NSCG_2013_raw, file = here("Data/NSCG_2013_raw.csv"))

# 2010 --------------------------------------------------------------------
NSCG_2010_raw <- read_sas(here("Cohort Data/epcg10.sas7bdat"))
saveRDS(NSCG_2010_raw, file = here("Data/NSCG_2010_raw.rds"))
write_csv(NSCG_2010_raw, file = here("Data/NSCG_2010_raw.csv"))

# 2003 --------------------------------------------------------------------
NSCG_2003_raw <- read_sas(here("Cohort Data/ecg03.sas7bdat"))
saveRDS(NSCG_2003_raw, file = here("Data/NSCG_2003_raw.rds"))
write_csv(NSCG_2003_raw, file = here("Data/NSCG_2003_raw.csv"))
