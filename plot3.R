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


# Group total NEI emissions by year and type
baltCityMD_byYear <- NEI %>%
  filter(fips == "24510") %>%
  group_by(year, type) %>%
  summarise(Emissions = sum(Emissions))

# Plot 3
png("plot3.png", width=800, height=800)
ggplot(baltCityMD_byYear, aes(x=factor(year), y = Emissions/1000, 
                              fill = type, label = round(Emissions/1000,2))) +
                                          
  geom_bar(stat="identity") +
  facet_grid(. ~ type) +
  xlab("Year") +
  ylab(expression("PM"[2.5]*" Emission (kilotons)")) +
  ggtitle(expression("PM"[2.5]*" Emissions by Source Types in Baltimore City, MD from 1999 to 2008")) +
  geom_label(aes(fill = type), colour = "white", fontface = "bold")


dev.off()




