#  plot5.R seeks to create a plot (plot5.png) in your default directory
#  which answers the question - 
#  How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
#  Assumed that motor vehicle is only the 

## Install necessary libraries
library(data.table)
library(RColorBrewer)
library(ggplot2)
library(plyr)
library(scales)

#  First, read in data from working directory using readRDS().  Assumes file is in unzipped in present working dir.
dt <- data.table(readRDS("summarySCC_PM25.rds"))
#  Set year as factor for ggplot2
dt$year <- as.factor(dt$year)
names(dt)

#  Now, subset the data using grep looking for coal emissions to merge w/ dt
dt.sub <- subset(dt, fips == "24510" & type == "ON-ROAD", select = c(year, Emissions,type))
dt.sub <- aggregate(dt.sub$Emissions, by=list(Year=dt.sub$year), FUN=sum)

#  Plot
png(file = "plot5.png", width = 480, height = 480)
ggplot(data=dt.sub, aes(x=Year, y=x)) + geom_bar(fill = "blue", stat="identity", position=position_dodge()) +
        scale_fill_hue(name="Emission Type") +
        xlab("Year PM2.5 Emissions Recorded") + ylab("Tons of PM2.5 Motor Vehicle Emissions") +  
        ggtitle("Motor Vehicle PM2.5 Emissions in Baltimore, MD") + scale_y_continuous(labels = comma, limits = c(0,400))

dev.off()