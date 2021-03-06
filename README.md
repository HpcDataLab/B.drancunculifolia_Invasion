# The south invades the north 
<p align="justify" >
The genus Baccharis (Asteraceae) comprises over 440 species and is distributed along with North and South America. Some species of this genus have remarkable invasive characteristics, and one of these species is the South American shrub Baccharis dracunculifolia. Most of the introductions of non-indigenous species are held indirectly through trade, so it is believed that this species might become invasive in the North American continent because of the increasing sale of products derived from honey to this continent. The resin extracted from B. dracunculifolia is the leading source for preparing the green propolis produced in southeastern Brazil. Thus, the main objective of this work is to apply an approach based on distribution modeling to investigate possible areas of high environmental suitability for B. dracunculifolia in the North American continent, while we also observed that potential to the entire globe.
</p>

## 1. Ocurrence Data 
<p align="justify">
A collection of 1,862 georeferenced occurrence data points of Baccharis dracunculifolia were used to build the distribution model. These points were downloaded from the GBIF platform www.gbif.org, accessed on May 09, 2021 (doi.org/10.15468/dl.9v6cw8), all of them located in South America.
  </p>
  <img src = "figs/baccharis.png">
  
  #### + [original data](data/original/baccharis.csv)

  
  
 ## 2. Cleaning Ocurrence Data 

 <p align="justify">
  Many points were discarded because of overlap in the same pixel, thereby reducing autocorrelation effects. The duplicated function of the base R package was used for this purpose. Effects of spatial autocorrelation were avoided by thinning observations with a distance of 50 km using the poThin function of the RSpatial library. The occurrence points were partitioned into two subsets, 75% for model calibration and 25% for testing; the random method of the  ENMeval package was used to partition data.
  </p>
  
  #### + [cleaning data source code](src/1.cleaning_data.R)
  
  #### + [clean and partitioned data](data/unique_clean/)
