#  plot6.R seeks to create a plot (plot6.png) in your default directory
#  which answers the question - 
#  Compare emissions from motor vehicle sources in Baltimore City with  Los Angeles county
#  Which city has seen greater changes over time in motor vehicle emissions?
#  Assumed that motor vehicle is only the ON-ROAD value in the SummarySCC_PM25 table

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
dt.sub <- subset(dt, fips %in% c("24510","06037") & type == "ON-ROAD", select = c(year, Emissions, fips))
dt.sub$fips <- as.factor(dt.sub$fips)
dt.sub <- aggregate(dt.sub$Emissions, by=list(Year=dt.sub$year, City=dt.sub$fips), FUN=sum)

#  Plot
png(file = "plot6.png", width = 480, height = 480)
ggplot(data=dt.sub, aes(x=Year, y=x, fill=City)) + geom_bar(stat="identity", position=position_dodge()) +
        scale_fill_hue(name="City") +
        xlab("Year PM2.5 Emissions Recorded") + ylab("Tons of PM2.5 Motor Vehicle Emissions") +  
        ggtitle("Comparison of Los Angeles & Baltimore Vehicle Emissions") + scale_y_continuous(breaks = c(seq(0,5000,500)), labels = comma, limits = c(0,5000))

dev.off()