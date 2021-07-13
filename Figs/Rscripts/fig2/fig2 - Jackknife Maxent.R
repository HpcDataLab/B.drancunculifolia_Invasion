# Author: Ulises Olivares
# uolivares@unammx
# Jun 28, 2021

library(ggplot2)
library(reshape2)
library(stringr)
library(scales)

# Set working dir and import data

setwd("~/OneDrive - UNAM/0. UNAM - Juriquilla/4. COLABORACIONES/6. Geraldo/Rscripts/fig2")

maxentRes <- "maxentResults.csv"


############################################
# Immport maxent Results
############################################
result <- read.csv(maxentRes, sep=",")



############################################
# Generate ggplot graph plot
############################################

gain <- result[,grep("with", names(result), fixed = TRUE)]

# Separate training gain with only a specific var
only <- gain[,grep("only", names(gain), fixed = TRUE)]


only <- only[ , str_sort(names(only), numeric = TRUE)]
longOnly <- melt(only)
longOnly$gain <- "With only variable"

longOnly$variable <- str_replace(longOnly$variable, "Training.gain.with.only.", "")

summary(longOnly)


# Generate plot without a variable
without <-  gain[,grep("without", names(gain), fixed = TRUE)]
without <- without[ , str_sort(names(without), numeric = TRUE)]

longWithout <- melt(without)
longWithout$gain <- "Without variable"
longWithout$variable <- str_replace(longWithout$variable, "Training.gain.without.", "")


# Get data from regularized training
total <- as.data.frame(result$Regularized.training.gain)
total$variable <- "With all variables"
total$gain <- "With all variables"

names(total) <- c("value", "variable", "gain")





# Graph data from 
ggplot() +
  geom_bar(data=longWithout, aes(x=variable, y=value, color = gain, fill = gain), stat="identity")+
  geom_bar(data=longOnly, aes(x=variable, y=value, color = gain, fill = gain), stat="identity")+
  geom_bar(data = total, aes(x = variable, y=value, color = gain, fill = gain), stat = "identity")+
  labs(
    title = "Jackknife of regularized trainig gain for B. dracunculifolia",
    y="Regularized training gain",
    x="Environmental variable")+
  theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))+
  coord_flip()+
  scale_y_continuous(breaks = round(seq(0, 1.5, by = 0.1),1))

ggsave(filename = "fig2.tiff", width = 16, height = 9, dpi = 300)

  
############################################