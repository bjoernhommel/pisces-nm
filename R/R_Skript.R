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
data <- readr::read_csv("../../pisces-nm/data/ccases.csv") # für normale .csv-Dateien
data <- read_excel("../../pisces-nm/data/Psychosocial_Burden_Accessing_Abortion_Biggs_2020.xls")
data <- read.table("../../pisces-nm/Studies-1-5.csv", header = TRUE, sep = ";") # falls irgendwelche anderen Spaltenseparatoren statt Komma: unter sep = "" einstellen
data <- haven::read_sav("../../pisces-nm/data/Number Symbol Dataset.sav") # für .sav-Dateien (aus SPSS)
library(foreign)

data <- read.spss("C:/Users/nanam/Arbeit/New_validation/pisces-nm/data/Number Symbol Dataset.sav", to.data.frame = TRUE)
load("../../Backlog_digital/IPP31/IPP_complete.RData") # für .RData
load("../../BehavioralTextMining/dat_tx.Rda") # für .Rda
data <- read.table("../../pisces-nm/data/Study 2 Data.txt", header = TRUE, sep = "\t", stringsAsFactors = FALSE)


# Check the structure of the data frame
str(df)
data <- COMBINED # Name des Datensatz ersetzen
data <- read.table("../../BehavioralTextMining/data study 1.dat", header = TRUE, sep = "", stringsAsFactors = FALSE)

# Label für Variablen als Tabelle speichern --> Items
labels <- map_chr(data[,1:195], ~attr(.x, "label")) %>%  bind_cols(names = names(data[,1:195]), question = .)
write.csv(labels, "../../BehavioralTextMining/labels.csv")
colnames(data)
spalten_ueberschriften <- data.frame(Überschrift = names(data))

# Tabelle anzeigen
print(spalten_ueberschriften)
spalten_ueberschriften <- data.frame(
  Überschrift = names(data),
  stringsAsFactors = FALSE
)
# Spaltenüberschriften extrahieren


# Aufteilen der Spaltenüberschriften in Haupt- und Unterüberschriften
spalten_ueberschriften <- spalten_ueberschriften %>%
  separate(Überschrift, into = c("Hauptüberschrift", "Unterüberschrift"), sep = "\\.", fill = "right")

# Tabelle anzeigen
print(spalten_ueberschriften)

#Umwandeln von chr zu numeric

difficulty_mapping <- c(
  "Not at all" = 0,
  "A little bit" = 1,
  "Somewhat" = 2,
  "Very" = 3
)

# Umkodieren der spezifischen Spalte
data$`How difficult finding a place` <- as.numeric(recode(data$`How difficult finding a place`, !!!difficulty_mapping))

difficulty_mapping <- c(
  "Not at all" = 0,
  "A little bit" = 1,
  "Somewhat" = 2,
  "Very" = 3
)

# Umkodieren der spezifischen Spalte
data$`How difficult sheduling an appointment` <- as.numeric(recode(data$`How difficult sheduling an appointment`, !!!difficulty_mapping))

# Umkodieren der spezifischen Spalte
data$`How difficult traveling to a place for care` <- as.numeric(recode(data$`How difficult traveling to a place for care`, !!!difficulty_mapping))
# Umkodieren der spezifischen Spalte
data$`How difficult amount of time trying to obtain care` <- as.numeric(recode(data$`How difficult amount of time trying to obtain care`, !!!difficulty_mapping))
# Umkodieren der spezifischen Spalte
data$`How difficult deciding whether to end this pregnancy` <- as.numeric(recode(data$`How difficult deciding whether to end this pregnancy`, !!!difficulty_mapping))
# Umkodieren der spezifischen Spalte
data$`How difficult thinking I have to end this pregnancy` <- as.numeric(recode(data$`How difficult thinking I have to end this pregnancy`, !!!difficulty_mapping))
# Umkodieren der spezifischen Spalte
data$`Felt worried ending a potential life` <- as.numeric(recode(data$`Felt worried ending a potential life`, !!!difficulty_mapping))
# Umkodieren der spezifischen Spalte
data$`Felt forced to tell people that I was pregnant` <- as.numeric(recode(data$`Felt forced to tell people that I was pregnant`, !!!difficulty_mapping))
# Umkodieren der spezifischen Spalte
data$`Felt forced to tell people that I was  ending this pregnancy` <- as.numeric(recode(data$`Felt forced to tell people that I was  ending this pregnancy`, !!!difficulty_mapping))
# Umkodieren der spezifischen Spalte
data$`Felt forced to wait to end this pregnancy after I had made a decision` <- as.numeric(recode(data$`Felt forced to wait to end this pregnancy after I had made a decision`, !!!difficulty_mapping))
# Umkodieren der spezifischen Spalte
data$`How worried about parents' reaction` <- as.numeric(recode(data$`How worried about parents' reaction`, !!!difficulty_mapping))
# Umkodieren der spezifischen Spalte
data$`How worried about friends other family members' reaction` <- as.numeric(recode(data$`How worried about friends other family members' reaction`, !!!difficulty_mapping))








print(data)

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