#Author: Ulises Olivares
# uolivares@unam.mx
# June 9, 2021

library(ggplot2)

# WD
setwd("~/OneDrive - UNAM/0. UNAM - Juriquilla/4. COLABORACIONES/6. Geraldo/Rscripts/fig4")

# Load CSV
results <- read.csv("calibration_results.csv")

selected <- read.csv("best_candidate_models_OR_AICc.csv")

tiff('fig4.tiff', units="in", width=16, height=9, res=600, compression = 'lzw')

ggplot(results, aes(x=results$AICc, y=results$Omission_rate_at_5.))+
  geom_point(mapping = aes(color = "All candidate models"), size = 3, alpha = 0.55) +
  geom_point(data = selected, mapping = aes(x=AICc,  y = Omission_rate_at_5., color = "Selected models"), size = 5, alpha = 0.55)+
  scale_color_discrete(name = "Models")+
  labs(color ="")+
  scale_x_log10()+
  xlab("Natural logarithm of AICc") + 
  ylab("Omission rates at 5% threshold value")

dev.off()
