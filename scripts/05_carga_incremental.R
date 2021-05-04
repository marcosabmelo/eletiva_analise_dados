# --------------------------------------------------------------------------------------------
#
library(dplyr)
#
# carrega base de dados original
ranking_vacina_SP <- read.csv2("https://www.saopaulo.sp.gov.br/wp-content/uploads/2021/05/20210501_percentual_primeira_dose.csv", sep = ';', header = T)

names(ranking_vacina_SP) <- c("municipio",	"ranking", "percentual", "doses", "populacao")
#save(ranking_vacina_SP, file = "bases_originais/ranking_vacina_sp.RData")
#load("bases_originais/ranking_vacina_sp.RData")
# --------------------------------------------------------------------------------------------

  #>> Por causa da natureza da base de dados (ranking) várias posições podem mudar com uma atualização
  #>> temos que comparar linha por linha
  #>> O código abaixo é apenas para efeito de exercício. Eu carregaria a base nova e substituia a antiga
  #>> Corremos o risco de no futuro o ranking ficar errado pois só atualizamos com base nas novas doses

# --------------------------------------------------------------------------------------------
# após carregar a base original, basta executar o código abaixo para cada atualização
ranking_vacina_SP_new <- read.csv2("https://www.saopaulo.sp.gov.br/wp-content/uploads/2021/05/20210501_percentual_primeira_dose.csv", sep = ';', header = T)
#
names(ranking_vacina_SP_new) <- c("municipio",	"ranking", "percentual", "doses", "populacao")
#
# base de incrementos
ranking_atualizado <- (!ranking_vacina_SP_new$doses %in% ranking_vacina_SP$doses)
# --------------------------------------------------------------------------------------------
#
# apenas atualiza a base original com os valores da base nova
ranking_vacina_SP[ranking_atualizado, ] <- ranking_vacina_SP_new[ranking_atualizado, ]
