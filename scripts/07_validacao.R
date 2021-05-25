# ---------------------------------------------------------------------------------
#
# carregando pacotes para Data Wrangling
#
library(funModeling)
library(tidyverse)
library(validate)
# ---------------------------------------------------------------------------------
# saebST <- readRDS("bases_originais/saebST.rda")

# É muito fácil confundir validação com filtro

# Minha base de dados é muito bem comportada, mesmo assim vou criar um validador
# para notas que não podem ser negativas nem o município pode ser diferente
# de Serra Talhada-PE (2613909)
# Todos os casos passarão, pois a base é pequena e limpa, mas serve para ilustrar

regras <- validator(PROFICIENCIA_LP_SAEB > 0, PROFICIENCIA_MT_SAEB > 0, ID_MUNICIPIO == 2613909)

validacao <- confront(saebST_full, regras)

summary(validacao)

plot(validacao)

# Dessa forma não temos nenhum caso de escola fora do município correto e nem notas negativas