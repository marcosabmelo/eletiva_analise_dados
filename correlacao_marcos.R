## CORRELAÇÃO COM R ##
# Marcos A. B. de Melo
# 27/09/2023

# Carregando pacotes
pacman::p_load(corrplot, dplyr, ggplot2)

# Base mtcars
crimes <- USArrests

# Correlação de todas as variáveis numéricas
cor(crimes)

# Gráfico de dispersão
pairs(crimes)

# Corrplot das variáveis
crimes_cor <- cor(crimes) # Tabela de correlações
#corrplot(crimes_cor, method = "number", order = 'alphabet')
#corrplot(crimes_cor, order = 'alphabet') 

# Melhor visualização
corrplot(crimes_cor, method = "square", order = 'AOE')