# OR1-1219
pacman::p_load(dplyr,
               tidyr,
               readxl,
               writexl)

# summer internship data----
# the data collected in the 2019 summer internship is standardized to mm

summer <- 
  read_xlsx('OR1_1219/2021.03.09_OR1-1217_OR1-1219_macro_sorting.xlsx',sheet = 4) %>%
  filter(Cruise == "OR1_1219") %>% # filter by cruise
  filter(Taxon != "Polychaeta") %>%  # filter polychaetes
  filter(Taxon != "Ophiuroidea") # filter ophiuroids
# View(head(summer))

## renaming unknowns in the summerinternship data ----
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
size <- read_xlsx('OR1_1219/OR1-1219_RawTypingFile.xlsx', sheet = 3) %>%
  mutate(L = L * 0.1, W = W * 0.1) # unit to mm

# Standardize notation: "Limb" (old) to "Arm"
size[size$Note %in% "Limb",]$Note <- "Arm" 

# combine summer and size into size ----
size <- full_join(summer, size)

# Remove Bryozoa since I cannot find the speciemen... ---------------------------
size <- size[size$Taxon != "Bryozoa",]

# read OR1_1219 polychaeta ----
poly_measurements <- 
  read_xlsx("OR1_1219/OR1-1219_poly_rem.xlsx") %>%
  mutate(L = L * 0.1, W = W * 0.1) # unit to mm

s7_poly <- 
  read_xlsx('OR1_1219/2021.03.09_OR1-1217_OR1-1219_macro_sorting.xlsx',sheet = 4) %>%
  filter(Cruise == "OR1_1219") %>%
  filter(Station == "S7") %>%
  filter(Taxon == "Polychaeta") %>%
  mutate(Section = "0-10")

total_poly <- full_join(poly_measurements, s7_poly)

# join all data and write xlsx----
size <- full_join(total_poly, size)

write_xlsx(size, path = "data/OR1_1219_macro_size_final.xlsx")
