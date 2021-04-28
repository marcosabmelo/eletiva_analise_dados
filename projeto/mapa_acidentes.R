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
