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


baltCtyMD_emissions <- NEI %>%
  filter(fips == "24510" & type == "ON-ROAD") %>%
  group_by(year) %>%
  summarise(Emissions = sum(Emissions))

LACountyCA_emissions <- NEI %>%
  filter(fips == "06037" & type == "ON-ROAD") %>%
  group_by(year)%>% 
  summarise(Emissions = sum(Emissions))


baltCtyMD_emissions$County <- "Baltimore City, MD"
LACountyCA_emissions$County <- "Los Angeles County, CA"
both_emissions <- rbind(baltCtyMD_emissions, LACountyCA_emissions)

# Plot 6
png("plot6.png", width=640, height=480)
ggplot(both_emissions, 
       aes(x=factor(year), y=Emissions, fill=County, label=round(Emissions,2))) +
  geom_bar(stat="identity") + 
  facet_grid(County~., scales="free") +
  ylab(expression("PM"[2.5]*" Emissions (Tons)")) + 
  xlab("Year") +
  ggtitle(expression("Motor Vehicle Emission Comparison in Baltimore,MD & Los Angeles,CA"))+
  geom_label(aes(fill = County),colour = "white", fontface = "bold")

dev.off()
  



