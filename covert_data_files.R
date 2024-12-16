library(tidyverse)
library(arrow)

this_dir = dirname(rstudioapi::getSourceEditorContext()$path)
data_dir = file.path(this_dir, "/data")
setwd(this_dir)

# reading a .csv-file
input_filename = "AllScalesForCFA.csv"
data = readr::read_csv(file.path(data_dir, input_filename))

data = readr::read_tsv(file.path(data_dir, input_filename))

data <- read.delim("../../pisces-nm/data/AllScalesForCFA.csv", sep = "\t", header = TRUE)
library(haven)
input_filename <- "pone.0264889.s001.sav"
data <- read_sav(file.path(data_dir, input_filename))


library(foreign)

data <- read.spss(file = "C:/Users/nanam/Arbeit/New_validation/pisces-nm/data/main_data.sav", 
                  to.data.frame = TRUE, 
                  reencode = "UTF-8")

# Dateinamen und Pfad festlegen
input_filename <- "1015-5759_a000527_esm4.dat.txt"

# Daten einlesen
data <- read_excel(file.path(data_dir, input_filename))


data <- read.table(file.path(data_dir, input_filename)


input_filename = "1015-5759_a000527_esm4.dat.txt"  # Dateiname anpassen
data = readr::read_tsv(file.path(data_dir, input_filename))  # Für .txt (Tabulator-getrennte Datei)
                   
summary(data) # welche Variablen und Variablentypen sind das
skimr::skim(data) # Mittelwerte, Missings, Minima und Maxima, ... --> Missings die mit Zahlen kodiert sind finden, Einheiten der Skalen finden

# Bibliotheken laden
library(readxl)
library(rstudioapi)

# Verzeichnis des aktuellen Skripts festlegen
this_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
data_dir <- file.path(this_dir, "data")
setwd(this_dir)

# Dateinamen festlegen und Pfad überprüfen
input_filename <- "Data.xls"
file_path <- file.path(data_dir, input_filename)

if (!file.exists(file_path)) {
  stop("Datei existiert nicht: ", file_path)
}

# .xls-Datei einlesen
data <- read_xls(file_path)

difficulty_mapping <- c(
  "never" = 0,
  "rarely" = 1,
  "soemtimes" = 2,
  "often" = 3,
  "always" =4
)

# Umkodieren der spezifischen Spalte
data$`patr01` <- as.numeric(recode(data$`patr01`, !!!difficulty_mapping))
data$`patr02` <- as.numeric(recode(data$`patr02`, !!!difficulty_mapping))
data$`patr03` <- as.numeric(recode(data$`patr03`, !!!difficulty_mapping))
data$`patr04` <- as.numeric(recode(data$`patr04`, !!!difficulty_mapping))
data$`patr05` <- as.numeric(recode(data$`patr05`, !!!difficulty_mapping))
data$`patr06` <- as.numeric(recode(data$`patr06`, !!!difficulty_mapping))
data$`patr07` <- as.numeric(recode(data$`patr07`, !!!difficulty_mapping))
data$`patr08` <- as.numeric(recode(data$`patr08`, !!!difficulty_mapping))
data$`patr09` <- as.numeric(recode(data$`patr09`, !!!difficulty_mapping))
data$`patr10` <- as.numeric(recode(data$`patr10`, !!!difficulty_mapping))
data$`patr11` <- as.numeric(recode(data$`patr11`, !!!difficulty_mapping))
data$`patr12` <- as.numeric(recode(data$`patr12`, !!!difficulty_mapping))
data$`patr13` <- as.numeric(recode(data$`patr13`, !!!difficulty_mapping))
data$`patr14` <- as.numeric(recode(data$`patr14`, !!!difficulty_mapping))
data$`patr15` <- as.numeric(recode(data$`patr15`, !!!difficulty_mapping))
data$`patr16` <- as.numeric(recode(data$`patr16`, !!!difficulty_mapping))
data$`patr17` <- as.numeric(recode(data$`patr17`, !!!difficulty_mapping))
data$`patr18` <- as.numeric(recode(data$`patr18`, !!!difficulty_mapping))


difficulty_mapping_2 <- c(
  "disagree strongly" = 0,
  "disagree a little" = 1,
  "neither agree nor disagree" = 2,
  "agree a little" = 3,
  "agree stongly" = 4
)

data$`int1` <- as.numeric(recode(data$`int1`, !!!difficulty_mapping_2))
data$`int2` <- as.numeric(recode(data$`int2`, !!!difficulty_mapping_2))
data$`int3` <- as.numeric(recode(data$`int3`, !!!difficulty_mapping_2))

difficulty_mapping_3 <- c(
  "not at all" = 0,
  "a bit" = 1,
  "a little" = 2,
  "moderately" = 3,
  "very much" = 4
)

data$`panas01` <- as.numeric(recode(data$`panas01`, !!!difficulty_mapping_3))
data$`panas02` <- as.numeric(recode(data$`panas02`, !!!difficulty_mapping_3))
data$`panas03` <- as.numeric(recode(data$`panas03`, !!!difficulty_mapping_3))
data$`panas04` <- as.numeric(recode(data$`panas04`, !!!difficulty_mapping_3))
data$`panas05` <- as.numeric(recode(data$`panas05`, !!!difficulty_mapping_3))
data$`panas06` <- as.numeric(recode(data$`panas06`, !!!difficulty_mapping_3))
data$`panas07` <- as.numeric(recode(data$`panas07`, !!!difficulty_mapping_3))
data$`panas08` <- as.numeric(recode(data$`panas08`, !!!difficulty_mapping_3))
data$`panas09` <- as.numeric(recode(data$`panas09`, !!!difficulty_mapping_3))
data$`panas10` <- as.numeric(recode(data$`panas10`, !!!difficulty_mapping_3))
data$`panas11` <- as.numeric(recode(data$`panas11`, !!!difficulty_mapping_3))
data$`panas12` <- as.numeric(recode(data$`panas12`, !!!difficulty_mapping_3))
data$`panas13` <- as.numeric(recode(data$`panas13`, !!!difficulty_mapping_3))
data$`panas14` <- as.numeric(recode(data$`panas14`, !!!difficulty_mapping_3))
data$`panas15` <- as.numeric(recode(data$`panas15`, !!!difficulty_mapping_3))
data$`panas16` <- as.numeric(recode(data$`panas16`, !!!difficulty_mapping_3))
data$`panas17` <- as.numeric(recode(data$`panas17`, !!!difficulty_mapping_3))
data$`panas18` <- as.numeric(recode(data$`panas18`, !!!difficulty_mapping_3))
data$`panas19` <- as.numeric(recode(data$`panas19`, !!!difficulty_mapping_3))
data$`panas20` <- as.numeric(recode(data$`panas20`, !!!difficulty_mapping_3))

difficulty_mapping_4 <- c(
   "stimmt über-haupt nicht zu [1]" = 1,
   "stimme nicht zu [2]" = 2,
   "stimme eher nicht zu [3]" = 3,
   "weder / noch [4]" = 4,
   "stimme eher zu [5]" = 5,
   "stimme zu [6]" = 6,
   "stimme v�llig zu [7]" = 7
)

data$`swls1` <- as.numeric(recode(data$`swls1`, !!!difficulty_mapping_4))
data$`swls2` <- as.numeric(recode(data$`swls2`, !!!difficulty_mapping_4))
data$`swls3` <- as.numeric(recode(data$`swls3`, !!!difficulty_mapping_4))
data$`swls4` <- as.numeric(recode(data$`swls4`, !!!difficulty_mapping_4))
data$`swls5` <- as.numeric(recode(data$`swls5`, !!!difficulty_mapping_4))


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


# Label für Variablen als Tabelle speichern --> Items
labels <- map_chr(data[,1:195], ~attr(.x, "label")) %>%  bind_cols(names = names(data[,1:195]), question = .)
write.csv(labels, "../../New_validation/pisces-nm/data/labels.csv")
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
##Fehler behebung
# Benötigte Bibliotheken laden
# Benötigte Bibliotheken laden
library(tidyverse)
library(arrow)
library(haven)
library(readxl)
library(rstudioapi)

# Verzeichnis des aktuellen Skripts festlegen
this_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
data_dir <- file.path(this_dir, "data")
setwd(this_dir)

# Dateinamen für die .xlsx-Datei festlegen
input_filename <- "pedersenfaveroPAR2020.tab"  # Name der .xlsx-Datei anpassen

# .xlsx-Datei einlesen
data <- read_tsv(file.path(data_dir, input_filename))


# example: recode the value -99 as NA (missing) in columns 3 to 26
data[, 1:26] = data[, 1:26] %>% 
    mutate_if(is.numeric, ~replace(., . == 8, NA))

# saving the .parquet-file
output_filename = "wp0366.parquet"

data %>% 
    arrow::write_parquet(sink = file.path(data_dir, output_filename))