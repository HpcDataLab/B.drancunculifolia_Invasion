
# Installing and loading packages
if(!require(devtools)){
  install.packages("devtools")
}

if(!require(kuenm)){
  devtools::install_github("marlonecobos/kuenm")
}


library(kuenm)
library(parallel)

setwd("/Users/ulises/Desktop/baccharis10m")

# Filename for the MD file
file_name <- "all_procs10m"

kuenm_start(file.name = file_name)