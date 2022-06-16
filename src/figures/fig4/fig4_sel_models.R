#Author: Ulises Olivares
# uolivares@unam.mx
# June 9, 2021

library(ggplot2)

# Set WD
setwd("~/OneDrive - UNAM/0. UNAM - Juriquilla/4. COLABORACIONES/6. Geraldo/Rscripts/fig4")

# Load CSV
results <- read.csv("calibration_results.csv")

selected <- read.csv("best_candidate_models_OR_AICc.csv")

tiff('fig4.tiff', units="in", width=12, height=9, res=600, compression = 'lzw')

ggplot()+
  geom_point(data = results, mapping = aes(x=results$AICc, y=results$Omission_rate_at_5., color = "All candidate models"), size = 3.5, alpha = 0.3) +
  geom_point(data = selected, mapping = aes(x=AICc,  y = Omission_rate_at_5., color = "Selected models"), size = 4, alpha = 0.5)+
  scale_color_discrete(name = "Models")+
  #labs(color ="")+
  xlab("Natural logarithm of AICc (log scale)") + 
  ylab("Omission rates at 5% threshold value")+
  scale_x_continuous(trans = 'log10') + 
  scale_y_continuous(trans = 'log10')+
  annotation_logticks(sides="lb")
dev.off()
