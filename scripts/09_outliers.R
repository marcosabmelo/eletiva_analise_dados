# ---------------------------------------------------------------------------------
# Outliers 
# ---------------------------------------------------------------------------------
library(data.table)
library(dplyr)
library(plotly)
library(EnvStats)

# ---------------------------------------------------------------------------------
# Base do SAEB 1997 Alunos 8EF Prova de MAtemática - Brasil
saeb1997 <- readRDS("bases_originais/saeb8EF1997BR.rda")

# ---------------------------------------------------------------------------------
# Outliers na única variável numérica da base: PROFIC = notas de matemática do 8EF
# Distância interquartil
hist(saeb1997$PROFIC) # Pelo histograma já vemos que não tem outliers
plot_ly(y = saeb1997$PROFIC, type = "box", text = "Notas de Matemática 8EF", boxpoints = "all", jitter = 0.4)
boxplot.stats(saeb1997$PROFIC)$out # Padrão 1.5
boxplot.stats(saeb1997$PROFIC, coef = 2)$out # Coef = 2 (sendo mais rigoroso)
(which(saeb1997$PROFIC %in% boxplot.stats(saeb1997$PROFIC)$out)) # Descobrindo 'possíveis' outliers na base

# ---------------------------------------------------------------------------------
# Filtro de Hamper
lower_bound <- median(saeb1997$PROFIC) - 3 * mad(saeb1997$PROFIC, constant = 1)
upper_bound <- median(saeb1997$PROFIC) + 3 * mad(saeb1997$PROFIC, constant = 1)
(outlier_ind <- which(saeb1997$PROFIC < lower_bound | saeb1997$PROFIC > upper_bound))

# ---------------------------------------------------------------------------------
# Teste de Rosner irá confirmar que não temos nenhum outlier
(rosnerTest(saeb1997$PROFIC, k = 10))$all.stats
