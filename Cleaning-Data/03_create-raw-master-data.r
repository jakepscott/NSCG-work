#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Load Libs ---------------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library(tidyverse)
library(here)
library(vroom)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Load Data ---------------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
NSCG_2003_raw <- vroom(here("NSCG_Data/NSCG_2003_raw.csv"),
                       col_select = c(orig_dataset_id,JOBSATIS, BAACYR, OCEDRLP, RACETHM, 
                                      GENDER, AGE, CTZUSIN, CHLVIN, MARSTA, 
                                      SPOWK, RESPLOC, HCAPIN, DGRDG, HDCARN, 
                                      HDPBPR, NDGRMED, 
                                      SALARY, HRSWK, 
                                      SUPWK, STRTYR, WAPRI, FACADV,
                                      FACBEN, FACCHAL, FACIND, FACLOC, FACRESP, 
                                      FACSAL, FACSEC, FACSOC, EMSIZE, NEDTP, NRREA, NBAMED,
                                      NBANED, NOCPR, WTSURVY, HISPCAT, BAYR, REFYR,
                                      COMCOLI,EDDAD, EDMOM, HSYR, SATADV,
                                      SATBEN, SATCHAL, SATIND,SATLOC, SATRESP, SATSAL,
                                      SATSEC, SATSOC, EMSMI)) %>%
  rename("Job"=NOCPR, 
         "Major"=NDGRMED)

NSCG_2010_raw <- vroom(here("NSCG_Data/NSCG_2010_raw.csv"), 
                       col_select = c(orig_dataset_id,JOBSATIS, BAACYR, OCEDRLP, RACETHM, GENDER,
                                      AGE, CTZUSIN, CHLVIN, MARSTA, SPOWK, RESPLOC, 
                                      HCAPIN, DGRDG, HDCARN, 
                                      HDPBPR, NDGRMED, JOBINS, JOBPENS, 
                                      JOBPROFT, JOBVAC, SALARY, HRSWK, SUPWK, STRTYR, WAPRI, FACADV,
                                      FACBEN, FACCHAL, FACIND, FACLOC, FACRESP, FACSAL, 
                                      FACSEC, FACSOC, EMSIZE, NEDTP, NRREA, NBAMED,
                                      NBANED, N2OCPR, WTSURVY, HISPCAT, BAYR, REFYR,
                                      COMCOLI,EDDAD, EDMOM, HSYR, SATADV,
                                      SATBEN, SATCHAL, SATIND,SATLOC, SATRESP, SATSAL,
                                      SATSEC, SATSOC, EMSMI)) %>%
  rename("Job"=N2OCPR, 
         "Major"=NDGRMED)

NSCG_2013_raw <- vroom(here("NSCG_Data/NSCG_2013_raw.csv"), 
                       col_select = c(orig_dataset_id,JOBSATIS, BAACYR, OCEDRLP, RACETHM, GENDER, 
                                      AGE, CTZUSIN, CHLVIN, MARSTA, SPOWK, RESPLOC, 
                                      HCAPIN, DGRDG, HDCARN, 
                                      HDPBPR, NDGRMED, JOBINS, JOBPENS, 
                                      JOBPROFT, JOBVAC, SALARY, HRSWK, SUPWK, STRTYR, WAPRI, FACADV,
                                      FACBEN, FACCHAL, FACIND, FACLOC, FACRESP, FACSAL, 
                                      FACSEC, FACSOC, EMSIZE, NEDTP, NRREA, NBAMED,
                                      NBANED, N2OCPR, WTSURVY, HISPCAT, BAYR, REFYR,
                                      COMCOLI,EDDAD, EDMOM, HSYR, SATADV,
                                      SATBEN, SATCHAL, SATIND,SATLOC, SATRESP, SATSAL,
                                      SATSEC, SATSOC, EMSMI)) %>%
  rename("Job"=N2OCPR, 
         "Major"=NDGRMED)

NSCG_2015_raw <- vroom(here("NSCG_Data/NSCG_2015_raw.csv"), 
                       col_select = c(orig_dataset_id,JOBSATIS, BAACYR, OCEDRLP, RACETHM, GENDER, 
                                      AGE, CTZUSIN, CHLVIN, MARSTA, SPOWK, RESPLOC, 
                                      HCAPIN, DGRDG, HDCARN, 
                                      HDPBPR, NDGRMED, JOBINS, JOBPENS, 
                                      JOBPROFT, JOBVAC, SALARY, HRSWK, SUPWK, STRTYR, WAPRI, FACADV,
                                      FACBEN, FACCHAL, FACIND, FACLOC, FACRESP, FACSAL, 
                                      FACSEC, FACSOC, EMSIZE, NEDTP, NRREA, NBAMED,
                                      NBANED, N2OCPR, WTSURVY, HISPCAT, BAYR, REFYR,
                                      COMCOLI,EDDAD, EDMOM, HSYR, SATADV,
                                      SATBEN, SATCHAL, SATIND,SATLOC, SATRESP, SATSAL,
                                      SATSEC, SATSOC, EMSMI)) %>%
  rename("Job"=N2OCPR, 
         "Major"=NDGRMED)

NSCG_2017_raw <- vroom(here("NSCG_Data/NSCG_2017_raw.csv"), 
                       col_select = c(orig_dataset_id,JOBSATIS, BAACYR, OCEDRLP, RACETHM, GENDER, 
                                      AGE, CTZUSIN, CHLVIN, MARSTA, SPOWK, RESPLOC, 
                                      HCAPIN, DGRDG, HDCARN, 
                                      HDPBPR, NDGRMED, JOBINS, JOBPENS, 
                                      JOBPROFT, JOBVAC, SALARY, HRSWK, SUPWK, STRTYR, WAPRI, FACADV,
                                      FACBEN, FACCHAL, FACIND, FACLOC, FACRESP, FACSAL, 
                                      FACSEC, FACSOC, EMSIZE, NEDTP, NRREA, NBAMED,
                                      NBANED, N2OCPR, WTSURVY, HISPCAT, BAYR, REFYR,
                                      COMCOLI,EDDAD, EDMOM, HSYR, SATADV,
                                      SATBEN, SATCHAL, SATIND,SATLOC, SATRESP, SATSAL,
                                      SATSEC, SATSOC, EMSMI)) %>%
  rename("Job"=N2OCPR, 
         "Major"=NDGRMED)

NSCG_2019_raw <- vroom(here("NSCG_Data/NSCG_2019_raw.csv"), 
                       col_select = c(orig_dataset_id,JOBSATIS, BAACYR, OCEDRLP, RACETHM, GENDER, 
                                      AGE, CTZUSIN, CHLVIN, MARSTA, SPOWK, RESPLOC, 
                                      HCAPIN, DGRDG, HDCARN, 
                                      HDPBPR, N2DGRMED, JOBINS, JOBPENS, 
                                      JOBPROFT, JOBVAC, SALARY, HRSWK, SUPWK, STRTYR, WAPRI, FACADV,
                                      FACBEN, FACCHAL, FACIND, FACLOC, FACRESP, FACSAL, 
                                      FACSEC, FACSOC, EMSIZE, NEDTP, NRREA, N2BAMED,
                                      N2BANED, N3OCPR, WTSURVY, HISPCAT, BAYR, REFYR,
                                      COMCOLI,EDDAD, EDMOM, HSYR, SATADV,
                                      SATBEN, SATCHAL, SATIND,SATLOC, SATRESP, SATSAL,
                                      SATSEC, SATSOC, EMSMI)) %>%
  rename("Job"=N3OCPR, 
         "Major"=N2DGRMED)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Join in Match Data ------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Load Data
NSCG_2003_match <- vroom(here("NSCG_Data/Match_2003.csv"))
NSCG_2010_match <- vroom(here("NSCG_Data/Match_2010.csv"))
NSCG_2013_match <- vroom(here("NSCG_Data/Match_2013.csv"))
NSCG_2015_match <- vroom(here("NSCG_Data/Match_2015.csv"))
NSCG_2017_match <- vroom(here("NSCG_Data/Match_2017.csv"))
NSCG_2019_match <- vroom(here("NSCG_Data/Match_2019.csv"))


# Join data ( changesalso make a couple of)
NSCG_2003_clean <- NSCG_2003_raw %>% 
  left_join(NSCG_2003_match) %>% 
  mutate_all(as.character)

NSCG_2010_clean <- NSCG_2010_raw %>% 
  left_join(NSCG_2010_match) %>% 
  mutate_all(as.character)

NSCG_2013_clean <- NSCG_2013_raw %>% 
  left_join(NSCG_2013_match) %>% 
  mutate_all(as.character)

NSCG_2015_clean <- NSCG_2015_raw %>% 
  left_join(NSCG_2015_match) %>% 
  mutate_all(as.character)

NSCG_2017_clean <- NSCG_2017_raw %>% 
  left_join(NSCG_2017_match) %>% 
  mutate_all(as.character)

NSCG_2019_clean <- NSCG_2019_raw %>% 
  left_join(NSCG_2019_match) %>% 
  mutate_all(as.character)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Bind NSCG Data ------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
NSCG_Master_Raw <- NSCG_2003_clean %>%
  bind_rows(NSCG_2010_clean) %>% 
  bind_rows(NSCG_2013_clean) %>% 
  bind_rows(NSCG_2015_clean) %>% 
  bind_rows(NSCG_2017_clean) %>% 
  bind_rows(NSCG_2019_clean)  
  
write_csv(NSCG_Master_Raw, here("NSCG_Data/NSCG_Master_Raw.csv"))

