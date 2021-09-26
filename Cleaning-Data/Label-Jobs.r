#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Load Libs ---------------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library(tidyverse)
library(here)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Load Data ---------------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
data <- read_rds(here("Data/NSCG_Master.rds"))

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Make Labels -------------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Job_labels <- data %>% 
  select(Principal_Job) %>% 
  distinct(Principal_Job) %>%
  mutate(Job_Label = case_when(Principal_Job == 110510L ~ "Computer & information scientists, research",
                               Principal_Job == 110520L ~ "Computer network architect",
                               Principal_Job == 110530L ~ "Computer support specialists",
                               Principal_Job == 110540L ~ "Computer support specialists",
                               Principal_Job == 110550L ~ "Computer system analysts",
                               Principal_Job == 110560L ~ "Database administrators",
                               Principal_Job == 110570L ~ "Information security analysts",
                               Principal_Job == 110580L ~ "Network and computer systems administrators",
                               Principal_Job == 110590L ~ "Software developers - applications and systems software",
                               Principal_Job == 110600L ~ "Web developers",
                               Principal_Job == 110610L ~ "OTHER computer information science occupations",
                               Principal_Job == 110880L ~ "Computer engineers - software",
                               Principal_Job == 121720L ~ "Mathematicians",
                               Principal_Job == 121730L ~ "Operations research analysts, including modeling",
                               Principal_Job == 121740L ~ "Statisticians",
                               Principal_Job == 121760L ~ "OTHER mathematical scientists",
                               Principal_Job == 182760L ~ "Postsecondary Teachers: Computer Science",
                               Principal_Job == 182860L ~ "Postsecondary Teachers: Mathematics and Statistics",
                               Principal_Job == 210210L ~ "Agricultural and food scientists",
                               Principal_Job == 220220L ~ "Biochemists and biophysicists",
                               Principal_Job == 220230L ~ "Biological scientists (e.g., botanists, ecologists, zoologists)",
                               Principal_Job == 220250L ~ "Medical scientists (excluding practitioners)",
                               Principal_Job == 220270L ~ "OTHER biological and life scientists",
                               Principal_Job == 230240L ~ "Forestry and conservation scientists",
                               Principal_Job == 282710L ~ "Postsecondary Teachers: Agriculture",
                               Principal_Job == 282730L ~ "Postsecondary Teachers: Biological Sciences",
                               Principal_Job == 282970L ~ "Postsecondary Teachers: OTHER Natural Sciences",
                               Principal_Job == 311930L ~ "Chemists, except biochemists",
                               Principal_Job == 321920L ~ "Atmospheric and space scientists",
                               Principal_Job == 321940L ~ "Geologists, including earth scientists",
                               Principal_Job == 321950L ~ "Oceanographers",
                               Principal_Job == 331910L ~ "Astronomers",
                               Principal_Job == 331960L ~ "Physicists, except biophysicists",
                               Principal_Job == 341980L ~ "OTHER physical scientists",
                               Principal_Job == 382750L ~ "Postsecondary Teachers: Chemistry",
                               Principal_Job == 382770L ~ "Postsecondary Teachers: Earth, Environmental, and Marine Science",
                               Principal_Job == 382890L ~ "Postsecondary Teachers: Physics",
                               Principal_Job == 412320L ~ "Economists",
                               Principal_Job == 422350L ~ "Political scientists",
                               Principal_Job == 432360L ~ "Psychologists, including clinical",
                               Principal_Job == 442310L ~ "Anthropologists",
                               Principal_Job == 442370L ~ "Sociologists",
                               Principal_Job == 452380L ~ "OTHER social scientists",
                               Principal_Job == 482780L ~ "Postsecondary Teachers: Economics",
                               Principal_Job == 482900L ~ "Postsecondary Teachers: Political Science",
                               Principal_Job == 482910L ~ "Postsecondary Teachers: Psychology",
                               Principal_Job == 482930L ~ "Postsecondary Teachers: Sociology",
                               Principal_Job == 482980L ~ "Postsecondary Teachers: OTHER Social Sciences",
                               Principal_Job == 510820L ~ "Aeronautical/aerospace/astronautical engineers",
                               Principal_Job == 520850L ~ "Chemical engineers",
                               Principal_Job == 530860L ~ "Civil, including architectural/sanitary engineers",
                               Principal_Job == 540870L ~ "Computer engineer - hardware",
                               Principal_Job == 540890L ~ "Electrical and electronics engineers",
                               Principal_Job == 550910L ~ "Industrial engineers",
                               Principal_Job == 560940L ~ "Mechanical engineers",
                               Principal_Job == 570830L ~ "Agricultural engineers",
                               Principal_Job == 570840L ~ "Bioengineers or biomedical engineers",
                               Principal_Job == 570900L ~ "Environmental engineers",
                               Principal_Job == 570920L ~ "Marine engineers and naval architects",
                               Principal_Job == 570930L ~ "Materials and metallurgical engineers",
                               Principal_Job == 570950L ~ "Mining and geological engineers",
                               Principal_Job == 570960L ~ "Nuclear engineers",
                               Principal_Job == 570970L ~ "Petroleum engineers",
                               Principal_Job == 570980L ~ "Sales engineers",
                               Principal_Job == 570990L ~ "OTHER engineers",
                               Principal_Job == 582800L ~ "Postsecondary Teachers: Engineering",
                               Principal_Job == 611110L ~ "Diagnosing/treating practitioners (dent,optom,physicians,psych,pod,surgn,vet)",
                               Principal_Job == 611120L ~ "RNs, pharmacists, dieticians, therapists, physician asst, nurse practitioners",
                               Principal_Job == 611130L ~ "Health technologists and technicians (dent hyg,hlth rcrd tech,LPN,lab/rad tech)",
                               Principal_Job == 611140L ~ "OTHER health occupations",
                               Principal_Job == 612870L ~ "Postsecondary Teachers: Health and Related Sciences",
                               Principal_Job == 621420L ~ "Computer and information systems managers",
                               Principal_Job == 621430L ~ "Engineering managers",
                               Principal_Job == 621440L ~ "Medical and health services managers",
                               Principal_Job == 621450L ~ "Natural sciences managers",
                               Principal_Job == 632530L ~ "Teachers: Secondary - computer, math or sciences",
                               Principal_Job == 632540L ~ "Teachers: Secondary - social sciences",
                               Principal_Job == 640260L ~ "Technologists and technicians in the biological/life sciences",
                               Principal_Job == 640520L ~ "Computer programmers [business, scientific, process",
                               Principal_Job == 640530L ~ "Computer programmers (business, scientific, process control)",
                               Principal_Job == 641000L ~ "Electrical, electronic, industrial, and mechanical technicians",
                               Principal_Job == 641010L ~ "Drafting occupations, including computer drafting",
                               Principal_Job == 641020L ~ "Surveying and mapping technicians",
                               Principal_Job == 641030L ~ "OTHER engineering technologists and technicians",
                               Principal_Job == 641040L ~ "Surveyors, cartographers, photogrammetrists",
                               Principal_Job == 641750L ~ "Technologists and technicians in the mathematical sciences",
                               Principal_Job == 641970L ~ "Technologists and technicians in the physical sciences",
                               Principal_Job == 650810L ~ "Architects",
                               Principal_Job == 651710L ~ "Actuaries",
                               Principal_Job == 711410L ~ "Top-level managers, execs, admins (CEO/COO/CFO, pres, dist/gen mngr,provost)",
                               Principal_Job == 711460L ~ "Education administrators (e.g. registrar, dean, principal)",
                               Principal_Job == 711470L ~ "OTHER mid-level managers",
                               Principal_Job == 721510L ~ "Accountants, auditors, and other financial specialists",
                               Principal_Job == 721520L ~ "Personnel, training, and labor relations specialists",
                               Principal_Job == 721530L ~ "OTHER management related occupations",
                               Principal_Job == 732510L ~ "Teachers: Pre-kindergarten and kindergarten",
                               Principal_Job == 732520L ~ "Teachers: Elementary",
                               Principal_Job == 732550L ~ "Teachers: Secondary - other subjects",
                               Principal_Job == 732560L ~ "Teachers: Special education - primary and secondary",
                               Principal_Job == 732570L ~ "Teachers: OTHER precollegiate area",
                               Principal_Job == 742720L ~ "Postsecondary Teachers: Art, Drama, and Music",
                               Principal_Job == 742740L ~ "Postsecondary Teachers: Business Commerce and Marketing",
                               Principal_Job == 742790L ~ "Postsecondary Teachers: Education",
                               Principal_Job == 742810L ~ "Postsecondary Teachers: English",
                               Principal_Job == 742820L ~ "Postsecondary Teachers: Foreign Language",
                               Principal_Job == 742830L ~ "Postsecondary Teachers: History",
                               Principal_Job == 742880L ~ "Post-sec teachers - physical education",
                               Principal_Job == 742990L ~ "Postsecondary Teachers: OTHER Postsecondary fields",
                               Principal_Job == 750400L ~ "Clergy and other religious workers",
                               Principal_Job == 750700L ~ "Counselors (Educational, vocational,mental health, and substance abuse)",
                               Principal_Job == 752400L ~ "Social Workers",
                               Principal_Job == 762000L ~ "Insurance, securities, real estate and business services",
                               Principal_Job == 762010L ~ "Sales- Commodities except retail (industrial/med/dental machine,equip,supplies)",
                               Principal_Job == 762020L ~ "Sales- retail (e.g., furnishings, clothing, motor vehicles, cosmetics)",
                               Principal_Job == 762030L ~ "OTHER marketing and sales occupations",
                               Principal_Job == 770100L ~ "Writers, editors, PR specialists, artists, entertainers, broadcasters",
                               Principal_Job == 772330L ~ "Historians",
                               Principal_Job == 780310L ~ "Accounting clerks and bookkeepers",
                               Principal_Job == 780320L ~ "Secretaries, receptionists, typists",
                               Principal_Job == 780330L ~ "OTHER administrative (e.g. record clerks, telephone operators)",
                               Principal_Job == 781100L ~ "Farmers, Foresters and Fishermen",
                               Principal_Job == 781200L ~ "Lawyers, judges",
                               Principal_Job == 781300L ~ "Librarians, archivists, curators",
                               Principal_Job == 782210L ~ "Food preparation and service (e.g., cooks, waitresses, bartenders)",
                               Principal_Job == 782220L ~ "Protective services (e.g., fire fighters, police, guards, wardens, park rangers)",
                               Principal_Job == 782230L ~ "OTHER service occupations, except health (probation 860 1,029,731 officer,human services work)",
                               Principal_Job == 783000L ~ "OTHER teachers and instructors (private tutors, dance, flying, 585 616,276 martial arts)",
                               Principal_Job == 784010L ~ "Construction and extraction occupations",
                               Principal_Job == 784020L ~ "Installation, maintenance, and repair occupations",
                               Principal_Job == 784030L ~ "Precision/production occupations (metal/wood 381 348,057 work,butchers,baker,assmblr,tailor)",
                               Principal_Job == 784050L ~ "Transportation and material moving occupations",
                               Principal_Job == 785000L ~ "OTHER OCCUPATIONS"))



write_csv(Job_labels, here("Data/Job-labels.csv"))