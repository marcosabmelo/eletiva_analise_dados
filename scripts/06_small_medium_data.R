# ---------------------------------------------------------------------------------
# carregando pacotes para Large Data
library(data.table)
library(tidyverse)
# Baixar a base do SAEB 2019 no endereço abaixo e salvar na pasta bases_originais
# https://download.inep.gov.br/microdados/microdados_saeb_2019.zip
# na pasta DADOS escolher base TS_ESCOLA
enderecoBase <- "bases_originais/TS_ESCOLA.csv"
# ---------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------
# Extração direta via read.csv
#
system.time(saeb2019 <- read.csv2(enderecoBase, sep = ",", header = T))
# ---------------------------------------------------------------------------------


# ---------------------------------------------------------------------------------
# extração via função fread, que já faz amostragem automaticamente
#
system.time(saeb2019_fread <- fread(enderecoBase, sep = ",", header = T))
# ---------------------------------------------------------------------------------

