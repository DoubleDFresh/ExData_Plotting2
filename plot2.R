#  plot2.R seeks to creat a plot (plot2.png) in your default directory
#  which answers the question - 'Have total emissions from PM2.5 decreased
#   in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? 
#  Uses the base plotting system to plot the totals across '99, '02. '05, & '08.

## Install necessary libraries
library(data.table)
library(RColorBrewer)

#  First, read in data from working directory using readRDS().  Assumes file is in unzipped in present working dir.
NEI <- readRDS("summarySCC_PM25.rds")

#  Now, sum emissions by year into a data.frame object
dt <- data.table(NEI)
names(dt)
dt.sub <- subset(dt, fips == "24510", select = c(year, Emissions))
dt.sub <- aggregate(dt.sub$Emissions, by=list(Year=dt.sub$year), FUN=sum)

#  Now, plot.

png(file = "plot2.png", width = 480, height = 480)
brewer.pal(4,"Purples")->pal

# create extra margin room on the top for clarity

par(mar = c(5, 4, 6, 3))

par(yaxt="n")

barplot(dt.sub$x,names = dt.sub$Year, axes = FALSE, xlab = "Year PM2.5 Emissions Recorded", ylab = "Tons of PM2.5 Emissions (in millions)", col = pal, tck =2)
lablist.y<-as.vector(c(0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5))
axis(2, at=seq(0, 3500, by=500), tck = -.02, labels = FALSE)
axis(side = 2, lwd = 0, line = -.4, las = 1)
text(y = seq(0, 3500, by=500), par("usr")[1], labels = lablist.y, srt = 0, pos = 2, xpd = TRUE)


title(main = "PM2.5 Emissions in Baltimore City, MD: 1999 - 2008")
dev.off()