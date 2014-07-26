#  plot1.R seeks to creat a plot (plot1.png) in your default directory
#  which answers the question - 'Have total emissions from PM2.5 decreased
#  in the US from 1999 to 2008?
#  Uses the base plotting system to plot the totals across '99, '02. '05, & '08.

## Install necessary libraries
library(data.table)
library(RColorBrewer)

#  First, read in data from working directory using readRDS().  Assumes file is in unzipped in present working dir.
NEI <- readRDS("summarySCC_PM25.rds")

#  Now, sum emissions by year into a data.frame object
df <- aggregate(NEI$Emissions, by=list(Year=NEI$year), FUN=sum)

#  Now, plot.

png(file = "plot1.png", width = 480, height = 480)
brewer.pal(4,"Spectral")->pal

# create extra margin room on the top for clarity

par(mar = c(5, 4, 6, 3))

par(yaxt="n")

barplot(df$x,names = df$Year, axes = FALSE, xlab = "Year PM2.5 Emissions Recorded", ylab = "Tons of PM2.5 Emissions (in millions)", col = pal, tck =2)
lablist.y<-as.vector(c(0:8))
axis(2, at=seq(0, 8000000, by=1000000), tck = -.02, labels = FALSE)
axis(side = 2, lwd = 0, line = -.4, las = 1)
text(y = seq(0, 8000000, by=1000000), par("usr")[1], labels = lablist.y, srt = 0, pos = 2, xpd = TRUE)


title(main = "PM2.5 Emissions in the US: 1999 through 2008")
dev.off()