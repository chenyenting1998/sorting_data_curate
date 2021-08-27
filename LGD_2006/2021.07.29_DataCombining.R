pacman::p_load(
  readxl,
  writexl,
  dplyr
)

# Macrofauna --------------------------------------------------------------
# stations include all the stations measured previously (the ophiuroids were measured arbitrarily)
raw_20210203 <- read_xlsx("LGD_2006/20210203_LGD-2006_RawTypingFile.xlsx")
# stations include P4 N1 and such, the ophiuroids were measured with the new way
raw_20210729 <- read_xlsx("LGD_2006/20210729_LGD-2006_RawTypingFile.xlsx")

# View(raw_20210203)
# View(raw_20210729)

# reform raw_20210203
raw_20210203_add_oph <-
  raw_20210203 %>%
  filter(Taxon != "Ophiuroidea") %>%
  select(-...18) %>%
  full_join(oph_re) %>%
  mutate(L = 0.1 * L, W = 0.1 * W) %>%
  mutate(Habitat = "Shelf", Deployment = 1, Section = "0-10")

# the section length in P4 and N1 can be obtained from Dr. YSL in NSYSU
raw_20210729_modified <-
  raw_20210729 %>%
  mutate(L = 0.1 * L, W = 0.1 * W) %>%
  mutate(Habitat = "Shelf")

# ophuiroid ---------------------------------------------------------------
# oph_rem of the raw_20210203
oph_re <- read_xlsx("LGD_2006/LGD-2006_oph_rem.xlsx")

macro <- full_join(raw_20210203_add_oph, raw_20210729_modified)

# Change specific values --------------------------------------------------
# changing one value
macro[!is.na(macro$Note) & macro$Note == "disc-like colony", ]$Note <- "Colony"

# add value "Polyp" to entoprocta
macro[macro$Taxon == "Entoprocta", ]$Note <- "Polyp"

# change arachnida to Acari
macro[macro$Taxon == "Arachnida", ]$Taxon <- "Acari"


# polychaete --------------------------------------------------------------
poly_re <- read_excel("LGD_2006/LGD-2006_poly_rem.xlsx")

# add information
poly_re_modified <-
  poly_re %>%
  mutate(Habitat = "Shelf") %>%
  mutate(L = L * 0.1, W = W * 0.1) %>%
  mutate(Section = if_else(Station %in% c("P4", "N1"), NA_character_, "0-10"))

# Upper case the polychaete condition
poly_re_modified$Condition <- poly_re_modified$Condition %>% toupper()



# write excel -------------------------------------------------------------
full_join(macro, poly_re_modified) %>%
  write_xlsx("data/LGD-2006_macro_size_final.xlsx")
