# chamando eeptools
library("eeptools")

# vetor com o nome das escolas
nomes_escolas <- c("Cônego Torres", "Cornélio Soares", "Antônio Timóteo",
                   "Imaculada Conceição", "Francisco Mendes")

# vetor com a data de fundação
fundacao_escolas <- as.Date(c("1910-10-09", "1922-05-03", "1931-06-01",
                              "1945-08-19", "1990-11-07"))

# vetor com a idade das escolas
idade_escolas <- round(age_calc(fundacao_escolas, units = "years"))

# vetor púlica ou privada
tipo_escolas <- c("Pública", "Pública", "Pública", "Privada", "Privada")

# criando um data frame
escolas <- data.frame(nome = nomes_escolas, fundacao = fundacao_escolas,
                      idade = idade_escolas, tipo = tipo_escolas)
