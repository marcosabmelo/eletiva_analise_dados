# ---------------------------------------------------------------------------------------
# Carrega Microbenchmark
# Carrega Haven: ler e escrever em formatos SPSS, STATA
library(microbenchmark)
library(haven)
# ---------------------------------------------------------------------------------------
# EXPORTAÇÃO
# 
# exporta em formato nativo do R
saveRDS(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.rds")
#
# exporta em formato tabular (.csv) - padrão para interoperabilidade
write.csv2(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.csv")
#
# exporta em formato tabular (.sav) - padrão SPSS
write_sav(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.sav")
#
# exporta em formato tabular (.dta) - padrão STATA
write_dta(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.dta")
# ---------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------
# IMPORTAÇÃO
#
# carrega base de dados em formato nativo R
sinistrosRecife <- readRDS('bases_tratadas/sinistrosRecife.rds')
#
# carrega base de dados em formato tabular (.csv) - padrão para interoperabilidade
sinistrosRecife <- read.csv2('bases_tratadas/sinistrosRecife.csv', sep = ';')
#
# carrega base de dados em formato (.sav) - padrão SPSS
sinistrosRecife <- read_sav('bases_tratadas/sinistrosRecife.sav')
#
# carrega base de dados em formato (.dta) - padrão STATA
sinistrosRecife <- read_dta('bases_tratadas/sinistrosRecife.dta')
# ---------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------
# BENCHMARK
#
# compara os dois processos de exportação, usando a função microbenchmark
# >> adicionando formato SPSS e SAS
microbenchmark(a <- saveRDS(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.rds"), b <- write.csv2(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.csv"), c <- write_sav(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.sav"), d <- write_dta(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.dta"), times = 10L)
#
#
microbenchmark(a <- readRDS('bases_tratadas/sinistrosRecife.rds'), b <- read.csv2('bases_tratadas/sinistrosRecife.csv', sep = ';'), c <- read_sav("bases_tratadas/sinistrosRecife.sav"), d <- read_dta("bases_tratadas/sinistrosRecife.dta"), times = 10L)
# ---------------------------------------------------------------------------------------