# ---------------------------------------------------------------------------------
# Introdução a Datas e Tempos
# ---------------------------------------------------------------------------------
library(tidyverse)
library(highcharter)
library(maps)
library(lubridate)
library(anytime)
#
# Professor, fiz um monte de coisas diferentes para treinar para a prova
# mas os códigos pedidos no exercício estão indicado lá embaixo
#
# ---------------------------------------------------------------------------------
# Criando uma função simples
# ---------------------------------------------------------------------------------
pais <- function(x) {
  # x = Data frame com os países
  # Retorna um país e seu code escolhido
  resultado <- x[sample(nrow(x),1), c("a3", "mapname")]
  return(resultado)
}

# ---------------------------------------------------------------------------------
# Base de dados do pacote maps com o nome dos países
base <- iso3166
# Inicializando data frame
data_df <- data.frame("data" = "1", "iso-a3" = "1", "pais" = "1", "mortes" = 1)
# ---------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------
# Criando datas e tempos fictícios - EXERCÌCIO PARTE 1
# ---------------------------------------------------------------------------------
a <- nrow(base)
n <- 1000 # datas com horas dos registros

for (i in 1:n){
  dia  <- as.character(sprintf("%02d", sample.int(31, 1)))
  mes  <- as.character(sprintf("%02d", sample.int(12, 1)))
  hora <- as.character(sprintf("%02d", sample.int(23, 1)))
  min  <- as.character(sprintf("%02d", sample.int(59, 1)))
  seg  <- as.character(sprintf("%02d", sample.int(59, 1)))
  data_df[i, "data"] <- paste("2020", "-", mes, "-", dia, " ", hora, ":", min, ":", seg, sep = "")
  data_df[i, "iso-a3"] <- pais(base)[1]
  data_df[i, "pais"] <- pais(base)[2]
  data_df[i, "mortes"] <- sample.int(100, 1)
  }

# ---------------------------------------------------------------------------------
# Mapa de Morte por países: Adaptado de https://statsandr.com/blog/world-map-of-visited-countries-in-r/
# ---------------------------------------------------------------------------------
hcmap(
  map = "custom/world-highres3", # high resolution world map
  data = data_df, # name of dataset
  joinBy = "iso-a3",
  value = "mortes",
  showInLegend = FALSE, # hide legend
  nullColor = "#DADADA",
  download_map_data = TRUE
) %>%
  hc_mapNavigation(enabled = FALSE) %>%
  hc_legend("none") %>%
  hc_title(text = "Mapa Mundial de Mortes por Covid-19 em 2020") # title


# ---------------------------------------------------------------------------------
# Convertendo formatos EXERCÌCIO PARTE 2
# ---------------------------------------------------------------------------------

# Conversão para data
(str(minhaData1 <- as.Date(data_df$data)))

# Conversão para POSIXct
(str(minhaData2 <- as.POSIXct(anydate(data_df$data))))
unclass(minhaData2) # observamos o POSIXct no formato original (segundos)

# Conversão para POSIXlt
(str(minhaData3 <- as.POSIXlt(anydate((data_df$data)))))
unclass(minhaData3) # observamos o POSIXlt no formato original (componentes de tempo)

# ---------------------------------------------------------------------------------
# Extraindo EXERCÌCIO PARTE 3
# ---------------------------------------------------------------------------------

year(minhaData3) # ano

month(minhaData3) # mês

month(minhaData3, label = T) # mês pelo nome usando label = T

wday(minhaData3, label = T, abbr = T) # dia da semana abreviado

