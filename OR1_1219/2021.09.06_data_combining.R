# OR1-1219
pacman::p_load(dplyr,
               tidyr,
               readxl,
               writexl)

# summer internship data----
summer <- 
  read_xlsx('OR1_1219/2021.03.09_OR1-1217_OR1-1219_macro_sorting.xlsx',sheet = 4) %>%
  filter(Cruise == "OR1_1219") %>% # filter by cruise
  filter(Taxon != "Polychaeta") %>%  # filter polychaetes
  filter(Taxon != "Ophiuroidea") # filter ophiuroids

# renaming unknowns in the summerinternship data ----
# screen out species expect unknown
summer_others <- 
  summer %>% 
  filter(Taxon !="Unknown sp.1" & Taxon != "Unknown sp.2")

# screen out unknown and rename them
unk1 <- 
  summer %>% 
  filter(Taxon %in% c("Unknown sp.1") ) %>% 
  mutate(Note = "Larvae?", Taxon = "Unknown")

unk2 <- 
  summer %>% 
  filter(Taxon %in% c("Unknown sp.2") ) %>%
  mutate(Note = "Palp like", Taxon = "Unknown")

summer <- 
  full_join(summer_others, unk1) %>%
  full_join(unk2)

# other size data ----
# ophiuroids are measured correctly
size <- read_xlsx('OR1_1219/OR1-1219_RawTypingFile.xlsx', sheet = 3)

# Change "Limb" (old protocol) to "Arm"
size[size$Note %in% "Limb",]$Note <- "Arm" 

# combine summer and size ----
size <- full_join(summer, size)

# read OR1_1219 polychaeta ----
poly_measurements <- read_xlsx("OR1_1219/OR1-1219_poly_rem.xlsx")

# join all data and write xlsx----
full_join(poly_measurements, size) %>% write_xlsx(path = "data/OR1_1219_macro_final.xlsx")