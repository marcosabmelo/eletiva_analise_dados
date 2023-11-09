## IA EXPLICÁVEL ##
# Marcos A. B. de Melo
# 09/11/2023

#---------------------------------------------------
# carrega as bibliotecas
#---------------------------------------------------
pacman::p_load(
  caret, corrplot, data.table, dplyr, fastDummies, ggplot2, SmartEDA, tidyverse)

# Base de dados (376x11)
# SAEB 9EF 2019 para Pernambuco contendo 376 escolas com efeito escola "significante" Alto ou Baixo
# Índices de desigualdade Silber&Yalonetzki (IK) por INSE dos alunos
# Quanto maior o IK maior a desigualdade entre alunos com INSE acima e abaixo da média.
# Queremos saber se o IDEB da escola é explicado por essas variáveis
saeb_ineqPE <- readRDS("saeb_ineqPE.rds")

#---------------------------------------------------
# preparação
#---------------------------------------------------
particaoSaeb = createDataPartition(saeb_ineqPE$ideb, p=.7, list = F) # cria a partição 70-30
treinoSaeb = saeb_ineqPE[particaoSaeb, ] # treino
testeSaeb = saeb_ineqPE[-particaoSaeb, ] # - treino = teste

saeb_formula <- ideb ~ dependencia + localizacao + IK_port + IK_mat + efeito + inseescola + tdi

lista_modelos <- c('lm', 'glmnet', 'glmboost', 'rpart', 'cforest')

total_cv <- 10

train.control <- trainControl(method = "cv", number = total_cv, verboseIter = T) # controle de treino

pacman::p_load(caretEnsemble)
# Meu computador só tem 2 núcleos :-)
#pacman::p_load(caretEnsemble, doParallel)
#registerDoParallel(cores = detectCores() - 1)

#---------------------------------------------------
# modelagem
#---------------------------------------------------
saeb_modelos <- caretList(
  saeb_formula, 
  data = treinoSaeb, 
  methodList = lista_modelos, 
  metric = "RMSE",
  trControl = train.control,
  tuneLength = 5)

pacman::p_load(DALEX, iml, pdp)

#---------------------------------------------------
# importância
#---------------------------------------------------
saeb_varImp <- varImp(saeb_modelos$cforest)

saeb_varImp_df <- as.data.frame(as.matrix(saeb_varImp$importance))

saeb_varImp_df <- saeb_varImp_df %>% mutate(
  variável = c("dependenciaMunicipal", "localizacaoRural",
               "IK_port", "IK_mat", "efeito", "inseescola", "tdi"))

#----------------------------------------------------------------------------------------
# Gráfico Importância das Variáveis
#----------------------------------------------------------------------------------------
grafico_varImp <- ggplot(data=saeb_varImp_df, aes(x=reorder(variável, -Overall), y=Overall)) + geom_bar(stat="identity", fill=c("#eae0cc", "#fbe45b", "#2c7c94", "#a65852", "#3d005b", "#d1b2e0", "#660099")) + theme_minimal() + 
  coord_flip() + 
  labs(
    title  = ~ underline("Importância das variáveis usadas no modelo"), 
    subtitle = "Base SAEB",
    caption = 'Modelo: Floresta Aleatória',
    x = '',
    y = 'Importância Relativa') + theme(
      plot.title = element_text(face = 'bold', lineheight = 1, size = 16, color = "#333333"),
      plot.subtitle = element_text(face = 'italic', size = 12, color = "#333333") ,
      plot.caption = element_text(size = 10, color = "#007095") ,
      strip.text = element_text(size = 10, color = "white") ,
      axis.title.x = element_text(hjust=0, color = "#007095"),
      axis.text.x = element_text(face = 'bold', colour = '#5bc0de', size = 12, angle = 75, vjust = .5),
      axis.title.y = element_text(hjust=0, color = "#007095"),
      axis.text.y = element_text(face = 'bold', colour = '#5bc0de', size = 12),
      legend.position="bottom", 
      legend.box = "horizontal",
      legend.background = element_rect(fill="#dee2e6", colour ="white")
    )

grafico_varImp

#---------------------------------------------------
# perfil parcial
#---------------------------------------------------
treinoSaeb_x <- dplyr::select(treinoSaeb, -ideb)
testeSaeb_x <- dplyr::select(testeSaeb, -ideb)

explainer_rf <- DALEX::explain(model = saeb_modelos$cforest, data = testeSaeb_x, y = testeSaeb$ideb, label = "Random Forest")

pdp_rf_saeb <- model_profile(explainer = explainer_rf, variables = "efeito", groups = "dependencia")

grafico_pdp <- plot(pdp_rf_saeb, geom = "profiles") + 
  labs(
  title  = ~ underline("Perfis de dependência parcial para IDEB por Dependência"), 
  subtitle = "Base SAEB",
  caption = 'Modelo: Florestas Aleatórias',
  tag = '',
  x = 'Efeito Escola',
  y = 'IDEB',
  colour = "dependencia") + 
  scale_colour_manual(
    values = c('orange', 'deepskyblue'),
    name = "Dependência") + 
  theme(
    plot.title = element_text(face = 'bold', lineheight = 1, size = 16, color = "#333333"),
    plot.subtitle = element_text(face = 'italic', size = 12, color = "#333333") ,
    plot.caption = element_text(size = 10, color = "#007095") ,
    strip.text = element_text(size = 10, color = "white") ,
    axis.title.x = element_text(hjust=0, color = "#007095"),
    axis.text.x = element_text(face = 'bold', colour = '#5bc0de', size = 12),
    axis.title.y = element_text(hjust=0, color = "#007095"),
    axis.text.y = element_text(face = 'bold', colour = '#5bc0de', size = 12),
    legend.position="bottom", 
    legend.box = "horizontal",
    legend.background = element_rect(fill="#dee2e6", colour ="white")
  )

grafico_pdp
