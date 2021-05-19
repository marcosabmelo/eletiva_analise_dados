# ---------------------------------------------------------------------------------------
#
# carrega a base da situação final dos alunos do Recife
#
# carregando pacotes para Large Data
library(ff)
library(ffbase)
library(tidyverse)
# ---------------------------------------------------------------------------------


# ---------------------------------------------------------------------------------
# 1) Como  o read.csv.ffdf não lê direto da web, baixei tudo para a minha máquina
# Vá no link abaixo e baixe os arquivos na pasta bases_originais do seu projeto
# http://dados.recife.pe.gov.br/dataset/situacao-final-dos-alunos-por-periodo-letivo
#
sfa11 <- read.csv2.ffdf(file = "bases_originais/situacaofinalalunos2011.csv")
sfa12 <- read.csv2.ffdf(file = "bases_originais/situacaofinalalunos2012.csv")
sfa13 <- read.csv2.ffdf(file = "bases_originais/situacaofinalalunos2013.csv")
sfa14 <- read.csv2.ffdf(file = "bases_originais/situacaofinalalunos2014.csv")
sfa15 <- read.csv2.ffdf(file = "bases_originais/situacaofinalalunos2015.csv")
sfa16 <- read.csv2.ffdf(file = "bases_originais/situacaofinalalunos2016.csv")
sfa17 <- read.csv2.ffdf(file = "bases_originais/situacaofinalalunos2017.csv")
sfa18 <- read.csv2.ffdf(file = "bases_originais/situacaofinalalunos2018.csv")
sfa19 <- read.csv2.ffdf(file = "bases_originais/situacaofinalalunos2019.csv")
sfa20 <- read.csv2.ffdf(file = "bases_originais/situacaofinalalunos2020.csv")
# ---------------------------------------------------------------------------------


# ---------------------------------------------------------------------------------
# 2) juntando bases semelhantes
basesfa <- ffdfrbind.fill(sfa11, sfa12, sfa13, sfa14, sfa15, sfa16, sfa17, sfa18, sfa19, sfa20)

# Informações sobre a base agrupada 
# Conferi com as variáveis sfa11... e realmente agrupou
class(basesfa)
object.size(basesfa)/1024 # tamanho em KB
summary(basesfa)
head(basesfa)
# ---------------------------------------------------------------------------------


# ---------------------------------------------------------------------------------
# 3) Limpando arquivos temporários
remove(sfa11, sfa12, sfa13, sfa14, sfa15, sfa16, sfa17, sfa18, sfa19, sfa20)
# ---------------------------------------------------------------------------------


# ---------------------------------------------------------------------------------
# 4) Exportando base como RDS
saveRDS(basesfa, file = "basesfa.RDS")
# basesfa <- readRDS("basesfa.RDS")
# ---------------------------------------------------------------------------------