# ---------------------------------------------------------------------------------
# Pacotes 
# ---------------------------------------------------------------------------------
library(tidyverse)   #::%>% 
library(data.table)  #::setDT
library(funModeling) #::status
library(kableExtra)  #::kbl, kabble_paper
library(plotly)      #::plotly
if (!require(aweek)) install.packages("aweek") 
library(aweek)       #::date2week
library(fuzzyjoin)

# ---------------------------------------------------------------------------------
# 1)  Extraia a base geral de covid em Pernambuco disponível neste endereço:
#     https://dados.seplag.pe.gov.br/apps/corona_dados.html.
# ---------------------------------------------------------------------------------
# A base de CovidPE (https://dados.seplag.pe.gov.br/apps/basegeral.csv) tem 200 Mb.
# Baixei a base e salvei como .rds na pasta bases_originais do meu github. O arquivo ficou com 8 Mb
# No processo de importação a variável raca foi corrompida.

covidPE <- readRDS("bases_originais/covidPE.rds")
covidPE <- covidPE %>% setDT() # Transformando em Data Table

glimpse(covidPE)
status(covidPE)

# ---------------------------------------------------------------------------------
# 2) Calcule, para cada município do Estado, o total de casos confirmados 
#    e o total de óbitos por semana epidemiológica 
#    [atenção, você terá de criar uma variável de semana epidemiológica com base na data].
# ---------------------------------------------------------------------------------
# Criando semana epidemiológica
covidPE$epiweek <- date2week(covidPE$dt_notificacao)

# Reduzindo a quantidade de varáveis para apenas as de interesse
agg <- covidPE[ , c("municipio", "classe", "dt_obito", "epiweek")]

# Preparando para o summarise
agg$dt_obito <- ifelse(is.na(agg$dt_obito), 0, 1)
agg$classe   <- ifelse(agg$classe == "CONFIRMADO", 1, 0)

# Summarise e Tabela
agg %>%
  group_by(municipio, epiweek) %>%
  summarise(confirmado = sum(classe), obitos = sum(dt_obito)) %>% 
  kbl() %>%
  kable_paper("hover", full_width = F) 

# ---------------------------------------------------------------------------------
# 3) Enriqueça a base criada no passo 2 com a população de cada município, 
#    usando a tabela6579 do sidra ibge
# ---------------------------------------------------------------------------------  
# Carregando a base sidra
sidra <- readRDS("bases_originais/sidra.rds")

# Deixando a base com os municípios de PE
i <- grepl('(PE)', sidra$municipio)
sidra$municipio <- ifelse(i == T, sidra$municipio, NA)
sidra <- na.delete(sidra)


# Enriquecendo a base
# Não deu tempo fazer
# Essa é a parte mais trabalhosa. Perdi muito tempo com a base grande e meu computador lento. Depois
# percebi que podia reduzir a base.

# ---------------------------------------------------------------------------------
# 4) Calcule a incidência (casos por 100.000 habitantes) e letalidade (óbitos por 100.000 habitantes)
#    por município a cada semana epidemiológica. Enriqueça a base criada no passo 2 com a população 3
#    de cada município, usando a tabela6579 do sidra ibge
# ---------------------------------------------------------------------------------  

# caso tivesse conseguido, a tabela com a incidência e a letalidade seria algo assim:
# Vou fazer com uma base simulada
agg_full <- agg # agg é a base reduzida, pois meu computador é muito lento
agg_full$pop2020 <- 120000 # coloquei 120000 habitantes para todos os municípios

# Summarise e Tabela
agg_full %>%
  group_by(municipio, epiweek) %>%
  summarise(incidencia = 100000*sum(classe)/mean(pop2020), letalidade = 100000*sum(dt_obito)/mean(pop2020)) %>% 
  kbl() %>%
  kable_paper("hover", full_width = F) 
