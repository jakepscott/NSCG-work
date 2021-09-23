#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Load libs-----------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library(haven)
library(tidyverse)
library(survey)
library(magrittr)
library(here)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Load data-----------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
NSCG_2019_raw <- read_rds(here("Data/NSCG_2019_raw.rds"))

NSCG_2019_clean <- NSCG_2019_raw %>% 
  dplyr::select(JOBSATIS, BAACYR, OCEDRLP, RACETHM, GENDER, AGE, CTZUSIN, 
                CHLVIN, MARSTA, SPOWK, RESPLOC, HCAPIN, DGRDG, HDCARN, 
                HDPBPR, N2DGRMED, UGLOANR, JOBINS, JOBPENS, JOBPROFT, 
                JOBVAC, SALARY, HRSWK, SUPWK, STRTYR, WAPRI, FACADV,
                FACBEN, FACCHAL, FACIND, FACLOC, FACRESP, FACSAL, 
                FACSEC, FACSOC, EMSIZE, NEDTP, LFSTAT, NRREA, N2BAMED,
                N2BANED, N3OCPR, WTSURVY, HISPCAT, BAYR, REFYR, COMCOLI, 
                DIFHEAR, DIFLIFT, DIFSEE, DIFWALK,
                EDDAD, EDMOM, HSYR, LFSTAT, SATADV,
                SATBEN, SATCHAL, SATIND,SATLOC, SATRESP, SATSAL,
                SATSEC, SATSOC, WAPRI, EMSMI)

#From 2017 to 2019 the following vars changed names
# NDGRMED->N2DGRMED = field of highest degree
# NBAMED->N2BAMED = field of bachelors degre
# NBANED->N2BANED = field of second degree of minor
# N2OCPR->N3OCPR = principal job

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Majors by Job -----------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#so looking at what Fields of Study are common for given occupations

majors_by_job <-  NSCG_2019_clean %>%  
  dplyr::select(N2OCPR, NDGRMED, WTSURVY) %>% 
  group_by(N2OCPR) %>% 
  nest()


jobs_by_major <-  NSCG_2019_clean %>% 
  filter(N2OCPR!=999989) %>%  
  dplyr::select(N2OCPR, NDGRMED, WTSURVY) %>% 
  group_by(NDGRMED) %>% 
  nest()

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Set up survey design function--------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##This function takes a dataframe as an input, and outputs a "design" object, 
# which tells svy commands (like svytable) how to weight the data
design_func <- function(df) {
  design_hidden <- svydesign(~0, data = df, weights = df$WTSURVY)
}

##Just making a "design" column, so that each job's mini_dataframe (in the data column) 
##is next to the design object for it. This will allow us to use weights when we work with them. So the cell for N2OCPR==1 and 
## column = design is the weights for the N2OCPRs==1 minidataframe. 
majors_by_job <- majors_by_job %>% 
  mutate(design = map(data, design_func))

jobs_by_major <- jobs_by_major %>% 
  mutate(design = map(data, design_func))

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Generate top majors by job ----------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## The first row is me saying that for the ith element of the majors_tables column, make a survey table using the ith row of the data column,
##and the ith row of the design column. Then make that into a proportion table, make that into a data frame, and finally make that into 
## a tibble. So look at the mini dataframe in the data column for geologists. Make a frequency table of the majors, and use the survey 
##weights stored in the design column for geologists. Then take that frequency table and make it into a proportion table, then a df, then
##a tibble. The second line just dplyr::renames the leftmost column in the mini dataframes to major
##The third says okay now we have these dataframes for each job in the "majors_tables" column. To each of these dataframes
##we want to add a new column that converts the proportion from a decimal to a percentage. Then, we arrange these mini dataframes based on
##the percent of people that are each major. Finally, we use this list of majors to create a new column of mini dataframes of the the top 5 most common majors for each job

### PIPED VERSION
### Just cleaned the first line to work with pipes so I could read it and added some comments @Caio
for (i in seq_along(majors_by_job$N2OCPR)) {
  ## create survey table for this job cat
  majors_by_job$majors_tables[[i]] <- svytable(~majors_by_job$data[[i]]$NDGRMED, 
                                               design = majors_by_job$design[[i]]) %>%
    prop.table() %>%
    as.data.frame() %>%
    as_tibble()
  ## dplyr::rename column in nested survey table
  majors_by_job$majors_tables[[i]] <- dplyr::rename(majors_by_job$majors_tables[[i]], 
                                                    major = majors_by_job.data..i...NDGRMED)
  ## add percentage column to  survey table 
  majors_by_job$majors_tables[[i]]$percentage <- majors_by_job$majors_tables[[i]]$Freq*100
  ## sort survey table by percent
  majors_by_job$majors_tables[[i]] <- arrange(majors_by_job$majors_tables[[i]], 
                                              desc(percentage))
  ##make a cumulative sum column of percent for each majors_tables tibble
  majors_by_job$majors_tables[[i]] <- majors_by_job$majors_tables[[i]] %>% 
    mutate(cum_perc = cumsum(majors_by_job$majors_tables[[i]]$percentage))
  ##extract all majors for which the cumulative sum of percentage is less than or equal to 75%, put that in a new mini tibble
  majors_by_job$top_75_p[[i]] <- majors_by_job$majors_tables[[i]] %>% 
    filter(ifelse(test = (percentage<=75), 
                  yes = cum_perc <= 75, 
                  no = percentage>75))
  ##List majors by cumulative percent of workers covered. Find the one that takes the cumulative percentage from below to above 75% and all the majors below it
  majors_by_job$top_75_p_inclusive[[i]] <- majors_by_job$majors_tables[[i]] %>% 
    mutate(over75=case_when(cum_perc>=75~1,TRUE~0),
           include = case_when(over75==1 & lag(over75)==0~1,
                               over75==0~1,
                               TRUE~0)) %>% ##Looking at when cumperc turns from below to above 75%
    filter(include==1)
}

majors_by_job <- majors_by_job %>% 
  dplyr::select(-data,-design,-majors_tables)

##Arranging so N2OCPR==0 is at top
majors_by_job<- majors_by_job %>% 
  arrange(N2OCPR)


###**************************************************Now turning to making the mismatch variable**************************************************

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Getting data set up -----------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Set up survey design
design <- svydesign(~0, data = NSCG_2019_clean, weights = NSCG_2019_clean$WTSURVY)

##KEY, use the merge! So I have majors_by_job, which has a jobcus column and a top_5 column. The top_5 column contains the top 5 majors for 
##the given job. I can use a merge so that I bring this top_5 column to the NSCG data, using jobcus. So each row in NSCG where jobcus ==
## geologist, there will be a top_5 column, which would be the top 5 majors for geologists in that given row
NSCG_2019_clean <- left_join(NSCG_2019_clean, 
                             majors_by_job, 
                             by = "N2OCPR") ##THIS IS THE KEY

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Create mismatch variable itself -----------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##Looks at each row of NSCG, and sets the value of the ith row of the new objmatch column to 1 or 0 based on the following. It first goes to the ith column of NSCG and sees the value of
## NDGMEN. It then goes to that same ith row of NSCG and looks at the top_75_p column. This is a list of lists, so each element of top_75_p is a list with 1 element, a tibble. We want the 
##tibble, so we put the double brackets. So now we have the tibble in the ith row of the top_75_p column. Now we grab the list of majors in that tibble. This represents the top 75% majors
##for the job of the person in that ith row. If the value of NDGRMED in the ith column is in the list of the top_75_p majors, set the value of objmatch to 1. Otherwise, set it to 0. 
library("progress")
pb <- progress_bar$new(format = "[:bar] :current/:total (:percent)", 
                       total = nrow(NSCG_2019_clean))
for (i in 1:nrow(NSCG_2019_clean)) {
  pb$tick()
  NSCG_2019_clean$Obj_Mismatch[i] <- NSCG_2019_clean[i,]$NDGRMED %in% NSCG_2019_clean[i,]$top_75_p[[1]]$major ##need to do this because the ith row of top_5 major is a list with 
  ##one element, the tibble. RUn this code to see this: class(NSCG_2019_clean[3,]$top_5). So we need to tell r, look at the ith row of the top_5 column,  which will be 
  ##a list, then take the first element of this list, which is a tibble, then look at the major column. 
  NSCG_2019_clean$Obj_Mismatch_Inclusive[i] <- NSCG_2019_clean[i,]$NDGRMED %in% NSCG_2019_clean[i,]$top_75_p_inclusive[[1]]$major
}


##this converts mismatches to numeric
NSCG_2019_clean$Obj_Mismatch <-  as.numeric(NSCG_2019_clean$Obj_Mismatch) 
NSCG_2019_clean$Obj_Mismatch_Inclusive <-  as.numeric(NSCG_2019_clean$Obj_Mismatch_Inclusive) 

##Inverting variables. Right now it is 1 if matched, I want it to be 1 if mismatched
NSCG_2019_clean <- NSCG_2019_clean %>% 
  mutate(Obj_Mismatch = ifelse(Obj_Mismatch == 1, 0, 1),
         Obj_Mismatch_Inclusive = ifelse(Obj_Mismatch_Inclusive == 1, 0, 1))

##Getting non-list columns
NSCG_2019_clean <- NSCG_2019_clean %>% 
  select_if(negate(is.list))


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Find top jobs by major ------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# so looking at what jobs are common are given fields of study

jobs_by_major <-  NSCG_2019_clean %>% filter(N2OCPR!=999989) %>%
  dplyr::select(N2OCPR, NDGRMED, WTSURVY) %>% 
  group_by(NDGRMED) %>% 
  nest()

jobs_by_major <- jobs_by_major %>% 
  mutate(design = map(data, design_func))

for (i in seq_along(jobs_by_major$NDGRMED)) {
  ## create survey table for this job cat
  jobs_by_major$jobs_tables[[i]] <- svytable(~jobs_by_major$data[[i]]$N2OCPR, 
                                             design = jobs_by_major$design[[i]]) %>%
    prop.table() %>%
    as.data.frame() %>%
    as_tibble()
  ## dplyr::rename column in nested survey table
  jobs_by_major$jobs_tables[[i]] <- dplyr::rename(jobs_by_major$jobs_tables[[i]], 
                                                  job = jobs_by_major.data..i...N2OCPR)
  ## add percentage column to  survey table 
  jobs_by_major$jobs_tables[[i]]$percentage <- jobs_by_major$jobs_tables[[i]]$Freq*100
  ## sort survey table by percent
  jobs_by_major$jobs_tables[[i]] <- arrange(jobs_by_major$jobs_tables[[i]], 
                                            desc(percentage))
  ##make a cumulative sum column of percent for each jobs_tables tibble
  jobs_by_major$jobs_tables[[i]] <- jobs_by_major$jobs_tables[[i]] %>%
    mutate(cum_perc = cumsum(jobs_by_major$jobs_tables[[i]]$percentage))
  ##extract all majors for which the cumulative sum of percentage is less than or equal to 75%, put that in a new mini tibble
  jobs_by_major$top_75_p[[i]] <- jobs_by_major$jobs_tables[[i]] %>% 
    filter(ifelse(test = (percentage<=75), 
                  yes = cum_perc <= 75, 
                  no = percentage>75))
  ##List occupations by major by cumulative percent of individuals covered. Find the occupation that takes the cumulative percentage from below to above 75% and all the occupations below it
  jobs_by_major$top_75_p_inclusive[[i]] <- jobs_by_major$jobs_tables[[i]] %>% 
    mutate(over75=case_when(cum_perc>=75~1,TRUE~0),
           include = case_when(over75==1 & lag(over75)==0~1,
                               over75==0~1,
                               TRUE~0)) %>% ##Looking at when cumperc turns from below to above 75%
    filter(include==1)
}

jobs_by_major <- jobs_by_major %>% 
  dplyr::select(-data,-design,-jobs_tables)


##KEY, use the merge! So I have jobs_by_major, which has a jobcus column and a top 75 percnt column. The top 75 percnt column contains the top 5 majors for 
##the given job. I can use a merge so that I bring this top 75 percnt column to the NSCG data, using jobcus. So each row in NSCG where jobcus ==
## geologist, there will be a top 75 percnt column, which would be the top 5 majors for geologists in that given row
NSCG_2019_clean <- left_join(NSCG_2019_clean, jobs_by_major, by = "NDGRMED") ##THIS IS THE KEY

NSCG_2019_clean <- NSCG_2019_clean %>% 
  as.tibble()

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Creat mismatch variable itself ------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

##Looks at each row of NSCG, and sets the value of the ith row of the new objmatch column to 1 or 0 based on the following. It first goes to the ith column of NSCG and sees the value of
## NDGMEN. It then goes to that same ith row of NSCG and looks at the top 75 percnt column. This is a list of lists, so each element of top 75 percnt is a list with 1 element, a tibble. We want the 
##tibble, so we put the double brackets. So now we have the tibble in the ith row of the top 75 percnt column. Now we grab the list of majors in that tibble. This represents the top 5 majors
##for the job of the person in that ith row. If the value of NDGRMED in the ith column is in the list of the top 5 majors, set the value of objmatch to 1. Otherwise, set it to 0. 

library("progress")
pb <- progress_bar$new(format = "[:bar] :current/:total (:percent)", total = nrow(NSCG_2019_clean))
for (i in 1:nrow(NSCG_2019_clean)) {
  pb$tick()
  NSCG_2019_clean$Obj_Mismatch_Reversed[i] <- NSCG_2019_clean[i,]$N2OCPR %in% NSCG_2019_clean[i,]$top_75_p[[1]]$job ##need to do this because the ith row of top 75 percnt major is a list with 
  ##one element, the tibble. RUn this code to see this: class(NSCG_2019_clean[3,]$top 75 percnt). So we need to tell r, look at the ith row of the top 75 percnt column,  which will be 
  ##a list, then take the first element of this list, which is a tibble, then look at the major column. 
  NSCG_2019_clean$Obj_Mismatch_Reversed_Inclusive[i] <- NSCG_2019_clean[i,]$N2OCPR %in% NSCG_2019_clean[i,]$top_75_p_inclusive[[1]]$job
}


##this converts objmatch2 to numeric
NSCG_2019_clean$Obj_Mismatch_Reversed <-  as.numeric(NSCG_2019_clean$Obj_Mismatch_Reversed) 
NSCG_2019_clean$Obj_Mismatch_Reversed_Inclusive <-  as.numeric(NSCG_2019_clean$Obj_Mismatch_Reversed_Inclusive) 


##Right now the mismatch column is 1 if matched, I am reversing it
NSCG_2019_clean <- NSCG_2019_clean %>% 
  mutate(Obj_Mismatch_Reversed = ifelse(Obj_Mismatch_Reversed == 1, 0, 1))
NSCG_2019_clean <- NSCG_2019_clean %>% 
  mutate(Obj_Mismatch_Reversed_Inclusive = ifelse(Obj_Mismatch_Reversed_Inclusive == 1, 0, 1))

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Final cleaning -----------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

##Getting non-list columns
NSCG_2019_clean <- NSCG_2019_clean %>% select_if(negate(is.list))


##getting debt variable
NSCG_2019_clean <- NSCG_2019_clean %>% 
  mutate(Undergrad_Debt=case_when(UGLOANR=="2"~ 0,
                                  UGLOANR=="3"~5000,
                                  UGLOANR=="4"~15000,
                                  UGLOANR=="5"~ 25000,
                                  UGLOANR=="6"~ 35000,
                                  UGLOANR=="7" ~ 45000,
                                  UGLOANR=="8" ~ 55000,
                                  UGLOANR=="9" ~ 65000,
                                  UGLOANR=="10" ~ 75000,
                                  UGLOANR=="11" ~ 85000,
                                  UGLOANR=="12" ~ 95000))

##Saving
saveRDS(NSCG_2019_clean, file = "Data/NSCG_2019_clean.rds")


