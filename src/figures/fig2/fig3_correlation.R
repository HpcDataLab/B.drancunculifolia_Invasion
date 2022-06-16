# Author: Ulises Olivares
# uolivares@unam.mx
# July 06, 2021

library(raster)
library(ggplot2)
library(rasterExtras)
#library(spocc)
#library(occ)
library(dplyr)
library(RSpatial)
library(dismo)
library(gtools)

################################
# Import DATA from CSV file
#IMAC path 
setwd("/Users/ulises/OneDrive - UNAM/0. UNAM - Juriquilla/4. COLABORACIONES/6. Geraldo/3. Data/GBIF")

#Macbook pro path
#setwd("~/OneDrive - UNAM/0. UNAM - Juriquilla/4. COLABORACIONES/6. Geraldo/3. Data/GBIF")

fileName <-"baccharis2021.csv"
bacc <- read.csv(fileName, sep="\t")

location <- data.frame(bacc$species, bacc$decimalLongitude, bacc$decimalLatitude)

print(paste("Total registers:", nrow(location)))

#Remove registers with NA
cleanLoc <- na.omit(location)
names(cleanLoc) <- c("species", "longitude", "latitude")
print(paste("Registers with location:", nrow(cleanLoc)))

#free mem
rm(location)
rm(bacc)

#Remove duplicated registers
dups <- duplicated(cleanLoc[c("longitude", "latitude")])
uniqueLoc <- cleanLoc[!dups, ]
cat(nrow(cleanLoc) - nrow(uniqueLoc), "records are removed")

print(paste("Unique registers:", nrow(uniqueLoc)))


# 1 degree = 16 miles
ext <- extent(min(uniqueLoc$longitude), max(uniqueLoc$longitude), min(uniqueLoc$latitude), max(uniqueLoc$latitude))

setwd("/Volumes/DATALacie/worldclim/wc2.1_30s_BIO/")

## Import worldclim data
# Read all rasters from worldclim
rastlist <- list.files(path = "/Volumes/DATALacie/worldclim/wc2.1_30s_BIO/", pattern='.tif$', all.files=TRUE, full.names=FALSE)
rastlist <- mixedsort(rastlist)

# Stack all rasters
BIO <- stack(rastlist)

# Croping rasters
BIOVars <- crop(BIO, ext)

# Transform to dataframe
BIOVars_df <- as.data.frame(BIOVars, xy=TRUE)# for ploting

names(BIOVars_df) <- c("x", "y", "BIO1", "BIO2", "BIO3", "BIO4", "BIO5", "BIO6", "BIO7", "BIO8", "BIO9", "BIO10", 
                       "BIO11", "BIO12", "BIO13", "BIO14", "BIO15", "BIO16", "BIO17", "BIO18", "BIO19")

# -------------------------------------------------
# 4. Getting new layers: Elevation, aspect and slope
# -------------------------------------------------

### Elevation

# IMAC
setwd("/Volumes/DATALacie/worldclim/elevation")
rastlist <- list.files(path = "/Volumes/DATALacie/worldclim/elevation", pattern='.tif$', all.files=TRUE, full.names=FALSE)


dem <- raster(rastlist)
# Crop raster to interest area
dem <- crop(dem, ext)
dem_df<- as.data.frame(dem)
names(dem_df) <- c("elevation")

### Calculate slope and aspect from elevation
# Calculate and export slope
slope <-  terrain(dem, opt= 'slope', unit='tangent', neighbors=8)
slope_df <- as.data.frame(slope)
names(slope_df) <- c("slope")
#writeRaster(slope, "slope", format = "ascii", overwrite=TRUE)

# Calculate and export aspect
aspect <- terrain(dem, opt='aspect', unit='degrees', neighbors=8)
aspect_df <- as.data.frame(aspect)
names(aspect_df) <- c("aspect")
#writeRaster(aspect, "aspect", format = "ascii", overwrite=TRUE)

# Joint all variables
BIOVars_df$dem <- dem_df
BIOVars_df$slope <- slope_df
BIOVars_df$aspect <- aspect_df


names(BIOVars_df) <- (c("x", "y", "BIO1", "BIO2", "BIO3", "BIO4", "BIO5", "BIO6", "BIO7", "BIO8", "BIO9", "BIO10", 
                        "BIO11", "BIO12", "BIO13", "BIO14", "BIO15", "BIO16", "BIO17", "BIO18", "BIO19", 
                        "elevation", "slope", "aspect"))

# ------------------------------------------------------------------
# 5. Correlation of environmental variables, dem, slope and aspect
# ------------------------------------------------------------------
#install.packages("ggpubr")
#install.packages("Hmisc")
#install.packages("ggcorrplot")
#install.packages("caret")
#install.packages("IDPmisc") # remove NA nad NaN
library(Hmisc)
library(ggpubr)
library(corrplot)
library(IDPmisc)
library(RColorBrewer)
library(ggcorrplot)
library(caret)
library(heatmaply)
# Drop all rows with NA
allVars <- na.omit(BIOVars_df[3:24])

#Drop all rows with NA, NaN -inf, inf, etc.
allVars <- NaRV.omit(allVars)

# Calculate pearson correlation
correlation <- cor(allVars, method = c("pearson"))


# Select highly correlated variables 
cutoff <- findCorrelation(correlation, cutoff = 0.8, verbose = TRUE, exact=TRUE, names = TRUE)

finalVars<- sort(cutoff)

finalBIOclimCut<- allVars[finalVars]

print(finalVars)

setwd("~/OneDrive - UNAM/0. UNAM - Juriquilla/4. COLABORACIONES/6. Geraldo/Rscripts/fig3")

tiff('fig3.tiff', units="in", width=9, height=9, res=600, compression = 'lzw')

corrplot(correlation, order = "hclust", hclust.method = "average", insig="p-value", sig.level = -1, addrect = 10, tl.cex = 0.7, tl.col = "black", method = "color")

dev.off()


ggcorrplot(correlation, hc.order=TRUE, lab=TRUE, type = "upper", color = c("#FC4E07", "white", "#00AFBB"))


ggsave(corPlot, filename = "correlation.tiff", device = "tiff", dpi = 600, width = 16, height = 9)

