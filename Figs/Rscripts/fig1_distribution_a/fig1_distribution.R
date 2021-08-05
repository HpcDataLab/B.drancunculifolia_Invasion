# Author: Ulises Olivares
# uolivares@unammx
# Jun 28, 2021

library(raster)
library(plotly)
library(dplyr)
library(ggplot2)
library(ggmap)

# Set working dir and import data
setwd("~/OneDrive - UNAM/0. UNAM - Juriquilla/4. COLABORACIONES/6. Geraldo/Rscripts/fig1_distribution")

fileCropped <- "Sp_cropped.csv"
fileComplete <- "Sp_all.csv"


############################################
# Immport and proces CSV with all registers
############################################
baccharisComplete <- read.csv(fileComplete, sep="\t")

# Reduce registers
location <- data.frame(baccharisComplete$species, baccharisComplete$decimalLongitude, baccharisComplete$decimalLatitude)

print(paste("Total registers:", nrow(location)))

baccharisComplete <- read.csv(fileComplete)
#Remove registers with NA
cleanLoc <- na.omit(location)
names(cleanLoc) <- c("species", "longitude", "latitude")
print(paste("Registers with location:", nrow(cleanLoc)))

#free mem
rm(location)
rm(bacc)

#Remove duplicated registers
dups <- duplicated(cleanLoc[c("longitude", "latitude")])
baccharisUnique <- cleanLoc[!dups, ]
cat(nrow(cleanLoc) - nrow(baccharisUnique), "records are removed")

print(paste("Unique registers:", nrow(baccharisUnique)))

# Finished complete registers
############################################



############################################
# Immport and proces CSV with cropped regs
############################################
# Import Cropped registers
baccharisCropped <- read.csv(fileCropped)

print(paste("Successfully imported", nrow(baccharisComplete), "records"))
# Finished cropped registers
############################################


############################################
# Generate MAP
############################################


# Generate plot using plotly
fig <- quakes 
fig <- fig %>%
  plot_ly(
    type = 'densitymapbox',
    lat = ~baccharisUnique$latitude,
    lon = ~baccharisUnique$longitude,
    coloraxis = 'coloraxis',
    radius = 4) 
fig <- fig %>%
  layout(
    mapbox = list(
      style='stamen-terrain',
      center= list(lat=-20.928, lon=-56.70), zoom=3.5), coloraxis = list(colorscale = 'Viridis'))

fig <- fig %>%
  config(toImageButtonOptions = list(format = 'jpeg'))

fileName <- 'baccaris.jpeg'
dpi <- 300
orca(fig, file = fileName, width=3 * dpi, height = 3 * dpi, scale = 18, parallel_limit = 4, verbose = 2, timeout=100000) %>%
  config(toImageButtonOptions = list(format = 'svg'))
fig