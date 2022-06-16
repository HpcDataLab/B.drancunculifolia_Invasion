# Author: Ulises Olivares
# Date: May 18, 2021
# uolivares@unam.mx

library(raster)
library(plotly)
library(dplyr)
library(ggplot2)
library(ggmap)
library(RSpatial)


#IMAC path 
setwd("~/Library/CloudStorage/OneDrive-UNAM/0. UNAM - Juriquilla/4. COLABORACIONES/6. Geraldo/PREPARATION/3. Data/NoAmazonData")

#Macbook pro path
#setwd("~/OneDrive - UNAM/0. UNAM - Juriquilla/4. COLABORACIONES/6. Geraldo/3. Data/GBIF")

fileComplete <-"baccharis2021.csv"

############################################
# Immport and proces CSV with all registers
############################################
baccharisComplete <- read.csv(fileComplete, sep="\t")

# Reduce registers
location <- data.frame(baccharisComplete$species, baccharisComplete$decimalLongitude, baccharisComplete$decimalLatitude)

print(paste("Total registers:", nrow(location)))


#Remove registers with NA
cleanLoc <- na.omit(location)
names(cleanLoc) <- c("species", "longitude", "latitude")
print(paste("Registers with location:", nrow(cleanLoc)))

write.csv(cleanLoc, "baccharisUnique.csv")

#free mem
rm(location)
rm(bacc)

#Remove duplicated registers
dups <- duplicated(cleanLoc[c("longitude", "latitude")])
baccharisUnique <- cleanLoc[!dups, ]
cat(nrow(cleanLoc) - nrow(baccharisUnique), "records are removed")

write.csv(baccharisUnique, "baccharisUnique.csv")
print(paste("Unique registers:", nrow(baccharisUnique)))
# Finished complete registers
############################################

############################################
# Generate MAP A 
############################################


# Generate plot using plotly
fig <- quakes 
fig <- fig %>%
  plot_ly(
    type = 'densitymapbox',
    lat = ~cleanLoc$latitude,
    lon = ~cleanLoc$longitude,
    coloraxis = 'coloraxis',
    radius = 4) 
fig <- fig %>%
  layout(
    mapbox = list(
      style='stamen-terrain',
      center= list(lat=-20.928, lon=-56.70), zoom=3.5), coloraxis = list(colorscale = 'Viridis'))

fig <- fig %>%
  config(toImageButtonOptions = list(format = 'jpeg'))

fig
fileName <- 'baccaris.jpeg'
dpi <- 300
orca(fig, file = fileName, width=3 * dpi, height = 3 * dpi, scale = 18, parallel_limit = 4, verbose = 2, timeout=100000) %>%
  config(toImageButtonOptions = list(format = 'svg'))

# Finished complete registers
######## ####################################


############################################
# Thining registers...
############################################

# removig near points
occ2thin = poThin(
  df = baccharisUnique,
  spacing = 50, #minimum distance between points in thinned data in kms
  dimension = nrow(baccharisUnique),
  lon = 'longitude',
  lat = 'latitude'
)

baccharisUnique <- baccharisUnique[-occ2thin,] #thin using index returned from occ2thin

print(paste("Registers after thining:", nrow(baccharisUnique)))



write.csv(baccharisUnique, "baccharisThined.csv")

############################################
# Generate MAP B
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

fig
fileName <- 'baccarisB.jpeg'
dpi <- 300
orca(fig, file = fileName, width=3 * dpi, height = 3 * dpi, scale = 18, parallel_limit = 4, verbose = 2, timeout=100000) %>%
  config(toImageButtonOptions = list(format = 'svg'))

# Finished complete registers
######## ####################################








