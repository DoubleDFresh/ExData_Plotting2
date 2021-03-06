#  plot3.R seeks to create a plot (plot3.png) in your default directory
#  which answers the question - 'Of the four types of sources indicated by the
#  type (point, nonpoint, onroad, nonroad) variable, 
#  which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
#  Which have seen increases in emissions from 1999–2008? 
#  Use the ggplot2 plotting system to make a plot answer this question.

## Install necessary libraries
library(data.table)
library(RColorBrewer)
library(ggplot2)
library(plyr)

#  First, read in data from working directory using readRDS().  Assumes file is in unzipped in present working dir.
dt <- data.table(readRDS("summarySCC_PM25.rds"))
names(dt)

#  Now, subset the data inta a table for a bar graphs
dt.sub <- subset(dt, fips == "24510", select = c(year, Emissions, type))
names(dt.sub)

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