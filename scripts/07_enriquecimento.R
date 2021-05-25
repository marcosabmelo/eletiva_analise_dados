# ---------------------------------------------------------------------------------
#
# carregando pacotes para Data Wrangling
#
library(tidyverse)
# ---------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------
# Base do SAEB 2019 para Serra Talhada - PE
# A base já está salva na pasta bases_originais no meu github
# saebST <- readRDS("bases_originais/saebST.rda")
escolaSTCod <- readRDS("bases_originais/escolaSTCod.rda")
# ---------------------------------------------------------------------------------

# A base do SAEB não tem o nome das escolas. Precisei baixar uma nova base de códigos no INEP
# o arquivo escolaSTCod.rda está salvo na pasta bases_originais no meu github
# Vamos usar a base toda no processo de merge. No caso da minha base faz mais sentido um merge
# do que um left_join

escolaSTCod <- escolaSTCod %>%
  rename("ID_ESCOLA" = "Código INEP") # precisei renomear a variável para o merge

saebST_full <- merge(x = saebST, y = escolaSTCod, by = "ID_ESCOLA", all.x = TRUE)

saebST_full <- saebST_full %>%
  filter(!is.na(PROFICIENCIA_LP_SAEB | PROFICIENCIA_MT_SAEB))

status(saebST_full)