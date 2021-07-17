#Author: Ulises Olivares
# uolivares@unam.mx
# July 16, 2021


library(raster)
library(tiff)


# set Working dir
setwd("~/Documents/GitHub/SouthInvassion/Figs/Rscripts/fig5")

rastFile <- list.files(path = "~/Documents/GitHub/SouthInvassion/Figs/Rscripts/fig5", pattern='.tif$', all.files=TRUE, full.names=FALSE)
#rastFile <- mixedsort(rastlist)

# Stack all rasters
mop <- raster(rastFile)

mop_df <- as.data.frame(mop)

# Generate a plot from tiff
plot(mop)