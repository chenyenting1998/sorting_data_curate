rm(list = ls())
library(readxl)
library(writexl)
library(dplyr)
library(tidyr)
library(tibble)
setwd("C:\\Users\\tumha\\Desktop\\Lab Work\\Data\\Sorting data\\LGD_2006")
# 100 = 1 cm = 10 mm
size <- read_xlsx("20210203_LGD-2006_RawTypingFile.xlsx", sheet = 1) %>%
  mutate(L = L * 0.1, W = W * 0.1) %>%
  mutate(Habitat = "Shelf", Deployment = 1, Section = "0-10") %>%
  select(Cruise, Habitat, Station, Deployment, Tube, Section, Taxon, Family, Genus, Condition, Type, L, W, a, b, Size, Note)
poly <- read_xlsx("20210203_LGD-2006_RawTypingFile.xlsx", sheet = 2)

write_xlsx(list(macro = size, polychaete = poly), "LGD-2006_macro_size.xlsx") # lack polychaete infromation


# check<- size %>% select(Taxon, Condition, Note) %>% distinct %>% arrange(Taxon)
# check

###########################################
# Revise ZHJ3 Ophiuroids Note information #
###########################################

#######################################
# Some decapods lack note information #
#######################################

#####################################
# Need to further classify decapods #
#####################################
