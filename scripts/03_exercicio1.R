# ----------------------------------------------------------------------------------------------
#1. Crie um data frame com pelo menos 500 casos e a seguinte composição: duas variáveis normais de desvio padrão diferente, uma variável de contagem (poisson), uma variável de contagem com dispersão (binomial negativa), uma variável binomial (0,1), uma variável qualitativa que apresenta um valor quando a variável binomial é 0 e outro quando é 1, e uma variável de index. 
# ----------------------------------------------------------------------------------------------
df <- data.frame(normal1 = rnorm(500,10,1), #normal mu= 10 sd=1
                 normal2 = rnorm(500,10,2), #normal mu= 10 sd=2
                 contagem_poisson = rpois(500,3), #poisson lambda=3
                 contagem_nbinomial = rnbinom(500, 1, 1/6), #binomial negativa: sucessos de um valor em um dado
                 contagem_binomial = rbinom(500, 1, 0.5)) #binomial: contando os sucessos 'cara' em uma moeda

# criando e inserindo a variável qualitativa
qualitativa = ifelse(df$contagem_binomial == 1, "Cara", "Coroa")
df$qualitativa <- qualitativa

# criando e inserindo a variável indice
indice = seq(1:500)
df$indice <- indice

# fiz dessa forma para deixar as variávei na ordem de sequencia pedida


# ----------------------------------------------------------------------------------------------
#2. Centralize as variáveis normais. 
# ----------------------------------------------------------------------------------------------
df$normal1 <- df$normal1-mean(df$normal1)
df$normal2 <- df$normal2-mean(df$normal2)


# ----------------------------------------------------------------------------------------------
#3. Troque os zeros (0) por um (1) nas variáveis de contagem. 
# ----------------------------------------------------------------------------------------------
aux <- replace(df[3:5], df[3:5] == 0, 1)
df[3:5] <- aux
# não atualizei o cara ou coroa na qualitativa


# ----------------------------------------------------------------------------------------------
#4. Crie um novo data.frame com amostra (100 casos) da base de dados original.
# ----------------------------------------------------------------------------------------------
df_novo <- df[sample(1:nrow(df), 100, replace = F), ] #selecionando amostra com 100
row.names(df_novo) <- (1:100) #corrijindo os nomes das linhas no data frame novo

#podemos usar o dplyr. O código seria:
#library(dplyr)
#df_novo <- sample_n(df, 100, replace = F)
#não haveria o problema de sujar os nomes das linhas