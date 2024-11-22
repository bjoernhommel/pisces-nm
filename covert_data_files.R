library(tidyverse)
library(arrow)

this_dir = dirname(rstudioapi::getSourceEditorContext()$path)
data_dir = file.path(this_dir, "/data")
setwd(this_dir)

# reading a .csv-file
input_filename = "HILS3 and SWLS3 T1 Raw Open.csv"
data = readr::read_csv(file.path(data_dir, input_filename))

library(haven)

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
  "Not at all" = 0,
  "A little bit" = 1,
  "Somewhat" = 2,
  "Very" = 3
)

# Umkodieren der spezifischen Spalte
data$`How difficult finding a place` <- as.numeric(recode(data$`How difficult finding a place`, !!!difficulty_mapping))


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
output_filename = "wp0303.parquet"

data %>% 
    arrow::write_parquet(sink = file.path(data_dir, output_filename))