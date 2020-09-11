

if(!file.exists("data")){
  dir.create("data")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl, destfile = "./data/FNEI_data.zip", method = "curl")
unzip("./data/FNEI_data.zip")


NEI <- readRDS("summarySCC_PM25.rds") 


SCC <- readRDS("Source_Classification_Code.rds")

library(dplyr)
total_emissions <- NEI %>%
  group_by(year) %>%
  summarize(Emissions = sum(Emissions))

# Plot 1
png("plot1.png", width=480, height=480)
clrs <- c("blue", "green", "red", "yellow")
x1 <- barplot(height = total_emissions$Emissions/1000, names.arg = total_emissions$year,
            xlab = "Years", ylab = expression('PM'[2.5]*' Emissions (Kilotons)'),
            ylim = c(0,8000), col = clrs,
            main = expression('Total PM'[2.5]*' Emissions in the US From 1999 to 2008'))

# Add text at the top of bars
text(x = x1, y = round(total_emissions$Emissions/1000,2), 
     label = round(total_emissions$Emissions/1000,2), pos = 3, cex = 0.8, col = "black")


dev.off()
