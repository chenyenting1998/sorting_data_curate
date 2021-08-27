setwd("C:\\Users\\tumha\\Desktop\\Lab Work\\Data\\Sorting data\\LGD_2006")

library(readxl)
library(writexl)
library(dplyr)


# Macrofauna --------------------------------------------------------------
# stations include all the stations measured previously (the ophiuroids were measured arbitrarily)
raw_20210203 <- read_xlsx("20210203_LGD-2006_RawTypingFile.xlsx")
# stations include P4 N1 and such, the ophiuroids were measured with the new way
raw_20210729 <- read_xlsx("20210729_LGD-2006_RawTypingFile.xlsx")

#View(raw_20210203)
#View(raw_20210729)

# oph_rem of the raw_20210203
oph_re <- read_xlsx("LGD-2006_oph_rem.xlsx")

# reform raw_20210203
raw_20210203_add_oph <- 
  raw_20210203 %>%
  filter(Taxon != "Ophiuroidea") %>%
  select(-...18) %>%
  full_join(oph_re) %>%
  mutate(L = 0.1 * L, W = 0.1 * W) %>% 
  mutate(Habitat = "Shelf", Deployment = 1, Section = "0-10")

raw_20210729_modified <-
  raw_20210729 %>%
  mutate(L = 0.1 * L, W = 0.1 * W) %>% 
  mutate(Habitat = "Shelf")   
  

macro <- full_join(raw_20210203_add_oph, raw_20210729_modified)

# changing one value
disk_like_bryo <- 
  macro %>% 
  filter(Note == "disc-like colony") %>% 
  mutate(Note = "Colony")

macro <-
  macro %>%
  filter(!Note %in% "disc-like colony") %>%
  full_join(disk_like_bryo)


# add value polyp to entoprocta
macro <-
  macro %>%
  mutate(Note = if_else(Taxon == "Entoprocta", "Polyp", NA_character_))


# polychaete --------------------------------------------------------------
poly_re <- read_excel("LGD-2006_poly_rem.xlsx")

#View(poly_re)
#View(macro)

# add information
poly_re_modified <-
  poly_re %>% 
  mutate(Habitat = "Shelf") %>%
  mutate(L = L * 0.1) %>%
  mutate(W = W * 0.1) %>%
  mutate(Section = if_else(Station %in% c("P4", "N1"), NA_character_, "0-10")) 
#`if_else` is so rigid that the true and false condition should be in the same class

poly_re_modified$Condition <- poly_re_modified$Condition %>% toupper

# the section length in P4 and N1 can be obtained from Dr. YSL in NSYSU

# change arachnida to Acari
macro[macro$Taxon == "Arachnida",]$Taxon <- "Acari"  

# write excel
full_join(macro, poly_re_modified) %>%
  write_xlsx("LGD-2006_macro_size_final.xlsx")



