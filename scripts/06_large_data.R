# ---------------------------------------------------------------------------------
# carregando pacotes para Large Data
library(ff)
library(ffbase)
library(tidyverse)
# Baixar a base do SAEB 2019 no endereço abaixo e salvar na pasta bases_originais
# https://download.inep.gov.br/microdados/microdados_saeb_2019.zip
# na pasta DADOS escolher base TS_ESCOLA
# Precisei modificar a base e excluir várias colunas (NIVEL...) pois o comando read.csv.ffdf não
# estava funcionando. Por isso o enderecoBase se refere a TS_ESCOLA1
enderecoBase <- "bases_originais/TS_ESCOLA1.csv"
# ---------------------------------------------------------------------------------


# ---------------------------------------------------------------------------------
#
# tempo de carregamento da base SAEB 2019 TS_ESCOLA (~20MB) Apenas para ilustrar pois a base não é pesada
#
system.time(saeb2019 <- read.csv.ffdf(file = enderecoBase))
class(saeb2019) # classe do objeto
object.size(saeb2019)/1024 # tamanho em KB
summary(saeb2019)
head(saeb2019)
# ---------------------------------------------------------------------------------

mean(saeb2019$MEDIA_5EF_MT, na.rm = T)

mean(saeb2019$NU_PRESENTES_5EF, na.rm = T)
# Tentei calcular a mediana mas demorou tanto que desisti

regressao <- lm(MEDIA_5EF_MT ~ NU_PRESENTES_5EF, data = saeb2019)

summary(regressao)
# ---------------------------------------------------------------------------------