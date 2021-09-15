pacman::p_load(
  readxl,
  writexl,
  dplyr
)

# read RawTypingFile ----
macro <- 
  read_xlsx('OR1_1219/OR1-1219_RawTypingFile.xlsx', sheet = 3) %>% 
  mutate(L = L*0.1, W = W*0.1) # rescale L and W to mm

# adding summerinternship data ----
si <- read_xlsx('OR1_1219/2021.03.09_OR1-1217_OR1-1219_macro_sorting.xlsx',sheet = 4) %>% 
  filter(Cruise == "OR1_1219") %>% # filter by cruise
  filter(Taxon != "Polychaeta") %>%  # filter polychaetes
  filter(Taxon != "Ophiuroidea") # filter ophiuroids

# renaming unknowns in the summerinternship data ----
# screen out species expect unknown
oth <- si %>% 
  filter(Taxon !="Unknown sp.1" & Taxon != "Unknown sp.2")

# screen out unknown and rename them
unk<- si %>% 
  filter(Taxon %in% c("Unknown sp.1", "Unknown sp.2") ) %>% 
  mutate(Note = Taxon, Taxon = "Unknown")

# data merging ----
# final macrofauna size data
# merging unknowns, others, and the rest of the OR1-1219
OR1_1219 <- full_join(raw.data , oth, by = colnames(si)) %>% 
  full_join(unk, by = colnames(si)) %>%
  mutate(Section = "0-10")

# polychaete count inclusion ----

# summer internship data
poly1 <- read_xlsx('2021.03.09_OR1-1217_OR1-1219_macro_sorting.xlsx',sheet = 4) %>%
  filter(Taxon == "Polychaeta" & Cruise == "OR1_1219") %>% 
  select(Cruise, Habitat ,Station, Deployment, Tube, Taxon, Condition) %>%
  group_by(Cruise, Habitat, Station, Deployment, Tube, Condition) %>% 
  count(Condition) %>%
  pivot_wider(names_from = "Condition", values_from = "n") %>%
  mutate(Note = NA)

# RawTypingfile
hab <- c(rep("Canyon", 3), rep("Shelf", 6),rep("Slope", 3), rep("Shelf", 4))
poly2 <- read_xlsx('OR1-1219_RawTypingFile.xlsx', sheet = 2) %>% 
  mutate(Cruise = "OR1_1219", Habitat = hab)
colnames(poly2)[2] <- "Deployment"

# Joining two polychaete count data
Poly.c <- full_join(poly1, poly2, by = colnames(poly1))


# new lines 2021/08/10  ---------------
OR1_1219[OR1_1219$Taxon == "Ophiuroidea" & OR1_1219$Note == "Limb",] <-
  OR1_1219 %>%
  filter(Taxon == "Ophiuroidea") %>% 
  filter(Note == "Limb") %>%
  mutate(Note = "Arm")

View(OR1_1219)

# write
write_xlsx(list(OR1_1219_macro = OR1_1219, Polychaete_count = Poly.c), "OR1_1219_macro_size.xlsx")
