# ---------------------------------------------------------------------------------
# Pacotes
# ---------------------------------------------------------------------------------
library(ade4)
library(arules)
library(forcats)
library(purrr)
# ---------------------------------------------------------------------------------
# Criando um data frame mais diversificado da corrupção
# ---------------------------------------------------------------------------------
justica <- sample(1:3, 40, replace = T)
ID_justica <- c(Arquivado = 1, Inocentado = 2, Prescrito = 3)
justica <- factor(justica, levels = ID_justica, labels = names(ID_justica))

esfera <- sample(1:3, 40, replace = T)
ID_esfera <- c(Municipal = 1, Estadual = 2, Federal = 3)
esfera <- factor(esfera, levels = ID_esfera, labels = names(ID_esfera))

cargo <- sample(0:1, 40, replace = T) 
ID_cargo <- c(Não_Eletivo = 0, Eletivo = 1)
cargo <- factor(cargo, levels = ID_cargo, labels = names(ID_cargo))

ideologia <- sample(1:3, 40, replace = T) 
ID_ideologia <- c(Esquerda = 1, Centro = 2, Direita = 3)
ideologia <- factor(ideologia, levels = ID_ideologia, labels = names(ID_ideologia))

salario <- runif(40, 30000, 40000) # Salário declarado em US$
processos <- sample(50:100, 40, replace = T) # Número de processos na justiça
idade <- sample(25:95, 40, replace = T)
fuma <- sample(1:5, 40, replace = T)  
bebe <- sample(1:3, 40, replace = T)  
sexo <- sample(0:2, 40, replace = T)  
raca <- sample(1:10, 40, replace = T) 

base_corrupcao <- data.frame(paises, desvios, justica, esfera, salario, processos, idade, cargo,
                            ideologia, fuma, bebe, sexo, raca)
str(base_corrupcao)

# ---------------------------------------------------------------------------------
# conversão em fatores usando pacote purrr
base_corrupcao[ , 10:13] <- purrr::map_df(base_corrupcao[ , 10:13], as.factor)
str(base_corrupcao)

# ---------------------------------------------------------------------------------
# Base apenas para fatores
base_corrupcao_fatores <- base_corrupcao %>%
  dplyr::select_if(is.factor)
str(base_corrupcao_fatores)

# ---------------------------------------------------------------------------------
# One Hot Encoding
base_corrupcao_dummy <- acm.disjonctif(base_corrupcao_fatores)

# ---------------------------------------------------------------------------------
# Discretização
# Resolvi fazer os dois: One Hot Encoding e Discretização
# ---------------------------------------------------------------------------------
base_corrupcao_inteiros <- base_corrupcao %>%
  dplyr::select_if(is.integer)
str(base_corrupcao_inteiros)

base_corrupcao_inteiros$faixaetaria <- discretize(base_corrupcao_inteiros$idade,
                                                  method = "fixed",
                                                  breaks = c(0, 40, 60, 100),
                                                  labels = c("Jovens", 'Adultos', 'Idosos'))

# forcats e purrr para fatores
purrr::map(base_corrupcao_fatores, fct_count) # Conta os fatores

purrr::map(base_corrupcao_fatores, fct_lump) # Reclassifica em mais comuns 
