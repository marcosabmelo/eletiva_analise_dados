# ---------------------------------------------------------------------------------
# Juntando e Buscando Textos  
# ---------------------------------------------------------------------------------
library(tidyverse)
library(fuzzyjoin)
library(rvest)

# -----------------------------------------------------------------
# Scraping tabela do wikipedia. Alguns países possuem nomes parecidos
# em Português e Inglês. Veremos que o stringdist_join vai unir os
# nomes que são parecidos
# -----------------------------------------------------------------
# tabela IDH wikipedia
url <- "https://pt.wikipedia.org/wiki/Lista_de_países_por_Índice_de_Desenvolvimento_Humano_(2008)"
url_tabela <- url %>% read_html %>% html_nodes("table")
IDH <- as.data.frame(html_table(url_tabela[2]))
# -----------------------------------------------------------------
# tabela HDI wikipedia
url <- "https://en.wikipedia.org/wiki/List_of_countries_by_Human_Development_Index"
url_tabela <- url %>% read_html %>% html_nodes("table")
HDI <- as.data.frame(html_table(url_tabela[1]))

# Unindo as bases e buscando elemento chamado Brasil
base_junta <- stringdist_join(HDI, IDH, by = 3, mode = "left")
base_junta[which(base_junta$Country.or.territory == "Brazil"), 1:10]