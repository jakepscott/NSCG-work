NSCG_2017_Old_raw <- read_rds(here("NSCG_Data/NSCG_2017_clean.rds")) 


# NSCG_2017_Old %>% 
#   count(Obj_Mismatch, wt=WTSURVY) %>% 
#   mutate(percent = n/sum(n)*100) 
  
NSCG_2017_Old <- NSCG_2017_Old_raw %>% 
  select("Job" = N2OCPR, "Major" = NDGRMED, "Org_Match" = Obj_Mismatch, WTSURVY) %>% 
  #filter(Job != 999989L) %>% 
  arrange(Job,Major)



NSCG_2017_Old %>% 
  count(Job,Major,Org_Match) 
NSCG_2017_Old %>%
  filter(Job != 999989L) %>%
  count(Org_Match, wt = WTSURVY) %>%
  mutate(percent = n/sum(n)*100)


match_M2_clean <- match_M2 %>% 
  select(Job, Major, "New_Match" = match, WTSURVY) %>% 
  mutate(New_Match = ifelse(New_Match == "Match", 0, 1)) %>% 
  arrange(Job,Major)

match_M2_clean %>% 
  count(Job,New_Match,wt = WTSURVY) %>% 
  group_by(Job) %>% 
  mutate(percent = n/sum(n)*100) %>% 
  ungroup() %>% 
  arrange(desc(percent)) %>% 
  group_by(Job) %>% 
  mutate(total = sum(n)) %>% 
  ungroup() %>% 
  mutate(per_of_tot_jobs = total/sum(total)*100) %>% 
  arrange(desc(per_of_tot_jobs))

match_M2_clean %>% 
  count(Job,Major,New_Match)


old <- NSCG_2017_Old %>% 
  count(Job,Org_Match,wt = WTSURVY) %>% 
  group_by(Job) %>% 
  mutate(old_percent = n/sum(n)*100) %>% 
  ungroup() %>% 
  arrange(desc(old_percent)) %>% 
  select(Job, Org_Match, old_percent) %>% 
  mutate(Job = as.numeric(Job))


new <- match_M2_clean %>% 
  count(Job,New_Match,wt = WTSURVY) %>% 
  group_by(Job) %>% 
  mutate(percent = n/sum(n)*100) %>% 
  ungroup() %>% 
  arrange(desc(percent)) %>% 
  select(Job, New_Match, percent)  

old %>% 
  left_join(new, by = c("Job", "Org_Match"="New_Match")) %>% 
  mutate(diff = percent - old_percent) %>% 
  View()

majors_by_job_M2 %>% 
  filter(Job==382750) %>% 
  pull(count_table)
