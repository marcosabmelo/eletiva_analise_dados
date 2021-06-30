# ---------------------------------------------------------------------------------
# Pacotes 
# ---------------------------------------------------------------------------------
library(tidyverse)   #::%>% 
library(data.table)  #::setDT
library(Hmisc)       #::describe, impute
library(funModeling) #::status
library(kableExtra)  #::kbl, kabble_paper
library(zoo)         #::rollmean 
library(plotly)      #::plotly
# ---------------------------------------------------------------------------------
# 1) Extraia a base geral de covid em Pernambuco
# ---------------------------------------------------------------------------------
# A base de CovidPE (https://dados.seplag.pe.gov.br/apps/basegeral.csv) tem 200 Mb.
# Baixei a base e salvei como .rds na pasta bases_originais do meu github. O arquivo ficou com 8 Mb
covidPE <- readRDS("bases_originais/covidPE.rds")
covidPE <- covidPE %>% setDT() # Transformando em Data Table

glimpse(covidPE)
status(covidPE)
# ---------------------------------------------------------------------------------
# 2) Corrija os NAs da coluna sintomas através de imputação randômica
# ---------------------------------------------------------------------------------
# A variável data dos primeiros sintomas (dt_primeiros_sintomas) tem muitos NA's mas 
# a variável sintomas não. Ela apenas apresenta um espaço em branco. Não sei se minha
# base abriu errado, mas vou colocar NA nos espaços em branco e imputar os sintomas aleatoriamente.

# Trocando "" por NA
covidPE$sintomas[covidPE$sintomas == ""] <- NA

# Imputando valores aleatórios em sintomas
covidPE$sintomas <- impute(covidPE$sintomas, "random") # Valores imputados aparecem com *
# Sumário do pacote Hmisc: Já diz se foi imputado ou não
describe(covidPE[ , "sintomas"])

# ---------------------------------------------------------------------------------
# 3) Calcule, para cada município do Estado, o total de casos confirmados e negativos
# ---------------------------------------------------------------------------------
# Summarise casos por município + tabela
covidPE %>%
  group_by(municipio, classe) %>%
  summarise(n = n()) %>%
  filter(classe %in% c("CONFIRMADO", "NEGATIVO")) %>% 
  kbl() %>%
  kable_paper("hover", full_width = F) 

# ---------------------------------------------------------------------------------
# 4) Crie uma variável binária se o sintoma inclui tosse ou não e calcule quantos
#    casos confirmados e negativos tiveram tosse como sintoma
# ---------------------------------------------------------------------------------
# Criando variável binária: tosse
i <- grepl('TOSSE', covidPE$sintomas)
tosse <- ifelse(i == T, 1, 0)
covidPE$tosse <- tosse

# Summarise casos por município + tabela
covidPE %>%
  group_by(municipio, classe, tosse) %>%
  summarise(n = n()) %>%
  filter(classe %in% c("CONFIRMADO", "NEGATIVO")) %>%
  kbl() %>%
  kable_paper("hover", full_width = F)

# Plotando tabela agregada
covidPE %>%
  group_by(classe, tosse) %>%
  summarise(n = n()) %>%
  filter(classe %in% c("CONFIRMADO", "NEGATIVO")) %>%
  kbl() %>%
  kable_paper("hover", full_width = F)

# ---------------------------------------------------------------------------------
# 5) Agrupe os dados para o Estado, estime a média móvel de 7 dias de confirmados e negativos
# ---------------------------------------------------------------------------------
# Criando variável conf. 1 se casos são confirmados e 0 caso contrário
conf <- ifelse(covidPE$classe == "CONFIRMADO", 1, 0)
covidPE$conf <- conf

auxconf <- covidPE %>%
  group_by(dt_notificacao, conf) %>%
  summarise(n = n()) %>%
  filter(conf == 1) %>% 
  dplyr::ungroup()

auxconf[, "n"] <- cumsum(auxconf[, "n"])

auxconf <- auxconf %>% 
  mutate(data = dt_notificacao,
         conf = n,
         confMM7 = round(rollmean(x = n, 7, align = "right", fill = NA), 2)) %>% 
  select(data, conf, confMM7)
  
# Como a série já é suave, a média móvel também será
plot_ly(auxconf) %>% add_trace(x = ~ data, y = ~ conf, type = "scatter", mode = "lines", name = "Confirmados") %>% add_trace(x = ~ data, y = ~ confMM7, name = "Confirmados MM7", type = "scatter", mode = "lines") %>%
  layout(title = "Casos Confirmados de COVID19 em Pernambuco e Média Móvel 7 dias (MM7)",
         xaxis = list(title = "Data", showgrid = FALSE), 
         yaxis = list(title = "Casos Confirmados Acumulados por Dia", showgrid = FALSE),
         hovermode = "compare") # plotando tudo junto, para comparação
# ---------------------------------------------------------------------------------
# Criando variável neg. 1 se casos são negativos e 0 caso contrário
neg <- ifelse(covidPE$classe == "NEGATIVO", 1, 0)
covidPE$neg <- neg

auxneg <- covidPE %>%
  group_by(dt_notificacao, neg) %>%
  summarise(n = n()) %>%
  filter(neg == 1) %>% 
  dplyr::ungroup()

auxneg[, "n"] <- cumsum(auxneg[, "n"])

auxneg <- auxneg %>% 
  mutate(data = dt_notificacao,
         neg = n,
         negMM7 = round(rollmean(x = n, 7, align = "right", fill = NA), 2)) %>% 
  select(data, neg, negMM7)

# Como a série já é suave, a média móvel também será
plot_ly(auxneg) %>% add_trace(x = ~ data, y = ~ neg, type = "scatter", mode = "lines", name = "Negativados") %>% add_trace(x = ~ data, y = ~ negMM7, name = "Negativados MM7", type = "scatter", mode = "lines") %>%
  layout(title = "Casos Negativados de COVID19 em Pernambuco e Média Móvel 7 dias (MM7)",
         xaxis = list(title = "Data", showgrid = FALSE), 
         yaxis = list(title = "Casos Negativados Acumulados por Dia", showgrid = FALSE),
         hovermode = "compare") # plotando tudo junto, para comparação