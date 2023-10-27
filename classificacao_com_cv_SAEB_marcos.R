## CLASSIFICAÇÃO COM CV ##
# Marcos A. B. de Melo
# 26/10/2023

# Carregando pacotes
pacman::p_load(ade4, arules, car, caret, corrplot, data.table, dplyr, e1071, forcats, funModeling, ggplot2, mlbench, mltools, randomForest, rattle, tidyverse)

# leitura da base de dados
ENEM_ESCOLA_2019 <- read.csv2('https://raw.githubusercontent.com/hugoavmedeiros/etl_com_r/master/bases_tratadas/ENEM_ESCOLA_2019.csv', stringsAsFactors = T) # carregando a base já tratada para o ambiente do R

# Carregando base
# SAEB 2019 Alunos do 9EF Pernambuco
# Retirados todos os NA
saeb_PE <- readRDS("SAEB_ESCOLA9EF_2019_PE.rds")

# Retirando amostra para reeduzir tamanho da base
#saeb_PE <- sample_n(saeb_PE, 500)
saeb_PE <- saeb_PE %>% 
  filter(municipio == "Recife")

#----------------------------------------------------------------------
# Dummies
# Não coloquei Dummies
# Não sei se foi por isso que deu erro no algoritmo de glmboost lá embaixo!

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

# Validação Cruzada: Pré-processamento
# Controle de treinamento
train.control <- trainControl(method = "cv", number = 10, verboseIter = T) # controle de treino

# Treinamentos
## Máquina de Vetor se Suporte (SVM)
SAEB_SVM_CLASS <- train(matematica ~ dependencia + localizacao + tdi + insealuno + reprovacao, data = treinoSAEB, method = "svmLinear", trControl = train.control)
SAEB_SVM_CLASS # sumário da máquina de vetor de suporte
plot(varImp(SAEB_SVM_CLASS))

# criar a máquina de vetor de suporte
svmSAEBCLass = svm(matematica ~ dependencia + localizacao + tdi + insealuno + reprovacao, data = treinoSAEB, cost = 10, scale = F)
svmSAEBCLass
plot(svmSAEBCLass, treinoSAEB, tdi ~ insealuno)

## Árvore de Decisão
SAEB_RPART_CLASS <- train(matematica ~ dependencia + localizacao + tdi + insealuno + reprovacao, data = treinoSAEB, method = "rpart", trControl = train.control)

summary(SAEB_RPART_CLASS)
fancyRpartPlot(SAEB_RPART_CLASS$finalModel) # desenho da árvore
plot(varImp(SAEB_RPART_CLASS)) # importância das variáveis

# Bagging com Floresta Aleatória
SAEB_RF_CLASS <- train(matematica ~ dependencia + localizacao + tdi + insealuno + reprovacao, data = treinoSAEB, method = "cforest", trControl = train.control)

plot(SAEB_RF_CLASS) # evolução do modelo
plot(varImp(SAEB_RF_CLASS)) # plot de importância

#-----------------------------------------------
#
# A partir daqui está dando erro!
#
#-----------------------------------------------
# Boosting com Boosted Generalized Linear Model
SAEB_ADA_CLASS <- train(matematica ~ dependencia + localizacao + tdi + insealuno + reprovacao, data = treinoSAEB, method = "glmboost", trControl = train.control)

plot(SAEB_ADA_CLASS) # evolução do modelo
print(SAEB_ADA_CLASS) # modelo
summary(SAEB_ADA_CLASS) # sumário

melhor_modelo <- resamples(list(SVM = SAEB_SVM_CLASS, RPART = SAEB_RPART_CLASS, RF = SAEB_RF_CLASS, ADABOOST = SAEB_ADA_CLASS))
melhor_modelo

summary(melhor_modelo)

predVals <- extractPrediction(list(SVM = SAEB_SVM_CLASS, RPART = SAEB_RPART_CLASS, RF = SAEB_RF_CLASS, ADABOOST = SAEB_ADA_CLASS), testX = testeSAEB[, c(8, 12:17)], testY = testeSAEB$nota) 

plotObsVsPred(predVals)
