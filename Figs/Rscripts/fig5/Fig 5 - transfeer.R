#Author: Ulises Olivares
# uolivares@unam.mx
# July 16, 2021


library(raster)
library()

# set Working dir
setwd("~/Documents/GitHub/SouthInvassion/Figs/Rscripts/fig5")

rastlist <- list.files(path = "~/Documents/GitHub/SouthInvassion/Figs/Rscripts/fig5", pattern='.tif$', all.files=TRUE, full.names=FALSE)
rastFile <- mixedsort(rastlist)

# Stack all rasters
bio <- stack(rastlist)


