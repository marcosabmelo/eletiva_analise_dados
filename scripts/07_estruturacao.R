# ---------------------------------------------------------------------------------
#
# carregando pacotes para Data Wrangling
#
library(data.table)
library(dplyr)
library(tidyverse)
# ---------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------
# Base do SAEB 2019 para Serra Talhada - PE
# A base já está salva na pasta bases_originais no meu github
# saebST <- readRDS("bases_originais/saebST.rda")
# ---------------------------------------------------------------------------------

# Da base só queremos as variáveis ID_ESCOLA e PROFICIENCIA_MT_SAEB (nota de Matemática)
# A base está em formato LONGO e iremos transformar em WIDE

saebST_long <- saebST %>%
  select(ID_ESCOLA, PROFICIENCIA_MT_SAEB) %>%
  na.omit() %>% # removendo os casos com NA nas notas
  mutate(row = row_number()) # criando row para servir de nome das linhas

# pivotando long  >>  wide
saebST_wide <- saebST_long %>%
  pivot_wider(names_from = row, values_from = PROFICIENCIA_MT_SAEB) %>%
  remove_rownames %>%
  column_to_rownames(var="ID_ESCOLA")
# Não fica muito 'bonito' pois o data frame fica com 'cara de matriz esparsa'
