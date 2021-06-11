# ---------------------------------------------------------------------------------
# Valores Ausentes 
# ---------------------------------------------------------------------------------
library(data.table)
library(funModeling) 
library(tidyverse)
library(mice)
library(VIM)
library(corrplot)

# ---------------------------------------------------------------------------------
# Base do SAEB 1997 Alunos 8EF Prova de MAtemática - Brasil
saeb1997 <- readRDS("bases_originais/saeb8EF1997BR.rda")

# ---------------------------------------------------------------------------------
dim(saeb1997) # apenas 18806 alunos e 72 variáveis
status(saeb1997) # Muitas variáveis com NA. IDADE tem 1382 NA's e a variável A081_001 (data nascimento) também

# ---------------------------------------------------------------------------------
# Dicionário resumido dos dados: Importante para saber se há correlação 
# ---------------------------------------------------------------------------------
# A081_001 Data de nascimento
# A081_002 Que idade voce tinha quando entrou na 1ª serie do Ensino Fundamental(1ºGrau)?
# A081_003 Qual o seu sexo?
# A081_004 Qual sua raça?
# A081_005 Com quem voce mora?
# A081_006 Qual o nivel de instruçao do seu pai?
# A081_007 Qual o nivel de instruçao da sua mae?

# ---------------------------------------------------------------------------------
# Removendo todos os casos
dim(na.omit(saeb1997)) # Ficamos com apenas 13316 casos completos
                       # Se eu não precisar da variável Idade para fazer uma regressão, por exemplo,
                       # podemos deixar muitos casos que retirados com o na.omit

# ---------------------------------------------------------------------------------
# Saeb Shadow Matrix
saeb1997SM <- as.data.frame(abs(is.na(saeb1997)))

# Visualizando o padrão com o pacote VIM. Apenas metade da matriz
aggr(saeb1997[,1:36], prop=FALSE, numbers=TRUE)

# Filtrando por variância em coluna
saeb1997SM <- saeb1997SM[which(sapply(saeb1997SM, sd) > 0)]

# Como são muitas variáveis fiz um corrplot da Sahdow Matrix.
# Note que IDADE e A081_001 são perfeitamente correlacionadas como alertamos antes
corrplot(cor(saeb1997SM))

# Padrões entre os valores específicos das variáveis e os NA
saeb1997NUM <- saeb1997 %>% # Deixando apenas variáveis numéricas
  select_if(., is.numeric)

cor(saeb1997NUM, saeb1997SM, use="pairwise.complete.obs")

# Trazendo de volta UF para a base para efeitos de agrupamento e sumário
saeb1997SM <- cbind(saeb1997SM, UF = saeb1997$UF)

# Agrupando por UF
saeb1997SM <- saeb1997SM %>% 
  group_by(UF) %>%
  summarise(across(everything(), list(sum)))
