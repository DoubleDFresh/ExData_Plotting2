#  plot4.R seeks to create a plot (plot4.png) in your default directory
#  which answers the question - 
#  Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

## Install necessary libraries
library(data.table)
library(RColorBrewer)
library(ggplot2)
library(plyr)

#  First, read in data from working directory using readRDS().  Assumes file is in unzipped in present working dir.
dt <- data.table(readRDS("summarySCC_PM25.rds"))
dt2 <- data.table(readRDS("Source_Classification_Code.rds"), stringsAsFactors=FALSE)
names(dt)
names(dt2)
dt2 <- dt2[, SCC:=as.character(SCC)]
#  Now, subset the data using grep looking for coal emissions to merge w/ dt
dt2.sub <- dt2[grep("Coal$", dt2$EI.Sector), ]
names(dt2.sub)


## 2.  Subset using SCC

#  Set year and type as factors for ggplot2
dt.sub$year <- as.factor(dt.sub$year)
dt.sub$type <- as.factor(dt.sub$type)

df <- aggregate(dt.sub$Emissions, by=list(Year=dt.sub$year, Type =dt.sub$type), FUN=sum)


png(file = "plot3.png", width = 480, height = 480)
ggplot(data=df, aes(x=Year, y=x, fill=Type)) + geom_bar(stat="identity", position=position_dodge()) +
        scale_fill_hue(name="Emission Type") +
        xlab("Year PM2.5 Emissions Recorded") + ylab("Tons of PM2.5 Emissions") +  
        ggtitle("PM2.5 Emissions in Baltimore, MD by Year")

dev.off()