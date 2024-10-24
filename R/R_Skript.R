library(tidyverse)
library(arrow)
library(psych)
library(haven)
library(hablar)
library(readxl)


this_dir = dirname(rstudioapi::getSourceEditorContext()$path)
setwd(this_dir)
getwd()
data_path = file.path(this_dir, "../data")
mappings_path = file.path(this_dir, "../mappings")

# Daten einlesen (je nach Dateiformat) --> auf Namen achten!!
data <- readr::read_csv("../../pisces-nm/Studies-1-5.csv") # für normale .csv-Dateien
data <- read_excel("../../pisces-nm/Datasets.xlsx")
data <- read.table("../../pisces-nm/Studies-1-5.csv", header = TRUE, sep = ";") # falls irgendwelche anderen Spaltenseparatoren statt Komma: unter sep = "" einstellen
data <- haven::read_sav("../../pisces-nm/BSF Study 1 - validation.sav") # für .sav-Dateien (aus SPSS)
load("../../Backlog_digital/IPP31/IPP_complete.RData") # für .RData
load("../../BehavioralTextMining/dat_tx.Rda") # für .Rda


# Check the structure of the data frame
str(df)
data <- COMBINED # Name des Datensatz ersetzen
data <- read.table("../../BehavioralTextMining/data study 1.dat", header = TRUE, sep = "", stringsAsFactors = FALSE)

# Label für Variablen als Tabelle speichern --> Items
labels <- map_chr(data[,1:195], ~attr(.x, "label")) %>%  bind_cols(names = names(data[,1:195]), question = .)
write.csv(labels, "../../BehavioralTextMining/labels.csv")
colnames(data)

# Spaltenüberschriften extrahieren
spalten_ueberschriften <- data.frame(Überschrift = names(data))

# Tabelle anzeigen
print(spalten_ueberschriften)
spalten_ueberschriften <- data.frame(
  Überschrift = names(data),
  stringsAsFactors = FALSE
)

# Aufteilen der Spaltenüberschriften in Haupt- und Unterüberschriften
spalten_ueberschriften <- spalten_ueberschriften %>%
  separate(Überschrift, into = c("Hauptüberschrift", "Unterüberschrift"), sep = "\\.", fill = "right")

# Tabelle anzeigen
print(spalten_ueberschriften)



install.packages("Hmisc")

library(Hmisc)

get_column_labels <- function(df) {
  data.frame(
    Column = colnames(df),
    Label = sapply(df, label)  # extrahiert die Item-Beschreibungen (Labels)
  )
}

# Labels extrahieren
labels <- get_column_labels(data)

# Tabelle anzeigen
print(labels)


# Übersicht über Daten bekommen
summary(data) # welche Variablen und Variablentypen sind das
skimr::skim(data) # Mittelwerte, Missings, Minima und Maxima, ... --> Missings die mit Zahlen kodiert sind finden, Einheiten der Skalen finden

# random shit (weiß nicht mehr genau was ich da wollte)
data <- data %>% 
  mutate_at(c(15:64), as.numeric)
data <- data %>% retype()
which(data_psy_complete$kult1 == 0)
apply(dataf_res[,13:52], 1, sd)
data <- rbind(data1, data2)

# Missings, die mit Zahlen kodert sind mit NA ersetzen
data[,3:26] <- data[,3:26] %>% mutate_if(is.numeric, ~replace(., . == -99, NA)) # Spalten von 3 bis 26 (in dem Fall)
data <- data %>% mutate_if(is.numeric, ~replace(., . == 99, NA)) # überall nach -99 suchen und mit NA ersetzen







# Datei als .feather speichern
data %>% 
  tibble::as_tibble() %>% 
  arrow::write_feather(
    sink = file.path(data_path, "wp0190.feather")
  )

# we read the data by using the `read_feather()` function
df = arrow::read_feather(
  file = file.path(data_path, "wp0089.feather")
)

# here we can find the data needed for the `.json` mapping file
?psych::bfi