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


coal <- grepl("[Cc][Oo][Aa][Ll]", SCC$EI.Sector)

coal_sources <- SCC[coal, ]

coal_combustion <- NEI[(NEI$SCC %in% coal_sources$SCC), ]

coal_combustion_related <- coal_combustion %>% 
  group_by(year) %>% 
  summarise(Emissions = sum(Emissions))

# Plot 4
png("plot4.png", width=640, height=480)
ggplot(coal_combustion_related, aes(x=factor(year), y=Emissions/1000,
                                   fill=year, label = round(Emissions/1000,2))) +
  geom_bar(stat="identity") +
  xlab("Year") +
  ylab(expression("PM"[2.5]*" Emissions (Kilotons)")) +
  ggtitle("Emissions from Coal Combustion-Related Sources in the US from 1999-2008") +
  geom_label(aes(fill = year),colour = "white", fontface = "bold")


dev.off()


