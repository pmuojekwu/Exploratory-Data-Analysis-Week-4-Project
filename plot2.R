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

baltimoreMD_emissions <- NEI %>%
  filter(fips == 24510) %>%
  group_by(year) %>%
  summarise(Emissions = sum(Emissions))

# Plot 1
png("plot2.png", width=480, height=480)
clrs <- c("blue", "green", "red", "yellow")
x2 <- barplot(height = baltimoreMD_emissions$Emissions/1000, 
            names.arg = baltimoreMD_emissions$year, xlab = "Years",
            ylab = expression('PM'[2.5]*' Emission (Kilotons)'), ylim=c(0,4), col = clrs,
            main = expression('Total PM'[2.5]*' Emissions in Baltimore City, MD from 1999 to 2008'))

## Add text at top of bars
text(x = x2, y = round(baltimoreMD_emissions$Emissions/1000,2), 
     label = round(baltimoreMD_emissions$Emissions/1000,2), 
     pos = 3, cex = 0.8, col = "black")
dev.off()
