#  plot4.R seeks to create a plot (plot4.png) in your default directory
#  which answers the question - 
#  Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

## Install necessary libraries
library(data.table)
library(RColorBrewer)
library(ggplot2)
library(plyr)
library(scales)

#  First, read in data from working directory using readRDS().  Assumes file is in unzipped in present working dir.
dt <- data.table(readRDS("summarySCC_PM25.rds"))
dt2 <- data.table(readRDS("Source_Classification_Code.rds"), stringsAsFactors=FALSE)

#  Now, subset the data using grep looking for coal emissions to merge w/ dt
dt2.sub <- dt2[grep("Coal$", dt2$EI.Sector), ]

dt <- merge(dt,dt2.sub,by="SCC")  


#  Set year and type as factors for ggplot2
dt$year <- as.factor(dt$year)
dt$type <- as.factor(dt$type)

#  Aggregate for ggplot2
df <- aggregate(dt$Emissions, by=list(Year=dt$year, Type =dt$type), FUN=sum)


png(file = "plot4.png", width = 480, height = 480)
ggplot(data=df, aes(x=Year, y=x, fill=Type)) + geom_bar(stat="identity", position=position_dodge()) +
        scale_fill_hue(name="Emission Type") +
        xlab("Year PM2.5 Emissions Recorded") + ylab("Tons of PM2.5 Emissions") +  
        ggtitle("Coal PM2.5 Emissions in the US by Year and Type") + scale_y_continuous(breaks = c(seq(0,600000,100000)),labels = comma)

dev.off()