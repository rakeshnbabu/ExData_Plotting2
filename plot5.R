# Plot5.R:How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

library(plyr)
library(ggplot2)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

NEI$type <- as.factor(NEI$type)
NEI$year <- as.numeric(NEI$year)
# Filter out SCC's starting with 22010 or 22300; per the codebook, this should yield all motor vehicular
# emissions. Full text of the relevant paragraph from the codebook follows:
#SCCs starting with 22010 define the light duty gasoline vehicles including motorcycles, with the exception of SCCs starting with 220107, which define the heavy duty gasoline vehicles. SCCs starting with 22300 define the ;light duty diesel vehicles, with the exception of SCCs starting with 223007 that define the heavy duty diesel vehicles

vehicleCodes <- grep("^(22010|22300)", NEI$SCC)
vehicleCodes <- intersect(which(NEI$fips == "24510"), vehicleCodes)

totalPerYear <- ddply(NEI[vehicleCodes,], c("year"), 
                      function(df)sum(df$Emissions, na.rm=TRUE))

png(filename="plot5.png", width=480, height=480)
ggplot(data=totalPerYear, aes(x=year, y=V1)) +
  geom_line() +
  xlab("Year") +
  ylab("PM2.5 (tons)") +
  ggtitle("PM2.5 from Motor Vehicles vs. Year in the Baltimore City, MD area")
dev.off()
