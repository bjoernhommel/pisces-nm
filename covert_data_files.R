library(tidyverse)
library(arrow)

this_dir = dirname(rstudioapi::getSourceEditorContext()$path)
data_dir = file.path(this_dir, "/data")
setwd(this_dir)

# reading a .csv-file
input_filename = "data.csv"
data = readr::read_csv(file.path(data_dir, input_filename))

# example: recode the value -99 as NA (missing) in columns 3 to 26
data[, 3:26] = data[, 3:26] %>% 
    mutate_if(is.numeric, ~replace(., . == -99, NA))

# saving the .parquet-file
output_filename = "data.parquet"

data %>% 
    arrow::write_parquet(sink = file.path(data_dir, output_filename))