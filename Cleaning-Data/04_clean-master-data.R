# Load Libs ---------------------------------------------------------------
library(tidyverse)
library(here)
library(vroom)

# Load Data ---------------------------------------------------------------
NSCG_raw <- vroom(here("NSCG_Data/NSCG_Master_Raw.csv"))

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# generate Variables-----------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Rename weight and year vars ---------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
NSCG_Master <- NSCG_raw %>% 
  dplyr::rename( "Survey_Year"=REFYR, "Survey_Weight"=WTSURVY)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Generate satisfaction variable ------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Detailed satisfaction
NSCG_Master <- NSCG_Master %>% 
  mutate(Job_Satis = case_when(JOBSATIS=="4" ~ 1,
                               JOBSATIS=="3" ~ 2,
                               JOBSATIS=="2" ~ 3,
                               JOBSATIS=="1" ~ 4,
                               TRUE ~ NA_real_))


NSCG_Master$Job_Satis <- factor(NSCG_Master$Job_Satis,
                                labels = c("Very Dissatisfied", "Somewhat Dissatisfied", 
                                           "Somewhat Satisfied", "Very Satisfied"))
##Binary
NSCG_Master <- NSCG_Master %>% 
  mutate(Bi_Job_Satis = ifelse(JOBSATIS=="4" | JOBSATIS=="3", 
                               yes = 0, no = 1))

##Satisfaction with specific facets of the job
NSCG_Master <- NSCG_Master %>% mutate(SATADV = ifelse(SATADV=="4"|SATADV=="3", "0", "1"),
                                      SATBEN = ifelse(SATBEN=="4"|SATBEN=="3", "0", "1"),
                                      SATCHAL = ifelse(SATCHAL=="4"|SATCHAL=="3", "0", "1"),
                                      SATIND = ifelse(SATIND=="4"|SATIND=="3", "0", "1"),
                                      SATLOC = ifelse(SATLOC=="4"|SATLOC=="3", "0", "1"),
                                      SATRESP = ifelse(SATRESP=="4"|SATRESP=="3", "0", "1"),
                                      SATSAL = ifelse(SATSAL=="4"|SATSAL=="3", "0", "1"),
                                      SATSEC = ifelse(SATSEC=="4"|SATSEC=="3", "0", "1"),
                                      SATSOC = ifelse(SATSOC=="4"|SATSOC=="3", "0", "1"))

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Generate subjective mismatch ------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
NSCG_Master <- NSCG_Master %>% dplyr::rename("Sub_Mismatch" = OCEDRLP)
NSCG_Master <- NSCG_Master %>% 
  mutate(Sub_Mismatch = case_when(Sub_Mismatch != "L" ~ as.numeric(Sub_Mismatch),
                                  TRUE ~ NA_real_))

NSCG_Master$Sub_Mismatch <- factor(NSCG_Master$Sub_Mismatch,
                                   labels = c("Closely Related", "Somewhat Related", "Not Related"))

NSCG_Master <- NSCG_Master %>%
  mutate(Bi_Mismatch = ifelse(Sub_Mismatch=="Not Related",1,0))

NSCG_Master$Bi_Mismatch <- factor(NSCG_Master$Bi_Mismatch)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Create combined mismatch variable ---------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
NSCG_Master

#
#RECALL: Need to rename "match" into Objective match
NSCG_Master <- NSCG_Master %>% 
  mutate(Full_Mismatch = case_when(Sub_Mismatch=="Closely Related" & obj_match=="Match" ~ "True Match",
                                   Sub_Mismatch=="Closely Related" & obj_match=="Mismatch" ~ "Reported Match",
                                   Sub_Mismatch=="Somewhat Related" & obj_match=="Match" ~ "Somewhat Matched",
                                   Sub_Mismatch=="Somewhat Related" & obj_match=="Mismatch" ~ "Somewhat Mismatched",
                                   Sub_Mismatch=="Not Related" & obj_match=="Match" ~ "Reported Mismatch",
                                   Sub_Mismatch=="Not Related" & obj_match=="Mismatch"~ "True Mismatch",
                                   TRUE ~ NA_character_),
         four_mismatch = case_when(Sub_Mismatch=="Closely Related" & obj_match=="Match" | 
                                     Sub_Mismatch=="Somewhat Related" & obj_match=="Match" ~ "True Match",
                                   Sub_Mismatch=="Closely Related" & obj_match=="Mismatch" | 
                                     Sub_Mismatch=="Somewhat Related" & obj_match=="Mismatch" ~ "Reported Match",
                                   Sub_Mismatch=="Not Related" & obj_match=="Match" ~ "Reported Mismatch",
                                   Sub_Mismatch=="Not Related" & obj_match=="Mismatch" ~ "True Mismatch",
                                   TRUE ~ NA_character_))



################################################################################################################
##Generating demographic variables
################################################################################################################
#Race
NSCG_Master <- NSCG_Master %>% 
  mutate(Race=RACETHM)

NSCG_Master <- NSCG_Master %>% 
  mutate(Race=case_when(RACETHM=="5" ~ "White",
                        RACETHM=="1" ~ "Asian (and Asian/White)",
                        RACETHM=="3" ~ "Black, non-Hispanic",
                        HISPCAT=="1" ~ "Hispanic, Mexican",
                        HISPCAT=="2" | HISPCAT=="3" | HISPCAT=="4" ~  "Hispanic, non-Mexican",
                        RACETHM=="2" ~ "American Indian/Alaskan Native",
                        RACETHM=="6" ~ "Non-Hispanic Native Hawaiian/Pacific Islander", 
                        RACETHM=="7" ~ "Multiple Race",
                        TRUE ~ NA_character_))

#Race binary
NSCG_Master <- NSCG_Master %>% 
  mutate(Non_White=ifelse(Race!="White",1,0))

#Gender
NSCG_Master <- NSCG_Master %>% 
  dplyr::rename(Gender=GENDER)

NSCG_Master$Gender <- factor(NSCG_Master$Gender)

#Age
NSCG_Master <- NSCG_Master %>% mutate(Age=AGE, Age_Squared=(AGE^2))

#Citzenship
NSCG_Master <- NSCG_Master %>% mutate(US_Citizen=ifelse(CTZUSIN=="Y",1, 0))

################################################################################################################
##Personal Characteristics
################################################################################################################
NSCG_Master <- NSCG_Master %>% mutate(Children=ifelse(CHLVIN=="Y", 1,0),
                                      Marital_Status= ifelse(MARSTA=="1",0,
                                                             ifelse(MARSTA=="2",1,
                                                                    ifelse(MARSTA=="3", 2,
                                                                           ifelse(MARSTA=="4", 3,
                                                                                  ifelse(MARSTA=="5", 4,
                                                                                         ifelse(MARSTA=="6", 5, NA)))))),
                                      Spouse_Working = ifelse(SPOWK=="3", 0, 
                                                              ifelse(SPOWK=="1" | SPOWK=='2', 1, NA)),
                                      Phy_Disability=ifelse(HCAPIN=="N", 0, 
                                                            ifelse(HCAPIN=="Y", 1, NA)))

#Parent's education level
NSCG_Master <- NSCG_Master %>% mutate(EDDAD=as.numeric(EDDAD),
                                      EDMOM=as.numeric(EDMOM)) %>% mutate(EDDAD=case_when(EDDAD==1 | EDDAD==2 ~ 0,
                                                                                          EDDAD==3~1,
                                                                                          EDDAD==4~2,
                                                                                          EDDAD!=8 & EDDAD>=5~3),
                                                                          EDMOM=case_when(EDMOM==1 | EDMOM==2 ~ 0,
                                                                                          EDMOM==3~1,
                                                                                          EDMOM==4~2,
                                                                                          EDMOM!=8 & EDMOM>=5~3))

NSCG_Master$EDDAD <- factor(NSCG_Master$EDDAD,
                            levels = c(0,1,2,3),
                            labels = c("HS or Less", "Some Col", "BA", "Advanced"))

NSCG_Master$EDMOM <- factor(NSCG_Master$EDMOM,
                            levels = c(0,1,2,3),
                            labels = c("HS or Less", "Some Col", "BA", "Advanced"))


NSCG_Master$Marital_Status <- factor(NSCG_Master$Marital_Status,
                                     labels = c("Married", "Marriage-Like Relationship", "Widowed",
                                                "Separated", "Divorced", "Never Married"))

NSCG_Master <- NSCG_Master %>% mutate(RESPLOC=as.numeric(RESPLOC))
NSCG_Master <- NSCG_Master %>% mutate(Region = ifelse(RESPLOC==1,0,
                                                      ifelse(RESPLOC==2,1,
                                                             ifelse(RESPLOC==3, 2,
                                                                    ifelse(RESPLOC==4,3,
                                                                           ifelse(RESPLOC==5, 4, 
                                                                                  ifelse(RESPLOC==6,5,
                                                                                         ifelse(RESPLOC==7,6,
                                                                                                ifelse(RESPLOC==8,7,
                                                                                                       ifelse(RESPLOC==9,8,
                                                                                                              ifelse(RESPLOC>=10,9,NA)))))))))))

NSCG_Master$Region <- factor(NSCG_Master$Region,
                             labels = c("New England","Middle Atlantic", "East North Central",
                                        "West North Central", "South Atlantic", "East South Central",
                                        "West South Central", "Mountain", "Pacific and US Territories",
                                        "Other")) 

################################################################################################################
##Education Variables
################################################################################################################
NSCG_Master <- NSCG_Master %>% mutate(Highest_Degree_Type=ifelse(DGRDG=="1",0,
                                                                 ifelse(DGRDG=="2", 1, 
                                                                        ifelse(DGRDG=="3",2,
                                                                               ifelse(DGRDG=="4", 3, NA)))),
                                      Institution=ifelse(HDCARN=="40"|HDCARN=="51"|HDCARN=="53"|HDCARN=="54"|HDCARN=="56"|HDCARN=="57"|HDCARN=="59"|HDCARN=="60", "Other",
                                                         ifelse(HDCARN=="M" | HDCARN=="L",NA,HDCARN)),
                                      Private=ifelse(HDPBPR=="1",0,
                                                     ifelse(HDPBPR=="2",1, NA)))

NSCG_Master$Highest_Degree_Type <- factor(NSCG_Master$Highest_Degree_Type,
                                          levels = c(0,1,2,3),
                                          labels = c("Bachelor's", "Master's", "Doctorate", "Professional"))
NSCG_Master$Institution <- factor(NSCG_Master$Institution,
                                  levels = c(11, 12, 13, 14, 21, 22, 31, 32, 52, "Other"),
                                  labels = c(" Research University I", "Research University II", "Doctorate Granting I", "Doctorate Granting II",
                                             "Comprehensive I", "Comprehensive II", "Liberal Arts I", "Liberal Arts II", "Medical School", "Other"))

##Fixing field of study variables
NSCG_Master <- NSCG_Master %>% mutate(Major=ifelse(NBAMED=="999989" | NBAMED=="", NA, NBAMED),
                                      Second_Major=ifelse(NBANED=="999989" | NBANED=="", NA, NBANED),
                                      Highest_Deg_Field=ifelse(NDGRMED=="999989" | NDGRMED=="", NA, NDGRMED))
#Community College Indicator
NSCG_Master <- NSCG_Master %>% dplyr::rename("Com_Col"=COMCOLI) %>% 
  mutate(Com_Col=ifelse(Com_Col=="Y",1,ifelse(Com_Col=="N", 0, NA)))

NSCG_Master <- NSCG_Master %>% dplyr::rename("Grad_Year_BA"=BAYR, "Grad_Year_HS"=HSYR) %>% 
  mutate(Grad_Year_BA=ifelse(Grad_Year_BA>=2020, NA, Grad_Year_BA))
NSCG_Master <- NSCG_Master %>% mutate(Years_Since_Grad=Survey_Year-Grad_Year_BA,
                                      Years_Since_Grad_Squared=Years_Since_Grad^2)

################################################################################################################
##Debt
################################################################################################################                                                                                                                        ifelse(UGLOANR=="12",95000, NA))))))))))))
##Adjusting for Inflation
#inflation_adjust(2003) %>% filter(year==2017) %>% select(adj_value)
#inflation_adjust(2010) %>% filter(year==2017) %>% select(adj_value)
#inflation_adjust(2013) %>% filter(year==2017) %>% select(adj_value)
#inflation_adjust(2015) %>% filter(year==2017) %>% select(adj_value)

NSCG_Master <- NSCG_Master %>% mutate(Undergrad_Debt_Adj=
                                        case_when(Survey_Year==2003~Undergrad_Debt*1.33,
                                                  Survey_Year==2010~Undergrad_Debt*1.12,
                                                  Survey_Year==2013~Undergrad_Debt*1.05,
                                                  Survey_Year==2015~Undergrad_Debt*1.03,
                                                  Survey_Year==2017~Undergrad_Debt))

################################################################################################################
##Benefits
################################################################################################################
#No job benefits information for 2003 or 2013

NSCG_Master <- NSCG_Master %>% mutate(Health_Bens=ifelse(JOBINS=="Y", 1,
                                                         ifelse(JOBINS=="N", 0, NA)),
                                      Pension=ifelse(JOBPENS=="Y", 1,
                                                     ifelse(JOBPENS=="N", 0, NA)),
                                      Profit_Sharing=ifelse(JOBPROFT=="Y", 1,
                                                            ifelse(JOBPROFT=="N", 0, NA)),
                                      Time_Off=ifelse(JOBVAC=="Y", 1,
                                                      ifelse(JOBVAC=="N", 0, NA)))

################################################################################################################
##Job Characteristics
################################################################################################################
NSCG_Master <- NSCG_Master %>% mutate(Salary=ifelse(SALARY==9999998 | SALARY==999998 | (Survey_Year==2013 & SALARY>999996), NA,
                                                    ifelse(SALARY==0,NA, SALARY)),
                                      Hours_Worked=ifelse(HRSWK==98, NA, HRSWK),
                                      Log_Hours=log(Hours_Worked),
                                      Supervisor=ifelse(SUPWK=="Y", 1, 
                                                        ifelse(SUPWK=="N", 0, NA)),
                                      Full_Time=ifelse(HRSWK>=35, 1, 0),
                                      Tenure=(ifelse(STRTYR!=9998, Survey_Year-STRTYR, NA)),
                                      Tenure_Squared=(Tenure^2),
                                      Work_Type=WAPRI,
                                      Important_Adv=ifelse(FACADV=="L",NA,
                                                           ifelse(FACADV==2|FACADV==1,1,0)),
                                      Important_Ben=ifelse(FACBEN=="L",NA,
                                                           ifelse(FACBEN==2|FACBEN==1,1,0)),
                                      Important_Int=ifelse(FACCHAL=="L",NA,
                                                           ifelse(FACCHAL==2|FACCHAL==1,1,0)),
                                      Important_Ind=ifelse(FACIND=="L",NA,
                                                           ifelse(FACIND==2|FACIND==1,1,0)),
                                      Important_Loc=ifelse(FACLOC=="L",NA,
                                                           ifelse(FACLOC==2|FACLOC==1,1,0)),
                                      Important_Res=ifelse(FACRESP=="L",NA,
                                                           ifelse(FACRESP==2|FACRESP==1,1,0)),
                                      Important_Sal=ifelse(FACSAL=="L",NA,
                                                           ifelse(FACSAL==2|FACSAL==1,1,0)),
                                      Important_Sec=ifelse(FACSEC=="L",NA,
                                                           ifelse(FACSEC==2|FACSEC==1,1,0)),
                                      Important_Soc=ifelse(FACSOC=="L",NA,
                                                           ifelse(FACSOC==2|FACSOC==1,1,0)))


NSCG_Master <- NSCG_Master %>% mutate(Work_Type = ifelse(Work_Type=="L"|Work_Type=="LL", NA, Work_Type)) 
NSCG_Master$Work_Type <- factor(NSCG_Master$Work_Type,
                                labels = c("Accounting, finance, contracts", "Basic res.-study to gain sci. knwldg prima. for its own",
                                           "Apld. res.-study to gain sci. knwldg to meet recognized", 
                                           "Computer applications, programming, systems development",
                                           "Dev.-knowledge from res. for the prod. of materials",
                                           "Design of equipment, processes, structures, models",
                                           "Employee relations- inc. recruiting, personnel dev",
                                           "Management and Administration",
                                           "Production, operations, maintenance [e.g. truck driver]",
                                           "Prof. services [healthcare, fin. serv., legal serv",
                                           "Sales, purchasing, marketing",
                                           "Quality or productivity management",
                                           "Teaching",
                                           "Other"))

##Adjusting for Inflation
#inflation_adjust(2003) %>% filter(year==2017) %>% select(adj_value)
#inflation_adjust(2010) %>% filter(year==2017) %>% select(adj_value)
#inflation_adjust(2013) %>% filter(year==2017) %>% select(adj_value)
#inflation_adjust(2015) %>% filter(year==2017) %>% select(adj_value)

NSCG_Master <- NSCG_Master %>% mutate(Salary_Adj=case_when(Survey_Year==2003~Salary*1.33,
                                                           Survey_Year==2010~Salary*1.12,
                                                           Survey_Year==2013~Salary*1.05,
                                                           Survey_Year==2015~Salary*1.03,
                                                           Survey_Year==2017~Salary))

NSCG_Master <- NSCG_Master %>% mutate(Log_Salary_Adj=log(Salary_Adj))

NSCG_Master <- NSCG_Master %>% mutate(Job_Change=case_when(EMSMI=="1"~0,
                                                           EMSMI=="2"~1,
                                                           EMSMI=="3"~2,
                                                           EMSMI=="4"~3))


NSCG_Master$Job_Change <- factor(NSCG_Master$Job_Change,
                                 levels = c(0,1,2,3),
                                 labels = 
                                   c("No Change", "Same emp, Diff Job", "Diff emp, Same job", "Diff Empl, Diff job"))
################################################################################################################
##Firm Characteristics
################################################################################################################
NSCG_Master <- NSCG_Master %>% mutate(Firm_Size=ifelse(EMSIZE=="L", NA, EMSIZE),
                                      Firm_Type=ifelse(NEDTP=="L", NA, NEDTP))

NSCG_Master$Firm_Size <- factor(NSCG_Master$Firm_Size,
                                levels = 1:8,
                                labels = c("10 or fewer",
                                           "11-24",
                                           "25-99",
                                           "100-499",
                                           "500-999",
                                           "1000-4999",
                                           "5000-24999",
                                           "25000+"))
NSCG_Master$Firm_Type <- factor(NSCG_Master$Firm_Type,
                                levels = 1:9,
                                labels = c("Self-employed, not incorp. bus., profess. practice",
                                           "Self-employed, incorp. business, profess. practice",
                                           "Priv.-for-profit co./bus./indv., wrkg for wages/sal./comm",
                                           "Private not-for-profit, tax-exempt/charitable organ",
                                           "Local government [city, county, etc.]",
                                           "State government",
                                           "U.S. mil. ser., active duty or commiss. Corps",
                                           "U.S. government [civilian employee]",
                                           "Other"))

#############################################################
##Last second cleaning
#############################################################

NSCG_Master <- NSCG_Master %>% filter(!is.na(Bi_Mismatch)) %>% mutate(Years_Since_Grad_Squared=
                                                                        Years_Since_Grad^2,
                                                                      Recent_Grad=ifelse(Years_Since_Grad<=6,1,0))


#############################################################
##Only Keeping Vars of Interest
############################################################
NSCG_Master <- NSCG_Master %>% dplyr::select(-NBAMED, -NBANED, - NDGRMED,-(JOBSATIS:BAACYR),-RACETHM, -(AGE:HDPBPR), 
                                             -(JOBINS:NRREA), -N2OCPR, -NOCPR, -HISPCAT)

############################################################
##Adding unemployment at time of grad
###########################################################
unemployment <- 
  read_csv(here("NSCG_Data/UNRATE.csv"))

unemployment <- unemployment %>% mutate(Month=month(DATE),
                                        Grad_Year_BA=year(DATE)) %>% filter(Month==5)

NSCG_Master <- left_join(NSCG_Master, unemployment, by="Grad_Year_BA")

#Creating recession indicator
recession_indicator <- read_csv(here("NSCG_Data/USRECM.csv"))
rec_yearly <- recession_indicator %>% 
  mutate(Grad_Year_BA=year(DATE)) %>% 
  group_by(Grad_Year_BA) %>% 
  dplyr::summarise(recession=sum(USRECM)) %>% 
  ungroup() %>%
  mutate(recession=ifelse(recession>=1,1,0))

NSCG_Master <- left_join(NSCG_Master,rec_yearly,by="Grad_Year_BA")

#############################################################
##SAVING DATASET
############################################################
saveRDS(NSCG_Master, file = here("NSCG_Data/NSCG_Master.rds"))

