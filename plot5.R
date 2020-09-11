if(!file.exists("data")){
  dir.create("data")
  fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileUrl, destfile = "./data/FNEI_data.zip", method = "curl")
  unzip("./data/FNEI_data.zip")
}

if(!exists("NEI")){
  NEI <- readRDS("summarySCC_PM25.rds")
}

if(!exists("SCC")){
  SCC <- readRDS("Source_Classification_Code.rds")
}

library(dplyr)
library(ggplot2)


baltCityMD_onRoad <-NEI[(NEI$fips=="24510") & (NEI$type=="ON-ROAD"),]

baltCity_Emission_byYear <- baltCityMD_onRoad %>%
  group_by(year) %>%
  summarise(Emissions = sum(Emissions))

# Plot 5
png("plot5.png", width=640, height=480)
ggplot(baltCity_Emission_byYear, 
       aes(x=factor(year), y=Emissions, fill=year, label=round(Emissions,2))) +
  geom_bar(stat="identity") +
  xlab("Year") +
  ylab(expression("PM"[2.5]*" Emissions (Tons)")) +
  ggtitle("Emissions from Motor Vehicle Sources in Baltimore City, MD from 1999-2008")+
  geom_label(aes(fill = year),colour = "white", fontface = "bold")


dev.off()
