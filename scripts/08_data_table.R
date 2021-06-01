# ---------------------------------------------------------------------------------
# Pacotes
# ---------------------------------------------------------------------------------
library(data.table)
library(dplyr)

# ---------------------------------------------------------------------------------
# Usando a base de corrupção
base_corrupcaoDT <- setDT(base_corrupcao)
class(base_corrupcaoDT)

# Só bandidos da Nicarágua
base_corrupcaoDT[paises == "Nicarágua", ]

# Só bandidos da Nicarágua e do Camboja acima de 50 anos que tenham dado prejuízo > 120 bilhões
base_corrupcaoDT[paises == "Nicarágua" | paises == "Camboja", ][idade > 50][desvios > 120]

# Prejuízo médio dos bandidos brasileiros
base_corrupcaoDT[paises == "Brasil", .(média_dos_desvios = mean(desvios, na.rm = T))]

#--------------------------------------------------------------------------------  
# Sumário da Regressão
base_corrupcaoDT[ , summary(lm(formula = desvios ~ idade))]