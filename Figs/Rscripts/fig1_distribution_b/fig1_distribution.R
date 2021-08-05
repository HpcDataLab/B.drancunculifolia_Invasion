# Author: Ulises Olivares
# uolivares@unammx
# Jun 28, 2021

library(raster)
library(plotly)
library(dplyr)
library(ggplot2)
library(ggmap)

# Set working dir and import data
setwd("/Users/uolivares/Documents/GitHub/SouthInvassion/Figs/Rscripts/fig1_distribution_b/")

joint <- "baccharis_joint.csv"

############################################
# Immport and proces CSV with cropped regs
############################################
# Import joint registers
baccharisJoint <- read.csv(joint)
print(paste("Successfully imported", nrow(baccharisJoint), "records"))

############################################


############################################
# Generate MAP
tiff("fig4b.tiff", units="in", width=16, height=9, res=600, compression = 'lzw')
# Generate plot using plotly
fig <- baccharisJoint 
fig <- fig %>%
  plot_ly(
    type = 'densitymapbox',
    lat = ~baccharisJoint$latitude,
    lon = ~baccharisJoint$longitude,
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

dev.off()