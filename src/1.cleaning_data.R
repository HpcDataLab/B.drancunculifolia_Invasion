
#-------------------------#
# Author: Ulises Olivares º
# Date: May 18, 2021      º
# uolivares@unam.mx       º
#-------------------------#

# Import libraries
library(ENMeval)
library(dismo)
library(RSpatial)
library(dplyr)

# Set WD to CSV file location
setwd("path_to_csv")

fileName <-"baccharis2021.csv"

# Import CSV file
bacc <- read.csv(fileName, sep="\t")
location <- data.frame(bacc$species, bacc$decimalLongitude, bacc$decimalLatitude)
print(paste("Total registers:", nrow(location)))

# Remove registers with NA (no location)
cleanLoc <- na.omit(location)
names(cleanLoc) <- c("species", "longitude", "latitude")
print(paste("Registers with location:", nrow(cleanLoc)))

#Remove duplicated registers
dups <- duplicated(cleanLoc[c("longitude", "latitude")])
uniqueLoc <- cleanLoc[!dups, ]
cat(nrow(cleanLoc) - nrow(uniqueLoc), "Records were removed")
print(paste("Unique registers:", nrow(uniqueLoc)))


# Removig points within 50 kms
occ2thin = poThin(
  df = uniqueLoc,
  spacing = 50, 
  dimension = nrow(uniqueLoc),
  lon = 'longitude',
  lat = 'latitude'
)
uniqueLoc <- uniqueLoc[-occ2thin,] #thin using index returned from occ2thin
print(paste("Registers after thining:", nrow(uniqueLoc)))


# Randomly select 10 occurrences (Independent Data)
index <- sample(nrow(uniqueLoc),10)
Sp_ind <- uniqueLoc[index,]
write.csv(Sp_ind, "Sp_ind.csv")

# Generate joint data species (Joint data)
Sp_joint <- uniqueLoc[-index, ] # Remove independent random points
write.csv(Sp_joint,"Sp_joint.csv")


# Split joint data in Train 75% and Test 25% data.
# Generate random points over an extent

bg <- dismo::randomPoints(bioVars[[1]], n = nrow(Sp_joint))
jack <- get.jackknife(occs = uniqueLoc, bg)
random <- get.randomkfold(occs = uniqueLoc, bg = bg, kfolds = 4)

# Subset data in train and test
testIndex <- sample(nrow(Sp_joint), nrow(Sp_joint)*0.25) # 25% for testing
test <- Sp_joint[testIndex,]
print(paste("test size:", nrow(test)))

train <- Sp_joint[-testIndex, ] # 75% for training
print(paste("train size:", nrow(train)))

write.csv(test, "Sp_test.csv")
write.csv(train, "Sp_train.csv")

# Finish cleaning data 