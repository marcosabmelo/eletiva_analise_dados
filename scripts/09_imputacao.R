# ---------------------------------------------------------------------------------
# Imputação 
# ---------------------------------------------------------------------------------
library(data.table)
library(dplyr)
library(Hmisc)
# ---------------------------------------------------------------------------------
# Base do SAEB 1997 Alunos 8EF Prova de MAtemática - Brasil
saeb1997 <- readRDS("bases_originais/saeb8EF1997BR.rda")
saeb1997 <- saeb1997 %>% setDT() # Transformando em Data Table

# ---------------------------------------------------------------------------------
# Imputando valores de medida central: Média e Mediana com pacote Hmisc
# Já sabemos do exercício anterior que IDADE tem muitos NA's
saeb1997M1 <- saeb1997
saeb1997M2 <- saeb1997
saeb1997M1$IDADE <- impute(saeb1997$IDADE, fun = mean) # média
saeb1997M2$IDADE <- impute(saeb1997$IDADE, fun = median) # média

describe(saeb1997M1[ , "IDADE"]) # Sumário do pacote Hmisc: Já diz se foi imputado ou não
describe(saeb1997M2[ , "IDADE"]) # Sumário do pacote Hmisc: Já diz se foi imputado ou não

# ---------------------------------------------------------------------------------
# Imputando valores por Hot Deck (imputação aleatória)
saeb1997HD <- saeb1997
(saeb1997HD$IDADE <- impute(saeb1997HD$IDADE, "random")) # Valores imputados aparecem com *
describe(saeb1997HD[ , "IDADE"]) # Sumário do pacote Hmisc: Já diz se foi imputado ou não
