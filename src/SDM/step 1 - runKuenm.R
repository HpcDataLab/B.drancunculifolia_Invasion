
# Installing and loading packages
if(!require(devtools)){
  install.packages("devtools")
}

if(!require(kuenm)){
  devtools::install_github("marlonecobos/kuenm")
}


library(kuenm)
library(parallel)

setwd("/Volumes/DATALacie/baccharis")

# Filename for the MD file
file_name <- "all_procs"

kuenm_start(file.name = file_name)