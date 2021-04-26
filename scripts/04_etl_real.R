# ---------------------------------------------------------------------------------------
# carrega a base de snistros de transito do site da PCR
#
# Base 2018
sinistrosRecife2018Raw <- read.csv2('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/2caa8f41-ccd9-4ea5-906d-f66017d6e107/download/acidentes_2018-jan.csv', sep = ';', encoding = 'UTF-8')
# Base 2019
sinistrosRecife2019Raw <- read.csv2('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/2caa8f41-ccd9-4ea5-906d-f66017d6e107/download/acidentes_2019-jan.csv', sep = ';', encoding = 'UTF-8')
# Base 2020
sinistrosRecife2020Raw <- read.csv2('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/fc1c8460-0406-4fff-b51a-e79205d1f1ab/download/acidentes_2020-novo.csv', sep = ';', encoding = 'UTF-8')
# Base 2021
sinistrosRecife2021Raw <- read.csv2('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/2caa8f41-ccd9-4ea5-906d-f66017d6e107/download/acidentes_2021-jan.csv', sep = ';', encoding = 'UTF-8')
# ---------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------
# junta as bases de dados com comando rbind (juntas por linhas)
# 
sinistrosRecifeRaw <- rbind(sinistrosRecife2018Raw,
                            sinistrosRecife2019Raw,
                            sinistrosRecife2020Raw,
                            sinistrosRecife2021Raw)
# ---------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------
# observa a estrutura dos dados
str(sinistrosRecifeRaw)
# ---------------------------------------------------------------------------------------


# ---------------------------------------------------------------------------------------
# modifca a data para formato date
sinistrosRecifeRaw$data <- as.Date(sinistrosRecifeRaw$data, format = "%Y-%m-%d")
# ---------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------
# modifica: natureza do sinistro, situação, tempo clima e conservação da via de texto para fator
sinistrosRecifeRaw$natureza_acidente <- as.factor(sinistrosRecifeRaw$natureza_acidente)
sinistrosRecifeRaw$situacao <- as.factor(sinistrosRecifeRaw$situacao)
sinistrosRecifeRaw$tempo_clima <- as.factor(sinistrosRecifeRaw$tempo_clima)
sinistrosRecifeRaw$conservacao_via <- as.factor(sinistrosRecifeRaw$conservacao_via)
# ---------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------
# cria função para substituir not available (na) por 0
naZero <- function(x) {
  x <- ifelse(is.na(x), 0, x)
}
# ---------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------
# Removendo as bases que não são mais úteis
remove(sinistrosRecife2018Raw)
remove(sinistrosRecife2019Raw)
remove(sinistrosRecife2020Raw)
remove(sinistrosRecife2021Raw)
# ---------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------
# aplica a função naZero a todas as colunas de contagem
sinistrosRecifeRaw[, 15:25] <- sapply(sinistrosRecifeRaw[, 15:25], naZero)

# exporta em formato nativo do R
saveRDS(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.rds")

# exporta em formato tabular (.csv) - padrão para interoperabilidade
write.csv2(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.csv")
# ---------------------------------------------------------------------------------------