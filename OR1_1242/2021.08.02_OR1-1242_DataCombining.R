# 2021/08/02 --------------------------------------------------------------
pacman::p_load(
  readxl,
  writexl,
  dplyr
)

# 100 = 1 cm = 10 mm
# read oph
oph <- read_xlsx("OR1_1242/2021.02.03_Ophiuroidea_remeasured_RawTypingFile.xlsx") %>% mutate(L = L*0.1, W = W*0.1)
# change "Limb" to "Arm" [just a notation pet peeve]
oph[oph$Note == "Limb",] <- oph %>% filter(Note =="Limb") %>% mutate(Note = "Arm")

# read other macros
new <- read_xlsx("OR1_1242/2021.02.06 (ignore all other files; this is the final file)OR1_1242-FINAL DATA.xlsx", sheet = 4) %>% 
  filter(Taxon != "Ophiuroidea") %>% # remove the previously recorded Oph.
  full_join(oph) %>% 
  mutate(Section = "0-10")

# write xlsx
write_xlsx(list(OR1_1242_Macro = new), "OR1_1242_macro_size_final.xlsx") # lack polychaete infromation

