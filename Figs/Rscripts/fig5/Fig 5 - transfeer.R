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
mop <- stack(rastlist)

mop <- mop[1]

mop_df <- as.data.frame(mop)

# Generate a plot from tiff
ggplot() +
  geom_raster(data = mop_df , aes(x = y, y = y, fill = HARV_dsmCrop)) +
  scale_fill_viridis_c() +
  coord_quickmap()