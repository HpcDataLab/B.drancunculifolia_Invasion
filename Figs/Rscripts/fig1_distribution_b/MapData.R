# Author: Ulises Olivares

# uolivares@unam.mx

library(raster)
library(ggplot2)
library(rasterExtras)
#library(spocc)
#library(occ)
library(dplyr)
library(RSpatial)
library(dismo)
library(gtools)

######################################################################################
#Process individual records downloaded from I-naturalist to validate selected models

setwd("/Users/uolivares/Documents/GitHub/SouthInvassion/Figs/Rscripts/fig1_distribution_b")

#Import and clean data
ind <- read.csv("Sp.csv")

print(paste("Original registers: ", nrow(ind)))

# Cleaning and thining data

#Remove duplicated registers
dupsInd <- duplicated(ind[c("longitude", "latitude")])
uniqueInd <- ind[!dupsInd, ]
cat(nrow(ind) - nrow(uniqueInd), "records were removed")

print(paste("Unique registers:", nrow(uniqueInd)))

#removig near points
occ2thin = poThin(
  df = uniqueLoc,
  spacing = 50, #minimum distance between points in thinned data in kms
  dimension = nrow(uniqueLoc),
  lon = 'longitude',
  lat = 'latitude'
)


uniqueInd <- uniqueInd[-occ2thin,] #thin using index returned from occ2thin

print(paste("Registers after thining:", nrow(uniqueInd)))


