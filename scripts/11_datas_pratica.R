# ---------------------------------------------------------------------------------
# Datas na Prática
# ---------------------------------------------------------------------------------
library(tidyverse)
library(lubridate)
library(drc)
library(plotly)
library(zoo)
library(xts)

# ---------------------------------------------------------------------------------
url = 'https://raw.githubusercontent.com/wcota/covid19br/master/cases-brazil-states.csv'
covidBR = read.csv2(url, encoding='latin1', sep = ',') # baixar a base de covidBR
covidPE <- subset(covidBR, state == 'PE') # filtrar para Pernambuco
str(covidPE) # observar as classes dos dados
covidPE$date <- as.Date(covidPE$date, format = "%Y-%m-%d") # modificar a coluna data de string para date
str(covidPE) # observar a mudança na classe

# ---------------------------------------------------------------------------------
# Dados da 1a. dose da vacina
# ---------------------------------------------------------------------------------
start_vac1 <- covidPE$date[min(which(!is.na(covidPE$vaccinated)))]
end_vac1   <- covidPE$date[max(which(!is.na(covidPE$vaccinated)))]
paste("A vacinação começou no dia", start_vac1, "e até o dia", end_vac1, " já foram", end_vac1 - start_vac1, "dias de vacinação (1a. dose)")

# ---------------------------------------------------------------------------------
# Preparando base e vetores auxiliares
# ---------------------------------------------------------------------------------
covidPE$dia <- seq(1:length(covidPE$date)) # criar uma nova coluna
predDia = data.frame(dia = covidPE$dia) # criar vetor auxiliar de predição
predSeq = data.frame(dia = seq(max(covidPE$dia)+1, max(covidPE$dia)+60)) # vetor auxiliar +60 dias
predDia <- rbind(predDia, predSeq) # juntar os dois 

# ---------------------------------------------------------------------------------
# Prevendo  o comportamento dos vacinados 1a. dose para os próximos 60 dias
# ---------------------------------------------------------------------------------
# drc::drm pacote para predição
fitLL <- drm(vaccinated ~ dia, fct = LL2.5(),
             data = covidPE, robust = 'mean') # fazendo a predição log-log com a função drm
plot(fitLL, log="", main = "Log logistic") # observando o ajuste

# usando o modelo para prever para frente, com base no vetor predDia
predLL <- data.frame(predicao = ceiling(predict(fitLL, predDia))) 
# criando uma sequência de datas para corresponder aos dias extras na base de predição
predLL$data <- seq.Date(as.Date('2020-03-12'), by = 'day', length.out = length(predDia$dia))
# juntando as informações observadas da base original
predLL <- merge(predLL, covidPE, by.x ='data', by.y = 'date', all.x = T) 

# ---------------------------------------------------------------------------------
# Limpando os dias da base em que não houve vacinação
# ---------------------------------------------------------------------------------
predLL <- predLL[min(which(!is.na(covidPE$vaccinated))):nrow(predDia), ]

# ---------------------------------------------------------------------------------
# Plotando o gráfico interativo
# ---------------------------------------------------------------------------------
plot_ly(predLL) %>% add_trace(x = ~data, y = ~predicao, type = 'scatter', mode = 'lines', name = "Previsão - 1a. dose") %>% add_trace(x = ~data, y = ~vaccinated, name = "Vacinados - 1a. dose", mode = 'lines') %>%
  layout(title = 'Previsão de vacinados com 1a. dose contra COVID 19 em Pernambuco',
         xaxis = list(title = 'Data', showgrid = FALSE),
         yaxis = list(title = 'Casos Acumulados por Dia', showgrid = FALSE),
         hovermode = "compare") # plotando tudo junto, para comparação

# ---------------------------------------------------------------------------------
# Manipulando Séries Temporais
# ---------------------------------------------------------------------------------
# zoo::rollmean biblioteca para manipulação de datas e séries temporais
# média móvel de 7 dias
covidPE <- covidPE %>% mutate(vaccinatedMM7 = round(rollmean(x = vaccinated, 7, align = "right", fill = NA), 2)) 

plot_ly(covidPE) %>% add_trace(x = ~date, y = ~vaccinated, type = 'scatter', mode = 'lines', name = "Vacinados 1a. dose") %>% add_trace(x = ~date, y = ~vaccinatedMM7, name = "Vacinados MM7", mode = 'lines') %>%
  layout(title = 'Vacinados 1a. dose contra COVID19 em Pernambuco e Média Móvel 7 dias (MM7)',
         xaxis = list(title = 'Data', showgrid = FALSE), 
         yaxis = list(title = 'Vacinados Acumulados por Dia', showgrid = FALSE),
         hovermode = "compare") # plotando tudo junto, para comparação

# ---------------------------------------------------------------------------------
# Convertendo para Séries Temporais. Usando uma série mais limpa: predLL
# ---------------------------------------------------------------------------------
# xts converte em séries temporais
(covidPE_ts <- xts(predLL$vaccinated, predLL$data))
str(covidPE_ts)

autoplot(covidPE_ts)