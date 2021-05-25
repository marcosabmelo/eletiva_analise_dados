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

# Como já havia retirado os NA da base script Estruturação vou aproveitar esse script para
# ampliar minha base para ID_ESCOLA, PROFICIENCIA_LP_SAEB (nota de Português) e
# PROFICIENCIA_MT_SAEB (nota de Matemática)

saebST_long <- saebST %>%
  select(ID_ESCOLA, PROFICIENCIA_LP_SAEB, PROFICIENCIA_MT_SAEB) %>%
  na.omit() %>% # removendo os casos com NA nas notas
  mutate(row = row_number()) # criando row para servir de nome das linhas

# pivotando long  >>  wide
saebST_wide <- saebST_long %>%
  pivot_wider(names_from = row, values_from = c(PROFICIENCIA_LP_SAEB, PROFICIENCIA_MT_SAEB)) %>%
  remove_rownames %>%
  column_to_rownames(var="ID_ESCOLA")
