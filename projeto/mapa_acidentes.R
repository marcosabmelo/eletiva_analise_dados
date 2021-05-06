# ---------------------------------------------------------------------------------------
# Bibliotecas
# ---------------------------------------------------------------------------------------
#
#
# ---------------------------------------------------------------------------------------
# carrega a base de snistros de transito do site da PCR
#
# Base 2016
sinistrosRecife2016Raw <- read.csv2('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/2caa8f41-ccd9-4ea5-906d-f66017d6e107/download/acidentes_2016-jan.csv', sep = ';', encoding = 'UTF-8')
# Base 2017
sinistrosRecife2017Raw <- read.csv2('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/2caa8f41-ccd9-4ea5-906d-f66017d6e107/download/acidentes_2017-jan.csv', sep = ';', encoding = 'UTF-8')
# Base 2018
sinistrosRecife2018Raw <- read.csv2('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/2caa8f41-ccd9-4ea5-906d-f66017d6e107/download/acidentes_2018-jan.csv', sep = ';', encoding = 'UTF-8')
# Base 2019
sinistrosRecife2019Raw <- read.csv2('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/2caa8f41-ccd9-4ea5-906d-f66017d6e107/download/acidentes_2019-jan.csv', sep = ';', encoding = 'UTF-8')
# Base 2020
sinistrosRecife2020Raw <- read.csv2('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/fc1c8460-0406-4fff-b51a-e79205d1f1ab/download/acidentes_2020-novo.csv', sep = ';', encoding = 'UTF-8')
# Base 2021
sinistrosRecife2021Raw <- read.csv2('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/2caa8f41-ccd9-4ea5-906d-f66017d6e107/download/acidentes_2021-jan.csv', sep = ';', encoding = 'UTF-8')
# ---------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------
# junta as bases de dados com comando rbind (juntas por linhas)
# 
sinistrosRecifeRaw <- rbind(sinistrosRecife2016Raw,
                            sinistrosRecife2017Raw,
                            sinistrosRecife2018Raw,
                            sinistrosRecife2019Raw,
                            sinistrosRecife2020Raw,
                            sinistrosRecife2021Raw)
# ---------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------
# observa a estrutura dos dados
str(sinistrosRecifeRaw)
# ---------------------------------------------------------------------------------------

# exporta em formato nativo do R
saveRDS(sinistrosRecifeRaw, "projeto/sinistrosRecife.rds")

sinistrosRecife <- readRDS("projeto/sinistrosRecife.rds")






# Geocoding a csv column of "addresses" in R

#install.packages("ggmap")

library(ggmap)

# Select the file from the file chooser
#fileToLoad <- file.choose(new = TRUE)

# Read in the CSV data and store it in a variable 
#origAddress <- read.csv(fileToLoad, stringsAsFactors = FALSE)
origAddress <- sinistrosRecife


# Initialize the data frame
geocoded <- data.frame(stringsAsFactors = FALSE)

# Loop through the addresses to get the latitude and longitude of each address and add it to the
# origAddress data frame in new columns lat and lon
for(i in 1:nrow(origAddress))
{
  # Print("Working...")
  result <- geocode(origAddress$endereco[i], output = "latlona", source = "google")
  origAddress$lon[i] <- as.numeric(result[1])
  origAddress$lat[i] <- as.numeric(result[2])
  origAddress$geoAddress[i] <- as.character(result[3])
}
# Write a CSV file containing origAddress to the working directory
write.csv(origAddress, "geocoded.csv", row.names=FALSE)




