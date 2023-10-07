## ARVORE DE DECISÃO COM R ##
# Marcos A. B. de Melo
# 07/10/2023

# Carregando base
# SAEB 2019 Alunos do 9EF Pernambuco
# Retirados todos os NA
saeb_PE <- readRDS("SAEB_ESCOLA9EF_2019_PE.rds")

# Carregando pacotes
pacman::p_load(caret, ggplot2, plotly, rattle)

# Semente aleatória
set.seed(314)

# Pré-processamento
particaoSAEB = createDataPartition(1 : nrow(saeb_PE), p = 0.7) # cria a partição 70-30
treinoSAEB = saeb_PE[particaoSAEB$Resample1, ] # treino
testeSAEB = saeb_PE[-particaoSAEB$Resample1, ] # - treino = teste

# Controle de treinamento
train.control <- trainControl(method = "cv", number = 100, verboseIter = T)

# Mineração e predição com Árvores de Decisão
# Árvore de Decisão
SAEB_RPART <- train(
  matematica ~ dependencia + localizacao + tdi + insealuno + reprovacao,
  data = treinoSAEB, 
  method = "rpart", 
  trControl = train.control,
  tuneGrid = expand.grid(cp = c(0.002596, runif(19,0,0.25))))

# Plot complexity
plot(SAEB_RPART)

# Desenho da árvore
fancyRpartPlot(SAEB_RPART$finalModel)

# Importância das variáveis
plot(varImp(SAEB_RPART))

predicaoTree = predict(SAEB_RPART, newdata = testeSAEB)

# Teste de performance da Árvore Condicional
postResample(testeSAEB[ , 7], predicaoTree) # Nota de Matemática = coluna 7

base_avaliacao <- data.frame(
  Observado = testeSAEB[ , 7], # Nota de Matemática = coluna 7
  Predição = predicaoTree)
colnames(base_avaliacao) = c("Observado", "Predição") # Tive que forçar o nome "Observado"

# Plot Predição
predicao_arvore <- base_avaliacao %>% 
  ggplot(aes(x = Observado, y = Predição)) +
  geom_point() + # cria os pontos
  geom_smooth() # cria a curva de associação
ggplotly(predicao_arvore)
