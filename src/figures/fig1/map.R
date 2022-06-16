
# packages for mapping, and the data for, e.g., state borders
require(maptools)
require(maps)
require(mapdata)
require(dismo)# dismo has the SDM analyses we"ll need
install.packages("rangemap")
library(rangemap)

setwd("~/Library/CloudStorage/OneDrive-UNAM/0. UNAM - Juriquilla/4. COLABORACIONES/6. Geraldo/figs")

occs = read_csv("Sp_joint.csv")

# Getting the data
data("occ_f", package = "rangemap")

# checking which countries may be involved in the analysis
par(mar = rep(0, 4)) # optional, reduces the margins of the figure
rangemap_explore(occurrences = occ_f)
rangemap_explore(occurrences = occ_f, show_countries = TRUE)


# Getting the data
data("occ_d", package = "rangemap")

# preparing arguments
level <- 0 # Level of detail for administrative areas
adm <- "Ecuador" # Although no record is on this country, we know it is in Ecuador
countries <- c("PER", "BRA", "COL", "VEN", "ECU", "GUF", "GUY", "SUR", "BOL") # ISO names of countries involved in the analysis


b_range <- rangemap_boundaries(occurrences = occ_d, adm_areas = adm,
                               country_code = countries, boundary_level = level)

save <- TRUE # to save the results
name <- "test" # name of the results

b_range <- rangemap_boundaries(occurrences = occ_d, adm_areas = adm,
                               country_code = countries, boundary_level = level, 
                               save_shp = save, name = name)
# arguments for the species range figure
extent <- TRUE
occ <- TRUE
legend <- TRUE

# creating the species range figure
par(mar = rep(0, 4))
rangemap_plot(b_range, add_EOO = extent, add_occurrences = occ,
              legend = legend)