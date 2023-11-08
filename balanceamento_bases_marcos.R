## BALANCEAMENTO DE BASES ##
# Marcos A. B. de Melo
# 08/11/2023

# carrega as bibliotecas
pacman::p_load(ade4, arules, car, caret, corrplot, data.table, dplyr, e1071, forcats, funModeling, ggplot2, mlbench, mltools, randomForest, rattle, tidyverse)

# leitura da base de dados
#ENEM_ESCOLA_2019 <- read.csv2('https://raw.githubusercontent.com/hugoavmedeiros/etl_com_r/master/bases_tratadas/ENEM_ESCOLA_2019.csv', stringsAsFactors = T) # carregando a base já tratada para o ambiente do R

# Carregando base
# SAEB 2019 Alunos do 9EF Pernambuco
# Retirados todos os NA
saeb_PE <- readRDS("SAEB_ESCOLA9EF_2019_PE.rds")

# Retirando amostra para reeduzir tamanho da base
#saeb_PE <- sample_n(saeb_PE, 500)
#--------------------------------------------------------
saeb_PE <- saeb_PE %>% 
  filter(municipio == "Recife")

#----------------------------------------------------------------------
# Dummies
# Não coloquei Dummies
#ENEM_ESCOLA_2019_D <- acm.disjonctif(as.data.frame(ENEM_ESCOLA_2019$tipo))
#names(ENEM_ESCOLA_2019_D) <- c('EREM', 'ETE', 'Federal', 'Privada', 'Regular')

#ENEM_ESCOLA_2019 <- cbind(ENEM_ESCOLA_2019, ENEM_ESCOLA_2019_D)
#----------------------------------------------------------------------

# Discretização da nota de Matemática
saeb_PE$matematica <- discretize(saeb_PE$matematica, method = "frequency", breaks = 2, labels = c("baixa", "alta"))

# Treino e Teste: Pré-processamento
particaoSAEB = createDataPartition(saeb_PE$matematica, p=.7, list = F) # cria a partição 70-30
treinoSAEB = saeb_PE[particaoSAEB, ] # treino
testeSAEB = saeb_PE[-particaoSAEB, ] # - treino = teste

table(treinoSAEB$matematica)


# Nenhum dos códigos abaixo funcionou porque as classes 'baixa' e 'alta' têm o mesmo valor. No máximo
# há uma diferença de 1 ou 2 entre eles. Ou seja, a base não é desbalanceada!
#----------------------------------------------------------------------
# down / under
treinoSAEBDs <- downSample(x = treinoSAEB[, -ncol(treinoSAEB)], y = treinoSAEB$matematica)
table(treinoSAEBDs$Class)   
#---------------------------------
# up
treinoSAEBUs <- upSample(x = treinoSAEB[, -ncol(treinoSAEB)], y = treinoSAEB$matematica)
table(treinoSAEBUs$Class)  
