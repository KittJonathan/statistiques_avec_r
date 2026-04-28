# Statistiques avec R
# Statistiques descriptives univariees
# 2026-04-28

# Packages ----

library(dplyr)
library(writexl)
library(ggplot2)

# Importer les donnees ----

dataScores <- read.csv2("data/ScoresEleves.csv", na.strings = "")

