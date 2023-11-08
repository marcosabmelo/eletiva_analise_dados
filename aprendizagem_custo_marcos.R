## BALANCEAMENTO DE BASES ##
# Marcos A. B. de Melo
# 08/11/2023

# carrega as bibliotecas
pacman::p_load(ade4, arules, car, caret, corrplot, data.table, dplyr, DMwR, e1071, forcats, funModeling, ggplot2, mlbench, mltools, randomForest, rattle, tidyverse)

# leitura da base de dados
#ENEM_ESCOLA_2019 <- read.csv2('https://raw.githubusercontent.com/hugoavmedeiros/etl_com_r/master/bases_tratadas/ENEM_ESCOLA_2019.csv', stringsAsFactors = T) # carregando a base já tratada para o ambiente do R

# Carregando base
# SAEB 2019 Alunos do 9EF Pernambuco
# Retirados todos os NA
saeb_PE <- readRDS("SAEB_ESCOLA9EF_2019_PE.rds")

#--------------------------------------------------------
#saeb_PE <- saeb_PE %>% 
#  filter(municipio == "Recife")

# Discretização da nota de Matemática
saeb_PE$matematica <- discretize(saeb_PE$matematica, method = "frequency", breaks = 2, labels = c("baixa", "alta"))

# Treino e Teste: Pré-processamento
particaoSAEB = createDataPartition(saeb_PE$matematica, p=.7, list = F) # cria a partição 70-30
treinoSAEB = saeb_PE[particaoSAEB, ] # treino
testeSAEB = saeb_PE[-particaoSAEB, ] # - treino = teste

table(treinoSAEB$matematica)

prop.table(table(treinoSAEB$matematica))

# Validação Cruzada: Pré-processamento
# Controle de treinamento
train.control <- trainControl(method = "cv", number = 10, verboseIter = T) # controle de treino

matrizCusto <- matrix(c(0,1,1000,0), ncol = 2)
rownames(matrizCusto) <- levels(treinoSAEB$matematica)
colnames(matrizCusto) <- levels(treinoSAEB$matematica)
matrizCusto

SAEB_RF_CLASS <- randomForest(matematica ~ dependencia + localizacao + tdi + insealuno + reprovacao, data = treinoSAEB, method = "cforest", parms = list(loss = matrizCusto))
SAEB_RF_CLASS

SAEB_C5_CLASS <- train(matematica ~ dependencia + localizacao + tdi + insealuno + reprovacao, data = treinoSAEB, method = "C5.0Cost", trControl = train.control)
SAEB_C5_CLASS

predicaoSAEB_RF_CLASS = predict(SAEB_RF_CLASS, testeSAEB) # criar predição
cmSAEB_RF_CLASS <- confusionMatrix(predicaoSAEB_RF_CLASS, testeSAEB$matematica)
cmSAEB_RF_CLASS

predicaoSAEB_C5_CLASS = predict(SAEB_C5_CLASS, testeSAEB) # criar predição
cmSAEB_C5_CLASS <- confusionMatrix(predicaoSAEB_C5_CLASS, testeSAEB$matematica)
cmSAEB_C5_CLASS
