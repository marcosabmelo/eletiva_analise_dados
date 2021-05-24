# ---------------------------------------------------------------------------------
#
# carregando pacotes para Large Data
#
library(funModeling)
library(tidyverse)
# ---------------------------------------------------------------------------------
# Base do SAEB 2019 para Serra Talhada - PE
# A base já está salva na pasta bases_originais no meu github
saebST <- readRDS("bases_originais/saebST.rda")
# ---------------------------------------------------------------------------------
# Descobrindo os dados
#
glimpse(saebST) # visão geral nos dados
status(saebST) # resumo da estrutura 
plot_num(saebST) # explorando variáveis numéricas. Algumas não são de interesse, depois eu estruturo
profiling_num(saebST) # estatísticas das variáveis numéricas
# ---------------------------------------------------------------------------------