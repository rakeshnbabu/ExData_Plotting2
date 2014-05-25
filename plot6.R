# Plot6.R: Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?

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
vehicleCodes <- intersect(union(which(NEI$fips == "24510"),
                                which(NEI$fips == "06037")),
                          vehicleCodes)

totalPerYear <- ddply(NEI[vehicleCodes,], c("year", "fips"), 
                      function(df)sum(df$Emissions, na.rm=TRUE))
names(totalPerYear) <- c("year", "region", "emissions")

totalPerYear$region <- as.factor(totalPerYear$region)
levels(totalPerYear$region) <- c("Los Angeles", "Baltimore")

png(filename="plot6.png", width=480, height=480)

ggplot(data=totalPerYear, aes(x=year, y=emissions, group=region, colour=region)) +
  geom_line() +
  xlab("Year") +
  ylab("PM2.5 (tons)") +
  ggtitle("PM2.5 from Motor Vehicles vs. Year in Baltimore and Los Angeles")
dev.off()
